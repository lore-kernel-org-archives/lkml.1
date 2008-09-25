Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbYIYR0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbYIYR0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbYIYRZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:25:58 -0400
Received: from mail.collax.com ([82.194.105.242]:47697 "EHLO mail.collax.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbYIYRZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:25:57 -0400
Message-ID: <48DBC9A1.20900@collax.com>
Date: Thu, 25 Sep 2008 19:25:53 +0200
From: Tilman Baumann <tilman.baumann@collax.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: SMACK netfilter smacklabel socket match
Content-Type: multipart/mixed;
 boundary="------------040006080903000000040300"
X-Filtered: By ProxSMTP
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.33/RELEASE, bases: 25092008 #1124361, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040006080903000000040300
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

i made some SMACK related patches. I hope this list is the right place 
to post them.

The intention behind this patch is that i needed a way to (firewall) 
match for packets originating from specific processes.
The existing owner match did not work well enough, especially since the 
cmd-owner part is removed.
Then i thought about a way to tag processes and somehow match this tag 
in the firewall.
I recalled that SELinux can do this (SECMARK) but SELinux would have 
been way to complex for what i want. But the idea was born, i just 
needed something more simple.

SMACK seemed to be the right way. So i made a little primitive netfilter 
match to match against the security context of sockets.
SMACK does CIPSO labels, but this was not what i wanted, i wanted to 
label the socket not the packet (on the wire).
This of course only works for packets with a local socket, but this was 
my intention anyway.

This way i can label a process and all it's sockets carry the same label 
which i then can use to match against in the firewall.

The code is pretty much based on cargo cult coding from other netfilter 
matches, especially the owner match (which turned out to be a bad 
reference since it is crapped with tons of compat interfaces).

I have no kernel coding experience whatsoever and little C coding 
history. So i would really like you guys to look over it a bit.

Originally i intended to put this mask in the xtables_match structure.
.hooks = (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_LOCAL_IN)
But it turned out that i then could not longer put the rule in a chain 
which is called by the OUTPUT chain but only in OUTPUT directly.
I did not investigate much more since i did not really understand this 
part. Allowing the user to add this match wherever he wants to does not 
hurt, if there is no local socket there is no matching.
But maybe this is something that should be changed.

About the Files:
SMACK-netfilter-socket-label-match.patch
is a git patch for the current kernel.

iptables-smacklabel.patch
contains the iptables userspace part (applies to iptables-1.4.1.1)


Regards
  Tilman Baumann
-- 
Tilman Baumann
Software Developer
Collax GmbH . Boetzinger Strasse 60 . 79111 Freiburg . Germany

p: +49 (0) 89-990157-0
f: +49 (0) 89-990157-11

Geschaeftsfuehrer: William K. Hite / Boris Nalbach
AG Muenchen HRB 158898, Ust.-IdNr: DE 814464942

--------------040006080903000000040300
Content-Type: text/x-patch;
 name="SMACK-netfilter-socket-label-match.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="SMACK-netfilter-socket-label-match.patch"

>From 1c79c7c413dd3ebd72dbe12e1133037c6ea223af Mon Sep 17 00:00:00 2001
From: Tilman Baumann <tilman.baumann@collax.com>
Date: Thu, 25 Sep 2008 19:07:37 +0200
Subject: [PATCH] SMACK netfilter socket label match


Signed-off-by: Tilman Baumann <tilman.baumann@collax.com>
---
 include/linux/netfilter/Kbuild     |    1 +
 include/linux/netfilter/xt_smack.h |   21 +++++++++
 net/netfilter/Kconfig              |   10 +++++
 net/netfilter/Makefile             |    1 +
 net/netfilter/xt_smack.c           |   79 ++++++++++++++++++++++++++++++++++++
 5 files changed, 112 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/netfilter/xt_smack.h
 create mode 100644 net/netfilter/xt_smack.c

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index 3aff513..9c8fffd 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -29,6 +29,7 @@ header-y += xt_mac.h
 header-y += xt_mark.h
 header-y += xt_multiport.h
 header-y += xt_owner.h
+header-y += xt_smack.h
 header-y += xt_pkttype.h
 header-y += xt_rateest.h
 header-y += xt_realm.h
diff --git a/include/linux/netfilter/xt_smack.h b/include/linux/netfilter/xt_smack.h
new file mode 100644
index 0000000..a3a4471
--- /dev/null
+++ b/include/linux/netfilter/xt_smack.h
@@ -0,0 +1,21 @@
+#ifndef _XT_SMACK_MATCH_H
+#define _XT_SMACK_MATCH_H
+
+#define SMK_MAXLEN      23
+#define SMK_LABELLEN    (SMK_MAXLEN+1)
+
+enum {
+	XT_SMACK_IN   = 1 << 0,
+	XT_SMACK_OUT  = 1 << 1,
+	XT_SMACK_PEER = 1 << 2,
+};
+
+struct xt_smack_match_info {
+	u_int8_t	mask, invert;
+	char    	match_in[SMK_LABELLEN];
+	char    	match_out[SMK_LABELLEN];
+	char    	match_peer_packet[SMK_LABELLEN];
+
+};
+
+#endif /* _XT_SMACK_MATCH_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index ee898e7..e03ff69 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -650,6 +650,16 @@ config NETFILTER_XT_MATCH_OWNER
 	based on who created the socket: the user or group. It is also
 	possible to check whether a socket actually exists.
 
+config NETFILTER_XT_MATCH_SMACK
+	tristate '"smack" socket label match support'
+	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
+	depends on SECURITY_SMACK
+	help
+	  SMACK label matching allows you to match locally generated packets
+	  based on the smack labels of the socket which is inherited from the
+	  associated process and allows matching on the TCP peers CIPSO label.
+
 config NETFILTER_XT_MATCH_POLICY
 	tristate 'IPsec "policy" match support'
 	depends on NETFILTER_XTABLES && XFRM
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 3bd2cc5..dc2efe5 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -83,3 +83,4 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) += xt_string.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) += xt_tcpmss.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TIME) += xt_time.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_U32) += xt_u32.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_SMACK) += xt_smack.o
diff --git a/net/netfilter/xt_smack.c b/net/netfilter/xt_smack.c
new file mode 100644
index 0000000..b41a559
--- /dev/null
+++ b/net/netfilter/xt_smack.c
@@ -0,0 +1,79 @@
+/*
+ * Kernel module to match against SMACK labels
+ *
+ * (C) 2008 Tilman Baumann <tilman.baumann@collax.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/file.h>
+#include <net/sock.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_smack.h>
+#include <../security/smack/smack.h>
+
+
+static bool
+smack_mt(const struct sk_buff *skb, const struct net_device *in,
+         const struct net_device *out, const struct xt_match *match,
+         const void *matchinfo, int offset, unsigned int protoff,
+         bool *hotdrop)
+{
+	const struct xt_smack_match_info *info = matchinfo;
+	struct socket_smack *smacks;
+
+	if (skb->sk == NULL || skb->sk->sk_socket == NULL)
+		return (info->mask ^ info->invert) == 0;
+	smacks = skb->sk->sk_security;
+	if (smacks == NULL){
+		 return (info->mask ^ info->invert);
+	}
+
+	if(info->mask & XT_SMACK_IN){
+		return ! ((!strncmp(smacks->smk_in, info->match_in, SMK_LABELLEN)) ^
+			(info->invert & XT_SMACK_IN));
+	}
+	
+	if(info->mask & XT_SMACK_OUT){
+		return ! ((!strncmp(smacks->smk_in, info->match_out, SMK_LABELLEN)) ^
+			(info->invert & XT_SMACK_OUT));
+	}
+
+	if(info->mask & XT_SMACK_PEER){
+		return ! ((!strncmp(smacks->smk_packet, info->match_peer_packet, SMK_LABELLEN)) ^
+			(info->invert & XT_SMACK_IN));
+	}
+	return true;
+}
+
+
+static struct xt_match smack_mt_reg[] __read_mostly = {
+	{
+		.name       = "smack",
+		.match      = smack_mt,
+		.matchsize  = sizeof(struct xt_smack_match_info),
+		.family     = AF_INET,
+		.me         = THIS_MODULE,
+	},
+};
+
+static int __init smack_mt_init(void)
+{
+	return xt_register_matches(smack_mt_reg, ARRAY_SIZE(smack_mt_reg));
+}
+
+static void __exit smack_mt_exit(void)
+{
+	xt_unregister_matches(smack_mt_reg, ARRAY_SIZE(smack_mt_reg));
+}
+
+module_init(smack_mt_init);
+module_exit(smack_mt_exit);
+MODULE_AUTHOR("Tilman Baumann <tilman@baumann.name>");
+MODULE_DESCRIPTION("Xtables: socket SMACK label matching");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_smack");
+MODULE_ALIAS("ip6t_smack");
-- 
1.5.6.3


--------------040006080903000000040300
Content-Type: text/x-patch;
 name="iptables-smacklabel.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-smacklabel.patch"

diff -Nur iptables-1.4.1.1/extensions/libxt_smack.c iptables-1.4.1.1-new/extensions/libxt_smack.c
--- iptables-1.4.1.1/extensions/libxt_smack.c	1970-01-01 01:00:00.000000000 +0100
+++ iptables-1.4.1.1-new/extensions/libxt_smack.c	2008-09-11 18:15:23.000000000 +0200
@@ -0,0 +1,129 @@
+#include <stdbool.h>
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <xtables.h>
+#include <linux/netfilter/xt_smack.h>
+
+/* Function which prints out usage message. */
+static void smack_help(void)
+{
+	printf(
+"smack match options:\n"
+"[!] --in       label      Match socket in label\n"
+"[!] --out      label      Match socket out label\n"
+"[!] --tcp-peer label      Match TCP peer label (CIPSO)\n");
+}
+
+
+static const struct option smack_opts[] = {
+	{.name = "in",       .has_arg = true, .val = 'i'},
+	{.name = "out",      .has_arg = true, .val = 'o'},
+	{.name = "tcp-peer", .has_arg = true, .val = 'p'},
+	{ .name = NULL }
+};
+
+static void parse_label(const char *s, char *d)
+{	
+	int slen = strlen(s);
+
+	if (slen >= SMK_LABELLEN) {
+		exit_error(PARAMETER_PROBLEM,
+			"SMACK label must be shorter than %i characters", SMK_LABELLEN);
+	}
+	strcpy(d, s);
+}
+
+static int smack_parse(int c, char **argv, int invert, unsigned int *flags,
+                          const void *entry, struct xt_entry_match **match)
+{
+	struct xt_smack_match_info *info = (void *)(*match)->data;
+
+	switch (c) {
+	case 'i':
+		param_act(P_ONLY_ONCE, "smack", "--in", *flags & XT_SMACK_IN);
+		
+		if (invert)
+			info->invert |= XT_SMACK_IN;
+		info->mask  |= XT_SMACK_IN;
+		parse_label(optarg, info->match_in);
+		*flags       |= XT_SMACK_IN;
+		return true;
+
+	case 'o':
+		param_act(P_ONLY_ONCE, "smack", "--out", *flags & XT_SMACK_OUT);
+		
+		if (invert)
+			info->invert |= XT_SMACK_OUT;
+		info->mask  |= XT_SMACK_OUT;
+		parse_label(optarg, info->match_out);
+		*flags       |= XT_SMACK_OUT;
+		return true;
+
+	case 'p':
+		param_act(P_ONLY_ONCE, "smack", "--tcp-peer", *flags & XT_SMACK_PEER);
+		
+		if (invert)
+			info->invert |= XT_SMACK_PEER;
+		info->mask  |= XT_SMACK_PEER;
+		parse_label(optarg, info->match_peer_packet);
+		*flags       |= XT_SMACK_PEER;
+		return true;
+	}
+	return false;
+}
+
+static void smack_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+			   "SMACK match: You must at least specify one match");
+}
+
+static void smack_save_item(const char *param, const char *label, u_int8_t invert){
+	if (invert)
+		printf("! ");
+	printf("--%s \"%s\" ", param, label);
+}
+
+static void smack_save(const void *ip, const struct xt_entry_match *match)
+{
+	struct xt_smack_match_info *info = (struct xt_smack_match_info *)match->data;
+
+	if(info->mask & XT_SMACK_IN)
+		smack_save_item("in", info->match_in, info->invert & XT_SMACK_IN);
+	if(info->mask & XT_SMACK_OUT)
+		smack_save_item("out", info->match_out, info->invert & XT_SMACK_OUT);
+	if(info->mask & XT_SMACK_PEER)
+		smack_save_item("tcp-peer", info->match_peer_packet, info->invert & XT_SMACK_PEER);
+
+}
+
+static void smack_print(const void *ip, const struct xt_entry_match *match, int numeric)
+{
+	printf("SMACK label match ");
+	smack_save(ip, match);
+	
+}
+
+static struct xtables_match smack_match = {
+	.family		= AF_UNSPEC,
+	.name		= "smack",
+	.version	= XTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_smack_match_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_smack_match_info)),
+	.help		= smack_help,
+	.parse		= smack_parse,
+	.final_check	= smack_check,
+	.print		= smack_print,
+	.save		= smack_save,
+	.extra_opts	= smack_opts,
+};
+
+void _init(void)
+{
+	xtables_register_match(&smack_match);
+}
diff -Nur iptables-1.4.1.1/include/linux/netfilter/xt_smack.h iptables-1.4.1.1-new/include/linux/netfilter/xt_smack.h
--- iptables-1.4.1.1/include/linux/netfilter/xt_smack.h	1970-01-01 01:00:00.000000000 +0100
+++ iptables-1.4.1.1-new/include/linux/netfilter/xt_smack.h	2008-09-11 17:36:25.000000000 +0200
@@ -0,0 +1,21 @@
+#ifndef _XT_SMACK_MATCH_H
+#define _XT_SMACK_MATCH_H
+
+#define SMK_MAXLEN      23
+#define SMK_LABELLEN    (SMK_MAXLEN+1)
+
+enum {
+	XT_SMACK_IN   = 1 << 0,
+	XT_SMACK_OUT  = 1 << 1,
+	XT_SMACK_PEER = 1 << 2,
+};
+
+struct xt_smack_match_info {
+	u_int8_t	mask, invert;
+	char    	match_in[SMK_LABELLEN];
+	char    	match_out[SMK_LABELLEN];
+	char    	match_peer_packet[SMK_LABELLEN];
+
+};
+
+#endif /* _XT_SMACK_MATCH_H */

--------------040006080903000000040300--
