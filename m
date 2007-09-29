Return-Path: <linux-kernel-owner+w=401wt.eu-S1757147AbXI2B2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbXI2B2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 21:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbXI2B17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 21:27:59 -0400
Received: from phunq.net ([64.81.85.152]:47751 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751996AbXI2B16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 21:27:58 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: A unresponsive file system can hang all I/O in the system on linux-2.6.23-rc6 (dirty_thresh problem?)
Date: Fri, 28 Sep 2007 18:27:47 -0700
User-Agent: KMail/1.9.5
Cc: Jonathan Corbet <corbet@lwn.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, nfs@lists.sourceforge.net,
       Chakri n <chakriin5@gmail.com>
References: <10659.1190986132@lwn.net> <1190986542.13204.10.camel@twins>
In-Reply-To: <1190986542.13204.10.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709281827.48350.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 September 2007 06:35, Peter Zijlstra wrote:
> ,,,it would be grand (and dangerous) if we could provide for a
> button that would just kill off all outstanding pages against a dead
> device.

Substitute "resources" for "pages" and you begin to get an idea of how 
tricky that actually is.  That said, this is exactly what we have done 
with ddsnap, for the simple reason that our users, now emboldened by 
being able to stop or terminate the user space part, felt justified in 
expecting that the system continue as if nothing had happened, and 
furthermore, be able to restart ddsnap without a hiccup.  (Otherwise 
known as a sysop's diety-given right to kill.)

So this is what we do in the specific case of ddsnap:

   * When we detect some nasty state change such as our userspace
      control daemon disappearing on us, we go poking around and
      explicitly release every semaphore that the device driver could
      possibly wait on forever (interestingly they are all in our own
      driver except for BKL, which is just an artifact of device mapper
      not having gone over to unlock_ioctl for no good reason that I
      know of).

   * Then at the points were the driver falls through some lock thus
      released, we check our "ready" flag, and if it indicates "busted",
      proceed with wherever cleanup is needed at that point.

Does not sound like an approach one would expect to work reliably, does 
it?  But there just may be some general principle to be ferretted out 
here.  (Anyone who has ideas on how bits of this procedure could be 
abstracted, please do not hesitate to step boldly forth into the 
limelight.)

Incidentally, only a small subset of locks needed special handling as 
above.  Most can be shown to have no way to block forever, short of an 
outright bug.

I shudder to think how much work it would be to bring every driver in 
the kernel up to such a standard, particularly if user space components 
are involved, as with USB.  On the other hand, every driver fixed is 
one less driver that sucks.  The next one to emerge from the pipeline 
will most likely be NBD, which we have been working on in fits and 
starts for a while.  Look for it to morph into "ddbd", with cross-node 
distributed data awareness, in addition to perforning its current job 
without deadlocking.

Regards,

Daniel
