Return-Path: <linux-kernel-owner+w=401wt.eu-S1758039AbZF0B4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbZF0B4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 21:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbZF0B4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 21:56:02 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:60830 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbZF0B4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 21:56:00 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: tridge@samba.org
Cc: john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
References: <19013.8005.541836.436991@samba.org>
Date: Sat, 27 Jun 2009 10:56:02 +0900
In-Reply-To: <19013.8005.541836.436991@samba.org> (tridge@samba.org's message
	of "Sat, 27 Jun 2009 05:19:33 +1000")
Message-ID: <87ab3uzbgt.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tridge@samba.org writes:

> This is a new patch for VFAT long filename support, replacing the one
> that I posted last month. It retains a lot more functionality then the
> previous patch.
>
> A FAQ will be posted immediately after this patch to answer the
> questions that were raised from the previous discussion.

Looks good to me. It seems to be trying to be minimal change, and I
guess it would be worth a try for realworld problem.  Like FAQ is
saying, the default might be arguable though.

> When VFAT_FS_DUALNAMES is disabled we avoid the creation of 8.3 short
> filenames for files on VFAT filesystems that require a long name. The
> patch uses a pattern of 11 bytes in the directory entry which contains
> invalid characters such that it cannot be considered to be a valid short
> filename.
>
> Signed-off-by: Andrew Tridgell <tridge@samba.org>
> Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  fs/fat/Kconfig      |   20 +++++++++++++++++
>  fs/fat/dir.c        |   15 ++++++-------
>  fs/fat/namei_vfat.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 86 insertions(+), 8 deletions(-)
>
> diff --git a/fs/fat/Kconfig b/fs/fat/Kconfig
> index 182f9ff..907a5de 100644
> --- a/fs/fat/Kconfig
> +++ b/fs/fat/Kconfig
> @@ -74,6 +74,26 @@ config VFAT_FS
>  	  To compile this as a module, choose M here: the module will be called
>  	  vfat.
>  
> +config VFAT_FS_DUALNAMES
> +	bool "VFAT dual names support"
> +	depends on VFAT_FS
> +	help
> +	  This option provides support for dual filenames on VFAT filesystems.
> +	  If this option is disabled then file creation will either put
> +	  a short (8.3) name or a long name on the file, but never both.
> +	  The field where a shortname would normally go is filled with
> +	  invalid characters such that it cannot be considered a valid
> +	  short filename.
> +
> +	  That means that long filenames created with this option
> +	  disabled will not be accessible at all to operating systems
> +	  that do not understand the VFAT extensions.
> +
> +	  Users considering enabling this option should consider the implications
> +	  of any patents that may exist on dual filenames in VFAT.
> +
> +	  If unsure, say N
> +
>  config FAT_DEFAULT_CODEPAGE
>  	int "Default codepage for FAT"
>  	depends on MSDOS_FS || VFAT_FS
> diff --git a/fs/fat/dir.c b/fs/fat/dir.c
> index 38ff75a..cd5d3ec 100644
> --- a/fs/fat/dir.c
> +++ b/fs/fat/dir.c
> @@ -420,14 +420,13 @@ parse_record:
>  			}
>  			i += chl;
>  		}
> -		if (!last_u)
> -			continue;
> -
> -		/* Compare shortname */
> -		bufuname[last_u] = 0x0000;
> -		len = fat_uni_to_x8(sbi, bufuname, bufname, sizeof(bufname));
> -		if (fat_name_match(sbi, name, name_len, bufname, len))
> -			goto found;
> +		if (last_u) {
> +			/* Compare shortname */
> +			bufuname[last_u] = 0x0000;
> +			len = fat_uni_to_x8(sbi, bufuname, bufname, sizeof(bufname));
> +			if (fat_name_match(sbi, name, name_len, bufname, len))
> +				goto found;
> +		}
>  
>  		if (nr_slots) {
>  			void *longname = unicode + FAT_MAX_UNI_CHARS;
> diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
> index 73471b7..894f44d 100644
> --- a/fs/fat/namei_vfat.c
> +++ b/fs/fat/namei_vfat.c
> @@ -22,6 +22,7 @@
>  #include <linux/smp_lock.h>
>  #include <linux/buffer_head.h>
>  #include <linux/namei.h>
> +#include <linux/random.h>
>  #include "fat.h"
>  
>  /*
> @@ -586,6 +587,59 @@ xlate_to_uni(const unsigned char *name, int len, unsigned char *outname,
>  	return 0;
>  }
>  
> +#ifndef CONFIG_VFAT_FS_DUALNAMES
> +/*
> + * build a 11 byte 8.3 buffer which is not a short filename. We want 11
> + * bytes which:
> + *    - will be seen as a constant string to all APIs on Linux and Windows
> + *    - cannot be matched with wildcard patterns
> + *    - cannot be used to access the file
> + *    - has a low probability of collision within a directory
> + *    - has an invalid 3 byte extension
> + *    - contains at least one non-space and non-nul byte
> + */
> +static void vfat_build_dummy_83_buffer(struct inode *dir, char *msdos_name)
> +{
> +	u32 rand_num = random32() & 0x3FFFFFFF;
> +	int i;
> +
> +	/* a value of zero would leave us with only nul and spaces,
> +	 * which would not work with older linux systems
> +	 */
> +	if (rand_num == 0)
> +		rand_num = 1;
> +
> +	/* we start with a space followed by nul as spaces at the
> +	 * start of an entry are trimmed in FAT, which means that
> +	 * starting the 11 bytes with 0x20 0x00 gives us a value which
> +	 * cannot be used to access the file. It also means that the
> +	 * value as seen from all Windows and Linux APIs is a constant
> +	 */
> +	msdos_name[0]  = ' ';
> +	msdos_name[1]  = 0;
> +
> +	/* we use / and 2 nul bytes for the extension. These are
> +	 * invalid in FAT and mean that utilities that show the
> +	 * directory show no extension, but still work via the long
> +	 * name for old Linux kernels
> +	 */
> +	msdos_name[8]  = '/';
> +	msdos_name[9]  = 0;
> +	msdos_name[10] = 0;
> +
> +	/*
> +	 * fill the remaining 6 bytes with random invalid values
> +	 * This gives us a low collision rate, which means a low
> +	 * chance of problems with chkdsk.exe and WindowsXP
> +	 */
> +	for (i = 2; i < 8; i++) {
> +		msdos_name[i] = rand_num & 0x1F;
> +		rand_num >>= 5;
> +	}
> +}
> +#endif
> +
> +
>  static int vfat_build_slots(struct inode *dir, const unsigned char *name,
>  			    int len, int is_dir, int cluster,
>  			    struct timespec *ts,
> @@ -628,6 +682,11 @@ static int vfat_build_slots(struct inode *dir, const unsigned char *name,
>  		goto shortname;
>  	}
>  
> +#ifndef CONFIG_VFAT_FS_DUALNAMES
> +	vfat_build_dummy_83_buffer(dir, msdos_name);
> +	lcase = 0;
> +#endif
> +
>  	/* build the entry of long file name */
>  	cksum = fat_checksum(msdos_name);

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
