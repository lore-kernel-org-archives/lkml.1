Return-Path: <linux-kernel-owner+w=401wt.eu-S1761360AbYFWRtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761360AbYFWRtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 13:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbYFWRsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 13:48:54 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:57526 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbYFWRsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 13:48:53 -0400
Date: Mon, 23 Jun 2008 20:46:57 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: paulus@samba.org, geert@linux-m68k.org, zippel@linux-m68k.org,
       linuxppc-dev@ozlabs.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/macintosh/: possible cleanups
Message-ID: <20080623174657.GC4756@cs181140183.pp.htv.fi>
References: <20080609222312.GM1987@cs181133002.pp.htv.fi> <20080610102125.2816c9e3.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080610102125.2816c9e3.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 10:21:25AM +1000, Stephen Rothwell wrote:
> Hi Adrian,
> 
> On Tue, 10 Jun 2008 01:23:12 +0300 Adrian Bunk <bunk@kernel.org> wrote:
> >
> > +++ b/drivers/macintosh/adbhid.c
> > @@ -75,7 +75,7 @@ static struct notifier_block adbhid_adb_notifier = {
> >  #define ADB_KEY_POWER_OLD	0x7e
> >  #define ADB_KEY_POWER		0x7f
> >  
> > -u16 adb_to_linux_keycodes[128] = {
> > +static u16 adb_to_linux_keycodes[128] = {
> 
> This could be const as well.

Updated patch below.

cu
Adrian


<--  snip  -->


This patch contains the following possible cleanups:
- make the following needlessly global code static:
  - adb.c: adb_controller
  - adb.c: adb_init()
  - adbhid.c: adb_to_linux_keycodes[]  (also make it const)
  - via-pmu68k.c: backlight_level
  - via-pmu68k.c: backlight_enabled
- remove the following unused code:
  - via-pmu68k.c: sleep_notifier_list

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/macintosh/adb.c        |    5 ++---
 drivers/macintosh/adbhid.c     |    2 +-
 drivers/macintosh/via-pmu68k.c |    5 ++---
 include/linux/adb.h            |    1 -
 4 files changed, 5 insertions(+), 8 deletions(-)

45413fb42fb4215d80bb15f50a5bdc869465e9a1 diff --git a/drivers/macintosh/adb.c b/drivers/macintosh/adb.c
index dbaad39..61b62a6 100644
--- a/drivers/macintosh/adb.c
+++ b/drivers/macintosh/adb.c
@@ -46,7 +46,6 @@
 #endif
 
 
-EXPORT_SYMBOL(adb_controller);
 EXPORT_SYMBOL(adb_client_list);
 
 extern struct adb_driver via_macii_driver;
@@ -80,7 +79,7 @@ static struct adb_driver *adb_driver_list[] = {
 
 static struct class *adb_dev_class;
 
-struct adb_driver *adb_controller;
+static struct adb_driver *adb_controller;
 BLOCKING_NOTIFIER_HEAD(adb_client_list);
 static int adb_got_sleep;
 static int adb_inited;
@@ -290,7 +289,7 @@ static int adb_resume(struct platform_device *dev)
 }
 #endif /* CONFIG_PM */
 
-int __init adb_init(void)
+static int __init adb_init(void)
 {
 	struct adb_driver *driver;
 	int i;
diff --git a/drivers/macintosh/adbhid.c b/drivers/macintosh/adbhid.c
index ef4c117..af72f97 100644
--- a/drivers/macintosh/adbhid.c
+++ b/drivers/macintosh/adbhid.c
@@ -75,7 +75,7 @@ static struct notifier_block adbhid_adb_notifier = {
 #define ADB_KEY_POWER_OLD	0x7e
 #define ADB_KEY_POWER		0x7f
 
-u16 adb_to_linux_keycodes[128] = {
+static const u16 adb_to_linux_keycodes[128] = {
 	/* 0x00 */ KEY_A, 		/*  30 */
 	/* 0x01 */ KEY_S, 		/*  31 */
 	/* 0x02 */ KEY_D,		/*  32 */
diff --git a/drivers/macintosh/via-pmu68k.c b/drivers/macintosh/via-pmu68k.c
index e2f84da..b64741c 100644
--- a/drivers/macintosh/via-pmu68k.c
+++ b/drivers/macintosh/via-pmu68k.c
@@ -101,7 +101,6 @@ static int pmu_kind = PMU_UNKNOWN;
 static int pmu_fully_inited;
 
 int asleep;
-BLOCKING_NOTIFIER_HEAD(sleep_notifier_list);
 
 static int pmu_probe(void);
 static int pmu_init(void);
@@ -741,8 +740,8 @@ pmu_handle_data(unsigned char *data, int len)
 	}
 }
 
-int backlight_level = -1;
-int backlight_enabled = 0;
+static int backlight_level = -1;
+static int backlight_enabled = 0;
 
 #define LEVEL_TO_BRIGHT(lev)	((lev) < 1? 0x7f: 0x4a - ((lev) << 1))
 
diff --git a/include/linux/adb.h b/include/linux/adb.h
index 64d8878..63bca50 100644
--- a/include/linux/adb.h
+++ b/include/linux/adb.h
@@ -84,7 +84,6 @@ enum adb_message {
     ADB_MSG_PRE_RESET,	/* Called before resetting the bus */
     ADB_MSG_POST_RESET	/* Called after resetting the bus (re-do init & register) */
 };
-extern struct adb_driver *adb_controller;
 extern struct blocking_notifier_head adb_client_list;
 
 int adb_request(struct adb_request *req, void (*done)(struct adb_request *),

