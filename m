Return-Path: <linux-kernel-owner+w=401wt.eu-S1759125AbZCMQap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125AbZCMQap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbZCMQaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:30:14 -0400
Received: from gw.goop.org ([64.81.55.164]:56735 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754443AbZCMQaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:30:13 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Juan Quintela <quintela@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 02/15] xen dom0: Initialize xenbus for dom0.
Date: Fri, 13 Mar 2009 09:29:43 -0700
Message-Id: <1236961796-13407-3-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236961796-13407-1-git-send-email-jeremy@goop.org>
References: <1236961796-13407-1-git-send-email-jeremy@goop.org>
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
 1 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 773d1cf..38aaec3 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -821,6 +821,7 @@ void xenbus_probe(struct work_struct *unused)
 static int __init xenbus_probe_init(void)
 {
 	int err = 0;
+	unsigned long page = 0;
 
 	DPRINTK("");
 
@@ -841,7 +842,31 @@ static int __init xenbus_probe_init(void)
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
@@ -877,6 +902,9 @@ static int __init xenbus_probe_init(void)
 	bus_unregister(&xenbus_frontend.bus);
 
   out_error:
+	if (page != 0)
+		free_page(page);
+
 	return err;
 }
 
-- 
1.6.0.6

