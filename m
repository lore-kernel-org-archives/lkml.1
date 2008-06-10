Return-Path: <linux-kernel-owner+w=401wt.eu-S1758758AbYFJViS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbYFJViS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbYFJViE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:38:04 -0400
Received: from pat.uio.no ([129.240.10.15]:38249 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbYFJViD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:38:03 -0400
Subject: Re: [2.6.26-rc4] mount.nfsv4/memory poisoning issues...
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jeff Layton <jlayton@redhat.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>, linux-nfs@vger.kernel.org,
       nfsv4@linux-nfs.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       bfields@fieldses.org
In-Reply-To: <20080610170154.68e2e6fb@tleilax.poochiereds.net>
References: <6278d2220806041633n3bfe3dd2ke9602697697228b@mail.gmail.com>
	 <20080604203504.62730951@tleilax.poochiereds.net>
	 <1213124088.20459.16.camel@localhost>
	 <20080610151357.150b6f69@tleilax.poochiereds.net>
	 <1213127909.20459.48.camel@localhost>
	 <20080610161352.4e588653@tleilax.poochiereds.net>
	 <1213130012.20459.58.camel@localhost>
	 <20080610170154.68e2e6fb@tleilax.poochiereds.net>
Content-Type: text/plain
Date: Tue, 10 Jun 2008 17:37:56 -0400
Message-Id: <1213133876.20459.91.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: F751ED416952000528945D857F25A1C027A10973
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 433 total 8863781 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-10 at 17:01 -0400, Jeff Layton wrote:

> In practice, I think the thread generally runs immediately (at least
> with current scheduler behavior), so we're probably not terribly
> vulnerable to this race. Still, we shouldn't rely on that...

In the code I showed you, the 'kthread' task is put to sleep, then
kthread_run() calls wake_up_process() on it, but the current task isn't
scheduled out. Rather, it continues to run, so in almost all UP cases,
the race is not only possible, it is actually rather likely if
nfs_alloc_client() fails.

> For lockd and the nfs4 callback thread, we'll also need to deal with
> the fact that svc_exit_thread() doesn't get called if this happens. So
> we'll need to call svc_exit_thread from the *_down() functions too
> (I presume that's OK).

These *_up()/*_down() functions are getting very complex. Any chance we
could hide some of this complexity in some helpers? Looking at the NFSv4
callback code and lockd, it seems that there might be a couple of
opportunities for merging code.

> nfsd is a bigger problem since it exits on a signal. For that, perhaps
> we should declare a completion variable and have svc_set_num_threads()
> wait until nfsd() has actually run before continuing.

nfsd doesn't use kthreads, does it?



