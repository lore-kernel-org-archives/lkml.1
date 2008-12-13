Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbYLMXCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbYLMXCr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 18:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbYLMXCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 18:02:37 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:55139 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbYLMXCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 18:02:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=YtSCACJNUtSZoWHTrf2ouTJKkfa91CgI1wPlBc9cdv2UUhSdblRDWmbKp1PZaxT3ag
         5AKQruqK06IquqOyzPWyr7OAkfoIU35sOV5iUQw3o/OPExwdJRaqKepvjc/k1X14G5hO
         7J8pNCzLk57wNvVh34USZaPU7HY6mwK9RyFx8=
Subject: [PATCH 3/4] ieee1394: mark bus_info_data was a __be32 array
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 13 Dec 2008 15:02:34 -0800
Message-Id: <1229209354.11257.11.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two access functions get_max_rom and set_hw_config_rom are
changed to take __be32 as well.  Only bus_info_data was
ever passed in so this is OK.  All other uses of bus_info_data
treated it as a be32 value already.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/ieee1394/csr1212.h  |    4 ++--
 drivers/ieee1394/hosts.h    |    2 +-
 drivers/ieee1394/nodemgr.c  |    2 +-
 drivers/ieee1394/ohci1394.c |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/ieee1394/csr1212.h b/drivers/ieee1394/csr1212.h
index 043039f..55ab4cc 100644
--- a/drivers/ieee1394/csr1212.h
+++ b/drivers/ieee1394/csr1212.h
@@ -181,7 +181,7 @@ struct csr1212_csr_rom_cache {
 struct csr1212_csr {
 	size_t bus_info_len;	/* bus info block length in bytes */
 	size_t crc_len;		/* crc length in bytes */
-	u32 *bus_info_data;	/* bus info data incl bus name and EUI */
+	__be32 *bus_info_data;	/* bus info data incl bus name and EUI */
 
 	void *private;		/* private, bus specific data */
 	struct csr1212_bus_ops *ops;
@@ -215,7 +215,7 @@ struct csr1212_bus_ops {
 	/* This function is used by csr1212 to determine the max read request
 	 * supported by a remote node when reading the ConfigROM space.  Must
 	 * return 0, 1, or 2 per IEEE 1212.  */
-	int (*get_max_rom) (u32 *bus_info, void *private);
+	int (*get_max_rom) (__be32 *bus_info, void *private);
 };
 

diff --git a/drivers/ieee1394/hosts.h b/drivers/ieee1394/hosts.h
index dd22995..49c3590 100644
--- a/drivers/ieee1394/hosts.h
+++ b/drivers/ieee1394/hosts.h
@@ -154,7 +154,7 @@ struct hpsb_host_driver {
 	 * to set the hardware ConfigROM if the hardware supports handling
 	 * reads to the ConfigROM on its own. */
 	void (*set_hw_config_rom)(struct hpsb_host *host,
-				  quadlet_t *config_rom);
+				  __be32 *config_rom);
 
 	/* This function shall implement packet transmission based on
 	 * packet->type.  It shall CRC both parts of the packet (unless
diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
index 175a9d4..92c8b8d 100644
--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -115,7 +115,7 @@ static int nodemgr_bus_read(struct csr1212_csr *csr, u64 addr, u16 length,
 	return error;
 }
 
-static int nodemgr_get_max_rom(quadlet_t *bus_info_data, void *__ci)
+static int nodemgr_get_max_rom(__be32 *bus_info_data, void *__ci)
 {
 	return (be32_to_cpu(bus_info_data[2]) >> 8) & 0x3;
 }
diff --git a/drivers/ieee1394/ohci1394.c b/drivers/ieee1394/ohci1394.c
index 066726b..b3116d0 100644
--- a/drivers/ieee1394/ohci1394.c
+++ b/drivers/ieee1394/ohci1394.c
@@ -2973,7 +2973,7 @@ alloc_dma_trm_ctx(struct ti_ohci *ohci, struct dma_trm_ctx *d,
 	return 0;
 }
 
-static void ohci_set_hw_config_rom(struct hpsb_host *host, quadlet_t *config_rom)
+static void ohci_set_hw_config_rom(struct hpsb_host *host, __be32 *config_rom)
 {
 	struct ti_ohci *ohci = host->hostdata;
 
-- 
1.6.1.rc2.306.ge5d5e


