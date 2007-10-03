Return-Path: <linux-kernel-owner+w=401wt.eu-S1756323AbXJCBTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323AbXJCBTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 21:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbXJCBTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 21:19:12 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:41003 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbXJCBTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 21:19:11 -0400
Date: Wed, 3 Oct 2007 11:19:09 +1000
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Linas Vepstas <linas@austin.ibm.com>, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc7-mm1 -- powerpc rtas panic
Message-ID: <20071003011909.GG9814@bakeyournoodle.com>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org> <20070924123531.GC30855@shadowen.org> <20071002232819.GN4338@austin.ibm.com> <20071003002646.GD9814@bakeyournoodle.com> <1191371416.8073.1.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1191371416.8073.1.camel@concordia>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 10:30:16AM +1000, Michael Ellerman wrote:
 
> I realise it'll make the patch bigger, but this doesn't seem like a
> particularly good name for the variable anymore.

Sure, what about?

Clarify when RTAS logging is enabled.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>

---
 arch/powerpc/platforms/pseries/rtasd.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/rtasd.c b/arch/powerpc/platforms/pseries/rtasd.c
index 30925d2..73401c8 100644
--- a/arch/powerpc/platforms/pseries/rtasd.c
+++ b/arch/powerpc/platforms/pseries/rtasd.c
@@ -54,8 +54,9 @@ static unsigned int rtas_event_scan_rate;
 static int full_rtas_msgs = 0;
 
 /* Stop logging to nvram after first fatal error */
-static int no_more_logging;
-
+static int logging_enabled; /* Until we initialize everything,
+                             * make sure we don't try logging
+                             * anything */
 static int error_log_cnt;
 
 /*
@@ -217,7 +218,7 @@ void pSeries_log_error(char *buf, unsigned int err_type, int fatal)
 	}
 
 	/* Write error to NVRAM */
-	if (!no_more_logging && !(err_type & ERR_FLAG_BOOT))
+	if (logging_enabled && !(err_type & ERR_FLAG_BOOT))
 		nvram_write_error_log(buf, len, err_type, error_log_cnt);
 
 	/*
@@ -229,8 +230,8 @@ void pSeries_log_error(char *buf, unsigned int err_type, int fatal)
 		printk_log_rtas(buf, len);
 
 	/* Check to see if we need to or have stopped logging */
-	if (fatal || no_more_logging) {
-		no_more_logging = 1;
+	if (fatal || !logging_enabled) {
+		logging_enabled = 0;
 		spin_unlock_irqrestore(&rtasd_log_lock, s);
 		return;
 	}
@@ -302,7 +303,7 @@ static ssize_t rtas_log_read(struct file * file, char __user * buf,
 
 	spin_lock_irqsave(&rtasd_log_lock, s);
 	/* if it's 0, then we know we got the last one (the one in NVRAM) */
-	if (rtas_log_size == 0 && !no_more_logging)
+	if (rtas_log_size == 0 && logging_enabled)
 		nvram_clear_error_log();
 	spin_unlock_irqrestore(&rtasd_log_lock, s);
 
@@ -414,6 +415,8 @@ static int rtasd(void *unused)
 	memset(logdata, 0, rtas_error_log_max);
 	rc = nvram_read_error_log(logdata, rtas_error_log_max,
 	                          &err_type, &error_log_cnt);
+	/* We can use rtas_log_buf now */
+	logging_enabled = 1;
 
 	if (!rc) {
 		if (err_type != ERR_FLAG_ALREADY_LOGGED) {

Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

