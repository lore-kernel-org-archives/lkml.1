Return-Path: <linux-kernel-owner+w=401wt.eu-S1758400AbZAVWgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400AbZAVWgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755298AbZAVWg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:36:28 -0500
Received: from gw.goop.org ([64.81.55.164]:35974 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759200AbZAVWgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:36:15 -0500
Message-ID: <4978F4D8.6090706@goop.org>
Date: Thu, 22 Jan 2009 14:36:08 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "dan.magenheimer@oracle.com" <dan.magenheimer@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Stable Kernel <stable@kernel.org>
Subject: [PATCH] xen: actually release memory when shrinking domain
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Magenheimer <dan.magenheimer@oracle.com>

Fix this:

> It appears that in the upstream balloon driver,
> > the call to HYPERVISOR_update_va_mapping is missing
> > from decrease_reservation.  I think as a result,
> > the balloon driver is eating memory but not
> > releasing it to Xen, thus rendering the balloon
> > driver essentially useless.  (Can be observed via xentop.)

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/balloon.c |    5 +++++
 1 file changed, 5 insertions(+)

===================================================================
--- linux-2.6.28/drivers/xen/balloon.c.orig
+++ linux-2.6.28/drivers/xen/balloon.c
@@ -296,6 +296,11 @@
 		frame_list[i] = pfn_to_mfn(pfn);
 
 		scrub_page(page);
+
+		ret = HYPERVISOR_update_va_mapping(
+			(unsigned long)__va(pfn << PAGE_SHIFT),
+			__pte_ma(0), 0);
+		BUG_ON(ret);
 	}
 
 	/* Ensure that ballooned highmem pages don't have kmaps. */


