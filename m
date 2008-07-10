Return-Path: <linux-kernel-owner+w=401wt.eu-S1758695AbYGJT2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbYGJT2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbYGJT2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:28:03 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:61568 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbYGJT2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:28:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:organization:reply-to:to:cc:subject:message-id:user-agent
         :mime-version:content-type:content-transfer-encoding:from;
        b=LZTYd5fNYhQhbnbqjnHeuR2f08Hggs/L1X3lsTuqO82YSr2RJpJWBBZhyl8bajKhk5
         G2iSk9XlIqrpke5agGONk7kXCOyPoNF/RHd06N7pQzCvUtbfLVinSabYC4hsllysYz6Y
         uBgCtljkq6VIPK1cF1t/Ngh4hKl7Xg0Qndslc=
Date: Thu, 10 Jul 2008 14:27:11 -0500
Organization: Xiotech Corporation
Reply-To: Mark Rustad <MRustad@gmail.com>
To: openipmi-developer@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, wim@iguana.be
Subject: [PATCH] IPMI: return correct value from ipmi_write
Message-ID: <4876628f.41O/uzQ5H7nSU2Vg%MRustad@gmail.com>
User-Agent: Heirloom mailx 12.3 7/15/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Mark Rustad <mrustad@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <MRustad@gmail.com>

This patch corrects the handling of write operations to the IPMI watchdog
to work as intended by returning the number of characters actually
processed. Without this patch, an "echo V >/dev/watchdog" enables the
watchdog if IPMI is providing the watchdog function.

Signed-off-by: Mark Rustad <MRustad@gmail.com>
---
I have not checked all of the watchdogs to see if there are others that have
this problem, but the one I was using before using the IPMI one did work
right. It was also a big surprise how much the default watchdog timeout
varies from one to another. Let me tell you that the 10 second default
for the IPMI watchdog was a real sore spot while tracking this problem down!
This problem goes back at least as far as 2.6.20, but I generated this patch
based on 2.6.26-rc9. I have applied, compiled and tested this fix.

 drivers/char/ipmi/ipmi_watchdog.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/char/ipmi/ipmi_watchdog.c	2008-07-10 09:31:52.000000000 -0500
+++ b/drivers/char/ipmi/ipmi_watchdog.c	2008-07-10 09:33:41.000000000 -0500
@@ -755,9 +755,8 @@ static ssize_t ipmi_write(struct file *f
 		rv = ipmi_heartbeat();
 		if (rv)
 			return rv;
-		return 1;
 	}
-	return 0;
+	return len;
 }
 
 static ssize_t ipmi_read(struct file *file,
