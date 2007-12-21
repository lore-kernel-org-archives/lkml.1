Return-Path: <linux-kernel-owner+w=401wt.eu-S1760294AbXLUBHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760294AbXLUBHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 20:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbXLUBHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 20:07:18 -0500
Received: from waste.org ([66.93.16.53]:33143 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbXLUBHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 20:07:17 -0500
Date: Thu, 20 Dec 2007 19:06:55 -0600
From: Matt Mackall <mpm@selenic.com>
To: David Miller <davem@davemloft.net>
Cc: m.kozlowski@tuxland.pl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: 2.6.24-rc5-mm1: problems with cat /proc/kpageflags
Message-ID: <20071221010653.GA19691@waste.org>
References: <20071220.045359.107684960.davem@davemloft.net> <20071220174540.GW19691@waste.org> <200712202047.56745.m.kozlowski@tuxland.pl> <20071220.161726.68534356.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220.161726.68534356.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 04:17:26PM -0800, David Miller wrote:
> From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> Date: Thu, 20 Dec 2007 20:47:55 +0100
> 
> > [  145.128915] TSTATE: 0000004411009603 TPC: 00000000005119ac TNPC: 00000000005119b0 Y: 00000000    Not tainted
> > [  145.128940] TPC: <kpagecount_read+0x94/0xe0>
> 
> My suspicion at this point is that with certain RAM layouts, simply
> iterating over PFN's is simply not working out.

That was my original suspicion, which is why I asked Mariusz to
effectively comment out the actual PFN lookup up-thread. I didn't send
him a patch to do that, so I guess my instructions on how to hack it
may have been misunderstood.
 
> pfn_to_page() seems to be doing no range checking, and with sparsemem
> vmemmap, which sparc64 always uses, this can be problematic.
> 
> It just blindly goes "vmemmap + pfn" which is asking for trouble, in
> particular when the physical RAM layout really is sparse.
> 
> Maybe it's enough to add a pfn_valid() check here?  If pfn_valid()
> means there is a vmemmap translation setup for that page struct too,
> it would work.

Here's a test patch:

Index: mm/fs/proc/proc_misc.c
===================================================================
--- mm.orig/fs/proc/proc_misc.c	2007-12-20 19:04:35.000000000 -0600
+++ mm/fs/proc/proc_misc.c	2007-12-20 19:06:01.000000000 -0600
@@ -707,7 +707,10 @@ static ssize_t kpagecount_read(struct fi
 		return -EIO;
 
 	while (count > 0) {
-		ppage = pfn_to_page(pfn++);
+		ppage = 0;
+		if (pfn_valid(pfn))
+			ppage = pfn_to_page(pfn);
+		pfn++;
 		if (!ppage)
 			pcount = 0;
 		else
@@ -773,7 +776,10 @@ static ssize_t kpageflags_read(struct fi
 		return -EIO;
 
 	while (count > 0) {
-		ppage = pfn_to_page(pfn++);
+		ppage = 0;
+		if (pfn_valid(pfn))
+			ppage = pfn_to_page(pfn);
+		pfn++;
 		if (!ppage)
 			kflags = 0;
 		else


-- 
Mathematics is the supreme nostalgia of our time.
