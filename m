Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbXF3DZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbXF3DZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 23:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbXF3DYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 23:24:38 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:41380 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbXF3DYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 23:24:34 -0400
Subject: [RFC PATCH 3/6] Conversion of some s390 drivers to DTI
From: Tom Zanussi <zanussi@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: dwilder@us.ibm.com, HOLZHEU@de.ibm.com
Content-Type: text/plain
Date: Fri, 29 Jun 2007 22:24:01 -0500
Message-Id: <1183173841.24291.139.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does a first pass at converting some of the s390 drivers
from s390dbf to DTI.  The others can be converted later if DTI is ever
merged.  Note that the location of the trace files is now under
/sys/kernel/debug/dti rather than /sys/kernel/debug/s390dbf.  There
are also some other differences e.g. there are no longer 'hex views'
in the kernel - this would be done instead via the userspace
'dtiprint' utility.  Also, dynamic resizing isn't currently supported.

Signed-off-by: Tom Zanussi <zanussi@us.ibm.com>
Signed-off-by: David Wilder <dwilder@us.ibm.com>
---
 block/dasd.c     |   18 ++++++++----------
 block/dasd_int.h |   54 ++++++++++++++++++++++++++++--------------------------
 char/tape.h      |    9 +++++----
 char/tape_34xx.c |    9 ++++-----
 char/tape_3590.c |    9 ++++-----
 char/tape_core.c |    9 ++++-----
 cio/cio.c        |   27 ++++++++++++---------------
 cio/cio_debug.h  |   19 ++++++++-----------
 8 files changed, 73 insertions(+), 81 deletions(-)

diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index bfeca57..eafdaa7 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/buffer_head.h>
 #include <linux/hdreg.h>
+#include <linux/dti.h>
 
 #include <asm/ccwdev.h>
 #include <asm/ebcdic.h>
@@ -35,7 +36,7 @@
 /*
  * SECTION: exported variables of dasd.c
  */
-debug_info_t *dasd_debug_area;
+struct dti_info *dasd_debug_area;
 struct dasd_discipline *dasd_diag_discipline_pointer;
 void dasd_int_handler(struct ccw_device *, unsigned long, struct irb *);
 
@@ -181,10 +182,8 @@ dasd_state_known_to_basic(struct dasd_device * device)
 		return rc;
 
 	/* register 'device' debug area, used for all DBF_DEV_XXX calls */
-	device->debug_area = debug_register(device->cdev->dev.bus_id, 1, 2,
-					    8 * sizeof (long));
-	debug_register_view(device->debug_area, &debug_sprintf_view);
-	debug_set_level(device->debug_area, DBF_WARNING);
+	device->debug_area = dti_register(device->cdev->dev.bus_id, 4096, 4);
+	dti_set_level(device->debug_area, DBF_WARNING);
 	DBF_DEV_EVENT(DBF_EMERG, device, "%s", "debug area created");
 
 	device->state = DASD_STATE_BASIC;
@@ -207,7 +206,7 @@ dasd_state_basic_to_known(struct dasd_device * device)
 
 	DBF_DEV_EVENT(DBF_EMERG, device, "%p debug area deleted", device);
 	if (device->debug_area != NULL) {
-		debug_unregister(device->debug_area);
+		dti_unregister(device->debug_area);
 		device->debug_area = NULL;
 	}
 	device->state = DASD_STATE_KNOWN;
@@ -1924,7 +1923,7 @@ dasd_exit(void)
 	dasd_gendisk_exit();
 	dasd_devmap_exit();
 	if (dasd_debug_area != NULL) {
-		debug_unregister(dasd_debug_area);
+		dti_unregister(dasd_debug_area);
 		dasd_debug_area = NULL;
 	}
 }
@@ -2231,13 +2230,12 @@ dasd_init(void)
 	init_waitqueue_head(&dasd_flush_wq);
 
 	/* register 'common' DASD debug area, used for all DBF_XXX calls */
-	dasd_debug_area = debug_register("dasd", 1, 2, 8 * sizeof (long));
+	dasd_debug_area = dti_register("dasd", 4096, 4);
 	if (dasd_debug_area == NULL) {
 		rc = -ENOMEM;
 		goto failed;
 	}
