Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbYBXPFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbYBXPFB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 10:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYBXPEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 10:04:51 -0500
Received: from mail.bugwerft.de ([212.112.241.193]:46162 "EHLO
	mail.bugwerft.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbYBXPEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 10:04:50 -0500
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Feb 2008 10:04:49 EST
From: Uli Luckas <u.luckas@road.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [patch 00/38] 2.6.24-stable review
Date: Sun, 24 Feb 2008 15:55:37 +0100
User-Agent: KMail/1.9.7
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
References: <20080223002907.GA7268@suse.de>
In-Reply-To: <20080223002907.GA7268@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802241555.39230.u.luckas@road.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi stable-team,
Could you please include the attached patch [1] to the next stable release.
The patch fixes the otherwise unusable bluetooth uart on pxa25x . The patch is 
written by Russell King [1] who also gave his OK for stable inclusion [2].
The patch is also available as commit a0dd005d1d9f4c3beab52086f3844ef9342d1e67 
to Linus' tree.

Thanks,
Uli

[1] http://marc.info/?l=linux-arm-kernel&m=120298366510315
[2] http://marc.info/?l=linux-arm-kernel&m=120384388411097


diff --git a/arch/arm/mach-pxa/clock.c b/arch/arm/mach-pxa/clock.c
index 83ef5ec..df5ae27 100644
--- a/arch/arm/mach-pxa/clock.c
+++ b/arch/arm/mach-pxa/clock.c
@@ -23,18 +23,27 @@ static LIST_HEAD(clocks);
 static DEFINE_MUTEX(clocks_mutex);
 static DEFINE_SPINLOCK(clocks_lock);

+static struct clk *clk_lookup(struct device *dev, const char *id)
+{
+       struct clk *p;
+
+       list_for_each_entry(p, &clocks, node)
+               if (strcmp(id, p->name) == 0 && p->dev == dev)
+                       return p;
+
+       return NULL;
+}
+
 struct clk *clk_get(struct device *dev, const char *id)
 {
        struct clk *p, *clk = ERR_PTR(-ENOENT);

        mutex_lock(&clocks_mutex);
-       list_for_each_entry(p, &clocks, node) {
-               if (strcmp(id, p->name) == 0 &&
-                   (p->dev == NULL || p->dev == dev)) {
-                       clk = p;
-                       break;
-               }
-       }
+       p = clk_lookup(dev, id);
+       if (!p)
+               p = clk_lookup(NULL, id);
+       if (p)
+               clk = p;
        mutex_unlock(&clocks_mutex);

        return clk;
