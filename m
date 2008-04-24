Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbYDXFtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbYDXFtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 01:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYDXFtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 01:49:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33948 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbYDXFtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 01:49:08 -0400
Subject: Re: physmap and "request_module: runaway loop modprobe net-pf-1"
From: David Woodhouse <dwmw2@infradead.org>
To: Gordon Farquharson <gordonfarquharson@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, davem@davemloft.net,
       netdev@vger.kernel.org
In-Reply-To: <97a0a9ac0804232101i71bfff22o723e2aaa80b09c2f@mail.gmail.com>
References: <97a0a9ac0803112235l157706adoa84b131549a46049@mail.gmail.com>
	 <20080311225926.6515e18c.akpm@linux-foundation.org>
	 <1208867831.9212.582.camel@pmac.infradead.org>
	 <97a0a9ac0804232101i71bfff22o723e2aaa80b09c2f@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 24 Apr 2008 06:49:03 +0100
Message-Id: <1209016143.9212.910.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-23 at 22:01 -0600, Gordon Farquharson wrote:
> I guess the question is which patch (if either) is more appealing.

I definitely think we should initialise AF_UNIX sockets earlier. At
least request_module() _can_ work then, if you want it to and you set up
userspace accordingly.

I'm also tempted to reduce the proliferation of modules in drivers/mtd
and turn the various partition options into booleans, though. Your
original patch is close, but I don't think it works in the CONFIG_MTD=m
case. I think we need to modify drivers/mtd/Makefile too, along these
lines:

diff --git a/drivers/mtd/Makefile b/drivers/mtd/Makefile
index 4b77335..6137eec 100644
--- a/drivers/mtd/Makefile
+++ b/drivers/mtd/Makefile
@@ -7,12 +7,12 @@ obj-$(CONFIG_MTD)             += mtd.o
 mtd-y                          := mtdcore.o mtdsuper.o
 mtd-$(CONFIG_MTD_PARTITIONS)   += mtdpart.o
 
-obj-$(CONFIG_MTD_CONCAT)       += mtdconcat.o
-obj-$(CONFIG_MTD_REDBOOT_PARTS) += redboot.o
-obj-$(CONFIG_MTD_CMDLINE_PARTS) += cmdlinepart.o
-obj-$(CONFIG_MTD_AFS_PARTS)    += afs.o
-obj-$(CONFIG_MTD_AR7_PARTS)    += ar7part.o
-obj-$(CONFIG_MTD_OF_PARTS)      += ofpart.o
+mtd-$(CONFIG_MTD_CONCAT)       += mtdconcat.o
+mtd-$(CONFIG_MTD_REDBOOT_PARTS) += redboot.o
+mtd-$(CONFIG_MTD_CMDLINE_PARTS) += cmdlinepart.o
+mtd-$(CONFIG_MTD_AFS_PARTS)    += afs.o
+mtd-$(CONFIG_MTD_AR7_PARTS)    += ar7part.o
+mtd-$(CONFIG_MTD_OF_PARTS)      += ofpart.o
 
 # 'Users' - code which presents functionality to userspace.
 obj-$(CONFIG_MTD_CHAR)         += mtdchar.o


I'll play with it.

-- 
dwmw2

