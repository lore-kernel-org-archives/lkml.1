Return-Path: <linux-kernel-owner+w=401wt.eu-S1760283AbYGRWOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760283AbYGRWOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760111AbYGRWLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:11:43 -0400
Received: from styx.suse.cz ([82.119.242.94]:55547 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760090AbYGRWLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:11:41 -0400
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 09/12] ipwireless: Explicitly request io and mem regions
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dsterba@suse.cz, jkosina@suse.cz
Date: Sat, 19 Jul 2008 00:11:40 +0200
Message-ID: <20080718221140.19195.62126.stgit@ds.suse.cz>
In-Reply-To: <20080718220840.19195.4140.stgit@ds.suse.cz>
References: <20080718220840.19195.4140.stgit@ds.suse.cz>
User-Agent: StGIT/0.14.3.173.g2e37
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/pcmcia/driver-changes.txt says, that driver should call request_region
for used memory/io regions since PCMCIA does not do this (since 2.6.8).

Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---

 drivers/char/pcmcia/ipwireless/main.c |   79 +++++++++++++++++++--------------
 drivers/char/pcmcia/ipwireless/main.h |    5 ++
 2 files changed, 50 insertions(+), 34 deletions(-)

diff --git a/drivers/char/pcmcia/ipwireless/main.c b/drivers/char/pcmcia/ipwireless/main.c
index 6bdd11d..7169a0d 100644
--- a/drivers/char/pcmcia/ipwireless/main.c
+++ b/drivers/char/pcmcia/ipwireless/main.c
@@ -88,8 +88,6 @@ static int config_ipwireless(struct ipw_dev *ipw)
 	unsigned short buf[64];
 	cisparse_t parse;
 	unsigned short cor_value;
-	win_req_t request_attr_memory;
-	win_req_t request_common_memory;
 	memreq_t memreq_attr_memory;
 	memreq_t memreq_common_memory;
 
@@ -188,6 +186,9 @@ static int config_ipwireless(struct ipw_dev *ipw)
 		goto exit0;
 	}
 
+	request_region(link->io.BasePort1, link->io.NumPorts1,
+			IPWIRELESS_PCCARD_NAME);
+
 	/* memory settings */
 
 	tuple.DesiredTuple = CISTPL_CFTABLE_ENTRY;
