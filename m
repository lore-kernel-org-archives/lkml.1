Return-Path: <linux-kernel-owner+w=401wt.eu-S1757131AbZJLPTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbZJLPTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757117AbZJLPTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:19:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757114AbZJLPTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:19:13 -0400
Date: Mon, 12 Oct 2009 17:13:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: akpm@linux-foundation.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 8/8] FS: proc, make limits writable
Message-ID: <20091012151355.GA1825@redhat.com>
References: <20090903174106.GC27161@redhat.com> <1252008524-5376-8-git-send-email-jirislaby@gmail.com> <20090904142645.GA10535@redhat.com> <4ACE51A8.3030406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACE51A8.3030406@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08, Jiri Slaby wrote:
>
> On 09/04/2009 04:26 PM, Oleg Nesterov wrote:
> > One small nit, just to suggest the further 9/8 cleanup,
> >
> >> +static const struct file_operations proc_pid_limits_operations = {
> >> +	.read		= proc_info_read,
> >> +	.write		= limits_write,
> >> +};
> >
> > I think it makes sense to tweak proc_pid_limits() a little bit (and
> > rename it), so that we can do
> >
> > 	.read = limits_read,
> > 	.write = limits_write
> >
> > Then,
> >
> >> @@ -2501,7 +2571,9 @@ static const struct pid_entry tgid_base_stuff[] = {
> >> +	NOD("limits",	  S_IFREG|S_IRUSR|S_IWUSR, NULL,
> >> +			&proc_pid_limits_operations,
> >> +			{ .proc_read = proc_pid_limits }),
> >
> > We could use
> >
> > 	REG("limits", S_IRUSR|S_IWUSR, &proc_pid_limits_operations),
> >
> > instead, this looks a bit cleaner to me.
>
> Hi again, nobody picked them up yet, I waited till the end of the merge
> window and now I'll repost.
>
> Did you mean here to do the proc_info_read work (get/put task, alloc
> buf, simple_read) directly in limits_read?

limits_read() has to do get_proc_task(d_inode), yes. Otherwise I don't
see any additional complications, you can use simple_read_from_buffer(),
no need to allocate the buffer but of course you can you shouldn't
write more than "size_t count" bytes.

But perhaps I missed something, and in any case this is up to you. If
you don't like this - please forget.

> > And another minor nit (just in case you will re-submit this series for
> > some reason). Perhaps the changelog in 6/8 should mention that we do
> > not do any security checks when tsk != current (without selinux). We
> > assume that either the caller is sys_setrlimit(), or the caller should
> > verify it has rights to change the limits: in case of limits_write()
> > we rely on ->mode = S_IRUSR|S_IWUSR.
>
> I did it as a comment by the setrlimit. I think nobody would care about
> a changelog note ;).

Good ;)

Oleg.

