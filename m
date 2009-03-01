Return-Path: <linux-kernel-owner+w=401wt.eu-S1757828AbZCARKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828AbZCARKj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 12:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbZCARKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 12:10:30 -0500
Received: from ns.suse.de ([195.135.220.2]:46513 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756725AbZCARK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 12:10:29 -0500
Message-ID: <49AAC180.9000707@suse.de>
Date: Sun, 01 Mar 2009 18:10:24 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, kkeil@suse.de, linux-isdn@vger.kernel.org,
       Frank Seidel <frank@f-seidel.de>,
       =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Andreas Eversberg <andreas@eversberg.eu>,
       Hannes Eder <hannes@hanneseder.net>, Adrian Bunk <bunk@kernel.org>,
       Frank Seidel <fseidel@suse.de>
Subject: [PATCHv2] isdn: reduce stack size of mISDN_dsp
References: <49AAB8B2.8060801@suse.de>
In-Reply-To: <49AAB8B2.8060801@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Seidel <frank@f-seidel.de>

Reduce stack size memory footprint of mISDN_dsp.
(From 1468 bytes for dsp_cmx_send on i386 down
to 44).

Signed-off-by: Frank Seidel <frank@f-seidel.de>
---
 drivers/isdn/mISDN/dsp_cmx.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/isdn/mISDN/dsp_cmx.c
+++ b/drivers/isdn/mISDN/dsp_cmx.c
@@ -1592,13 +1592,21 @@ dsp_cmx_send(void *arg)
 	struct dsp_conf_member *member;
 	struct dsp *dsp;
 	int mustmix, members;
-	s32 mixbuffer[MAX_POLL+100], *c;
+	s32 *mixbuffer;
+	s32 *c;
 	u8 *p, *q;
 	int r, rr;
 	int jittercheck = 0, delay, i;
 	u_long flags;
 	u16 length, count;
 
+	mixbuffer = kmalloc(sizeof(*mixbuffer) * (MAX_POLL + 100), GFP_KERNEL);
+	if (!mixbuffer) {
+		printk(KERN_ERR "mISDN_dsp: cannot allocate buffer(%s)\n",
+		       __func__);
+		return;
+	}
+
 	/* lock */
 	spin_lock_irqsave(&dsp_lock, flags);
 
@@ -1811,6 +1819,8 @@ dsp_cmx_send(void *arg)
 
 	/* unlock */
 	spin_unlock_irqrestore(&dsp_lock, flags);
+
+	kfree(mixbuffer);
 }
 
 /*

