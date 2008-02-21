Return-Path: <linux-kernel-owner+w=401wt.eu-S935081AbYBUQvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935081AbYBUQvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764087AbYBUQuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:50:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932566AbYBUQuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:50:54 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Make the kernel NTP code hand 64-bit *unsigned* values to
	do_div() [try #3]
To: torvalds@osdl.org, akpm@linux-foundation.org, zippel@linux-m68k.org,
       schwab@suse.de
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Thu, 21 Feb 2008 16:50:35 +0000
Message-ID: <20080221165035.16571.67531.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

The kernel NTP code shouldn't hand 64-bit *signed* values to do_div().  Make it
instead hand 64-bit unsigned values.  This gets rid of a couple of warnings.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/time/ntp.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)


diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index c88b591..d4bca92 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -342,14 +342,16 @@ int do_adjtimex(struct timex *txc)
 		    freq_adj = shift_right(freq_adj, time_constant * 2 +
 					   (SHIFT_PLL + 2) * 2 - SHIFT_NSEC);
 		    if (mtemp >= MINSEC && (time_status & STA_FLL || mtemp > MAXSEC)) {
+			u64 utemp64;
 			temp64 = time_offset << (SHIFT_NSEC - SHIFT_FLL);
 			if (time_offset < 0) {
-			    temp64 = -temp64;
-			    do_div(temp64, mtemp);
-			    freq_adj -= temp64;
+			    utemp64 = -temp64;
+			    do_div(utemp64, mtemp);
+			    freq_adj -= utemp64;
 			} else {
-			    do_div(temp64, mtemp);
-			    freq_adj += temp64;
+			    utemp64 = temp64;
+			    do_div(utemp64, mtemp);
+			    freq_adj += utemp64;
 			}
 		    }
 		    freq_adj += time_freq;

