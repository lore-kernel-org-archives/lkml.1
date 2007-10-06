Return-Path: <linux-kernel-owner+w=401wt.eu-S1762286AbXJFNzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762286AbXJFNzj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 09:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757215AbXJFNzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 09:55:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:58899 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756405AbXJFNz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 09:55:29 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1/+g99lOq3+GymUKTyZ7JFPlwLoudrp7t+MWOVUwQ
	baJsNrnMSvKLdy
From: Helge Deller <deller@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [RFC] Time-based RFC 4122 UUID generator
Date: Sat, 6 Oct 2007 15:53:37 +0200
User-Agent: KMail/1.9.7
X-Face: &[jmHH-Dw>Aj):"[/t-VasJu+(5eP`/LEckV7V"JV,!nBy[6(/?#8M>x`5xzg/7:FkM.l@
	13<&9'nfV3"OkD~P)@j{P2=(uB7J(){:CcrM2jZeA+IBq?FUTp3c8Y{t+k<95mZf~[v"':
	t"f6wKtHUPFB&/]Z5^?9~IQs=16R;Pg"NS9JD=DK!ft&4b@S~&q/MfI3;qWqlg7Q1==jS4
	9V5OJkm$WQ[dc^_Y']DvibvMjizUZ]+'Jd4UnM><yrT}Rw(
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710061553.37311.deller@gmx.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The current Linux kernel currently contains the generate_random_uuid() function, which creates - based on RFC 4122 - truly random UUIDs and provides them to userspace through /proc/sys/kernel/random/boot_id  and /proc/sys/kernel/random/uuid.

The attached patch additionally adds the "Time-based UUID" variant of RFC 4122 to the Linux Kernel.
With this patch applied, userspace applications may easily get real unique time-based UUIDs through /proc/sys/kernel/random/uuid_time.

The attached implementation uses getnstimeofday() to get more fine-grained granularity than what would be possible with gettimeofday() in userspace.
As such it's in principle possible to provide a lot more UUIDs (if needed) per time than in userspace.
Additionally a mutex takes care of the proper locking against a mistaken double creation of UUIDs for simultanious running processes.

It would be nice if the patch could be applied. It should apply cleanly against git-head.
Helge


Signed-off-by: Helge Deller <deller@gmx.de>

 drivers/char/random.c  |  162 +++++++++++++++++++++++++++++++++++++++++++------
 include/linux/sysctl.h |    5 -
 2 files changed, 148 insertions(+), 19 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index af274e5..c84a385 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -239,6 +239,7 @@
 #include <linux/spinlock.h>
 #include <linux/percpu.h>
 #include <linux/cryptohash.h>
+#include <linux/netdevice.h>
 
 #include <asm/processor.h>
 #include <asm/uaccess.h>
@@ -1157,6 +1158,8 @@ void generate_random_uuid(unsigned char uuid_out[16])
 	uuid_out[6] = (uuid_out[6] & 0x0F) | 0x40;
 	/* Set the UUID variant to DCE */
 	uuid_out[8] = (uuid_out[8] & 0x3F) | 0x80;
+	/* Set multicast bit to avoid conflicts with NIC MAC addresses */
+	uuid_out[10] |= 0x80;
 }
 
 EXPORT_SYMBOL(generate_random_uuid);
@@ -1174,12 +1177,135 @@ EXPORT_SYMBOL(generate_random_uuid);
 static int min_read_thresh = 8, min_write_thresh;
 static int max_read_thresh = INPUT_POOL_WORDS * 32;
 static int max_write_thresh = INPUT_POOL_WORDS * 32;
-static char sysctl_bootid[16];
+static unsigned char sysctl_bootid[16] __read_mostly;
 
 /*
- * These functions is used to return both the bootid UUID, and random
- * UUID.  The difference is in whether table->data is NULL; if it is,
- * then a new UUID is generated and returned to the user.
+ * Generate time based UUID (RFC 4122)
+ *
+ * This function is protected with a mutex to ensure system-wide
+ * uniqiness of the new time based UUID.
+ */
+static void generate_random_uuid_time(unsigned char uuid_out[16])
+{
+	static DEFINE_MUTEX(uuid_mutex);
+	static u64 last_time_all;
+	static u16 clock_seq, clock_seq_started;
+	static unsigned char last_mac[6];
+	static int clock_seq_initialized __read_mostly;
+
+	struct timespec ts;
+	u64 time_all;
+	struct net_device *d;
+	int netdev_found = 0;
+
+	mutex_lock(&uuid_mutex);
+
+	/* Determine 60-bit timestamp value. For UUID version 1, this is
+	 * represented by Coordinated Universal Time (UTC) as a count of 100-
+	 * nanosecond intervals since 00:00:00.00, 15 October 1582 (the date of
+	 * Gregorian reform to the Christian calendar).
+	 */
+try_again:
+	getnstimeofday(&ts);
+	time_all = ((u64) ts.tv_sec) * (NSEC_PER_SEC/100);
+	time_all += ts.tv_nsec / 100;
+
+	/* add offset from Gregorian Calendar to Jan 1 1970 */
+	time_all += 12219292800000ULL * (NSEC_PER_MSEC/100);
+	time_all &= 0x0fffffffffffffffULL; /* limit to 60 bits */
+	uuid_out[3] = (u8) time_all;
+	uuid_out[2] = (u8) (time_all >> 8);
+	uuid_out[1] = (u8) (time_all >> 16);
+	uuid_out[0] = (u8) (time_all >> 24);
+	uuid_out[5] = (u8) (time_all >> 32);
+	uuid_out[4] = (u8) (time_all >> 40);
+	uuid_out[7] = (u8) (time_all >> 48);
+	uuid_out[6] = (u8) (time_all >> 56);
+
+	/* Determine clock sequence (max. 14 bit) */
+	if (unlikely(!clock_seq_initialized)) {
+		get_random_bytes(&clock_seq, sizeof(clock_seq));
+		clock_seq &= 0x3fff;
+		clock_seq_started = clock_seq;
+		clock_seq_initialized = 1;
+	} else {
+		if (unlikely(time_all <= last_time_all)) {
+inc_clock_seq:		clock_seq = (clock_seq+1) & 0x3fff;
+			if (unlikely(clock_seq == clock_seq_started)) {
+				clock_seq = (clock_seq-1) & 0x3fff;
+				goto try_again; /* wait until time advanced */
+			}
+		} else
+			clock_seq_started = clock_seq;
+	}
+	last_time_all = time_all;
+
+	uuid_out[8] = clock_seq >> 8;
+	uuid_out[9] = clock_seq & 0xff;
+
+	/* Set the spatially unique node identifier */
+#ifdef CONFIG_NET
+	read_lock(&dev_base_lock);
+	for_each_netdev(d) {
+		if (!netdev_found && d->type == 1 &&
+		    d->addr_len == 6 && d != &loopback_dev) {
+			memcpy(&uuid_out[10], d->dev_addr, 6);
+			netdev_found = 1;
+		}
+	}
+	read_unlock(&dev_base_lock);
+#endif
+	if (unlikely(!netdev_found)) {
+		/* use bootid's nodeID if no network interface found */
+		if (sysctl_bootid[8] == 0)
+			generate_random_uuid(sysctl_bootid);
+		memcpy(&uuid_out[10], &sysctl_bootid[10], 6);
+	}
+	/* if MAC/NodeID changed, create a new clock_seq value */
+	if (unlikely(memcmp(&uuid_out[10], &last_mac, 6))) {
+		memcpy(&last_mac, &uuid_out[10], 6);
+		/* for very first UUID, do not increment clock_seq */
+		if (unlikely(clock_seq_initialized == 1))
+			clock_seq_initialized = 2;
+		else
+			goto inc_clock_seq;
+	}
+
+	/* Set UUID version to 1 --- time-based generation */
+	uuid_out[6] = (uuid_out[6] & 0x0F) | 0x10;
+	/* Set the UUID variant to DCE */
+	uuid_out[8] = (uuid_out[8] & 0x3F) | 0x80;
+
+	mutex_unlock(&uuid_mutex);
+}
+
+
+/*
+ * Get UUID based on requested type.
+ */
+static unsigned char *get_uuid(int type, unsigned char *uuid)
+{
+	switch (type) {
+	case RANDOM_BOOT_ID:
+		uuid = sysctl_bootid;
+		if (unlikely(uuid[8] == 0))
+			generate_random_uuid(uuid);
+		break;
+	case RANDOM_UUID:
+		generate_random_uuid(uuid);
+		break;
+	case RANDOM_UUID_TIME:
+		generate_random_uuid_time(uuid);
+		break;
+	default:
+		BUG();
+	}
+	return uuid;
+}
+
+/*
+ * These functions are used to return the bootid UUID, random UUID and
+ * time based UUID.
  *
  * If the user accesses this via the proc interface, it will be returned
  * as an ASCII string in the standard UUID format.  If accesses via the
@@ -1191,13 +1317,13 @@ static int proc_do_uuid(ctl_table *table, int write, struct file *filp,
 	ctl_table fake_table;
 	unsigned char buf[64], tmp_uuid[16], *uuid;
 
-	uuid = table->data;
-	if (!uuid) {
-		uuid = tmp_uuid;
-		uuid[8] = 0;
+	/* random/time UUIDs need to be read completely at once */
+	if (table->ctl_name != RANDOM_BOOT_ID && *ppos > 0) {
+		*lenp = 0;
+		return 0;
 	}
-	if (uuid[8] == 0)
-		generate_random_uuid(uuid);
+
+	uuid = get_uuid(table->ctl_name, tmp_uuid);
 
 	sprintf(buf, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-"
 		"%02x%02x%02x%02x%02x%02x",
@@ -1221,13 +1347,7 @@ static int uuid_strategy(ctl_table *table, int __user *name, int nlen,
 	if (!oldval || !oldlenp)
 		return 1;
 
-	uuid = table->data;
-	if (!uuid) {
-		uuid = tmp_uuid;
-		uuid[8] = 0;
-	}
-	if (uuid[8] == 0)
-		generate_random_uuid(uuid);
+	uuid = get_uuid(table->ctl_name, tmp_uuid);
 
 	if (get_user(len, oldlenp))
 		return -EFAULT;
@@ -1298,6 +1418,14 @@ ctl_table random_table[] = {
 		.proc_handler	= &proc_do_uuid,
 		.strategy	= &uuid_strategy,
 	},
+	{
+		.ctl_name	= RANDOM_UUID_TIME,
+		.procname	= "uuid_time",
+		.maxlen		= 16,
+		.mode		= 0444,
+		.proc_handler	= &proc_do_uuid,
+		.strategy	= &uuid_strategy,
+	},
 	{ .ctl_name = 0 }
 };
 #endif 	/* CONFIG_SYSCTL */
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 483050c..f77134b 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -247,8 +247,9 @@ enum
 	RANDOM_ENTROPY_COUNT=2,
 	RANDOM_READ_THRESH=3,
 	RANDOM_WRITE_THRESH=4,
-	RANDOM_BOOT_ID=5,
-	RANDOM_UUID=6
+	RANDOM_BOOT_ID=5,	/* rfc4122 version 4, boot UUID */
+	RANDOM_UUID=6,		/* rfc4122 version 4, random-based */
+	RANDOM_UUID_TIME=7	/* rfc4122 version 1, time-based */
 };
 
 /* /proc/sys/kernel/pty */
