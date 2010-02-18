Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab0BRBms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 20:42:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56844 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab0BRBmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 20:42:46 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net
Cc: linux-kernel@vger.kernel.org, 8an@praha12.net
Subject: [PATCH] iw: Add support for NL80211_ATTR_WIPHY_COVERAGE_CLASS
Date: Wed, 17 Feb 2010 20:42:43 -0500
Message-Id: <1266457363-31601-1-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.2.rc1.3.g81d3f
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lukáš Turek <8an@praha12.net>

New nl80211 attribute NL80211_ATTR_WIPHY_COVERAGE_CLASS allows setting
IEEE 802.11 coverage class, which is then used by drivers to calculate
slot time and ACK timeout for long distance links.

Two iw parameters are added: 'coverage' sets the coverage class
directly, while 'distance' is more user-friendly, as it allows to set
just the link distance and let iw do the necessary calculation itself.

Signed-off-by: Lukas Turek <8an@praha12.net>
---
 info.c    |    8 ++++++++
 nl80211.h |   49 +++++++++++++++++++++++++++++++++++++++++++++++--
 phy.c     |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 113 insertions(+), 2 deletions(-)

diff --git a/info.c b/info.c
index 69af216..1a1b588 100644
--- a/info.c
+++ b/info.c
@@ -156,6 +156,14 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 			printf("\tRTS threshold: %d\n", rts);
 	}
 
+	if (tb_msg[NL80211_ATTR_WIPHY_COVERAGE_CLASS]) {
+		unsigned char coverage;
+
+		coverage = nla_get_u8(tb_msg[NL80211_ATTR_WIPHY_COVERAGE_CLASS]);
+		/* See handle_distance() for an explanation where the '450' comes from */
+		printf("\tCoverage class: %d (up to %dm)\n", coverage, 450 * coverage);
+	}
+
 	if (!tb_msg[NL80211_ATTR_SUPPORTED_IFTYPES])
 		goto commands;
 
