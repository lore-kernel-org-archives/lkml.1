Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbYBAPIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbYBAPIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 10:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbYBAPID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 10:08:03 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1912 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753494AbYBAPIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 10:08:01 -0500
Message-ID: <47A335CA.1020301@myri.com>
Date: Fri, 01 Feb 2008 10:07:54 -0500
From: Andrew Gallatin <gallatin@myri.com>
User-Agent: Thunderbird 1.5.0.7 (Macintosh/20060909)
MIME-Version: 1.0
To: AndrewL733 <AndrewL733@aol.com>
CC: linux-kernel@vger.kernel.org, Myricom Technical Support <help@myri.com>
Subject: Re: [Myricom help #56546] Re: 2.6.24 Page Allocation Failure
References: <2517DBDB-3596-4815-89AB-E08B55F11E8E@aol.com>
In-Reply-To: <2517DBDB-3596-4815-89AB-E08B55F11E8E@aol.com>
Content-Type: multipart/mixed;
 boundary="------------050908060303090308020509"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050908060303090308020509
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

AndrewL733 wrote:
 > The cause of this problem seems to be compiling the Myricom driver with
 > the ALLOC_ORDER=2 option. When I use the in-kernel driver, (1.3.2) or
 > recompile the Myricom 1.4.0 driver WITHOUT the option, the problem seems
 > to go away even after heavy hammering of the system.
 >
 > The ALLOC_ORDER=2 compiling option doesn't seem to cause any problem for
 > the Myricom 1.4.0 driver in the 2.6.22 kernel but it does cause the
 > problem when I run it in 2.6.24.

High order allocations are much harder to satisfy than single page
allocations, which is why we default MYRI10GE_ALLOC_ORDER to zero.
Part of the reason why we receive into pages rather than plain skbs is
to be able to use jumbo frames without high order allocations.  In
your case, I suspect that "something" changed enough between 2.6.22
and 2.6.24 that caused the high order allocations to start failing
under the same workload.  I don't know enough about the VM system
to know what changed.

In some quick experiments here, it seems that most of the cost of
these failures is the console messages that they generate.  The driver
is written such that failures like this can be tolerated.  I think the
warning should just be disabled for our rx buffer allocations.

I've attached a patch (against 1.4.0) which does this.  When running a
memory hog which repeatedly reads one byte per page of an array larger
than physical memory, I still see line rate with this patch applied.
Without the patch, I see a few hundred Mb/s and constant page
allocation warnings.  Please note that this disables the warnings just
for our rx buffer allocations.  Other allocations done elsewhere in
the system may still generate warnings if the system is under heavy
memory pressure.

Drew

--------------050908060303090308020509
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="nowarn.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nowarn.diff"

Index: myri10ge.c
===================================================================
RCS file: /repository/myrige/linux/myri10ge.c,v
retrieving revision 1.313
diff -u -r1.313 myri10ge.c
--- myri10ge.c	17 Jan 2008 15:04:30 -0000	1.313
+++ myri10ge.c	1 Feb 2008 15:00:39 -0000
@@ -1655,7 +1655,8 @@
 			get_page(rx->page);
 		} else {
 			/* we need a new page */
-			page = myri10ge_alloc_pages(GFP_ATOMIC | __GFP_COMP, MYRI10GE_ALLOC_ORDER);
+			page = myri10ge_alloc_pages(GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN,
+						    MYRI10GE_ALLOC_ORDER);
 			if (unlikely(page == NULL)) {
 				if (rx->fill_cnt - rx->cnt < 16)
 					rx->watchdog_needed = 1;

--------------050908060303090308020509--