-	debug_register_view(dasd_debug_area, &debug_sprintf_view);
-	debug_set_level(dasd_debug_area, DBF_WARNING);
+	dti_set_level(dasd_debug_area, DBF_WARNING);
 
 	DBF_EVENT(DBF_EMERG, "%s", "debug area created");
 
diff --git a/drivers/s390/block/dasd_int.h b/drivers/s390/block/dasd_int.h
index 241294c..324ed1e 100644
--- a/drivers/s390/block/dasd_int.h
+++ b/drivers/s390/block/dasd_int.h
@@ -13,6 +13,8 @@
 
 #ifdef __KERNEL__
 
+#include <linux/dti.h>
+
 /* we keep old device allocation scheme; IOW, minors are still in 0..255 */
 #define DASD_PER_MAJOR (1U << (MINORBITS - DASD_PARTN_BITS))
 #define DASD_PARTN_MASK ((1 << DASD_PARTN_BITS) - 1)
@@ -82,45 +84,45 @@ typedef enum {
  */
 #define DBF_DEV_EVENT(d_level, d_device, d_str, d_data...) \
 do { \
-	debug_sprintf_event(d_device->debug_area, \
-			    d_level, \
-			    d_str "\n", \
-			    d_data); \
+	__dti_printk(d_device->debug_area,   \
+		     d_level,		     \
+		     d_str "\n",	     \
+		     d_data);		     \
 } while(0)
 
 #define DBF_DEV_EXC(d_level, d_device, d_str, d_data...) \
 do { \
-	debug_sprintf_exception(d_device->debug_area, \
-				d_level, \
-				d_str "\n", \
-				d_data); \
+	__dti_printk(d_device->debug_area, \
+		     d_level,		   \
+		     d_str "\n",	   \
+		     d_data);		   \
 } while(0)
 
 #define DBF_EVENT(d_level, d_str, d_data...)\
 do { \
-	debug_sprintf_event(dasd_debug_area, \
-			    d_level,\
-			    d_str "\n", \
-			    d_data); \
+	__dti_printk(dasd_debug_area,		\
+		       d_level,			\
+		       d_str "\n",		\
+		       d_data);			\
 } while(0)
 
 #define DBF_EXC(d_level, d_str, d_data...)\
 do { \
-	debug_sprintf_exception(dasd_debug_area, \
-				d_level,\
-				d_str "\n", \
-				d_data); \
+	__dti_printk(dasd_debug_area,       \
+		     d_level,		    \
+		     d_str "\n",	    \
+		     d_data);		    \
 } while(0)
 
 /* definition of dbf debug levels */
-#define	DBF_EMERG	0	/* system is unusable			*/
-#define	DBF_ALERT	1	/* action must be taken immediately	*/
-#define	DBF_CRIT	2	/* critical conditions			*/
-#define	DBF_ERR		3	/* error conditions			*/
-#define	DBF_WARNING	4	/* warning conditions			*/
-#define	DBF_NOTICE	5	/* normal but significant condition	*/
-#define	DBF_INFO	6	/* informational			*/
-#define	DBF_DEBUG	6	/* debug-level messages			*/
+#define	DBF_EMERG	DTI_LEVEL_EMERG	/* system is unusable			*/
+#define	DBF_ALERT	DTI_LEVEL_ALERT	/* action must be taken immediately	*/
+#define	DBF_CRIT	DTI_LEVEL_CRIT	/* critical conditions			*/
+#define	DBF_ERR		DTI_LEVEL_ERR	/* error conditions			*/
+#define	DBF_WARNING	DTI_LEVEL_WARNING	/* warning conditions			*/
+#define	DBF_NOTICE	DTI_LEVEL_NOTICE	/* normal but significant condition	*/
+#define	DBF_INFO	DTI_LEVEL_INFO	/* informational			*/
+#define	DBF_DEBUG	DTI_LEVEL_DEBUG	/* debug-level messages			*/
 
 /* messages to be written via klogd and dbf */
 #define DEV_MESSAGE(d_loglevel,d_device,d_string,d_args...)\
@@ -332,7 +334,7 @@ struct dasd_device {
 	struct work_struct kick_work;
 	struct timer_list timer;
 
-	debug_info_t *debug_area;
+	struct dti_info *debug_area;
 
 	struct ccw_device *cdev;
 
@@ -465,7 +467,7 @@ dasd_check_blocksize(int bsize)
 #define DASD_PROFILE_ON	 1
 #define DASD_PROFILE_OFF 0
 
-extern debug_info_t *dasd_debug_area;
+extern struct dti_info *dasd_debug_area;
 extern struct dasd_profile_info_t dasd_global_profile;
 extern unsigned int dasd_profile_level;
 extern struct block_device_operations dasd_device_operations;
diff --git a/drivers/s390/char/tape.h b/drivers/s390/char/tape.h
index 3b52f5c..e3a2566 100644
--- a/drivers/s390/char/tape.h
+++ b/drivers/s390/char/tape.h
@@ -22,6 +22,7 @@
 #include <linux/mtio.h>
 #include <linux/interrupt.h>
 #include <linux/workqueue.h>
+#include <linux/dti.h>
 
 struct gendisk;
 
@@ -32,7 +33,7 @@ struct gendisk;
 #ifdef  DBF_LIKE_HELL
 #define DBF_LH(level, str, ...) \
 do { \
-	debug_sprintf_event(TAPE_DBF_AREA, level, str, ## __VA_ARGS__); \
+	__dti_printk(TAPE_DBF_AREA, level, str, ## __VA_ARGS__); \
 } while (0)
 #else
 #define DBF_LH(level, str, ...) do {} while(0)
@@ -43,12 +44,12 @@ do { \
  */
 #define DBF_EVENT(d_level, d_str...) \
 do { \
-	debug_sprintf_event(TAPE_DBF_AREA, d_level, d_str); \
+	__dti_printk(TAPE_DBF_AREA, d_level, d_str); \
 } while (0)
 
 #define DBF_EXCEPTION(d_level, d_str...) \
 do { \
-	debug_sprintf_exception(TAPE_DBF_AREA, d_level, d_str); \
+	__dti_printk(TAPE_DBF_AREA, d_level, d_str); \
 } while (0)
 
 #define TAPE_VERSION_MAJOR 2
@@ -330,7 +331,7 @@ extern void tape_dump_sense_dbf(struct tape_device *, struct tape_request *,
 extern void tape_med_state_set(struct tape_device *, enum tape_medium_state);
 
 /* The debug area */
-extern debug_info_t *TAPE_DBF_AREA;
+extern struct dti_info *TAPE_DBF_AREA;
 
 /* functions for building ccws */
 static inline struct ccw1 *
diff --git a/drivers/s390/char/tape_34xx.c b/drivers/s390/char/tape_34xx.c
index e765875..2233e20 100644
--- a/drivers/s390/char/tape_34xx.c
+++ b/drivers/s390/char/tape_34xx.c
@@ -23,7 +23,7 @@
 /*
  * Pointer to debug area.
  */
-debug_info_t *TAPE_DBF_AREA = NULL;
+struct dti_info *TAPE_DBF_AREA = NULL;
 EXPORT_SYMBOL(TAPE_DBF_AREA);
 
 #define TAPE34XX_FMT_3480	0
@@ -1343,10 +1343,9 @@ tape_34xx_init (void)
 {
 	int rc;
 
-	TAPE_DBF_AREA = debug_register ( "tape_34xx", 2, 2, 4*sizeof(long));
-	debug_register_view(TAPE_DBF_AREA, &debug_sprintf_view);
+	TAPE_DBF_AREA = dti_register ( "tape_34xx", 4096, 4);
 #ifdef DBF_LIKE_HELL
-	debug_set_level(TAPE_DBF_AREA, 6);
+	dti_set_level(TAPE_DBF_AREA, 6);
 #endif
 
 	DBF_EVENT(3, "34xx init\n");
@@ -1364,7 +1363,7 @@ tape_34xx_exit(void)
 {
 	ccw_driver_unregister(&tape_34xx_driver);
 
-	debug_unregister(TAPE_DBF_AREA);
+	dti_unregister(TAPE_DBF_AREA);
 }
 
 MODULE_DEVICE_TABLE(ccw, tape_34xx_ids);
diff --git a/drivers/s390/char/tape_3590.c b/drivers/s390/char/tape_3590.c
index 7e2b2ab..bf01c1a 100644
--- a/drivers/s390/char/tape_3590.c
+++ b/drivers/s390/char/tape_3590.c
@@ -22,7 +22,7 @@
 /*
  * Pointer to debug area.
  */
-debug_info_t *TAPE_DBF_AREA = NULL;
+struct dti_info *TAPE_DBF_AREA = NULL;
 EXPORT_SYMBOL(TAPE_DBF_AREA);
 
 /*******************************************************************
@@ -1730,10 +1730,9 @@ tape_3590_init(void)
 {
 	int rc;
 
-	TAPE_DBF_AREA = debug_register("tape_3590", 2, 2, 4 * sizeof(long));
-	debug_register_view(TAPE_DBF_AREA, &debug_sprintf_view);
+	TAPE_DBF_AREA = dti_register("tape_3590", 4096, 4);
 #ifdef DBF_LIKE_HELL
-	debug_set_level(TAPE_DBF_AREA, 6);
+	dti_set_level(TAPE_DBF_AREA, 6);
 #endif
 
 	DBF_EVENT(3, "3590 init\n");
@@ -1751,7 +1750,7 @@ tape_3590_exit(void)
 {
 	ccw_driver_unregister(&tape_3590_driver);
 
-	debug_unregister(TAPE_DBF_AREA);
+	dti_unregister(TAPE_DBF_AREA);
 }
 
 MODULE_DEVICE_TABLE(ccw, tape_3590_ids);
diff --git a/drivers/s390/char/tape_core.c b/drivers/s390/char/tape_core.c
index 2fae633..23e38c7 100644
--- a/drivers/s390/char/tape_core.c
+++ b/drivers/s390/char/tape_core.c
@@ -43,7 +43,7 @@ static DEFINE_RWLOCK(tape_device_lock);
 /*
  * Pointer to debug area.
  */
-debug_info_t *TAPE_DBF_AREA = NULL;
+struct dti_info *TAPE_DBF_AREA = NULL;
 EXPORT_SYMBOL(TAPE_DBF_AREA);
 
 /*
@@ -1297,10 +1297,9 @@ tape_mtop(struct tape_device *device, int mt_op, int mt_count)
 static int
 tape_init (void)
 {
-	TAPE_DBF_AREA = debug_register ( "tape", 2, 2, 4*sizeof(long));
-	debug_register_view(TAPE_DBF_AREA, &debug_sprintf_view);
+	TAPE_DBF_AREA = dti_register ( "tape", 4096, 4);
 #ifdef DBF_LIKE_HELL
-	debug_set_level(TAPE_DBF_AREA, 6);
+	dti_set_level(TAPE_DBF_AREA, 6);
 #endif
 	DBF_EVENT(3, "tape init\n");
 	tape_proc_init();
@@ -1321,7 +1320,7 @@ tape_exit(void)
 	tapechar_exit();
 	tapeblock_exit();
 	tape_proc_cleanup();
-	debug_unregister (TAPE_DBF_AREA);
+	dti_unregister (TAPE_DBF_AREA);
 }
 
 MODULE_AUTHOR("(C) 2001 IBM Deutschland Entwicklung GmbH by Carsten Otte and "
diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index ea1defb..8fba334 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -33,9 +33,9 @@
 #include "chp.h"
 #include "../s390mach.h"
 
-debug_info_t *cio_debug_msg_id;
-debug_info_t *cio_debug_trace_id;
-debug_info_t *cio_debug_crw_id;
+struct dti_info *cio_debug_msg_id;
+struct dti_info *cio_debug_trace_id;
+struct dti_info *cio_debug_crw_id;
 
 int cio_show_msg;
 
@@ -65,31 +65,28 @@ __setup ("cio_msg=", cio_setup);
 static int __init
 cio_debug_init (void)
 {
-	cio_debug_msg_id = debug_register ("cio_msg", 16, 4, 16*sizeof (long));
+	cio_debug_msg_id = dti_register ("cio_msg", 4096, 4);
 	if (!cio_debug_msg_id)
 		goto out_unregister;
-	debug_register_view (cio_debug_msg_id, &debug_sprintf_view);
-	debug_set_level (cio_debug_msg_id, 2);
-	cio_debug_trace_id = debug_register ("cio_trace", 16, 4, 16);
+	dti_set_level (cio_debug_msg_id, 2);
+	cio_debug_trace_id = dti_register ("cio_trace", 4096, 4);
 	if (!cio_debug_trace_id)
 		goto out_unregister;
-	debug_register_view (cio_debug_trace_id, &debug_hex_ascii_view);
-	debug_set_level (cio_debug_trace_id, 2);
-	cio_debug_crw_id = debug_register ("cio_crw", 4, 4, 16*sizeof (long));
+	dti_set_level (cio_debug_trace_id, 2);
+	cio_debug_crw_id = dti_register ("cio_crw", 4096, 4);
 	if (!cio_debug_crw_id)
 		goto out_unregister;
-	debug_register_view (cio_debug_crw_id, &debug_sprintf_view);
-	debug_set_level (cio_debug_crw_id, 2);
+	dti_set_level (cio_debug_crw_id, 2);
 	pr_debug("debugging initialized\n");
 	return 0;
 
 out_unregister:
 	if (cio_debug_msg_id)
-		debug_unregister (cio_debug_msg_id);
+		dti_unregister (cio_debug_msg_id);
 	if (cio_debug_trace_id)
-		debug_unregister (cio_debug_trace_id);
+		dti_unregister (cio_debug_trace_id);
 	if (cio_debug_crw_id)
-		debug_unregister (cio_debug_crw_id);
+		dti_unregister (cio_debug_crw_id);
 	pr_debug("could not initialize debugging\n");
 	return -1;
 }
diff --git a/drivers/s390/cio/cio_debug.h b/drivers/s390/cio/cio_debug.h
index f88844a..5b2298c 100644
--- a/drivers/s390/cio/cio_debug.h
+++ b/drivers/s390/cio/cio_debug.h
@@ -1,33 +1,30 @@
 #ifndef CIO_DEBUG_H
 #define CIO_DEBUG_H
 
+#include <linux/dti.h>
 #include <asm/debug.h>
 
 /* for use of debug feature */
-extern debug_info_t *cio_debug_msg_id;
-extern debug_info_t *cio_debug_trace_id;
-extern debug_info_t *cio_debug_crw_id;
+extern struct dti_info *cio_debug_msg_id;
+extern struct dti_info *cio_debug_trace_id;
+extern struct dti_info *cio_debug_crw_id;
 
 #define CIO_TRACE_EVENT(imp, txt) do { \
-		debug_text_event(cio_debug_trace_id, imp, txt); \
+		__dti_event(cio_debug_trace_id, imp, txt, strlen(txt));\
 	} while (0)
 
 #define CIO_MSG_EVENT(imp, args...) do { \
-		debug_sprintf_event(cio_debug_msg_id, imp , ##args); \
+		__dti_printk(cio_debug_msg_id, imp , ##args); \
 	} while (0)
 
 #define CIO_CRW_EVENT(imp, args...) do { \
-		debug_sprintf_event(cio_debug_crw_id, imp , ##args); \
+		__dti_printk(cio_debug_crw_id, imp , ##args); \
 	} while (0)
 
 static inline void
 CIO_HEX_EVENT(int level, void *data, int length)
 {
-	while (length > 0) {
-		debug_event(cio_debug_trace_id, level, data, length);
-		length -= cio_debug_trace_id->buf_size;
-		data += cio_debug_trace_id->buf_size;
-	}
+	__dti_event(cio_debug_trace_id, level, data, length);
 }
 
 #define CIO_DEBUG(printk_level,event_level,msg...) ({ \



