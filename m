Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbZAHK3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbZAHK3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 05:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbZAHK30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 05:29:26 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:59295 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZAHK3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 05:29:25 -0500
From: Chandru <chandru@in.ibm.com>
Organization: ibm
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: 2.6.28-rc9 panics with crashkernel=256M while booting
Date: Thu, 8 Jan 2009 15:59:21 +0530
User-Agent: KMail/1.9.10
Cc: Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <200812241325.49404.chandru@in.ibm.com> <200901071828.13719.chandru@in.ibm.com> <1231349125.23462.81.camel@nimitz>
In-Reply-To: <1231349125.23462.81.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901081559.22204.chandru@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 January 2009 22:55:25 Dave Hansen wrote:
> 
> I'm just suggesting making your fix in the ppc code instead of in
> mm/bootmem.c.
> 

Here are the changes that helped to boot the kernel. Please review it.
Thanks,

Signed-off-by: Chandru S <chandru@linux.vnet.ibm.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
---

 arch/powerpc/mm/numa.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- linux-2.6.28/arch/powerpc/mm/numa.c.orig	2009-01-08 03:20:41.000000000 -0600
+++ linux-2.6.28/arch/powerpc/mm/numa.c	2009-01-08 03:50:41.000000000 -0600
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/nodemask.h>
 #include <linux/cpu.h>
+#include <linux/pfn.h>
 #include <linux/notifier.h>
 #include <linux/lmb.h>
 #include <linux/of.h>
@@ -898,9 +899,17 @@ static void mark_reserved_regions_for_ni
 			 * if reserved region extends past active region
 			 * then trim size to active region
 			 */
-			if (end_pfn > node_ar.end_pfn)
+			if (end_pfn > node_ar.end_pfn) {
 				reserve_size = (node_ar.end_pfn << PAGE_SHIFT)
 					- (start_pfn << PAGE_SHIFT);
+				/*
+				 * resize it further if the reservation could
+				 * cross the last page in this node
+				 */
+				if (PFN_UP(physbase+reserve_size) >
+						 node_end_pfn)
+					reserve_size -= PAGE_SIZE;
+			}
 			/*
 			 * Only worry about *this* node, others may not
 			 * yet have valid NODE_DATA().
