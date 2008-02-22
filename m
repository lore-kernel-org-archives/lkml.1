Return-Path: <linux-kernel-owner+w=401wt.eu-S1761486AbYBVHZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761486AbYBVHZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 02:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbYBVHZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 02:25:26 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:19549 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016AbYBVHZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 02:25:24 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Joel Becker <Joel.Becker@oracle.com>, Jody Belka <lists-lkml@pimb.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
In-Reply-To: <47BE0228.7020204@zytor.com>
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org>
	 <20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org>
	 <20080215202336.GE26034@mail.oracle.com>
	 <1203274161.27987.6.camel@localhost.localdomain>
	 <20080218104025.GA15899@ca-server1.us.oracle.com>
	 <1203458366.26910.15.camel@cthulhu.hellion.org.uk>
	 <47BBDA20.8030105@zytor.com>
	 <1203497511.26910.39.camel@cthulhu.hellion.org.uk>
	 <47BCA275.7000504@goop.org>
	 <1203546597.26910.74.camel@cthulhu.hellion.org.uk>
	 <47BDEA11.6010302@goop.org> <47BDEB57.5040203@zytor.com>
	 <47BDEF36.8000903@goop.org>
	 <1203631956.28436.4.camel@cthulhu.hellion.org.uk>
	 <47BDF9C7.6040400@zytor.com> <47BE0017.1020205@goop.org>
	 <47BE0228.7020204@zytor.com>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 07:25:06 +0000
Message-Id: <1203665106.28436.19.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: 2.6.25-rc1 xen pvops regression
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=qcrRp5rlbqkS0d6TfuPTVw==:17 a=yjx79DvRJ-rBO4U2mhwA:9 a=B8yEhJ_dlLvbXJtqpbEA:7 a=GhHhoZGLyeQbsNX_cArxNGwPhCUA:4 a=WuK_CZDBSqoA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-21 at 14:58 -0800, H. Peter Anvin wrote:
> 
> Which it is on real hardware, because although it's not *reserved*
> (type 2), it is certainly not made available as *normal memory* (type
> 1).  If Xen maps this as type 1 then I definitely see the problem.
> 
> We can exclude type 1 memory from DMI scan, certainly.

I'd been meaning to ask this. So the machines you have which don't
describe 0xf0000 as reserved also don't describe it as RAM? (I guess
it's either a hole in the table or one of the other e820 types).

So it sounds like it would be acceptable to simply invert the test in my
original patch as below? (actually reverting to my original-original
patch which I never sent out because checking for reserved sounded more
correct at the time, which was dumb of me because I was well aware of
the other possible types, I must have been having one of those days).

Ian.

>From 13bdb4ee9d80b83a81c3dbefa52464e511d1b4df Mon Sep 17 00:00:00 2001
From: Ian Campbell <ijc@hellion.org.uk>
Date: Fri, 22 Feb 2008 07:17:14 +0000
Subject: [PATCH] x86: Do not scan for DMI if the DMI region is marked as RAM by e820.

Under Xen the memory at 0xf0000 is regular RAM and so can potentially contain a
page table and hence cannot be mapped. The e820 map given to guest reflects
this.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
---
 drivers/firmware/dmi_scan.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 653265a..f8fde74 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -7,6 +7,7 @@
 #include <linux/bootmem.h>
 #include <linux/slab.h>
 #include <asm/dmi.h>
+#include <asm/e820.h>
 
 static char dmi_empty_string[] = "        ";
 
@@ -371,6 +372,9 @@ void __init dmi_scan_machine(void)
 		}
 	}
 	else {
+		if (e820_all_mapped(0xF0000, 0xF0000+0x10000, E820_RAM))
+			goto out;
+
 		/*
 		 * no iounmap() for that ioremap(); it would be a no-op, but
 		 * it's so early in setup that sucker gets confused into doing
-- 
1.5.4.2



-- 
Ian Campbell

Stupidity, like virtue, is its own reward.

