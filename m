Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762Ab0AEUMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab0AEUMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:12:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755466Ab0AEUGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:06:12 -0500
Received: from kroah.org ([198.145.64.141]:49941 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755454Ab0AEUGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:11 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:03:00 2010
Message-Id: <20100105200300.528030027@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [12/39] SCSI: fc class: fix fc_transport_init error handling
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Christie <michaelc@cs.wisc.edu>

commit 48de68a40aef032a2e198437f4781a83bfb938db upstream.

If transport_class_register fails we should unregister any
registered classes, or we will leak memory or other
resources.

I did a quick modprobe of scsi_transport_fc to test the
patch.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_transport_fc.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -648,11 +648,22 @@ static __init int fc_transport_init(void
 		return error;
 	error = transport_class_register(&fc_vport_class);
 	if (error)
-		return error;
+		goto unreg_host_class;
 	error = transport_class_register(&fc_rport_class);
 	if (error)
-		return error;
-	return transport_class_register(&fc_transport_class);
+		goto unreg_vport_class;
+	error = transport_class_register(&fc_transport_class);
+	if (error)
+		goto unreg_rport_class;
+	return 0;
+
+unreg_rport_class:
+	transport_class_unregister(&fc_rport_class);
+unreg_vport_class:
+	transport_class_unregister(&fc_vport_class);
+unreg_host_class:
+	transport_class_unregister(&fc_host_class);
+	return error;
 }
 
 static void __exit fc_transport_exit(void)


