Return-Path: <linux-kernel-owner+w=401wt.eu-S1760843AbXE1IGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843AbXE1IGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbXE1IGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:06:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56433 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbXE1IGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:06:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH][EXPERIMENTAL] Make kernel threads nonfreezable by default
Date: Mon, 28 May 2007 10:09:05 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Herbert Xu <herbert@gondor.apana.org.au>
References: <200705270012.59177.rjw@sisk.pl>
In-Reply-To: <200705270012.59177.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705281009.06685.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 27 May 2007 00:12, Rafael J. Wysocki wrote:
> Hi,
> 
> Following the "Freezing of kernel threads" discussion
> (http://lkml.org/lkml/2007/5/12/162) I have created a patch that changes the
> freezer's behavior with respect to kernel threads.  Namely, with the patch
> applied all kernel threads are nonfreezable by default (have PF_NOFREEZE set)
> and the ones that want to be frozen need to call set_freezable() (which clears
> PF_NOFREEZE for them) and try_to_freeze().  The other (nonfreezable) kernel
> threads don't need to call try_to_freeze() any more.
> 
> I have removed try_to_freeze() from a handful of kernel threads that I think
> need not be freezable, but in many cases I wasn't quite sure whether or not
> it was a good idea to change the current behavior.  For this reason I've added
> set_freezable() to the majority of (currently freezable) kernel threads that
> belong to device drivers and filesystems.
> 
> Of course, I have removed the setting of PF_NOFREEZE from the kernel threads
> that are currently nonfreezable, since with the other changes in the patch it
> isn't necessary any more.
> 
> This patch is on top of the "Freezer: Avoid freezing kernel threads prematurely"
> patch that I posted yestarday, available at http://lkml.org/lkml/2007/5/25/199
> (updated version that applies cleanly on top of 2.6.22-rc3, is available at
> http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc3/patches/07-freezer-avoid-freezing-kernel-threads-prematurely.patch).
> It has been tested on a couple of machines and doesn't seem to break anything.
> 
> [As you can see there are quite a lot of files affected, so I didn't add all
> maintainers of them to the CC list.  In fact, I'm not sure how to handle
> notifying them of the change, so please advise.]

Does the lack of comments mean that everyone on the CC list agrees with this
approach? ;-)

In the meantime, it turns out that this patch fixes the hibernation/suspend
problem with cryptd discussed in the thread at
http://lkml.org/lkml/2007/5/26/24 .

The problem is that cryptd doesn't call try_to_freeze() and doesn't set
PF_NOFREEZE for itself, so the freezer cannot handle it properly.  In principle
we can add either try_to_freeze() or the setting of PF_NOFREEZE to it, but if
the approach in the $subject patch is acceptable, we'll need to remove that
soon.  So, what should we do?

Rafael

