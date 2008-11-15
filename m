Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbYKOI77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbYKOI77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 03:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbYKOI7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 03:59:50 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:47785 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbYKOI7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 03:59:49 -0500
Subject: Re: [RFC] Add PR_PREFIX to pr_xyz macros.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081114133213.ac98ba0f.akpm@linux-foundation.org>
References: <1226511327.23498.3.camel@localhost>
	 <alpine.LFD.2.00.0811121144400.3468@nehalem.linux-foundation.org>
	 <1226521003.2222.8.camel@localhost>
	 <20081114133213.ac98ba0f.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: IBM Corporation
Date: Sat, 15 Nov 2008 09:58:58 +0100
Message-Id: <1226739539.4672.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-14 at 13:32 -0800, Andrew Morton wrote:
> > Subject: [PATCH] Add PR_PREFIX to pr_xyz macros.
> > 
> > From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > 
> > A common reason for device drivers to implement their own printk macros
> > is the lack of a printk prefix with the standard pr_xyz macros. Introduce
> > a pr_fmt macro that is applied for every pr_xyz macro to the format string.
> > The most common use of the pr_fmt macro would be to add the name of the
> > device driver to all pr_xyz messages in a source file.
> > 
> 
> Seems sane.  It would be nice to see one such driver converted over (hint;))

I now have about two dozen examples, I've created the patches after
Linus suggested to have the pr_fmt macro in the driver. One example is
below. The same will be done for all s390 device drivers.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.

---
Subject: [PATCH] convert sclp printks to pr_xxx macros.

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/char/sclp_cmd.c     |   29 ++++++++++++++++-------------
 drivers/s390/char/sclp_config.c  |   10 ++++++----
 drivers/s390/char/sclp_cpi_sys.c |   12 ++++++++----
 drivers/s390/char/sclp_sdias.c   |   18 +++++++++++-------
 4 files changed, 41 insertions(+), 28 deletions(-)

diff -urpN linux-2.6/drivers/s390/char/sclp_cmd.c linux-2.6-patched/drivers/s390/char/sclp_cmd.c
--- linux-2.6/drivers/s390/char/sclp_cmd.c	2008-11-14 17:49:35.000000000 +0100
+++ linux-2.6-patched/drivers/s390/char/sclp_cmd.c	2008-11-14 17:50:21.000000000 +0100
@@ -6,6 +6,9 @@
  *		 Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
  */
 
+#define KMSG_COMPONENT "sclp_cmd"
+#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
+
 #include <linux/completion.h>
 #include <linux/init.h>
 #include <linux/errno.h>
@@ -16,9 +19,8 @@
 #include <linux/memory.h>
 #include <asm/chpid.h>
 #include <asm/sclp.h>
-#include "sclp.h"
 
-#define TAG	"sclp_cmd: "
+#include "sclp.h"
 
 #define SCLP_CMDW_READ_SCP_INFO		0x00020001
 #define SCLP_CMDW_READ_SCP_INFO_FORCED	0x00120001
