Return-Path: <linux-kernel-owner+w=401wt.eu-S1765665AbZD3RUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765665AbZD3RUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764606AbZD3RHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:07:46 -0400
Received: from kroah.org ([198.145.64.141]:56384 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764511AbZD3RHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:37 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:42 2009
Message-Id: <20090430165742.630606755@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Patrick McHardy <kaber@trash.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 29/88] netfilter: {ip, ip6, arp}_tables: fix incorrect loop detection
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0048-netfilter-ip-ip6-arp-_tables-fix-incorrect-loop.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Patrick McHardy <kaber@trash.net>

upstream commit: 1f9352ae2253a97b07b34dcf16ffa3b4ca12c558

Commit e1b4b9f ([NETFILTER]: {ip,ip6,arp}_tables: fix exponential worst-case
search for loops) introduced a regression in the loop detection algorithm,
causing sporadic incorrectly detected loops.

When a chain has already been visited during the check, it is treated as
having a standard target containing a RETURN verdict directly at the
beginning in order to not check it again. The real target of the first
rule is then incorrectly treated as STANDARD target and checked not to
contain invalid verdicts.

Fix by making sure the rule does actually contain a standard target.

Based on patch by Francis Dupont <Francis_Dupont@isc.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/netfilter/arp_tables.c |    4 +++-
 net/ipv4/netfilter/ip_tables.c  |    4 +++-
 net/ipv6/netfilter/ip6_tables.c |    4 +++-
 3 files changed, 9 insertions(+), 3 deletions(-)

--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -374,7 +374,9 @@ static int mark_source_chains(struct xt_
 			    && unconditional(&e->arp)) || visited) {
 				unsigned int oldpos, size;
 
-				if (t->verdict < -NF_MAX_VERDICT - 1) {
+				if ((strcmp(t->target.u.user.name,
+					    ARPT_STANDARD_TARGET) == 0) &&
+				    t->verdict < -NF_MAX_VERDICT - 1) {
 					duprintf("mark_source_chains: bad "
 						"negative verdict (%i)\n",
 								t->verdict);
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -500,7 +500,9 @@ mark_source_chains(struct xt_table_info 
 			    && unconditional(&e->ip)) || visited) {
 				unsigned int oldpos, size;
 
-				if (t->verdict < -NF_MAX_VERDICT - 1) {
+				if ((strcmp(t->target.u.user.name,
+			    		    IPT_STANDARD_TARGET) == 0) &&
+				    t->verdict < -NF_MAX_VERDICT - 1) {
 					duprintf("mark_source_chains: bad "
 						"negative verdict (%i)\n",
 								t->verdict);
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -525,7 +525,9 @@ mark_source_chains(struct xt_table_info 
 			    && unconditional(&e->ipv6)) || visited) {
 				unsigned int oldpos, size;
 
-				if (t->verdict < -NF_MAX_VERDICT - 1) {
+				if ((strcmp(t->target.u.user.name,
+					    IP6T_STANDARD_TARGET) == 0) &&
+				    t->verdict < -NF_MAX_VERDICT - 1) {
 					duprintf("mark_source_chains: bad "
 						"negative verdict (%i)\n",
 								t->verdict);


