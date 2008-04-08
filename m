Return-Path: <linux-kernel-owner+w=401wt.eu-S1752283AbYDHKOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbYDHKOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 06:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbYDHKNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 06:13:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:51679 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbYDHKNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 06:13:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=GQEJVtiGtCe6/oZ169BM8+UveoSjVJyy6OfwVs0t6WE3M0wbS/qS3GTcc2f0PVHnU1xVi/mo2+MUxaS/XnHgaVaDsSyQmuizrU2GLSenIkCvN3A6YK28gddXGHJhr+8+EwPq5aEMAQ8g3dJ0mkDlpT0JRixzmcBy5onYUL2WMPI=
Message-ID: <f17812d70804080313q50248e21l98e8b215a975384e@mail.gmail.com>
Date: Tue, 8 Apr 2008 18:13:35 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] pxafb: introduce lcd_{read,write}l() to wrap the __raw_{read,write}l()
Cc: "linux-arm-kernel email list" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-fbdev-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>
In-Reply-To: <20080408012004.013a2572.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_23024_16796272.1207649615983"
References: <f17812d70804072103s4fa2b6d4t57abfcda9d8e0b11@mail.gmail.com>
	 <20080408012004.013a2572.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_23024_16796272.1207649615983
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Updated, sorry for the mailer I'm using (gmail web interface), I also
attach the patch hereby:

>From f4d383f836fc0ccee2669836b0355b60a4d4e88a Mon Sep 17 00:00:00 2001
From: Eric Miao <eric.miao@marvell.com>
Date: Thu, 27 Mar 2008 09:28:32 +0800
Subject: [PATCH] pxafb: introduce lcd_{read,write}l() to wrap the
__raw_{read,write}l()

using __raw_{read,write}l() everywhere looks messy, introduce
lcd_{read,write}l() to get this cleaned up a bit

Signed-off-by: eric miao <eric.miao@marvell.com>
---
 drivers/video/pxafb.c |   59 +++++++++++++++++++++++++++++--------------------
 1 files changed, 35 insertions(+), 24 deletions(-)

diff --git a/drivers/video/pxafb.c b/drivers/video/pxafb.c
index 0031a5f..4175617 100644
--- a/drivers/video/pxafb.c
+++ b/drivers/video/pxafb.c
@@ -71,6 +71,18 @@ static int pxafb_activate_var(struct fb_var_screeninfo *var,
 				struct pxafb_info *);
 static void set_ctrlr_state(struct pxafb_info *fbi, u_int state);

