Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbZKMKZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbZKMKZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbZKMKZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:25:34 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:34612 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968AbZKMKZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:25:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vlnmeUg11wqhcBiPe0DVbCC+2ZPydM3o9dLazxKuERSsTUiyUUGhgEulLk5LZvIMYh
         QgWod0RPDe9yq66+0onecKC39Pkq6dN2O5GoDwPdOdObhSwXmMHKnL8ewwIYCCsqlmDX
         LcwZpbY410e0RhSXg49twKz5Lx5UTjxd/AzJQ=
Message-ID: <4AFD36EE.6030509@gmail.com>
Date: Fri, 13 Nov 2009 11:37:34 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Eric Miao <eric.y.miao@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pxa: make index mfp unsigned in mfp_read() and write()
References: <4AFAE0DA.6040300@gmail.com> <f17812d70911122303x53892464le04883069ad99e64@mail.gmail.com>
In-Reply-To: <f17812d70911122303x53892464le04883069ad99e64@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure we do not read/write outside array boundaries
with a negative index.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
On 13-11-09 08:03, Eric Miao wrote:
> On Thu, Nov 12, 2009 at 12:05 AM, Roel Kluin <roel.kluin@gmail.com> wrote:
>> When signed, it is possible in theory to pass a negative mfp,
>> and read/write outside the array bounds.

>> I did not observe the passing of a negative mfp anywhere so this
>> can be considered as a cleanup. Alternatively I could introduce
>> a `mfp < 0' check in mfp_{read,write} instead if desired.
>>
> 
> I'd prefer to have a check in mfp_{read,write} instead.

ok,

diff --git a/arch/arm/plat-pxa/mfp.c b/arch/arm/plat-pxa/mfp.c
index 9405d03..be58f9f 100644
--- a/arch/arm/plat-pxa/mfp.c
+++ b/arch/arm/plat-pxa/mfp.c
@@ -207,7 +207,7 @@ unsigned long mfp_read(int mfp)
 {
 	unsigned long val, flags;
 
-	BUG_ON(mfp >= MFP_PIN_MAX);
+	BUG_ON(mfp < 0 || mfp >= MFP_PIN_MAX);
 
 	spin_lock_irqsave(&mfp_spin_lock, flags);
 	val = mfpr_readl(mfp_table[mfp].mfpr_off);
@@ -220,7 +220,7 @@ void mfp_write(int mfp, unsigned long val)
 {
 	unsigned long flags;
 
-	BUG_ON(mfp >= MFP_PIN_MAX);
+	BUG_ON(mfp < 0 || mfp >= MFP_PIN_MAX);
 
 	spin_lock_irqsave(&mfp_spin_lock, flags);
 	mfpr_writel(mfp_table[mfp].mfpr_off, val);