@@ -214,16 +215,16 @@ static int config_ipwireless(struct ipw_dev *ipw)
 	}
 
 	if (parse.cftable_entry.mem.nwin > 0) {
-		request_common_memory.Attributes =
+		ipw->request_common_memory.Attributes =
 			WIN_DATA_WIDTH_16 | WIN_MEMORY_TYPE_CM | WIN_ENABLE;
-		request_common_memory.Base =
+		ipw->request_common_memory.Base =
 			parse.cftable_entry.mem.win[0].host_addr;
-		request_common_memory.Size = parse.cftable_entry.mem.win[0].len;
-		if (request_common_memory.Size < 0x1000)
-			request_common_memory.Size = 0x1000;
-		request_common_memory.AccessSpeed = 0;
+		ipw->request_common_memory.Size = parse.cftable_entry.mem.win[0].len;
+		if (ipw->request_common_memory.Size < 0x1000)
+			ipw->request_common_memory.Size = 0x1000;
+		ipw->request_common_memory.AccessSpeed = 0;
 
-		ret = pcmcia_request_window(&link, &request_common_memory,
+		ret = pcmcia_request_window(&link, &ipw->request_common_memory,
 				&ipw->handle_common_memory);
 
 		if (ret != CS_SUCCESS) {
@@ -246,16 +247,18 @@ static int config_ipwireless(struct ipw_dev *ipw)
 		ipw->is_v2_card =
 			parse.cftable_entry.mem.win[0].len == 0x100;
 
-		ipw->common_memory = ioremap(request_common_memory.Base,
-				request_common_memory.Size);
+		ipw->common_memory = ioremap(ipw->request_common_memory.Base,
+				ipw->request_common_memory.Size);
+		request_mem_region(ipw->request_common_memory.Base,
+				ipw->request_common_memory.Size, IPWIRELESS_PCCARD_NAME);
 
-		request_attr_memory.Attributes =
+		ipw->request_attr_memory.Attributes =
 			WIN_DATA_WIDTH_16 | WIN_MEMORY_TYPE_AM | WIN_ENABLE;
-		request_attr_memory.Base = 0;
-		request_attr_memory.Size = 0;	/* this used to be 0x1000 */
-		request_attr_memory.AccessSpeed = 0;
+		ipw->request_attr_memory.Base = 0;
+		ipw->request_attr_memory.Size = 0;	/* this used to be 0x1000 */
+		ipw->request_attr_memory.AccessSpeed = 0;
 
-		ret = pcmcia_request_window(&link, &request_attr_memory,
+		ret = pcmcia_request_window(&link, &ipw->request_attr_memory,
 				&ipw->handle_attr_memory);
 
 		if (ret != CS_SUCCESS) {
@@ -274,8 +277,10 @@ static int config_ipwireless(struct ipw_dev *ipw)
 			goto exit2;
 		}
 
-		ipw->attr_memory = ioremap(request_attr_memory.Base,
-				request_attr_memory.Size);
+		ipw->attr_memory = ioremap(ipw->request_attr_memory.Base,
+				ipw->request_attr_memory.Size);
+		request_mem_region(ipw->request_attr_memory.Base, ipw->request_attr_memory.Size,
+				IPWIRELESS_PCCARD_NAME);
 	}
 
 	INIT_WORK(&ipw->work_reboot, signalled_reboot_work);
@@ -312,12 +317,12 @@ static int config_ipwireless(struct ipw_dev *ipw)
 	if (ipw->attr_memory && ipw->common_memory)
 		printk(KERN_INFO IPWIRELESS_PCCARD_NAME
 			": attr memory 0x%08lx-0x%08lx, common memory 0x%08lx-0x%08lx\n",
-			request_attr_memory.Base,
-			request_attr_memory.Base
-			+ request_attr_memory.Size - 1,
-			request_common_memory.Base,
-			request_common_memory.Base
-			+ request_common_memory.Size - 1);
+			ipw->request_attr_memory.Base,
+			ipw->request_attr_memory.Base
+			+ ipw->request_attr_memory.Size - 1,
+			ipw->request_common_memory.Base,
+			ipw->request_common_memory.Base
+			+ ipw->request_common_memory.Size - 1);
 
 	ipw->network = ipwireless_network_create(ipw->hardware);
 	if (!ipw->network)
@@ -349,12 +354,16 @@ exit4:
 	pcmcia_disable_device(link);
 exit3:
 	if (ipw->attr_memory) {
+		release_mem_region(ipw->request_attr_memory.Base,
+				ipw->request_attr_memory.Size);
 		iounmap(ipw->attr_memory);
 		pcmcia_release_window(ipw->handle_attr_memory);
 		pcmcia_disable_device(link);
 	}
 exit2:
 	if (ipw->common_memory) {
+		release_mem_region(ipw->request_common_memory.Base,
+				ipw->request_common_memory.Size);
 		iounmap(ipw->common_memory);
 		pcmcia_release_window(ipw->handle_common_memory);
 	}
@@ -366,19 +375,25 @@ exit0:
 
 static void release_ipwireless(struct ipw_dev *ipw)
 {
-	struct pcmcia_device *link = ipw->link;
-
-	pcmcia_disable_device(link);
+	pcmcia_disable_device(ipw->link);
 
-	if (ipw->common_memory)
+	if (ipw->common_memory) {
+		release_mem_region(ipw->request_common_memory.Base,
+				ipw->request_common_memory.Size);
 		iounmap(ipw->common_memory);
-	if (ipw->attr_memory)
+	}
+	if (ipw->attr_memory) {
+		release_mem_region(ipw->request_attr_memory.Base,
+				ipw->request_attr_memory.Size);
 		iounmap(ipw->attr_memory);
+	}
 	if (ipw->common_memory)
 		pcmcia_release_window(ipw->handle_common_memory);
 	if (ipw->attr_memory)
 		pcmcia_release_window(ipw->handle_attr_memory);
-	pcmcia_disable_device(link);
+
+	/* Break the link with Card Services */
+	pcmcia_disable_device(ipw->link);
 }
 
 /*
@@ -436,10 +451,6 @@ static void ipwireless_detach(struct pcmcia_device *link)
 
 	release_ipwireless(ipw);
 
-	/* Break the link with Card Services */
-	if (link)
-		pcmcia_disable_device(link);
-
 	if (ipw->tty != NULL)
 		ipwireless_tty_free(ipw->tty);
 	if (ipw->network != NULL)
diff --git a/drivers/char/pcmcia/ipwireless/main.h b/drivers/char/pcmcia/ipwireless/main.h
index 1bfdcc8..0e0363a 100644
--- a/drivers/char/pcmcia/ipwireless/main.h
+++ b/drivers/char/pcmcia/ipwireless/main.h
@@ -45,10 +45,15 @@ struct ipw_tty;
 struct ipw_dev {
 	struct pcmcia_device *link;
 	int is_v2_card;
+
 	window_handle_t handle_attr_memory;
 	void __iomem *attr_memory;
+	win_req_t request_attr_memory;
+
 	window_handle_t handle_common_memory;
 	void __iomem *common_memory;
+	win_req_t request_common_memory;
+
 	dev_node_t nodes[2];
 	/* Reference to attribute memory, containing CIS data */
 	void *attribute_memory;

