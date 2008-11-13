Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbYKMTjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbYKMTjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbYKMTeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:19 -0500
Received: from gw.goop.org ([64.81.55.164]:34398 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbYKMTeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:08 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 21 of 38] xen dom0: Initialize xenbus for dom0
X-Mercurial-Node: c91af5fdca49a2305c5a8a7afb64c07b62ddcece
Message-Id: <c91af5fdca49a2305c5a.1226603419@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:19 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juan Quintela <quintela@redhat.com>

Do initial xenbus/xenstore setup in dom0.  In dom0 we need to actually
allocate the xenstore resources, rather than being given them from
outside.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 drivers/xen/xenbus/xenbus_probe.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -810,6 +810,7 @@
 static int __init xenbus_probe_init(void)
 {
 	int err = 0;
+	unsigned long page = 0;
 
 	DPRINTK("");
 
@@ -830,7 +831,31 @@
 	 * Domain0 doesn't have a store_evtchn or store_mfn yet.
 	 */
 	if (xen_initial_domain()) {
-		/* dom0 not yet supported */
+		struct evtchn_alloc_unbound alloc_unbound;
+
+		/* Allocate Xenstore page */
+		page = get_zeroed_page(GFP_KERNEL);
+		if (!page)
+			return -ENOMEM;
+
+		xen_store_mfn = xen_start_info->store_mfn =
+			pfn_to_mfn(virt_to_phys((void *)page) >>
+				   PAGE_SHIFT);
+
+		/* Next allocate a local port which xenstored can bind to */
+		alloc_unbound.dom        = DOMID_SELF;
+		alloc_unbound.remote_dom = 0;
+
+		err = HYPERVISOR_event_channel_op(EVTCHNOP_alloc_unbound,
+						  &alloc_unbound);
+		if (err == -ENOSYS)
+			goto out_unreg_front;
+
+		BUG_ON(err);
+		xen_store_evtchn = xen_start_info->store_evtchn =
+			alloc_unbound.port;
+
+		xen_store_interface = mfn_to_virt(xen_store_mfn);
 	} else {
 		xenstored_ready = 1;
 		xen_store_evtchn = xen_start_info->store_evtchn;
@@ -858,6 +883,9 @@
 	bus_unregister(&xenbus_frontend.bus);
 
   out_error:
+	if (page != 0)
+		free_page(page);
+
 	return err;
 }
 


