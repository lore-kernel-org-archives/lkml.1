Return-Path: <linux-kernel-owner+w=401wt.eu-S933495AbYCFLEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933495AbYCFLEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932164AbYCFLAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:00:09 -0500
Received: from main.gmane.org ([80.91.229.2]:40066 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764237AbYCFLAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:00:07 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andrew Schulman <andrex@alumni.utexas.net>
Subject: [PATCH] fix xt_time_match() never matches on Sundays
Date: Thu, 06 Mar 2008 05:53:45 -0500
Message-ID: <m8jvs39i4tt8qnr8s7u28modogntmmv731@4ax.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: c-69-140-163-243.hsd1.md.comcast.net
X-Newsreader: Forte Agent 4.2/32.1118
X-Archive: encrypt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xt_time_match() in net/netfilter/xt_time.c in kernel 2.6.24 never matches on
Sundays.  On my host I have a rule like

    iptables -A OUTPUT -m time --weekdays Sun -j REJECT

and it never matches.  The problem is in localtime_2(), which uses

    r->weekday = (4 + r->dse) % 7;

to map the epoch day onto a weekday in {0,...,6}.  In particular this gives 0
for Sundays.  But 0 has to be wrong; a weekday of 0 can never match.
xt_time_match() has

    if (!(info->weekdays_match & (1 << current_time.weekday)))
        return false;

and when current_time.weekday = 0, the result of the & is always zero, even when
info->weekdays_match = XT_TIME_ALL_WEEKDAYS = 0xFE.

The solution is to map Sunday onto 7, not 0.  Either of the following patches
does it; they're equivalent.  The first is more compact, the second is probably
clearer.  With the patch (#1) installed, I've confirmed on my host that
'iptables -m time --weekdays Sun' matches again.

Andrew.

Only in linux-source-2.6.24/net/netfilter: .#xt_time.c
Only in linux-source-2.6.24/net/netfilter: #xt_time.c#
diff -ur linux-source-2.6.24.orig/net/netfilter/xt_time.c linux-source-2.6.24/net/netfilter/xt_time.c
--- linux-source-2.6.24.orig/net/netfilter/xt_time.c	2008-01-24 17:58:37.000000000 -0500
+++ linux-source-2.6.24/net/netfilter/xt_time.c	2008-03-05 20:01:37.000000000 -0500
@@ -96,7 +96,8 @@
 	r->dse = time / 86400;
 
 	/* 1970-01-01 (w=0) was a Thursday (4). */
-	r->weekday = (4 + r->dse) % 7;
+	/* -1 and +1 map Sunday onto 7, instead of 0. */
+	r->weekday = (4 + r->dse - 1) % 7 + 1;
 }
 
 static void localtime_3(struct xtm *r, time_t time)
diff -ur linux-source-2.6.24.orig/net/netfilter/xt_time.c linux-source-2.6.24/net/netfilter/xt_time.c
--- linux-source-2.6.24.orig/net/netfilter/xt_time.c	2008-01-24 17:58:37.000000000 -0500
+++ linux-source-2.6.24/net/netfilter/xt_time.c	2008-03-05 20:03:15.000000000 -0500
@@ -97,6 +97,9 @@
 
 	/* 1970-01-01 (w=0) was a Thursday (4). */
 	r->weekday = (4 + r->dse) % 7;
+	/* Map Sunday onto 7, not 0. */
+	if (r->weekday == 0)
+		r->weekday = 7;
 }
 
 static void localtime_3(struct xtm *r, time_t time)

