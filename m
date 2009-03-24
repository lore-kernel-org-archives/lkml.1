Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbZCXXXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbZCXXXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 19:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbZCXXXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 19:23:08 -0400
Received: from givry.fdupont.fr ([91.121.26.85]:64446 "EHLO givry.fdupont.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbZCXXXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 19:23:07 -0400
X-Greylist: delayed 1242 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Mar 2009 19:23:06 EDT
Message-Id: <200903242302.n2ON25u4024288@givry.fdupont.fr>
From: Francis Dupont <Francis.Dupont@fdupont.fr>
To: linux-kernel@vger.kernel.org
Cc: coreteam@netfilter.org, Francis_Dupont@isc.org
Subject: netfilter spurious ELOOP
Date: Wed, 25 Mar 2009 00:02:05 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

summary: iptables command gets spurious ELOOP errors

report: when a rule with a target like MARK --set-mark 0x80000001
then adding new other rules can failed with "Too many levels of symbolic
links" (aka ELOOP) error.
The problem is in kernel net/ipv4/netfilter/ip_tables.c in the 
mark_source_chains() routine which checks the verdict field of
targets even for not standard targets.

keywords: netfilter target eloop

environment: recent gentoo and fedora. Problem not fixed in
linux-2.6.29 (last stable version taken from kernel.org some minutes ago).

proposed fix (checked):
diff --unified=10 net/ipv4/netfilter/ip_tables.c*
at the end of the message.

request: can you send to me at both my personal and professional addresses
a bug/ticket number as soon as possible?

Request

Francis.Dupont@fdupont.fr

PS: the patch:

--- net/ipv4/netfilter/ip_tables.c	2009-03-23 16:12:14.000000000 -0700
+++ net/ipv4/netfilter/ip_tables.c+fix	2009-03-24 15:55:45.000000000 -0700
@@ -489,21 +489,23 @@
 			e->comefrom |= ((1 << hook) | (1 << NF_INET_NUMHOOKS));
 
 			/* Unconditional return/END. */
 			if ((e->target_offset == sizeof(struct ipt_entry)
 			    && (strcmp(t->target.u.user.name,
 				       IPT_STANDARD_TARGET) == 0)
 			    && t->verdict < 0
 			    && unconditional(&e->ip)) || visited) {
 				unsigned int oldpos, size;
 
-				if (t->verdict < -NF_MAX_VERDICT - 1) {
+				if ((t->verdict < -NF_MAX_VERDICT - 1) &&
+				    (strcmp(t->target.u.user.name,
+					    IPT_STANDARD_TARGET) == 0)) {
 					duprintf("mark_source_chains: bad "
 						"negative verdict (%i)\n",
 								t->verdict);
 					return 0;
 				}
 
 				/* Return: backtrack through the last
 				   big jump. */
 				do {
 					e->comefrom ^= (1<<NF_INET_NUMHOOKS);
