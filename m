Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZGOWOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZGOWOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 18:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbZGOWOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 18:14:37 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52567 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477AbZGOWOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 18:14:12 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] connector: get test code working by default
Date: Wed, 15 Jul 2009 18:14:09 -0400
Message-Id: <1247696049-15699-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247696049-15699-1-git-send-email-vapier@gentoo.org>
References: <1247696049-15699-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The connector test code currently does not work out of the box.  This is
because it uses a connector id that is above the registered limit.  So
rather than force people to stumble through undocumented code wondering
why it isn't working, have the test code use one of the "private" ids by
default.  While I'm in here, clean up the code (kernel and user app) so
that it's a bit more user friendly and verbose in significant things that
it does.  Terse test code wastes people time as they simply enumerate it
with all the same kind of debug messages to get a better feel of what code
is running at any time.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 Documentation/connector/Makefile  |    5 +++
 Documentation/connector/cn_test.c |   31 +++++++++++--------
 Documentation/connector/ucon.c    |   62 +++++++++++++++++++++++++++++++-----
 3 files changed, 76 insertions(+), 22 deletions(-)

diff --git a/Documentation/connector/Makefile b/Documentation/connector/Makefile
index 8df1a72..d98e4df 100644
--- a/Documentation/connector/Makefile
+++ b/Documentation/connector/Makefile
@@ -9,3 +9,8 @@ hostprogs-y := ucon
 always := $(hostprogs-y)
 
 HOSTCFLAGS_ucon.o += -I$(objtree)/usr/include
+
+all: modules
+
+modules clean:
+	$(MAKE) -C ../.. SUBDIRS=$(PWD) $@
diff --git a/Documentation/connector/cn_test.c b/Documentation/connector/cn_test.c
index 50d5ce4..6e73190 100644
--- a/Documentation/connector/cn_test.c
+++ b/Documentation/connector/cn_test.c
@@ -19,6 +19,8 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#define pr_fmt(fmt) "cn_test: " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -27,16 +29,17 @@
 
 #include <linux/connector.h>
 
-static struct cb_id cn_test_id = { 0x123, 0x456 };
+static struct cb_id cn_test_id = { CN_NETLINK_USERS + 3, 0x456 };
 static char cn_test_name[] = "cn_test";
 static struct sock *nls;
 static struct timer_list cn_test_timer;
 
-void cn_test_callback(struct cn_msg *msg)
+static void cn_test_callback(struct cn_msg *msg)
 {
-	printk("%s: %lu: idx=%x, val=%x, seq=%u, ack=%u, len=%d: %s.\n",
-	       __func__, jiffies, msg->id.idx, msg->id.val,
-	       msg->seq, msg->ack, msg->len, (char *)msg->data);
+	pr_info("%s: %lu: idx=%x, val=%x, seq=%u, ack=%u, len=%d: %s.\n",
+	        __func__, jiffies, msg->id.idx, msg->id.val,
+	        msg->seq, msg->ack, msg->len,
+	        msg->len ? (char *)msg->data : "");
 }
 
 /*
@@ -61,9 +64,7 @@ static int cn_test_want_notify(void)
 
 	skb = alloc_skb(size, GFP_ATOMIC);
 	if (!skb) {
-		printk(KERN_ERR "Failed to allocate new skb with size=%u.\n",
-		       size);
-
+		pr_err("failed to allocate new skb with size=%u\n", size);
 		return -ENOMEM;
 	}
 
@@ -112,12 +113,12 @@ static int cn_test_want_notify(void)
 	//netlink_broadcast(nls, skb, 0, ctl->group, GFP_ATOMIC);
 	netlink_unicast(nls, skb, 0, 0);
 
-	printk(KERN_INFO "Request was sent. Group=0x%x.\n", ctl->group);
+	pr_info("request was sent: group=0x%x\n", ctl->group);
 
 	return 0;
 
 nlmsg_failure:
-	printk(KERN_ERR "Failed to send %u.%u\n", msg->seq, msg->ack);
+	pr_err("failed to send %u.%u\n", msg->seq, msg->ack);
 	kfree_skb(skb);
 	return -EINVAL;
 }
@@ -129,6 +130,8 @@ static void cn_test_timer_func(unsigned long __data)
 	struct cn_msg *m;
 	char data[32];
 
+	pr_debug("%s: timer fired with data %lu\n", __func__, __data);
+
 	m = kzalloc(sizeof(*m) + sizeof(data), GFP_ATOMIC);
 	if (m) {
 
@@ -148,7 +151,7 @@ static void cn_test_timer_func(unsigned long __data)
 
 	cn_test_timer_counter++;
 
-	mod_timer(&cn_test_timer, jiffies + HZ);
+	mod_timer(&cn_test_timer, jiffies + msecs_to_jiffies(1000));
 }
 
 static int cn_test_init(void)
@@ -166,8 +169,10 @@ static int cn_test_init(void)
 	}
 
 	setup_timer(&cn_test_timer, cn_test_timer_func, 0);
-	cn_test_timer.expires = jiffies + HZ;
-	add_timer(&cn_test_timer);
+	mod_timer(&cn_test_timer, jiffies + msecs_to_jiffies(1000));
+
+	pr_info("initialized with id={%u.%u}\n",
+		cn_test_id.idx, cn_test_id.val);
 
 	return 0;
 
diff --git a/Documentation/connector/ucon.c b/Documentation/connector/ucon.c
index d738cde..a8e4d58 100644
--- a/Documentation/connector/ucon.c
+++ b/Documentation/connector/ucon.c
@@ -30,18 +30,24 @@
 
 #include <arpa/inet.h>
 
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <string.h>
 #include <errno.h>
 #include <time.h>
+#include <getopt.h>
 
 #include <linux/connector.h>
 
 #define DEBUG
 #define NETLINK_CONNECTOR 	11
 
+/* Hopefully your userspace connector.h matches this kernel */
+#define CN_TEST_IDX		CN_NETLINK_USERS + 3
+#define CN_TEST_VAL		0x456
+
 #ifdef DEBUG
 #define ulog(f, a...) fprintf(stdout, f, ##a)
 #else