diff --git a/nl80211.h b/nl80211.h
index 127a730..43aee23 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -3,7 +3,7 @@
 /*
  * 802.11 netlink interface public header
  *
- * Copyright 2006, 2007, 2008 Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2006-2010 Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2008 Michael Wu <flamingice@sourmilk.net>
  * Copyright 2008 Luis Carlos Cobo <luisca@cozybit.com>
  * Copyright 2008 Michael Buesch <mb@bu3sch.de>
@@ -51,7 +51,7 @@
  *	%NL80211_ATTR_WIPHY_TXQ_PARAMS, %NL80211_ATTR_WIPHY_FREQ,
  *	%NL80211_ATTR_WIPHY_CHANNEL_TYPE, %NL80211_ATTR_WIPHY_RETRY_SHORT,
  *	%NL80211_ATTR_WIPHY_RETRY_LONG, %NL80211_ATTR_WIPHY_FRAG_THRESHOLD,
- *	and/or %NL80211_ATTR_WIPHY_RTS_THRESHOLD.
+ *	and/or %NL80211_ATTR_WIPHY_RTS_THRESHOLD, %NL80211_ATTR_WIPHY_TXPOWER.
  * @NL80211_CMD_NEW_WIPHY: Newly created wiphy, response to get request
  *	or rename notification. Has attributes %NL80211_ATTR_WIPHY and
  *	%NL80211_ATTR_WIPHY_NAME.
@@ -299,6 +299,31 @@
  *	rate selection. %NL80211_ATTR_IFINDEX is used to specify the interface
  *	and @NL80211_ATTR_TX_RATES the set of allowed rates.
  *
+ * @NL80211_CMD_REGISTER_ACTION: Register for receiving certain action frames
+ *	(via @NL80211_CMD_ACTION) for processing in userspace. This command
+ *	requires an interface index and a match attribute containing the first
+ *	few bytes of the frame that should match, e.g. a single byte for only
+ *	a category match or four bytes for vendor frames including the OUI.
+ *	The registration cannot be dropped, but is removed automatically
+ *	when the netlink socket is closed. Multiple registrations can be made.
+ * @NL80211_CMD_ACTION: Action frame TX request and RX notification. This
+ *	command is used both as a request to transmit an Action frame and as an
+ *	event indicating reception of an Action frame that was not processed in
+ *	kernel code, but is for us (i.e., which may need to be processed in a
+ *	user space application). %NL80211_ATTR_FRAME is used to specify the
+ *	frame contents (including header). %NL80211_ATTR_WIPHY_FREQ (and
+ *	optionally %NL80211_ATTR_WIPHY_CHANNEL_TYPE) is used to indicate on
+ *	which channel the frame is to be transmitted or was received. This
+ *	channel has to be the current channel (remain-on-channel or the
+ *	operational channel). When called, this operation returns a cookie
+ *	(%NL80211_ATTR_COOKIE) that will be included with the TX status event
+ *	pertaining to the TX request.
+ * @NL80211_CMD_ACTION_TX_STATUS: Report TX status of an Action frame
+ *	transmitted with %NL80211_CMD_ACTION. %NL80211_ATTR_COOKIE identifies
+ *	the TX command and %NL80211_ATTR_FRAME includes the contents of the
+ *	frame. %NL80211_ATTR_ACK flag is included if the recipient acknowledged
+ *	the frame.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -387,6 +412,10 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_TX_BITRATE_MASK,
 
+	NL80211_CMD_REGISTER_ACTION,
+	NL80211_CMD_ACTION,
+	NL80211_CMD_ACTION_TX_STATUS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -653,6 +682,15 @@ enum nl80211_commands {
  *	rates based on negotiated supported rates information. This attribute
  *	is used with %NL80211_CMD_SET_TX_BITRATE_MASK.
  *
+ * @NL80211_ATTR_FRAME_MATCH: A binary attribute which typically must contain
+ *	at least one byte, currently used with @NL80211_CMD_REGISTER_ACTION.
+ *
+ * @NL80211_ATTR_ACK: Flag attribute indicating that the frame was
+ *	acknowledged by the recipient.
+ *
+ * @NL80211_ATTR_WIPHY_TXPOWER: Target output power, specified in mBm ((100 * dBm) as
+ *	some hardware allows finer granular power control than 1 dBm steps.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -798,6 +836,12 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_TX_RATES,
 
+	NL80211_ATTR_FRAME_MATCH,
+
+	NL80211_ATTR_ACK,
+
+	NL80211_ATTR_WIPHY_TXPOWER,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -831,6 +875,7 @@ enum nl80211_attrs {
 #define NL80211_ATTR_AKM_SUITES NL80211_ATTR_AKM_SUITES
 #define NL80211_ATTR_KEY NL80211_ATTR_KEY
 #define NL80211_ATTR_KEYS NL80211_ATTR_KEYS
+#define NL80211_ATTR_WIPHY_TXPOWER NL80211_ATTR_WIPHY_TXPOWER
 
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_REG_RULES		32
diff --git a/phy.c b/phy.c
index 8dd01aa..5a87024 100644
--- a/phy.c
+++ b/phy.c
@@ -164,3 +164,61 @@ static int handle_netns(struct nl80211_state *state,
 COMMAND(set, netns, "<pid>",
 	NL80211_CMD_SET_WIPHY_NETNS, 0, CIB_PHY, handle_netns,
 	"Put this wireless device into a different network namespace");
+
+static int handle_coverage(struct nl80211_state *state,
+			struct nl_cb *cb,
+			struct nl_msg *msg,
+			int argc, char **argv)
+{
+	unsigned int coverage;
+
+	if (argc != 1)
+		return 1;
+
+	coverage = strtoul(argv[0], NULL, 10);
+	if (coverage > 255)
+		return 1;
+
+	NLA_PUT_U8(msg, NL80211_ATTR_WIPHY_COVERAGE_CLASS, coverage);
+
+	return 0;
+ nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND(set, coverage, "<coverage class>",
+	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_coverage,
+	"Set coverage class (1 for every 3 usec of air propagation time).\n"
+	"Valid values: 0 - 255.");
+
+static int handle_distance(struct nl80211_state *state,
+			struct nl_cb *cb,
+			struct nl_msg *msg,
+			int argc, char **argv)
+{
+	unsigned int distance, coverage;
+
+	if (argc != 1)
+		return 1;
+
+	distance = strtoul(argv[0], NULL, 10);
+
+	/*
+	 * Divide double the distance by the speed of light in m/usec (300) to
+	 * get round-trip time in microseconds and then divide the result by
+	 * three to get coverage class as specified in IEEE 802.11-2007 table
+	 * 7-27. Values are rounded upwards.
+	 */
+	coverage = (distance + 449) / 450;
+	if (coverage > 255)
+		return 1;
+
+	NLA_PUT_U8(msg, NL80211_ATTR_WIPHY_COVERAGE_CLASS, coverage);
+
+	return 0;
+ nla_put_failure:
+	return -ENOBUFS;
+}
+COMMAND(set, distance, "<distance>",
+	NL80211_CMD_SET_WIPHY, 0, CIB_PHY, handle_distance,
+	"Set appropriate coverage class for given link distance in meters.\n"
+	"Valid values: 0 - 114750");
-- 
1.6.3.3

