Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbYBRTlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbYBRTlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 14:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbYBRTlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 14:41:07 -0500
Received: from mga10.intel.com ([192.55.52.92]:30266 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751666AbYBRTlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 14:41:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,372,1199692800"; 
   d="scan'208";a="520597811"
Message-ID: <47B9DDF4.8030605@linux.intel.com>
Date: Mon, 18 Feb 2008 11:35:16 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Laurent Riffard <laurent.riffard@free.fr>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Stuart Bennett <sb476@cam.ac.uk>
Subject: Re: 2.6.25-rc2-mm1: WARNING at arch/x86/mm/ioremap.c:129
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7553D.5040601@free.fr>
In-Reply-To: <47B7553D.5040601@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Riffard wrote:
> Le 16.02.2008 09:25, Andrew Morton a écrit :
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/ 
>>
> 
> Got this in dmesg output:
> 
> ------------[ cut here ]------------
> WARNING: at arch/x86/mm/ioremap.c:129 __ioremap+0xc7/0x182()

Can you try the patch below? It should print a bit more information so that we can
figure out who's really at fault here.. (eg it's either the diagnostics that are
wrong, or ACPI is doing something evil (on behalf of the bios), we need to know
what address is being triggered)


 From c346400b372a99a4158fce3ea45234bcf947bdf8 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 18 Feb 2008 08:01:47 -0800
Subject: [PATCH] More diagnostic output for the ioremap WARN_ON

now that ACPI seems to have triggered this WARN_ON.. we need to know
which address it triggers on to be able to judge a final "who's at fault".

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
  arch/x86/mm/ioremap.c |   10 +++++++++-
  1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 69f4981..524dd45 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -126,7 +126,15 @@ static void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
  			return NULL;
  	}

-	WARN_ON_ONCE(page_is_ram(pfn));
+	for (pfn = phys_addr >> PAGE_SHIFT; pfn < max_pfn_mapped &&
+	     (pfn << PAGE_SHIFT) < last_addr; pfn++) {
+		if (page_is_ram(pfn)) {
+			printk(KERN_ERR "ioremap: trying to map RAM page at %lx\n",
+					pfn << PAGE_SHIFT);
+			WARN_ON_ONCE(page_is_ram(pfn));
+		}
+	}
+

  	switch (mode) {
  	case IOR_MODE_UNCACHED:
-- 
1.5.4.1

