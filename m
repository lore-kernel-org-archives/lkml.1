Return-Path: <linux-kernel-owner+w=401wt.eu-S1754211AbXDSWFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbXDSWFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 18:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbXDSWFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 18:05:08 -0400
Received: from pat.uio.no ([129.240.10.15]:49893 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211AbXDSWFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 18:05:04 -0400
Subject: Re: [PATCH] nfs lockd reclaimer: Convert to kthread API
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
In-Reply-To: <20070419144059.7f5b9b39.akpm@linux-foundation.org>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	 <11769696321319-git-send-email-ebiederm@xmission.com>
	 <1176999710.6663.12.camel@heimdal.trondhjem.org>
	 <m1slawkw76.fsf@ebiederm.dsl.xmission.com>
	 <1177017564.6628.5.camel@heimdal.trondhjem.org>
	 <20070419144059.7f5b9b39.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 19 Apr 2007 18:04:44 -0400
Message-Id: <1177020284.6628.27.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: DC57B063EF5812C7BD88E029593A6DD00166232A
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 42 total 1199940 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-19 at 14:40 -0700, Andrew Morton wrote:
> Using signals to communicate with kernel threads is fairly unpleasant, IMO.
> We have much simpler, faster and more idiomatic ways of communicating
> between threads in-kernel and there are better ways in which userspace can
> communicate with the kernel - system calls, for example...
> 
> So I think generally any move which gets us away from using signals in
> kernel threads is moving in a good direction.

I have yet to see a proposal which did. Eric's patch was eliminating
signals in kernel threads that used them without proposing any
replacement mechanism or showing that he had plans to do so. That is a
good reason for a veto.

> > > With pid namespaces all kernel threads will disappear so how do
> > > we cope with the problem when the sysadmin can not see the kernel
> > > threads?
> > 
> > Then you have a usability problem. How does the sysadmin reboot the
> > system if there is no way to shut down the processes that are hanging on
> > an unresponsive filesystem?
> 
> Where's the hang?  A user process is stuck on h_rwsem?
> 
> If so, would it be appropriate to convert the user process to use
> down_foo_interruptible(), so that the operator can just kill the user
> process as expected, rather than having to futz around killing kernel
> threads?

If an NFS server reboots, then the locks held by user processes on the
client need to be re-established by when it comes up again. Otherwise,
the processes that thought they were holding locks will suddenly fail.
This recovery job is currently the done by a kernel thread.

The question is then what to do if the server crashes again while the
kernel thread is re-establishing the locks. Particularly if it never
comes back again.
Currently, the administrator can intervene by killing anything that has
open files on that volume and kill the recovery kernel thread.
You'll also note that lockd_down(), nfsd_down() etc all use signals to
inform lockd(), nfsd() etc that they should be shutting down. Since the
reclaimer thread is started by the lockd() thread using CLONE_SIGHAND,
this means that we also automatically kill any lingering recovery
threads whenever we shutdown lockd().

These mechanisms need to be replaced _before_ we start shooting down
sigallow() etc in the kernel.

  Trond

