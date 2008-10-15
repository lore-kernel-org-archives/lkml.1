Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbYJOKdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbYJOKdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 06:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbYJOKdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 06:33:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33939 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbYJOKdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 06:33:38 -0400
Date: Wed, 15 Oct 2008 06:33:29 -0400
From: Jeff Layton <jlayton@redhat.com>
To: "Steve French" <smfrench@gmail.com>
Cc: linux-kernel@vger.kernel.org, niallain@gmail.com,
       linux-cifs-client@lists.samba.org
Subject: Re: [PATCH 2/5] cifs: eliminate usage of kthread_stop for cifsd
Message-ID: <20081015063329.3e089ab9@tleilax.poochiereds.net>
In-Reply-To: <524f69650810141829u2d708e4axe47a8a78a2b72941@mail.gmail.com>
References: <1224031267-17194-1-git-send-email-jlayton@redhat.com>
	<1224031267-17194-3-git-send-email-jlayton@redhat.com>
	<524f69650810141829u2d708e4axe47a8a78a2b72941@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008 20:29:31 -0500
"Steve French" <smfrench@gmail.com> wrote:

> On Tue, Oct 14, 2008 at 7:41 PM, Jeff Layton <jlayton@redhat.com> wrote:
> > When cifs_demultiplex_thread was converted to a kthread based kernel
> > thread, great pains were taken to make it so that kthread_stop would be
> > used to bring it down. This just added unnecessary complexity since we
> > needed to use a signal anyway to break out of kernel_recvmsg.
> >
> > Also, cifs_demultiplex_thread does a bit of cleanup as it's exiting, and
> > we need to be certain that this gets done. It's possible for a kthread
> > to exit before its main function is ever run if kthread_stop is called
> > soon after its creation. While I'm not sure that this is a real problem
> > with cifsd now, it could be at some point in the future if cifs_mount is
> > ever changed to bring down the thread quickly.
> >
> > The upshot here is that using kthread_stop to bring down the thread just
> > adds extra complexity with no real benefit. This patch changes the code
> > to use the original method to bring down the thread, but still leaves it
> > so that the thread is actually started with kthread_run.
> >
> > This seems to fix the deadlock caused by the reproducer in this bug
> > report:
> >
> > https://bugzilla.samba.org/show_bug.cgi?id=5720
> 
> I agree with what Jeff is suggesting in this patch, and have no
> problem merging the patch, but want to make sure that those who wanted
> cifs to switch all of cifs threads to kthread usage are also ok with
> this.
> 
> I don't like the patch 1 (disabling a section of code code) and 5
> (basically reenabling similar code fixing some problems) though - has
> to be a better way to do this by rewriting the function once.
>

The main argument for the way that I've proposed is that once you take
kthread_stop out, it becomes much easier to hit the other races.

The other races are pretty dangerous -- you're likely to oops, but may
also corrupt memory in use-after-free situations. My suggestion would
be to take the patchset as is. While it'll temporarily break multiuser
mounts if someone bisects in the middle of the series, that person
shouldn't be vulnerable to the other problems.

If you feel strongly about it though, we could eliminate patch 1, roll
similar changes into patch 5, and move it to the beginning of the
series.

-- 
Jeff Layton <jlayton@redhat.com>
