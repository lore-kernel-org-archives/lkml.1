Return-Path: <linux-kernel-owner+w=401wt.eu-S1758523AbZDXWMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbZDXWMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 18:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755602AbZDXWLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 18:11:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58760 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbZDXWLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 18:11:53 -0400
Date: Sat, 25 Apr 2009 00:14:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [RFC][patch] filesystem: Vmufat filesystem, version 4
Message-ID: <20090424221455.GB5342@elf.ucw.cz>
References: <1239654768.6542.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239654768.6542.10.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-04-13 21:32:48, Adrian McMenamin wrote:
> I know this still has issues that others have raised but I wanted to
> post a version before the end of the long weekend...
> 
> As before - some documentation about the filesystem:
> http://mc.pp.se/dc/vms/flashmem.html
> 
> A shell filesystem (eg for mount over loopback) available here:
> http://newgolddream.dyndns.info/pristine
> 
> A few people commented that this is a bit long for a single file - but
> it is comparable to other files in the filesystem hierarchy - comments
> welcome.
> 
> The filesystem is hardware independent but is also written on the basis
> that this is most likely to be used with a Dreamcast VMU - though it may
> be of more use to emulator writers in the end.
> 
>  fs/Kconfig         |    1 +
>  fs/Makefile        |    1 +
>  fs/vmufat/Kconfig  |   14 +
>  fs/vmufat/Makefile |    7 +
>  fs/vmufat/inode.c  | 1362 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 1385 insertions(+), 0 deletions(-)
> 
> Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> ---
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 9f7270f..b7cb23d 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -176,6 +176,7 @@ source "fs/romfs/Kconfig"
>  source "fs/sysv/Kconfig"
>  source "fs/ufs/Kconfig"
>  source "fs/exofs/Kconfig"
> +source "fs/vmufat/Kconfig"
>  
>  config NILFS2_FS
>  	tristate "NILFS2 file system support (EXPERIMENTAL)"
> diff --git a/fs/Makefile b/fs/Makefile
> index af6d047..9d2d469 100644
> --- a/fs/Makefile
> +++ b/fs/Makefile
> @@ -124,3 +124,4 @@ obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
>  obj-$(CONFIG_BTRFS_FS)		+= btrfs/
>  obj-$(CONFIG_GFS2_FS)           += gfs2/
>  obj-$(CONFIG_EXOFS_FS)          += exofs/
> +obj-$(CONFIG_VMUFAT_FS)		+= vmufat/
> diff --git a/fs/vmufat/Kconfig b/fs/vmufat/Kconfig
> new file mode 100644
> index 0000000..bdad4c6
> --- /dev/null
> +++ b/fs/vmufat/Kconfig
> @@ -0,0 +1,14 @@
> +config VMUFAT_FS
> +	tristate "Dreamcast VMU FAT filesystem"
> +	depends on BLOCK
> +	help
> +	  This implements the simple FAT type filesystem found on SEGA
> +	  Dreamcast visual memory units.
> +
> +	  Dreamcast users who want to mount their VMUs to view the native
> +	  filesystem will say 'Y' here. The filesystem is hardware independent
> +	  but is not recommended for any serious use in other circumstances, so
> +	  just about everyone else should say 'N'.
> +
> +	  To compile this as a module say 'M' here. The module will be called
> +	  vmufat

"vmufat.ko." ?

> +static unsigned long vmufat_save_bcd(char *bh, int z)
> +{
> +	unsigned char day, year, century, nl_day, month;
> +	unsigned char u8year;

u8year? Should this be "u8 u8year"?

> +	unsigned long unix_date = CURRENT_TIME.tv_sec;
> +
> +	day = unix_date / 86400 - 3652;
> +	year = day / 365;
> +
> +	if ((year + 3) / 4 + 365 * year > day)
> +		year--;
> +
> +	day -= (year + 3) / 4 + 365 * year;
> +	if (day == 59 && !(year & 3)) {
> +		nl_day = day;
> +		month = 2;
> +	} else {
> +		nl_day = (year & 3) || day <= 59 ? day : day - 1;
> +		for (month = 0; month < 12; month++)
> +			if (day_n[month] > nl_day)
> +				break;
> +	}
> +
> +	century = 19;
> +	if (year > 19)
> +		century = 20;
> +
> +	bh[z + 0x10] = bin2bcd(century);
> +	u8year = year + 80;
> +	if (u8year > 99)
> +		u8year = u8year - 100;

It would be nice to document when this stops working.

> +	bh[z + 0x11] = bin2bcd(u8year);
> +	bh[z + 0x12] = bin2bcd(month);
> +	bh[z + 0x13] =
> +	    bin2bcd(day - day_n[month - 1] + 1);
> +	bh[z + 0x14] =
> +	    bin2bcd((unix_date / 3600) % 24);
> +	bh[z + 0x15] = bin2bcd((unix_date / 60) % 60);
> +	bh[z + 0x16] = bin2bcd(unix_date % 60);
> +	return unix_date;
> +}
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
