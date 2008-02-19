Return-Path: <linux-kernel-owner+w=401wt.eu-S1762144AbYBSV77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762144AbYBSV77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 16:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbYBSV7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 16:59:48 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:37696 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755147AbYBSV7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 16:59:46 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Jody Belka <lists-lkml@pimb.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
In-Reply-To: <20080218104025.GA15899@ca-server1.us.oracle.com>
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org>
	 <20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org>
	 <20080215202336.GE26034@mail.oracle.com>
	 <1203274161.27987.6.camel@localhost.localdomain>
	 <20080218104025.GA15899@ca-server1.us.oracle.com>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 21:59:26 +0000
Message-Id: <1203458366.26910.15.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: 2.6.25-rc1 xen pvops regression
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=qcrRp5rlbqkS0d6TfuPTVw==:17 a=lZepgPbEr_462fCnHxMA:9 a=KZWzkdkipGWqNQI7ou0A:7 a=_6JMF1NJ_gcGF2zA1_TJBeipHdAA:4 a=WuK_CZDBSqoA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-18 at 02:40 -0800, Joel Becker wrote:
> On Sun, Feb 17, 2008 at 06:49:21PM +0000, Ian Campbell wrote:

> > x86/xen: Do not scan for DMI unless the DMI region is reserved by e820.

> 	This fixed it.  I'm now booting successfully.  Thank you!

Excellent. Jeremy, are you happy for this to go in?

>From 23e4ec12b95064320f83fca1cc1ad5c7b2eb3386 Mon Sep 17 00:00:00 2001
From: Ian Campbell <ijc@hellion.org.uk>
Date: Tue, 19 Feb 2008 21:57:45 +0000
Subject: [PATCH] x86/xen: Do not scan for DMI unless the DMI region is reserved by e820.

Under Xen the memory at 0xf0000 is regular RAM and so can potentially contain a
page table and hence cannot be mapped. The e820 map given to guest reflects
this.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
---
 drivers/firmware/dmi_scan.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 653265a..7d29403 100644
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
+		if (!e820_all_mapped(0xF0000, 0xF0000+0x10000, E820_RESERVED))
+			goto out;
+
 		/*
 		 * no iounmap() for that ioremap(); it would be a no-op, but
 		 * it's so early in setup that sucker gets confused into doing
-- 
1.5.4.2

-- 
Ian Campbell

After the game the king and the pawn go in the same box.
		-- Italian proverb

