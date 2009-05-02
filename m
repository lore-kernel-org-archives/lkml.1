Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbZEBLfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbZEBLfo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 07:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754405AbZEBLfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 07:35:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58610 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbZEBLfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 07:35:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] PM: Disable OOM killer during system-wide power transitions
Date: Sat, 2 May 2009 13:34:50 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: pavel@ucw.cz, torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905020027.31244.rjw@sisk.pl> <20090501160931.1dbd2abc.akpm@linux-foundation.org>
In-Reply-To: <20090501160931.1dbd2abc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905021334.51261.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 May 2009, Andrew Morton wrote:
> On Sat, 2 May 2009 00:27:30 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The OOM killer is not particularly useful during system-wide power
> > transitions, so do not use it if such a transition is in progress.
> > 
> 
> so...  I think what you've done here is to arrange for the page
> allocator to return NULL if we're hibernating rather than oom-killing,
> yes?

Yes.

> Does the same apply to suspending?  If so, why?

Because I think it doesn't work anyway.  User space processes are frozen and
effectively in TASK_UNINTERRUPTIBLE, so they won't be killed.

> I think this is an OK change, as long as the only thing which is
> allocating memory is hibernation itself.  If random processes are still
> doing random memory allocations at this time then their failed memory
> allocation could be just as fatal as an oom-killing.  Moreso if they're
> s/bin/init or whatever.

At this point all of the user space tasks are frozen.

> So is it the case that pm_transition_in_progress() is only true during
> the highly-constrained hibernation process?  After everything is frozen?

Yes.

> If so, there are alternatives - the calling process could set
> PF_DONT_KILL_ANYONE_FOR_ME, or could pass __GFP_DONT_KILL_ANYONE_FOR_ME. 
> Those might be worse alternatives, dunno - I'm just asking probing
> questions ;)

Well, the __GFP_DONT_KILL_ANYONE_FOR_ME would be easier to implement.

I don't really think that the freezing of processes plays very well with the
OOM killer, so disabling it altogether after the processes have been frozen
seems reasonable to me.  Still, if you prefer to use
__GFP_DONT_KILL_ANYONE_FOR_ME, it's fine by me.