+static inline unsigned long
+lcd_readl(struct pxafb_info *fbi, unsigned int off)
+{
+	return __raw_readl(fbi->mmio_base + off);
+}
+
+static inline void
+lcd_writel(struct pxafb_info *fbi, unsigned int off, unsigned long val)
+{
+	__raw_writel(val, fbi->mmio_base + off);
+}
+
 static inline void pxafb_schedule_work(struct pxafb_info *fbi, u_int state)
 {
 	unsigned long flags;
@@ -684,8 +696,7 @@ static int pxafb_activate_var(struct fb_var_screeninfo *var,
 	fbi->reg_lccr1 = new_regs.lccr1;
 	fbi->reg_lccr2 = new_regs.lccr2;
 	fbi->reg_lccr3 = new_regs.lccr3;
-	fbi->reg_lccr4 = __raw_readl(fbi->mmio_base + LCCR4) &
-				(~LCCR4_PAL_FOR_MASK);
+	fbi->reg_lccr4 = lcd_readl(fbi, LCCR4) & ~LCCR4_PAL_FOR_MASK;
 	fbi->reg_lccr4 |= (fbi->lccr4 & LCCR4_PAL_FOR_MASK);
 	set_hsync_time(fbi, pcd);
 	local_irq_restore(flags);
@@ -694,12 +705,12 @@ static int pxafb_activate_var(struct
fb_var_screeninfo *var,
 	 * Only update the registers if the controller is enabled
 	 * and something has changed.
 	 */
-	if ((__raw_readl(fbi->mmio_base + LCCR0) != fbi->reg_lccr0) ||
-	    (__raw_readl(fbi->mmio_base + LCCR1) != fbi->reg_lccr1) ||
-	    (__raw_readl(fbi->mmio_base + LCCR2) != fbi->reg_lccr2) ||
-	    (__raw_readl(fbi->mmio_base + LCCR3) != fbi->reg_lccr3) ||
-	    (__raw_readl(fbi->mmio_base + FDADR0) != fbi->fdadr[0]) ||
-	    (__raw_readl(fbi->mmio_base + FDADR1) != fbi->fdadr[1]))
+	if ((lcd_readl(fbi, LCCR0) != fbi->reg_lccr0) ||
+	    (lcd_readl(fbi, LCCR1) != fbi->reg_lccr1) ||
+	    (lcd_readl(fbi, LCCR2) != fbi->reg_lccr2) ||
+	    (lcd_readl(fbi, LCCR3) != fbi->reg_lccr3) ||
+	    (lcd_readl(fbi, FDADR0) != fbi->fdadr[0]) ||
+	    (lcd_readl(fbi, FDADR1) != fbi->fdadr[1]))
 		pxafb_schedule_work(fbi, C_REENABLE);

 	return 0;
@@ -785,14 +796,14 @@ static void pxafb_enable_controller(struct
pxafb_info *fbi)
 	clk_enable(fbi->clk);

 	/* Sequence from 11.7.10 */
-	__raw_writel(fbi->reg_lccr3, fbi->mmio_base + LCCR3);
-	__raw_writel(fbi->reg_lccr2, fbi->mmio_base + LCCR2);
-	__raw_writel(fbi->reg_lccr1, fbi->mmio_base + LCCR1);
-	__raw_writel(fbi->reg_lccr0 & ~LCCR0_ENB, fbi->mmio_base + LCCR0);
-
-	__raw_writel(fbi->fdadr[0], fbi->mmio_base + FDADR0);
-	__raw_writel(fbi->fdadr[1], fbi->mmio_base + FDADR1);
-	__raw_writel(fbi->reg_lccr0 | LCCR0_ENB, fbi->mmio_base + LCCR0);
+	lcd_writel(fbi, LCCR3, fbi->reg_lccr3);
+	lcd_writel(fbi, LCCR2, fbi->reg_lccr2);
+	lcd_writel(fbi, LCCR1, fbi->reg_lccr1);
+	lcd_writel(fbi, LCCR0, fbi->reg_lccr0 & ~LCCR0_ENB);
+
+	lcd_writel(fbi, FDADR0, fbi->fdadr[0]);
+	lcd_writel(fbi, FDADR1, fbi->fdadr[1]);
+	lcd_writel(fbi, LCCR0, fbi->reg_lccr0 | LCCR0_ENB);
 }

 static void pxafb_disable_controller(struct pxafb_info *fbi)
@@ -805,11 +816,11 @@ static void pxafb_disable_controller(struct
pxafb_info *fbi)
 	add_wait_queue(&fbi->ctrlr_wait, &wait);

 	/* Clear LCD Status Register */
-	__raw_writel(0xffffffff, fbi->mmio_base + LCSR);
+	lcd_writel(fbi, LCSR, 0xffffffff);

-	lccr0 = __raw_readl(fbi->mmio_base + LCCR0) & ~LCCR0_LDM;
-	__raw_writel(lccr0, fbi->mmio_base + LCCR0);
-	__raw_writel(lccr0 | LCCR0_DIS, fbi->mmio_base + LCCR0);
+	lccr0 = lcd_readl(fbi, LCCR0) & ~LCCR0_LDM;
+	lcd_writel(fbi, LCCR0, lccr0);
+	lcd_writel(fbi, LCCR0, lccr0 | LCCR0_DIS);

 	schedule_timeout(200 * HZ / 1000);
 	remove_wait_queue(&fbi->ctrlr_wait, &wait);
@@ -824,15 +835,15 @@ static void pxafb_disable_controller(struct
pxafb_info *fbi)
 static irqreturn_t pxafb_handle_irq(int irq, void *dev_id)
 {
 	struct pxafb_info *fbi = dev_id;
-	unsigned int lccr0, lcsr = __raw_readl(fbi->mmio_base + LCSR);
+	unsigned int lccr0, lcsr = lcd_readl(fbi, LCSR);

 	if (lcsr & LCSR_LDD) {
-		lccr0 = __raw_readl(fbi->mmio_base + LCCR0) | LCCR0_LDM;
-		__raw_writel(lccr0, fbi->mmio_base + LCCR0);
+		lccr0 = lcd_readl(fbi, LCCR0);
+		lcd_writel(fbi, LCCR0, lccr0 | LCCR0_LDM);
 		wake_up(&fbi->ctrlr_wait);
 	}

-	__raw_writel(lcsr, fbi->mmio_base + LCSR);
+	lcd_writel(fbi, LCSR, lcsr);
 	return IRQ_HANDLED;
 }

-- 
1.5.4.3



On Tue, Apr 8, 2008 at 4:20 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 8 Apr 2008 12:03:16 +0800 "eric miao" <eric.y.miao@gmail.com> wrote:
>
>  > +#define lcd_readl(f, off)    __raw_readl((f)->mmio_base + (off))
>  > +#define lcd_writel(f, off, v)        __raw_writel((v), (f)->mmio_base + (off))
>
>  Please implement things like this in C.  Probably inlined.
>
>  Advantages:
>
>  - C looks nicer
>
>  - For some reason people are more likely to document their C than their macros
>
>  - macros can sometimes reference their argument multiple times, causing
>   bugs when they are passed experssions with side-effects.
>
>  - C functions have typechecking
>
>  - C functions (whether inlined or not) count as a reference to their
>   argument, and can help to avoid unused-variable warnings.
>
>
>



-- 
Cheers
- eric

------=_Part_23024_16796272.1207649615983
Content-Type: text/x-diff;
 name=0001-pxafb-introduce-lcd_-read-write-l-to-wrap-the-__r.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fesbdumt0
Content-Disposition: attachment;
 filename=0001-pxafb-introduce-lcd_-read-write-l-to-wrap-the-__r.patch

RnJvbSBmNGQzODNmODM2ZmMwY2NlZTI2Njk4MzZiMDM1NWI2MGE0ZDRlODhhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFcmljIE1pYW8gPGVyaWMubWlhb0BtYXJ2ZWxsLmNvbT4KRGF0
ZTogVGh1LCAyNyBNYXIgMjAwOCAwOToyODozMiArMDgwMApTdWJqZWN0OiBbUEFUQ0hdIHB4YWZi
OiBpbnRyb2R1Y2UgbGNkX3tyZWFkLHdyaXRlfWwoKSB0byB3cmFwIHRoZSBfX3Jhd197cmVhZCx3
cml0ZX1sKCkKCnVzaW5nIF9fcmF3X3tyZWFkLHdyaXRlfWwoKSBldmVyeXdoZXJlIGxvb2tzIG1l
c3N5LCBpbnRyb2R1Y2UKbGNkX3tyZWFkLHdyaXRlfWwoKSB0byBnZXQgdGhpcyBjbGVhbmVkIHVw
IGEgYml0CgpTaWduZWQtb2ZmLWJ5OiBlcmljIG1pYW8gPGVyaWMubWlhb0BtYXJ2ZWxsLmNvbT4K
LS0tCiBkcml2ZXJzL3ZpZGVvL3B4YWZiLmMgfCAgIDU5ICsrKysrKysrKysrKysrKysrKysrKysr
KysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZXMgY2hhbmdlZCwgMzUgaW5zZXJ0aW9u
cygrKSwgMjQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy92aWRlby9weGFmYi5j
IGIvZHJpdmVycy92aWRlby9weGFmYi5jCmluZGV4IDAwMzFhNWYuLjQxNzU2MTcgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvdmlkZW8vcHhhZmIuYworKysgYi9kcml2ZXJzL3ZpZGVvL3B4YWZiLmMKQEAg
LTcxLDYgKzcxLDE4IEBAIHN0YXRpYyBpbnQgcHhhZmJfYWN0aXZhdGVfdmFyKHN0cnVjdCBmYl92
YXJfc2NyZWVuaW5mbyAqdmFyLAogCQkJCXN0cnVjdCBweGFmYl9pbmZvICopOwogc3RhdGljIHZv
aWQgc2V0X2N0cmxyX3N0YXRlKHN0cnVjdCBweGFmYl9pbmZvICpmYmksIHVfaW50IHN0YXRlKTsK
IAorc3RhdGljIGlubGluZSB1bnNpZ25lZCBsb25nCitsY2RfcmVhZGwoc3RydWN0IHB4YWZiX2lu
Zm8gKmZiaSwgdW5zaWduZWQgaW50IG9mZikKK3sKKwlyZXR1cm4gX19yYXdfcmVhZGwoZmJpLT5t
bWlvX2Jhc2UgKyBvZmYpOworfQorCitzdGF0aWMgaW5saW5lIHZvaWQKK2xjZF93cml0ZWwoc3Ry
dWN0IHB4YWZiX2luZm8gKmZiaSwgdW5zaWduZWQgaW50IG9mZiwgdW5zaWduZWQgbG9uZyB2YWwp
Cit7CisJX19yYXdfd3JpdGVsKHZhbCwgZmJpLT5tbWlvX2Jhc2UgKyBvZmYpOworfQorCiBzdGF0
aWMgaW5saW5lIHZvaWQgcHhhZmJfc2NoZWR1bGVfd29yayhzdHJ1Y3QgcHhhZmJfaW5mbyAqZmJp
LCB1X2ludCBzdGF0ZSkKIHsKIAl1bnNpZ25lZCBsb25nIGZsYWdzOwpAQCAtNjg0LDggKzY5Niw3
IEBAIHN0YXRpYyBpbnQgcHhhZmJfYWN0aXZhdGVfdmFyKHN0cnVjdCBmYl92YXJfc2NyZWVuaW5m
byAqdmFyLAogCWZiaS0+cmVnX2xjY3IxID0gbmV3X3JlZ3MubGNjcjE7CiAJZmJpLT5yZWdfbGNj
cjIgPSBuZXdfcmVncy5sY2NyMjsKIAlmYmktPnJlZ19sY2NyMyA9IG5ld19yZWdzLmxjY3IzOwot
CWZiaS0+cmVnX2xjY3I0ID0gX19yYXdfcmVhZGwoZmJpLT5tbWlvX2Jhc2UgKyBMQ0NSNCkgJgot
CQkJCSh+TENDUjRfUEFMX0ZPUl9NQVNLKTsKKwlmYmktPnJlZ19sY2NyNCA9IGxjZF9yZWFkbChm
YmksIExDQ1I0KSAmIH5MQ0NSNF9QQUxfRk9SX01BU0s7CiAJZmJpLT5yZWdfbGNjcjQgfD0gKGZi
aS0+bGNjcjQgJiBMQ0NSNF9QQUxfRk9SX01BU0spOwogCXNldF9oc3luY190aW1lKGZiaSwgcGNk
KTsKIAlsb2NhbF9pcnFfcmVzdG9yZShmbGFncyk7CkBAIC02OTQsMTIgKzcwNSwxMiBAQCBzdGF0
aWMgaW50IHB4YWZiX2FjdGl2YXRlX3ZhcihzdHJ1Y3QgZmJfdmFyX3NjcmVlbmluZm8gKnZhciwK
IAkgKiBPbmx5IHVwZGF0ZSB0aGUgcmVnaXN0ZXJzIGlmIHRoZSBjb250cm9sbGVyIGlzIGVuYWJs
ZWQKIAkgKiBhbmQgc29tZXRoaW5nIGhhcyBjaGFuZ2VkLgogCSAqLwotCWlmICgoX19yYXdfcmVh
ZGwoZmJpLT5tbWlvX2Jhc2UgKyBMQ0NSMCkgIT0gZmJpLT5yZWdfbGNjcjApIHx8Ci0JICAgIChf
X3Jhd19yZWFkbChmYmktPm1taW9fYmFzZSArIExDQ1IxKSAhPSBmYmktPnJlZ19sY2NyMSkgfHwK
LQkgICAgKF9fcmF3X3JlYWRsKGZiaS0+bW1pb19iYXNlICsgTENDUjIpICE9IGZiaS0+cmVnX2xj
Y3IyKSB8fAotCSAgICAoX19yYXdfcmVhZGwoZmJpLT5tbWlvX2Jhc2UgKyBMQ0NSMykgIT0gZmJp
LT5yZWdfbGNjcjMpIHx8Ci0JICAgIChfX3Jhd19yZWFkbChmYmktPm1taW9fYmFzZSArIEZEQURS
MCkgIT0gZmJpLT5mZGFkclswXSkgfHwKLQkgICAgKF9fcmF3X3JlYWRsKGZiaS0+bW1pb19iYXNl
ICsgRkRBRFIxKSAhPSBmYmktPmZkYWRyWzFdKSkKKwlpZiAoKGxjZF9yZWFkbChmYmksIExDQ1Iw
KSAhPSBmYmktPnJlZ19sY2NyMCkgfHwKKwkgICAgKGxjZF9yZWFkbChmYmksIExDQ1IxKSAhPSBm
YmktPnJlZ19sY2NyMSkgfHwKKwkgICAgKGxjZF9yZWFkbChmYmksIExDQ1IyKSAhPSBmYmktPnJl
Z19sY2NyMikgfHwKKwkgICAgKGxjZF9yZWFkbChmYmksIExDQ1IzKSAhPSBmYmktPnJlZ19sY2Ny
MykgfHwKKwkgICAgKGxjZF9yZWFkbChmYmksIEZEQURSMCkgIT0gZmJpLT5mZGFkclswXSkgfHwK
KwkgICAgKGxjZF9yZWFkbChmYmksIEZEQURSMSkgIT0gZmJpLT5mZGFkclsxXSkpCiAJCXB4YWZi
X3NjaGVkdWxlX3dvcmsoZmJpLCBDX1JFRU5BQkxFKTsKIAogCXJldHVybiAwOwpAQCAtNzg1LDE0
ICs3OTYsMTQgQEAgc3RhdGljIHZvaWQgcHhhZmJfZW5hYmxlX2NvbnRyb2xsZXIoc3RydWN0IHB4
YWZiX2luZm8gKmZiaSkKIAljbGtfZW5hYmxlKGZiaS0+Y2xrKTsKIAogCS8qIFNlcXVlbmNlIGZy
b20gMTEuNy4xMCAqLwotCV9fcmF3X3dyaXRlbChmYmktPnJlZ19sY2NyMywgZmJpLT5tbWlvX2Jh
c2UgKyBMQ0NSMyk7Ci0JX19yYXdfd3JpdGVsKGZiaS0+cmVnX2xjY3IyLCBmYmktPm1taW9fYmFz
ZSArIExDQ1IyKTsKLQlfX3Jhd193cml0ZWwoZmJpLT5yZWdfbGNjcjEsIGZiaS0+bW1pb19iYXNl
ICsgTENDUjEpOwotCV9fcmF3X3dyaXRlbChmYmktPnJlZ19sY2NyMCAmIH5MQ0NSMF9FTkIsIGZi
aS0+bW1pb19iYXNlICsgTENDUjApOwotCi0JX19yYXdfd3JpdGVsKGZiaS0+ZmRhZHJbMF0sIGZi
aS0+bW1pb19iYXNlICsgRkRBRFIwKTsKLQlfX3Jhd193cml0ZWwoZmJpLT5mZGFkclsxXSwgZmJp
LT5tbWlvX2Jhc2UgKyBGREFEUjEpOwotCV9fcmF3X3dyaXRlbChmYmktPnJlZ19sY2NyMCB8IExD
Q1IwX0VOQiwgZmJpLT5tbWlvX2Jhc2UgKyBMQ0NSMCk7CisJbGNkX3dyaXRlbChmYmksIExDQ1Iz
LCBmYmktPnJlZ19sY2NyMyk7CisJbGNkX3dyaXRlbChmYmksIExDQ1IyLCBmYmktPnJlZ19sY2Ny
Mik7CisJbGNkX3dyaXRlbChmYmksIExDQ1IxLCBmYmktPnJlZ19sY2NyMSk7CisJbGNkX3dyaXRl
bChmYmksIExDQ1IwLCBmYmktPnJlZ19sY2NyMCAmIH5MQ0NSMF9FTkIpOworCisJbGNkX3dyaXRl
bChmYmksIEZEQURSMCwgZmJpLT5mZGFkclswXSk7CisJbGNkX3dyaXRlbChmYmksIEZEQURSMSwg
ZmJpLT5mZGFkclsxXSk7CisJbGNkX3dyaXRlbChmYmksIExDQ1IwLCBmYmktPnJlZ19sY2NyMCB8
IExDQ1IwX0VOQik7CiB9CiAKIHN0YXRpYyB2b2lkIHB4YWZiX2Rpc2FibGVfY29udHJvbGxlcihz
dHJ1Y3QgcHhhZmJfaW5mbyAqZmJpKQpAQCAtODA1LDExICs4MTYsMTEgQEAgc3RhdGljIHZvaWQg
cHhhZmJfZGlzYWJsZV9jb250cm9sbGVyKHN0cnVjdCBweGFmYl9pbmZvICpmYmkpCiAJYWRkX3dh
aXRfcXVldWUoJmZiaS0+Y3RybHJfd2FpdCwgJndhaXQpOwogCiAJLyogQ2xlYXIgTENEIFN0YXR1
cyBSZWdpc3RlciAqLwotCV9fcmF3X3dyaXRlbCgweGZmZmZmZmZmLCBmYmktPm1taW9fYmFzZSAr
IExDU1IpOworCWxjZF93cml0ZWwoZmJpLCBMQ1NSLCAweGZmZmZmZmZmKTsKIAotCWxjY3IwID0g
X19yYXdfcmVhZGwoZmJpLT5tbWlvX2Jhc2UgKyBMQ0NSMCkgJiB+TENDUjBfTERNOwotCV9fcmF3
X3dyaXRlbChsY2NyMCwgZmJpLT5tbWlvX2Jhc2UgKyBMQ0NSMCk7Ci0JX19yYXdfd3JpdGVsKGxj
Y3IwIHwgTENDUjBfRElTLCBmYmktPm1taW9fYmFzZSArIExDQ1IwKTsKKwlsY2NyMCA9IGxjZF9y
ZWFkbChmYmksIExDQ1IwKSAmIH5MQ0NSMF9MRE07CisJbGNkX3dyaXRlbChmYmksIExDQ1IwLCBs
Y2NyMCk7CisJbGNkX3dyaXRlbChmYmksIExDQ1IwLCBsY2NyMCB8IExDQ1IwX0RJUyk7CiAKIAlz
Y2hlZHVsZV90aW1lb3V0KDIwMCAqIEhaIC8gMTAwMCk7CiAJcmVtb3ZlX3dhaXRfcXVldWUoJmZi
aS0+Y3RybHJfd2FpdCwgJndhaXQpOwpAQCAtODI0LDE1ICs4MzUsMTUgQEAgc3RhdGljIHZvaWQg
cHhhZmJfZGlzYWJsZV9jb250cm9sbGVyKHN0cnVjdCBweGFmYl9pbmZvICpmYmkpCiBzdGF0aWMg
aXJxcmV0dXJuX3QgcHhhZmJfaGFuZGxlX2lycShpbnQgaXJxLCB2b2lkICpkZXZfaWQpCiB7CiAJ
c3RydWN0IHB4YWZiX2luZm8gKmZiaSA9IGRldl9pZDsKLQl1bnNpZ25lZCBpbnQgbGNjcjAsIGxj
c3IgPSBfX3Jhd19yZWFkbChmYmktPm1taW9fYmFzZSArIExDU1IpOworCXVuc2lnbmVkIGludCBs
Y2NyMCwgbGNzciA9IGxjZF9yZWFkbChmYmksIExDU1IpOwogCiAJaWYgKGxjc3IgJiBMQ1NSX0xE
RCkgewotCQlsY2NyMCA9IF9fcmF3X3JlYWRsKGZiaS0+bW1pb19iYXNlICsgTENDUjApIHwgTEND
UjBfTERNOwotCQlfX3Jhd193cml0ZWwobGNjcjAsIGZiaS0+bW1pb19iYXNlICsgTENDUjApOwor
CQlsY2NyMCA9IGxjZF9yZWFkbChmYmksIExDQ1IwKTsKKwkJbGNkX3dyaXRlbChmYmksIExDQ1Iw
LCBsY2NyMCB8IExDQ1IwX0xETSk7CiAJCXdha2VfdXAoJmZiaS0+Y3RybHJfd2FpdCk7CiAJfQog
Ci0JX19yYXdfd3JpdGVsKGxjc3IsIGZiaS0+bW1pb19iYXNlICsgTENTUik7CisJbGNkX3dyaXRl
bChmYmksIExDU1IsIGxjc3IpOwogCXJldHVybiBJUlFfSEFORExFRDsKIH0KIAotLSAKMS41LjQu
MwoK
------=_Part_23024_16796272.1207649615983--
