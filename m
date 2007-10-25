Return-Path: <linux-kernel-owner+w=401wt.eu-S1759481AbXJYVqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbXJYVqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 17:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759728AbXJYVqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 17:46:43 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:54096 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834AbXJYVql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 17:46:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=BAWX9FXrl84JfN44g8yscyzn7scJhsoIzBZ2ovbPO2c/53mEyX+TNDJ7IDbjO2JXz+UdbX6kwg3KrcVjvEHn88VHlQMuyqtvL7eb6QMfp/Sen2p4Z0mYgaAS+isNlO7aWylKXj7msRFbxEC5L3+2KJ/qSlXgZ2l0kgP4GlFdqyY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [IDE] Fix build bug
Date: Thu, 25 Oct 2007 23:41:38 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-mips@linux-mips.org,
       Martijn Uffing <mp3project@sarijopen.student.utwente.nl>
References: <20071025135334.GA23272@linux-mips.org>
In-Reply-To: <20071025135334.GA23272@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710252341.38902.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday 25 October 2007, Ralf Baechle wrote:
>   CC      drivers/ide/pci/generic.o
> drivers/ide/pci/generic.c:52: error: __setup_str_ide_generic_all_on causes a
> +section type conflict
> 
> This sort of build error is becoming a regular issue.  Either all or non
> of the elements that go into a particular section of a compilation unit
> need to be const.  Or an error may result such as in this case if
> CONFIG_HOTPLUG is unset.
> 
> Maybe worth a check in checkpatch.pl - but certainly gcc's interolerance
> is also being less than helpful here.
> 
> ---
>  drivers/ide/pci/generic.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ide/pci/generic.c b/drivers/ide/pci/generic.c
> index f44d708..0047684 100644
> --- a/drivers/ide/pci/generic.c
> +++ b/drivers/ide/pci/generic.c
> @@ -67,7 +67,7 @@ MODULE_PARM_DESC(all_generic_ide, "IDE generic will claim all unknown PCI IDE st
>  		.udma_mask	= ATA_UDMA6, \
>  	}
>  
> -static const struct ide_port_info generic_chipsets[] __devinitdata = {
> +static struct ide_port_info generic_chipsets[] __devinitdata = {
>  	/*  0 */ DECLARE_GENERIC_PCI_DEV("Unknown",	0),
>  
>  	{	/* 1 */

I would prefer to not remove const from generic_chipsets[] so:

[PATCH] drivers/ide/pci/generic: fix build for CONFIG_HOTPLUG=n

It turns out that const and __{dev}initdata cannot be mixed currently
and that generic IDE PCI host driver is also affected by the same issue:

On Thursday 25 October 2007, Ralf Baechle wrote:
>   CC      drivers/ide/pci/generic.o
> drivers/ide/pci/generic.c:52: error: __setup_str_ide_generic_all_on causes a
> +section type conflict

[ Also reported by Martijn Uffing <mp3project@sarijopen.student.utwente.nl>. ]

This patch workarounds the problem in a bit hackish way but without
removing const from generic_chipsets[] (it adds const to __setup() so
__setup_str_ide_generic_all becomes const).

Now all __{dev}initdata data in generic IDE PCI host driver are read-only
so it builds again (driver's .init.data section gets marked as READONLY).

Cc: Martijn Uffing <mp3project@sarijopen.student.utwente.nl>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/pci/generic.c
===================================================================
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -49,7 +49,7 @@ static int __init ide_generic_all_on(cha
 	printk(KERN_INFO "IDE generic will claim all unknown PCI IDE storage controllers.\n");
 	return 1;
 }
-__setup("all-generic-ide", ide_generic_all_on);
+const __setup("all-generic-ide", ide_generic_all_on);
 #endif
 module_param_named(all_generic_ide, ide_generic_all, bool, 0444);
 MODULE_PARM_DESC(all_generic_ide, "IDE generic will claim all unknown PCI IDE storage controllers.");
