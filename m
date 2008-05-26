Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbYEZWVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbYEZWVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 18:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbYEZWVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 18:21:18 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:14975 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247AbYEZWVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 18:21:16 -0400
X-IronPort-AV: E=Sophos;i="4.27,544,1204531200"; 
   d="scan'208";a="72405170"
From: Roland Dreier <rdreier@cisco.com>
To: Ralph Campbell <ralph.campbell@qlogic.com>
Cc: Gabriel C <nix.or.die@googlemail.com>, linux-next@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       general@lists.openfabrics.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ofa-general] Re: linux-next: [PATCH] infiniband/hw/ipath/ipath_sdma.c , fix compiler warnings
References: <48342C6C.2010502@googlemail.com> <adave14apdr.fsf@cisco.com>
	<1211579101.3949.326.camel@brick.pathscale.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 26 May 2008 15:21:15 -0700
In-Reply-To: <1211579101.3949.326.camel@brick.pathscale.com> (Ralph Campbell's
	message of "Fri, 23 May 2008 14:45:01 -0700")
Message-ID: <adabq2s4sh0.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 May 2008 22:21:15.0937 (UTC) FILETIME=[D02BB910:01C8BF7E]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, I added the following to my tree:

commit e8ffef73c8dd2c2d00287829db87cdaf229d3859
Author: Roland Dreier <rolandd@cisco.com>
Date:   Mon May 26 15:20:34 2008 -0700

    IB/ipath: Avoid test_bit() on u64 SDMA status value
    
    Gabriel C <nix.or.die@googlemail.com> pointed out that when the x86
    bitops are updated to operate on unsigned long, the code in
    sdma_abort_task() will produce warnings:
    
        drivers/infiniband/hw/ipath/ipath_sdma.c: In function 'sdma_abort_task':
        drivers/infiniband/hw/ipath/ipath_sdma.c:267: warning: passing argument 2 of 'constant_test_bit' from incompatible pointer type
    
    and so on, because it uses test_bit() to operation on a u64 value
    (returned by ipath_read_kref64() for a hardware register).
    
    Fix up these warnings by converting the test_bit() operations to &ing
    with appropriate symbolic defines of the bits within the hardware
    register.  This has the benign side-effect of making the code more
    self-documenting as well.
    
    Signed-off-by: Roland Dreier <rolandd@cisco.com>

diff --git a/drivers/infiniband/hw/ipath/ipath_kernel.h b/drivers/infiniband/hw/ipath/ipath_kernel.h
index 59a8b25..0bd8bcb 100644
--- a/drivers/infiniband/hw/ipath/ipath_kernel.h
+++ b/drivers/infiniband/hw/ipath/ipath_kernel.h
@@ -232,6 +232,11 @@ struct ipath_sdma_desc {
 #define IPATH_SDMA_TXREQ_S_ABORTED   2
 #define IPATH_SDMA_TXREQ_S_SHUTDOWN  3
 
+#define IPATH_SDMA_STATUS_SCORE_BOARD_DRAIN_IN_PROG	(1ull << 63)
+#define IPATH_SDMA_STATUS_ABORT_IN_PROG			(1ull << 62)
+#define IPATH_SDMA_STATUS_INTERNAL_SDMA_ENABLE		(1ull << 61)
+#define IPATH_SDMA_STATUS_SCB_EMPTY			(1ull << 30)
+
 /* max dwords in small buffer packet */
 #define IPATH_SMALLBUF_DWORDS (dd->ipath_piosize2k >> 2)
 
diff --git a/drivers/infiniband/hw/ipath/ipath_sdma.c b/drivers/infiniband/hw/ipath/ipath_sdma.c
index 0a8c1b8..eaba032 100644
--- a/drivers/infiniband/hw/ipath/ipath_sdma.c
+++ b/drivers/infiniband/hw/ipath/ipath_sdma.c
@@ -263,14 +263,10 @@ static void sdma_abort_task(unsigned long opaque)
 		hwstatus = ipath_read_kreg64(dd,
 				dd->ipath_kregs->kr_senddmastatus);
 
-		if (/* ScoreBoardDrainInProg */
-		    test_bit(63, &hwstatus) ||
-		    /* AbortInProg */
-		    test_bit(62, &hwstatus) ||
-		    /* InternalSDmaEnable */
-		    test_bit(61, &hwstatus) ||
-		    /* ScbEmpty */
-		    !test_bit(30, &hwstatus)) {
+		if ((hwstatus & (IPATH_SDMA_STATUS_SCORE_BOARD_DRAIN_IN_PROG |
+				 IPATH_SDMA_STATUS_ABORT_IN_PROG	     |
+				 IPATH_SDMA_STATUS_INTERNAL_SDMA_ENABLE)) ||
+		    !(hwstatus & IPATH_SDMA_STATUS_SCB_EMPTY)) {
 			if (dd->ipath_sdma_reset_wait > 0) {
 				/* not done shutting down sdma */
 				--dd->ipath_sdma_reset_wait;
