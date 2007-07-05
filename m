Return-Path: <linux-kernel-owner+w=401wt.eu-S1762650AbXGEXNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762650AbXGEXNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762094AbXGEXNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:13:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:52791 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761942AbXGEXNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:13:18 -0400
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
	RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: oliver@neukum.org, pavel@ucw.cz, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org
In-Reply-To: <E1I6XFM-0001ek-00@dorka.pomaz.szeredi.hu>
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com>
	 <20070705115400.GF3984@ucw.cz> <E1I6Q73-0000Xi-00@dorka.pomaz.szeredi.hu>
	 <200707052138.56920.oliver@neukum.org>
	 <E1I6XFM-0001ek-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 09:05:51 +1000
Message-Id: <1183676751.3388.96.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Yes, fuse could handle being frozen there.  However that would only
> solve part of the problem: an operation waiting for a reply could be
> holding a VFS mutex and some other task may be blocked on that mutex.
> 
> How would you solve freezing those tasks?

That task is implicitely frozen... but the kernel doesn't know it and
thus the freezer timeouts or fails or deadlocks or whatever.

The freezer could be made to ignore tasks that are sleeping in the
kernel assuming that if they go out of it, they'll ultimately reach
do_signal and freeze, but that means they can potentially still issues
IOs which is what the freezer tries to avoid ...

Or the kernel could start tracking dependencies, but then, good luck
implementing that crap.

At the end of the day, I stand my ground, the freezer cannot be made
reliable without massive infrastructure changes or giving up on very
useful features such as fuse among others. Besides, it only partially
"hides" the problem of requests going to drivers, thus it's a bad
solutions.

We would be much better off spending time fixing the drivers to properly
block requests after suspended, and that also gives for free the ability
to do dynamic runtime suspend on them.

And for "trivial" drivers where we don't care, using late_suspend to
power the chip off later when IRQs are off is an easy enough way to
solve it with very little code (though won't help with dynamic PM but
that's not necessarily an issue). No need for a freezer either way.

Ben.


