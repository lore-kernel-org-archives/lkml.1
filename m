Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbZF1Byr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbZF1Byr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 21:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZF1Byi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 21:54:38 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53010 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbZF1Byh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 21:54:37 -0400
To: tridge@samba.org
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
References: <19013.8005.541836.436991@samba.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 27 Jun 2009 18:54:26 -0700
In-Reply-To: <19013.8005.541836.436991@samba.org> (tridge@samba.org's message of "Sat\, 27 Jun 2009 05\:19\:33 +1000")
Message-ID: <m1d48p5dil.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: tridge@samba.org, paulmck@linux.vnet.ibm.com, cmm@us.ibm.com, sfrench@us.ibm.com, shaggy@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, john.lanza@linux.com, hirofumi@mail.parknet.co.jp
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;tridge@samba.org
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
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
>
> Cheers, Tridge
>
>
> ------------
>
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

This hunk allowing the examination of the long name if there is not a
short name is something else entirely.

You don't describe it in your summary, and don't make the case that
this is the correct behavior.

This should probably be split out into a separate patch if it is the
right thing to do, or drop it if (as it looks) there is no point in
that change.

Eric
