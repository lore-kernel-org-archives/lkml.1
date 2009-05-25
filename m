Return-Path: <linux-kernel-owner+w=401wt.eu-S1751190AbZEYRZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751190AbZEYRZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 13:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbZEYRZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 13:25:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36054 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbZEYRZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 13:25:15 -0400
Date: Mon, 25 May 2009 19:20:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
       roland@redhat.com, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] signal: make group kill signal fatal
Message-ID: <20090525172033.GA12586@redhat.com>
References: <1243198054-13816-1-git-send-email-jirislaby@gmail.com> <20090525000750.GA2301@redhat.com> <4A1AC5A3.9000600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1AC5A3.9000600@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25, Jiri Slaby wrote:
>
> On 05/25/2009 02:07 AM, Oleg Nesterov wrote:
> > On 05/24, Jiri Slaby wrote:
> >>
> >> __fatal_signal_pending() returns now true only for a non-group sent
> >> sigkill, i. e. for example tgkill, send_sig...
> >
> > No. Please look at complete_signal(). If we queue a fatal signal,
> > we always add SIGKILL to any thread.
>
> Ah, thanks. But it looks like it doesn't work well in some cases.
> Consider this kernel code:
>
> ...
> static int release(struct inode *ino, struct file *file)
> {
>         unsigned int a;
>         printk(KERN_DEBUG "fst\n");
>         for (a = 0; a < 10; a++) {
>                 printk(KERN_DEBUG "%s: SP=%u FSP=%u pend=%.16lx
> shpend=%.16lx\n",
>                                 __func__,
>                                 signal_pending(current),
>                                 fatal_signal_pending(current),
>                                 current->pending.signal.sig[0],
>
> current->signal->shared_pending.signal.sig[0]);
>
> ...
>
> int main(int argc, char **argv)
> {
>         struct pollfd fds = { .events = POLLIN };
>         int fd;
>
>         fd = open("/dev/m", O_RDONLY);
>         if (fd < 0)
>                 err(1, "open");
>         fds.fd = fd;
>         if (poll(&fds, 1, -1) < 0)
>                 err(2, "poll");
>         close(fd);
>         return 0;
> }
>
> ----------------------------------------------
> It outputs:
> fst
> release: SP=1 FSP=0 pend=0000000000000000 shpend=0000000000000100

Because (I guess) ->release() is called by do_exit()->close_files(),
by this time the private SIGKILL is already dequeued.

If you kill this program, poll() never returns to the user-space.

> If the poll isn't there, it works well.

Hmm. this is strange. Do you mean that if this program does
sleep(10000) (or something else) instead of poll() above, it
prints pend != 0 ?



Note. There are known issues with fatal_signal_pending() in exit()
path. But in any case, we should not check ->shared_pending.
And even if ->signal != NULL we must not use ->siglock. Because
schedule() checks fatal_signal_pending() under rq->lock, we can
deadlock. Also, the fact that SIGKILL is actually pending is the
current implementation detail, probably this will be changed.

__fatal_signal_pending() could check SIGNAL_GROUP_EXIT, but we
can't do this now, ->signal can be NULL. Actually signal_group_exit()
is more correct.

And. Why do you need fatal_signal_pending() ? It is special,
should be used by things like wait_event_killable().

Oleg.

