Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbZCVVJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbZCVVJA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 17:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZCVVIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 17:08:50 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:55692 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752189AbZCVVIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 17:08:49 -0400
Date: Sun, 22 Mar 2009 22:12:00 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Rui Santos <rsantos@grupopie.com>
Cc: Michael =?iso-8859-1?Q?B=FCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
Message-ID: <20090322211159.GA23042@electric-eye.fr.zoreil.com>
References: <200903041828.49972.m.bueker@berlin.de> <20090304224310.GA29043@electric-eye.fr.zoreil.com> <49B5066D.1030309@grupopie.com> <49BE4EF6.3030406@grupopie.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <49BE4EF6.3030406@grupopie.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Rui Santos <rsantos@grupopie.com> :
[...]
> I Finally ended up the big bisect operation. The commit responsible for
> this issue is commit
> b726e493e8dc13537d1d7f8cd66bcd28516606c3
> labeled
> 'r8169: sync existing 8168 device hardware start sequences with vendor
> driver'

Thanks a lot for the bisect.

> With that patch removed, I  was able to get a sustained 40MB/s+ on a
> 20GB ftp transfer. I wasn't able to do it with the specified patch applied.
> Just as a side note, I was never able to reproduce it on a 100MBit
> connection, only on a full 1GBit one...
> 
> However this patch will not reverse on the current kernel.
> 
> What do you think the next step should be ?
> As usual, if you need any testing, please do let me know.

Can you see if one of the attached patches or a combination of them
makes a difference for the current (-git) kernel ?

-- 
Ueimor

--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="r8169-00.patch"

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 43fedb9..c23a448 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -2620,15 +2620,6 @@ static void rtl_hw_start_8168c_1(void __iomem *ioaddr, struct pci_dev *pdev)
 
 static void rtl_hw_start_8168c_2(void __iomem *ioaddr, struct pci_dev *pdev)
 {
-	static struct ephy_info e_info_8168c_2[] = {
-		{ 0x01, 0,	0x0001 },
-		{ 0x03, 0x0400,	0x0220 }
-	};
-
-	rtl_csi_access_enable(ioaddr);
-
-	rtl_ephy_init(ioaddr, e_info_8168c_2, ARRAY_SIZE(e_info_8168c_2));
-
 	__rtl_hw_start_8168cp(ioaddr, pdev);
 }
 

--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="r8169-10.patch"

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 43fedb9..f56d20e 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -2546,15 +2546,7 @@ static void rtl_hw_start_8168bef(void __iomem *ioaddr, struct pci_dev *pdev)
 
 static void __rtl_hw_start_8168cp(void __iomem *ioaddr, struct pci_dev *pdev)
 {
-	RTL_W8(Config1, RTL_R8(Config1) | Speed_down);
-
-	RTL_W8(Config3, RTL_R8(Config3) & ~Beacon_en);
-
 	rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
-
-	rtl_disable_clock_request(pdev);
-
-	RTL_W16(CPlusCmd, RTL_R16(CPlusCmd) & ~R8168_CPCMD_QUIRK_MASK);
 }
 
 static void rtl_hw_start_8168cp_1(void __iomem *ioaddr, struct pci_dev *pdev)

--1yeeQ81UyVL57Vl7--
