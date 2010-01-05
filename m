Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095Ab0AEA4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab0AEA4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146Ab0AEAel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:34:41 -0500
Received: from kroah.org ([198.145.64.141]:34075 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111Ab0AEAei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:34:38 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Mike Christie <michaelc@cs.wisc.edu>,
       James Bottomley <James.Bottomley@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/97] SCSI: fc class: fix fc_transport_init error handling
Date: Mon,  4 Jan 2010 16:32:17 -0800
Message-Id: <1262651630-7354-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index c6f70da..45be82f 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -648,11 +648,22 @@ static __init int fc_transport_init(void)
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
-- 
1.6.6

