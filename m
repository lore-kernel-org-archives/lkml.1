Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbYHCPIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbYHCPIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 11:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756240AbYHCPIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 11:08:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:24649 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbYHCPII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 11:08:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=dB3UvxAq2+Cpxc7RNGQsWssMgxE8PsHwzvK7Gfhe0u/T2JK2XP8/0eTPFg9xWxEXl8
         GJ22BHwqsLW9EBjFTQS8XeNTDZyGjcWJd5EE9yE5E0aZVOy2i0woH0PVLs29KmGzRb0T
         yr17CYczJylBwnHfvX+HgmfTPtRpreobke5lI=
Date: Sun, 3 Aug 2008 17:08:03 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: alan@redhat.com, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 2/2] ide-generic: handle probing of legacy io-ports
Message-ID: <20080803150803.GC27766@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, alan@redhat.com,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080715053356.GA18628@gollum.tnic> <200808022046.16990.bzolnier@gmail.com> <20080803073842.GB8762@gollum.tnic> <200808031611.11033.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808031611.11033.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2008 at 04:11:10PM +0200, Bartlomiej Zolnierkiewicz wrote:

[.. ]

> There are still some issues to address though.

Issues addressed. Here's v2:

---
From: Borislav Petkov <petkovbb@gmail.com>
Date: Sun, 3 Aug 2008 09:28:53 +0200
Subject: [PATCH] ide-generic: handle probing of legacy io-ports v2

Avoid probing the io-ports in case an IDE PCI controller is present and it uses
the legacy iobases. If we still want to enforce the probing, we do

ide_generic.probe_mask=0x3f

on the kernel command line.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-generic.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/ide/ide-generic.c b/drivers/ide/ide-generic.c
index 8fe8b5b..1beb51b 100644
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -27,7 +27,7 @@
 
 #define DRV_NAME	"ide_generic"
 
-static int probe_mask = 0x03;
+static int probe_mask;
 module_param(probe_mask, int, 0);
 MODULE_PARM_DESC(probe_mask, "probe mask for legacy ISA IDE ports");
 
@@ -105,14 +105,27 @@ static int __init ide_generic_init(void)
 	hw_regs_t hw[MAX_HWIFS], *hws[MAX_HWIFS];
 	struct ide_host *host;
 	unsigned long io_addr;
-	int i, rc;
+	int i, rc, dummy, primary = 0, secondary = 0;
 
 #ifdef CONFIG_MIPS
 	if (!ide_probe_legacy())
 		return -ENODEV;
 #endif
-	printk(KERN_INFO DRV_NAME ": please use \"probe_mask=0x3f\" module "
-			 "parameter for probing all legacy ISA IDE ports\n");
+	ata_legacy_check_iobases(&primary, &secondary, &dummy);
+
+	if (!probe_mask) {
+		printk(KERN_INFO DRV_NAME ": please use \"probe_mask=0x3f\" "
+		       "module parameter for probing all legacy ISA IDE ports\n");
+
+		if (primary == 0)
+			probe_mask |= 0x1;
+
+		if (secondary == 0)
+			probe_mask |= 0x2;
+	} else {
+		printk(KERN_WARNING "%s: enforcing probing of io ports upon "
+			"user request.\n", DRV_NAME);
+	}
 
 	memset(hws, 0, sizeof(hw_regs_t *) * MAX_HWIFS);
 
-- 
1.5.5.4

-- 
Regards/Gruss,
    Boris.
