Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbYKZPcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbYKZPcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 10:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYKZPcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 10:32:03 -0500
Received: from ppp121-45-197-80.lns10.adl2.internode.on.net ([121.45.197.80]:44120
	"EHLO homer.shelbyville.oz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752132AbYKZPcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 10:32:02 -0500
X-Greylist: delayed 1505 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Nov 2008 10:32:01 EST
Date: Thu, 27 Nov 2008 02:01:52 +1030
From: Ron <ron@debian.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] fix for sched_clock() when using jiffies
Message-ID: <20081126153152.GB28153@homer.shelbyville.oz>
References: <20081126150645.GA28153@homer.shelbyville.oz> <1227712598.4454.199.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227712598.4454.199.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ron@debian.org
X-SA-Exim-Scanned: No (on homer.shelbyville.oz); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 04:16:38PM +0100, Peter Zijlstra wrote:
> On Thu, 2008-11-27 at 01:36 +1030, Ron wrote:
> > Hi,
> > 
> > I'm in the process of updating a port for an ARM based chip we've been
> > working on, from 2.6.22-rc4'ish to the current HEAD of Linus' tree, and
> > I started seeing the following:
> > 
> > [    0.000000] PID hash table entries: 512 (order: 9, 2048 bytes)
> > [42949372.970000] Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
> > 
> > The reason appears to be that printk_clock() has been replaced with a
> > call to cpu_clock, which in our case currently falls back to the default
> > (weak) implementation of sched_clock() that uses jiffies -- but doesn't
> > account for the initial offset of the jiffy count.  The following simple
> > patch fixes it for me, in line with what printk_clock used to do.
> > 
> 
> Looks good, except I suspect this line will now be longer than 80
> characters and you forgot to provide your signed-off-by line.

diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index 8178724..1ce2e53 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -37,7 +37,8 @@
  */
 unsigned long long __attribute__((weak)) sched_clock(void)
 {
-       return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
+       return (unsigned long long)(jiffies - INITIAL_JIFFIES)
+                                  * (NSEC_PER_SEC / HZ);
 }
 
 static __read_mostly int sched_clock_running;


 Signed-off-by: Ron Lee <ron@debian.org>


Thanks!


