Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbYFJUdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbYFJUdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbYFJUdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:33:40 -0400
Received: from pat.uio.no ([129.240.10.15]:43031 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbYFJUdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:33:38 -0400
Subject: Re: [2.6.26-rc4] mount.nfsv4/memory poisoning issues...
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jeff Layton <jlayton@redhat.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>, linux-nfs@vger.kernel.org,
       nfsv4@linux-nfs.org, Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080610161352.4e588653@tleilax.poochiereds.net>
References: <6278d2220806041633n3bfe3dd2ke9602697697228b@mail.gmail.com>
	 <20080604203504.62730951@tleilax.poochiereds.net>
	 <1213124088.20459.16.camel@localhost>
	 <20080610151357.150b6f69@tleilax.poochiereds.net>
	 <1213127909.20459.48.camel@localhost>
	 <20080610161352.4e588653@tleilax.poochiereds.net>
Content-Type: text/plain
Date: Tue, 10 Jun 2008 16:33:32 -0400
Message-Id: <1213130012.20459.58.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 7ACD1453E4A2A476A50DB7F2E8418891CCC454B2
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 425 total 8863020 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-10 at 16:13 -0400, Jeff Layton wrote:

> We can't call nfs_callback_down() until after nfs_callback_up()
> returns, so we're guaranteed to have "task" set to a valid task
> (presuming that nfs_callback_up() doesn't return error). We also can't
> return from nfs_callback_down() until after the nfs_callback_svc() has
> exited. kthread_stop() will block until it does.

The code I'm alluding to is in kthread():

       /* OK, tell user we're spawned, wait for stop or wakeup */
        __set_current_state(TASK_UNINTERRUPTIBLE);
        complete(&create->started);
        schedule();

        if (!kthread_should_stop())
                ret = threadfn(data);

schedule() is called _after_ the complete() call, and _before_ we
execute threadfn() a.k.a. nfs_callback_svc(). If nfs_alloc_client() has
time to call nfs_callback_down() before the above thread gets scheduled
back in, then threadfn() doesn't get called at all, since
kthread_should_stop() is true.

Cheers
  Trond

