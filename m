Return-Path: <linux-kernel-owner+w=401wt.eu-S1764406AbZFOReY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764406AbZFOReY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 13:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758610AbZFOReG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 13:34:06 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:12520 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbZFOReE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:34:04 -0400
From: "Fischer, Anna" <anna.fischer@hp.com>
To: "bridge@lists.linux-foundation.org" 
	<bridge@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "evb@yahoogroups.com" <evb@yahoogroups.com>
CC: "shemminger@linux-foundation.org" <shemminger@linux-foundation.org>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "kaber@trash.net" <kaber@trash.net>,
       "adobriyan@gmail.com" <adobriyan@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>,
       "Paul Congdon (UC Davis)" <ptcongdon@ucdavis.edu>
Date: Mon, 15 Jun 2009 17:33:35 +0000
Subject: [PATCH] bridge-utils: fix sysfs path for setting bridge
 configuration parameters
Thread-Topic: [PATCH] bridge-utils: fix sysfs path for setting bridge
 configuration parameters
Thread-Index: Acnt32j7nk5PclCUTfiaJ3n4mGwdZg==
Message-ID: <0199E0D51A61344794750DC57738F58E67D2DCECBC@GVW1118EXC.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under newer kernels the bridge configuration parameters 
are located under /sys/class/net/$bridgename/bridge/$param,
while the current bridge-utils code is trying to access
them under /sys/class/net/$bridgename/$param. This patch
fixes this issue in the bridge-utils code and so allows 
setting of bridge configuration parameters using sysfs 
under newer kernel versions.

Signed-off-by: Anna Fischer <anna.fischer@hp.com>

---

 libbridge/libbridge_devif.c   |   25 +++++++++++++++++++++----
 libbridge/libbridge_private.h |    1 +
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/libbridge/libbridge_devif.c b/libbridge/libbridge_devif.c
index 34e3cc8..547bb86 100644
--- a/libbridge/libbridge_devif.c
+++ b/libbridge/libbridge_devif.c
@@ -73,6 +73,26 @@ static void fetch_tv(const char *dev, const char *name,
 	__jiffies_to_tv(tv, fetch_int(dev, name));
 }
 
+/* Open sysfs path for writing bridge properties. */
+static FILE *br_sysfs_open(const char *bridge, const char *name)
+{
+	char path[SYSFS_PATH_MAX];
+
+	/* Try accessing /sys/class/net/$bridge/bridge/$name. */
+	snprintf(path, SYSFS_PATH_MAX, SYSFS_CLASS_NET "%s"
+		 SYSFS_BRIDGE_DIR "/%s", bridge, name);
+	if (!access(path, F_OK))
+		return fopen(path, "w+");
+
+	/* Try using old-style of accessing bridge sysfs properties. */
+	snprintf(path, SYSFS_PATH_MAX, SYSFS_CLASS_NET "%s/%s",
+		 bridge, name);
+	if (!access(path, F_OK))
+		return fopen(path, "w+");
+
+	return NULL;
+}
+
 /*
  * Convert device name to an index in the list of ports in bridge.
  *
@@ -283,12 +303,9 @@ static int br_set(const char *bridge, const char *name,
 		  unsigned long value, unsigned long oldcode)
 {
 	int ret;
-	char path[SYSFS_PATH_MAX];
 	FILE *f;
 
-	snprintf(path, SYSFS_PATH_MAX, SYSFS_CLASS_NET "%s/%s", bridge, name);
-
-	f = fopen(path, "w");
+	f = br_sysfs_open(bridge, name);
 	if (f) {
 		ret = fprintf(f, "%ld\n", value);
 		fclose(f);
diff --git a/libbridge/libbridge_private.h b/libbridge/libbridge_private.h
index 99a511d..1e1a0c6 100644
--- a/libbridge/libbridge_private.h
+++ b/libbridge/libbridge_private.h
@@ -31,6 +31,7 @@
 
 #define SYSFS_CLASS_NET "/sys/class/net/"
 #define SYSFS_PATH_MAX	256
+#define SYSFS_BRIDGE_DIR "/bridge"
 
 #define dprintf(fmt,arg...)