@@ -83,6 +89,25 @@ static int netlink_send(int s, struct cn_msg *msg)
 	return err;
 }
 
+static void usage(void)
+{
+	printf(
+		"Usage: ucon [options] [output file]\n"
+		"\n"
+		"\t-h\tthis help screen\n"
+		"\t-s\tsend buffers to the test module\n"
+		"\n"
+		"The default behavior of ucon is to subscribe to the test module\n"
+		"and wait for state messages.  Any ones received are dumped to the\n"
+		"specified output file (or stdout).  The test module is assumed to\n"
+		"have an id of {%u.%u}\n"
+		"\n"
+		"If you get no output, then verify the cn_test module id matches\n"
+		"the expected id above.\n"
+		, CN_TEST_IDX, CN_TEST_VAL
+	);
+}
+
 int main(int argc, char *argv[])
 {
 	int s;
@@ -94,17 +119,34 @@ int main(int argc, char *argv[])
 	FILE *out;
 	time_t tm;
 	struct pollfd pfd;
+	bool send_msgs = false;
 
-	if (argc < 2)
-		out = stdout;
-	else {
-		out = fopen(argv[1], "a+");
+	while ((s = getopt(argc, argv, "hs")) != -1) {
+		switch (s) {
+		case 's':
+			send_msgs = true;
+			break;
+
+		case 'h':
+			usage();
+			return 0;
+
+		default:
+			/* getopt() outputs an error for us */
+			usage();
+			return 1;
+		}
+	}
+
+	if (argc != optind) {
+		out = fopen(argv[optind], "a+");
 		if (!out) {
 			ulog("Unable to open %s for writing: %s\n",
 				argv[1], strerror(errno));
 			out = stdout;
 		}
-	}
+	} else
+		out = stdout;
 
 	memset(buf, 0, sizeof(buf));
 
@@ -115,9 +157,11 @@ int main(int argc, char *argv[])
 	}
 
 	l_local.nl_family = AF_NETLINK;
-	l_local.nl_groups = 0x123; /* bitmask of requested groups */
+	l_local.nl_groups = -1; /* bitmask of requested groups */
 	l_local.nl_pid = 0;
 
+	ulog("subscribing to %u.%u\n", CN_TEST_IDX, CN_TEST_VAL);
+
 	if (bind(s, (struct sockaddr *)&l_local, sizeof(struct sockaddr_nl)) == -1) {
 		perror("bind");
 		close(s);
@@ -130,15 +174,15 @@ int main(int argc, char *argv[])
 		setsockopt(s, SOL_NETLINK, NETLINK_ADD_MEMBERSHIP, &on, sizeof(on));
 	}
 #endif
-	if (0) {
+	if (send_msgs) {
 		int i, j;
 
 		memset(buf, 0, sizeof(buf));
 
 		data = (struct cn_msg *)buf;
 
-		data->id.idx = 0x123;
-		data->id.val = 0x456;
+		data->id.idx = CN_TEST_IDX;
+		data->id.val = CN_TEST_VAL;
 		data->seq = seq++;
 		data->ack = 0;
 		data->len = 0;
-- 
1.6.3.3

