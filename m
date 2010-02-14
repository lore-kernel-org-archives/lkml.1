Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab0BNPww (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 10:52:52 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:61717 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab0BNPwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 10:52:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=eBxcyMyFNLUJVnlOw0r4+inMFvuo/gs+Bd4IiwTwcygjxPrjxgBhllMY3OWYJ9n2oQ
         LR5i2meI58jpTudMbv/yBQa/WDMxjrX6fNCis78GU51tOb8UuTxe0IMacc0WtWpJwgel
         sVc73fbzLpnZfuCUPiUHuSf00HrWw0AV7Gq9s=
Message-ID: <4B781E05.9040502@gmail.com>
Date: Sun, 14 Feb 2010 17:00:05 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: paul@pwsan.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-omap@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] OMAP: Dereference of NULL autodep in _autodep_lookup()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't dereference autodep when it's NULL. In _autodep_lookup() an
ERR_PTR(-ENOENT) is assigned to autodep->pwrdm.ptr if pwrdm_lookup() fails.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---

Alternatively we could do:

-		for (autodep = autodeps; autodep->pwrdm.ptr; autodep++)
+		for (autodep = autodeps; !IS_ERR(autodep->pwrdm.ptr); autodep++)

...but considering how _clkdm_add_autodeps() traverses trough the autodeps it
appears that we want to ignore failures. Correct?

Roel

diff --git a/arch/arm/mach-omap2/clockdomain.c b/arch/arm/mach-omap2/clockdomain.c
index dd285f0..8f359c1 100644
--- a/arch/arm/mach-omap2/clockdomain.c
+++ b/arch/arm/mach-omap2/clockdomain.c
@@ -64,9 +64,6 @@ static void _autodep_lookup(struct clkdm_pwrdm_autodep *autodep)
 {
 	struct powerdomain *pwrdm;
 
-	if (!autodep)
-		return;
-
 	if (!omap_chip_is(autodep->omap_chip))
 		return;
 
@@ -211,7 +208,7 @@ void clkdm_init(struct clockdomain **clkdms,
 
 	autodeps = init_autodeps;
 	if (autodeps)
-		for (autodep = autodeps; autodep->pwrdm.ptr; autodep++)
+		for (autodep = autodeps; autodep; autodep++)
 			_autodep_lookup(autodep);
 }
 