@@ -169,8 +171,8 @@ static int do_sync_request(sclp_cmdw_t c
 
 	/* Check response. */
 	if (request->status != SCLP_REQ_DONE) {
-		printk(KERN_WARNING TAG "sync request failed "
-		       "(cmd=0x%08x, status=0x%02x)\n", cmd, request->status);
+		pr_warning("sync request failed (cmd=0x%08x, "
+			   "status=0x%02x)\n", cmd, request->status);
 		rc = -EIO;
 	}
 out:
@@ -224,8 +226,8 @@ int sclp_get_cpu_info(struct sclp_cpu_in
 	if (rc)
 		goto out;
 	if (sccb->header.response_code != 0x0010) {
-		printk(KERN_WARNING TAG "readcpuinfo failed "
-		       "(response=0x%04x)\n", sccb->header.response_code);
+		pr_warning("readcpuinfo failed (response=0x%04x)\n",
+			   sccb->header.response_code);
 		rc = -EIO;
 		goto out;
 	}
@@ -262,8 +264,9 @@ static int do_cpu_configure(sclp_cmdw_t 
 	case 0x0120:
 		break;
 	default:
-		printk(KERN_WARNING TAG "configure cpu failed (cmd=0x%08x, "
-		       "response=0x%04x)\n", cmd, sccb->header.response_code);
+		pr_warning("configure cpu failed (cmd=0x%08x, "
+			   "response=0x%04x)\n", cmd,
+			   sccb->header.response_code);
 		rc = -EIO;
 		break;
 	}
@@ -626,9 +629,9 @@ static int do_chp_configure(sclp_cmdw_t 
 	case 0x0450:
 		break;
 	default:
-		printk(KERN_WARNING TAG "configure channel-path failed "
-		       "(cmd=0x%08x, response=0x%04x)\n", cmd,
-		       sccb->header.response_code);
+		pr_warning("configure channel-path failed "
+			   "(cmd=0x%08x, response=0x%04x)\n", cmd,
+			   sccb->header.response_code);
 		rc = -EIO;
 		break;
 	}
@@ -695,8 +698,8 @@ int sclp_chp_read_info(struct sclp_chp_i
 	if (rc)
 		goto out;
 	if (sccb->header.response_code != 0x0010) {
-		printk(KERN_WARNING TAG "read channel-path info failed "
-		       "(response=0x%04x)\n", sccb->header.response_code);
+		pr_warning("read channel-path info failed "
+			   "(response=0x%04x)\n", sccb->header.response_code);
 		rc = -EIO;
 		goto out;
 	}
diff -urpN linux-2.6/drivers/s390/char/sclp_config.c linux-2.6-patched/drivers/s390/char/sclp_config.c
--- linux-2.6/drivers/s390/char/sclp_config.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6-patched/drivers/s390/char/sclp_config.c	2008-11-14 17:50:21.000000000 +0100
@@ -5,15 +5,17 @@
  *    Author(s): Heiko Carstens <heiko.carstens@de.ibm.com>
  */
 
+#define KMSG_COMPONENT "sclp_config"
+#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
+
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/cpu.h>
 #include <linux/sysdev.h>
 #include <linux/workqueue.h>
 #include <asm/smp.h>
-#include "sclp.h"
 
-#define TAG	"sclp_config: "
+#include "sclp.h"
 
 struct conf_mgm_data {
 	u8 reserved;
@@ -31,7 +33,7 @@ static void sclp_cpu_capability_notify(s
 	int cpu;
 	struct sys_device *sysdev;
 
-	printk(KERN_WARNING TAG "cpu capability changed.\n");
+	pr_warning("cpu capability changed.\n");
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
 		sysdev = get_cpu_sysdev(cpu);
@@ -78,7 +80,7 @@ static int __init sclp_conf_init(void)
 		return rc;
 
 	if (!(sclp_conf_register.sclp_send_mask & EVTYP_CONFMGMDATA_MASK)) {
-		printk(KERN_WARNING TAG "no configuration management.\n");
+		pr_warning("no configuration management.\n");
 		sclp_unregister(&sclp_conf_register);
 		rc = -ENOSYS;
 	}
diff -urpN linux-2.6/drivers/s390/char/sclp_cpi_sys.c linux-2.6-patched/drivers/s390/char/sclp_cpi_sys.c
--- linux-2.6/drivers/s390/char/sclp_cpi_sys.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6-patched/drivers/s390/char/sclp_cpi_sys.c	2008-11-14 17:50:21.000000000 +0100
@@ -7,6 +7,9 @@
  *		 Michael Ernst <mernst@de.ibm.com>
  */
 
+#define KMSG_COMPONENT "sclp_cpi"
+#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/stat.h>
@@ -20,6 +23,7 @@
 #include <linux/completion.h>
 #include <asm/ebcdic.h>
 #include <asm/sclp.h>
+
 #include "sclp.h"
 #include "sclp_rw.h"
 #include "sclp_cpi_sys.h"
@@ -150,16 +154,16 @@ static int cpi_req(void)
 	wait_for_completion(&completion);
 
 	if (req->status != SCLP_REQ_DONE) {
-		printk(KERN_WARNING "cpi: request failed (status=0x%02x)\n",
-			req->status);
+		pr_warning("request failed (status=0x%02x)\n",
+			   req->status);
 		rc = -EIO;
 		goto out_free_req;
 	}
 
 	response = ((struct cpi_sccb *) req->sccb)->header.response_code;
 	if (response != 0x0020) {
-		printk(KERN_WARNING "cpi: failed with "
-			"response code 0x%x\n", response);
+		pr_warning("request failed with response code 0x%x\n",
+			   response);
 		rc = -EIO;
 	}
 
diff -urpN linux-2.6/drivers/s390/char/sclp_sdias.c linux-2.6-patched/drivers/s390/char/sclp_sdias.c
--- linux-2.6/drivers/s390/char/sclp_sdias.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6-patched/drivers/s390/char/sclp_sdias.c	2008-11-14 17:50:21.000000000 +0100
@@ -5,15 +5,18 @@
  * Author(s): Michael Holzheu
  */
 
+#define KMSG_COMPONENT "sclp_sdias"
+#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
+
 #include <linux/sched.h>
 #include <asm/sclp.h>
 #include <asm/debug.h>
 #include <asm/ipl.h>
+
 #include "sclp.h"
 #include "sclp_rw.h"
 
 #define TRACE(x...) debug_sprintf_event(sdias_dbf, 1, x)
-#define ERROR_MSG(x...) printk ( KERN_ALERT "SDIAS: " x )
 
 #define SDIAS_RETRIES 300
 #define SDIAS_SLEEP_TICKS 50
@@ -131,7 +134,7 @@ int sclp_sdias_blk_count(void)
 
 	rc = sdias_sclp_send(&request);
 	if (rc) {
-		ERROR_MSG("sclp_send failed for get_nr_blocks\n");
+		pr_err("sclp_send failed for get_nr_blocks\n");
 		goto out;
 	}
 	if (sccb.hdr.response_code != 0x0020) {
@@ -145,7 +148,8 @@ int sclp_sdias_blk_count(void)
 			rc = sccb.evbuf.blk_cnt;
 			break;
 		default:
-			ERROR_MSG("SCLP error: %x\n", sccb.evbuf.event_status);
+			pr_err("SCLP error: %x\n",
+			       sccb.evbuf.event_status);
 			rc = -EIO;
 			goto out;
 	}
@@ -201,7 +205,7 @@ int sclp_sdias_copy(void *dest, int star
 
 	rc = sdias_sclp_send(&request);
 	if (rc) {
-		ERROR_MSG("sclp_send failed: %x\n", rc);
+		pr_err("sclp_send failed: %x\n", rc);
 		goto out;
 	}
 	if (sccb.hdr.response_code != 0x0020) {
@@ -219,9 +223,9 @@ int sclp_sdias_copy(void *dest, int star
 		case EVSTATE_NO_DATA:
 			TRACE("no data\n");
 		default:
-			ERROR_MSG("Error from SCLP while copying hsa. "
-				  "Event status = %x\n",
-				sccb.evbuf.event_status);
+			pr_err("Error from SCLP while copying hsa. "
+			       "Event status = %x\n",
+			       sccb.evbuf.event_status);
 			rc = -EIO;
 	}
 out:


