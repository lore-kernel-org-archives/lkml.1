Return-Path: <linux-kernel-owner+w=401wt.eu-S1752943AbZCYJ5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbZCYJ5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZCYJ5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:57:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53551 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbZCYJ5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:57:15 -0400
Message-ID: <49C9FFEA.7060908@cn.fujitsu.com>
Date: Wed, 25 Mar 2009 17:56:58 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: linux-next-20090324: undefined reference to `__this_fixmap_does_not_exist\'
References: <200903250324.n2P3OwX0098272@www262.sakura.ne.jp> <49C9BA02.9070706@cn.fujitsu.com> <49C9F0CB.2000807@cn.fujitsu.com>
In-Reply-To: <49C9F0CB.2000807@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wang Chen said the following on 2009-3-25 16:52:
> Wang Chen said the following on 2009-3-25 12:58:
>> Tetsuo Handa said the following on 2009-3-25 11:24:
>>> Hello.
>>>
>>> I encountered below error.
>>>
>>> arch/x86/mm/built-in.o(.init.text+0x1831): In function `early_ioremap_init':
>>> : undefined reference to `__this_fixmap_does_not_exist'
>>> make: *** [.tmp_vmlinux1] Error 1
>>>
>>> Config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.29-next-20090324
>>>
>> Tetsuo, I've tried the latest tip, it's OK.
>> I can't trigger the same problem as you do.
>> So I will try linux-next later.
>>
> 
> Tetsuo
> 
> I've "make" tested linux-next-20090324 with your config.
> Still can't trigger the error.
> It's strange :(
> 

Maybe we use different gcc versions.
Please try following patch.

From: Wang Chen <wangchen@cn.fujitsu.com>
Subject: [PATCH] use __fix_to_virt(), because we are sure it's safe

Commit:8827247ffcc9e880cbe4705655065cf011265157 used a variable(which would be
optimized to constant) as fix_to_virt()'s parameter.
It's depended on gcc's optimization and maybe failed on old gcc.

We can use __fix_to_vir() insteadly, because we know it's safe and don't need
link time error reporting.

Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
---
 ioremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- arch/x86/mm/ioremap.c.orig	2009-03-25 17:36:01.000000000 +0800
+++ arch/x86/mm/ioremap.c	2009-03-25 17:36:54.000000000 +0800
@@ -523,7 +523,7 @@ void __init early_ioremap_init(void)
 		printk(KERN_INFO "early_ioremap_init()\n");
 
 	for (i = 0; i < FIX_BTMAPS_SLOTS; i++)
-		slot_virt[i] = fix_to_virt(FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*i);
+		slot_virt[i] = __fix_to_virt(FIX_BTMAP_BEGIN - NR_FIX_BTMAPS*i);
 
 	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
 	if (sizeof(bm_pte)) {

