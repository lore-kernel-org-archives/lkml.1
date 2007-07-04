Return-Path: <linux-kernel-owner+w=401wt.eu-S1758342AbXGDFEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342AbXGDFEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 01:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbXGDFDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 01:03:03 -0400
Received: from ozlabs.org ([203.10.76.45]:37505 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756187AbXGDFC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 01:02:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18059.10554.955290.148535@cargo.ozlabs.ibm.com>
Date: Wed, 4 Jul 2007 14:59:38 +1000
From: Paul Mackerras <paulus@samba.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
 RAM pathway
In-Reply-To: <Pine.LNX.4.44L0.0707031609070.7671-100000@iolanthe.rowland.org>
References: <1183474748.3722.33.camel@johannes.berg>
	<Pine.LNX.4.44L0.0707031609070.7671-100000@iolanthe.rowland.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern writes:

> I disagree.  The problem isn't the kernel calling userspace; it's
> userspace trying to do I/O at a time when everything is supposed to be
> quiescing.  Detecting that and blocking it in drivers is hard and
> error-prone; preventing it by freezing userspace is easy and cheap.

And unreliable, and prone to deadlocks, and invasive - requiring
changes to kernel threads that have nothing to do with drivers or
suspend/resume.

> The reasons why the PPC people dislike the whole idea aren't clear to
> me. 

Our experience is that it isn't necessary.  It's extra code that in
practice causes deadlocks and added maintenance burden for no
discernable benefit.

> If it were necessary to have some user task running in order to
> carry out the STR then their objection would make sense -- obviously
> that task couldn't do its job if it were frozen.  But it isn't
> necessary, or at least it should not be.

The freezer doesn't achieve its stated goal of preventing drivers from
getting I/O requests after suspend, since kernel threads can (and do)
initiate I/O.  So then we say that some kernel threads need to be
frozen and others don't, but making that decision is difficult and
error-prone.

Besides, any kernel thread that does I/O is potentially doing that in
order to complete some other I/O request.  So we want to freeze it in
order to prevent new I/O requests from being initiated, but we don't
want to freeze it so that existing I/O requests can be completed.
Thus we have a fundamental conflict in the notion of the freezer.

In fact I believe that making a distinction between user and kernel
threads is wrong and likely to lead to problems, since userspace can
be involved in doing I/O (e.g. FUSE or the user-space driver
framework).  So the argument of the previous paragraph also applies to
some userspace processes.

> Userspace will be effectively "frozen" while the system as a whole is 
> suspended.  So what's wrong with freezing it a little early?  Despite 
> Ben's comments, it seems to me that the freezer doesn't hide problems 
> -- it prevents them.

No, it appears to prevent them, but doesn't in fact.

I remain convinced that the right approach is to fix the drivers to do
one of two things; either do something in the suspend call to block
further requests to the device, or use a late-suspend call to put
their device into a low-power state.  Of course, correctly-written
frameworks can do a lot to help the chipset drivers here.

> Now people may claim that the freezer implementation itself is buggy.  
> I wouldn't dispute it.  But the bugs should be fixable; nobody has 
> pointed out anything fundamentally wrong with the idea AFAICT.

The fundamental problem is the kernel threads and user processes that
we need running to complete existing I/O requests, but which may
initiate new I/O requests in doing so.

The right way to solve the problem is to do the request blocking in
the drivers.

Paul.
