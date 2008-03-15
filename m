Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbYCOOKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbYCOOKq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 10:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYCOOKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 10:10:36 -0400
Received: from proxy3.bredband.net ([195.54.101.73]:58476 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbYCOOKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 10:10:35 -0400
X-Greylist: delayed 1239 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Mar 2008 10:10:35 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av44AKtw20fVchQtPGdsb2JhbACBWo8bAQEBATYBlxWCDg
Message-ID: <50136.192.168.101.12.1205588993.squirrel@intranet>
Date: Sat, 15 Mar 2008 14:49:53 +0100 (CET)
Subject: [PATCH] netfilter: ipt_recent: sanity check hit count
From: "Daniel Hokka Zakrisson" <daniel@hozac.com>
To: linux-kernel@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
       akpm@linux-foundation.org, skennedy@vcn.com, daniel@hozac.com
User-Agent: SquirrelMail/1.4.10a-1.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a rule using ipt_recent is created with a hit count greater than
ip_pkt_list_tot, the rule will never match as it cannot keep track
of enough timestamps. This patch makes ipt_recent refuse to create such
rules.

With ip_pkt_list_tot's default value of 20, the following can be used
to reproduce the problem.

nc -u -l 0.0.0.0 1234 &
for i in `seq 1 100`; do echo $i | nc -w 1 -u 127.0.0.1 1234; done

This limits it to 20 packets:
iptables -A OUTPUT -p udp --dport 1234 -m recent --set --name test \
         --rsource
iptables -A OUTPUT -p udp --dport 1234 -m recent --update --seconds \
         60 --hitcount 20 --name test --rsource -j DROP

While this is unlimited:
iptables -A OUTPUT -p udp --dport 1234 -m recent --set --name test \
         --rsource
iptables -A OUTPUT -p udp --dport 1234 -m recent --update --seconds \
         60 --hitcount 21 --name test --rsource -j DROP

With the patch the second rule-set will throw an EINVAL.

Signed-off-by: Daniel Hokka Zakrisson <daniel@hozac.com>
Reported-by: Sean Kennedy <skennedy@vcn.com>
---
 net/ipv4/netfilter/ipt_recent.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/netfilter/ipt_recent.c
b/net/ipv4/netfilter/ipt_recent.c
index 68cbe3c..8e8f042 100644
--- a/net/ipv4/netfilter/ipt_recent.c
+++ b/net/ipv4/netfilter/ipt_recent.c
@@ -252,6 +252,8 @@ recent_mt_check(const char *tablename, const void *ip,
 	if ((info->check_set & (IPT_RECENT_SET | IPT_RECENT_REMOVE)) &&
 	    (info->seconds || info->hit_count))
 		return false;
+	if (info->hit_count > ip_pkt_list_tot)
+		return false;
 	if (info->name[0] == '\0' ||
 	    strnlen(info->name, IPT_RECENT_NAME_LEN) == IPT_RECENT_NAME_LEN)
 		return false;
-- 
1.5.3.3
