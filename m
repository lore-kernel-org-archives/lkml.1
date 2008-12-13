Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbYLMWLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbYLMWLb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 17:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbYLMWLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 17:11:23 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:49227 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbYLMWLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 17:11:23 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 13 Dec 2008 23:11:11 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/2] ieee1394: add quirk fix for Freecom HDD
To: linux1394-devel@lists.sourceforge.net, Christian Mueller <cm1@mumac.de>
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.aa600853dd4a55d9@s5r6.in-berlin.de>
Message-ID: <tkrat.61dc116fccdc7aa8@s5r6.in-berlin.de>
References: <20081212220902.10115108040@picon.linux-foundation.org>
 <4942E4E0.2030109@s5r6.in-berlin.de>
 <tkrat.cf2109296e2ea177@s5r6.in-berlin.de>
 <49441769.1060209@s5r6.in-berlin.de>
 <tkrat.aa600853dd4a55d9@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to http://bugzilla.kernel.org/show_bug.cgi?id=12206, Freecom
FireWire Hard Drive 1TB reports max_rom=2 but returns garbage if block
read requests are used to read the config ROM.  Force max_rom=0 to limit
them to quadlet read requests.

Reported-by: Christian Mueller <cm1@mumac.de>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Candidate patch for 2.6.28 and 2.6.27.y.
Christian, please test  and confirm that I got this right.

(Oops, I forgot to Cc Christian in the first posting.)

 drivers/ieee1394/nodemgr.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux/drivers/ieee1394/nodemgr.c
===================================================================
--- linux.orig/drivers/ieee1394/nodemgr.c
+++ linux/drivers/ieee1394/nodemgr.c
@@ -115,8 +115,14 @@ static int nodemgr_bus_read(struct csr12
 	return error;
 }
 
+#define OUI_FREECOM_TECHNOLOGIES_GMBH 0x0001db
+
 static int nodemgr_get_max_rom(quadlet_t *bus_info_data, void *__ci)
 {
+	/* Freecom FireWire Hard Drive firmware bug */
+	if (be32_to_cpu(bus_info_data[3]) >> 8 == OUI_FREECOM_TECHNOLOGIES_GMBH)
+		return 0;
+
 	return (be32_to_cpu(bus_info_data[2]) >> 8) & 0x3;
 }
 

-- 
Stefan Richter
-=====-==--- ==-- -==-=
http://arcgraph.de/sr/

