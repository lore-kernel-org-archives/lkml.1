Return-Path: <linux-kernel-owner+w=401wt.eu-S1757167AbZF3U5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbZF3U5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 16:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbZF3U5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 16:57:14 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:55481 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbZF3U5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 16:57:13 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: steve@digidescorp.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FAT: optimize FSINFO writeback
References: <1246392130-4261-1-git-send-email-steve@digidescorp.com>
Date: Wed, 01 Jul 2009 05:57:15 +0900
In-Reply-To: <1246392130-4261-1-git-send-email-steve@digidescorp.com>
	(steve@digidescorp.com's message of "Tue, 30 Jun 2009 15:02:10 -0500")
Message-ID: <87ocs5h238.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

steve@digidescorp.com writes:

> Only write the FSINFO block back to disk when its contents change.
> This optimization can be important when the underlying physical media
> can wear out, i.e. Flash.

I have no objection to this though.  Was this tested on recent version?
Well, now, we are using sb->s_dirty for fsinfo, so I'm wondering why
this happen frequently.

Thanks.

> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> diff -uprN a/fs/fat/misc.c b/fs/fat/misc.c
> --- a/fs/fat/misc.c	2009-06-29 11:12:40.000000000 -0500
> +++ b/fs/fat/misc.c	2009-06-29 11:46:45.000000000 -0500
> @@ -61,11 +61,25 @@ void fat_clusters_flush(struct super_blo
>  		       le32_to_cpu(fsinfo->signature2),
>  		       sbi->fsinfo_sector);
>  	} else {
> -		if (sbi->free_clusters != -1)
> -			fsinfo->free_clusters = cpu_to_le32(sbi->free_clusters);
> -		if (sbi->prev_free != -1)
> -			fsinfo->next_cluster = cpu_to_le32(sbi->prev_free);
> -		mark_buffer_dirty(bh);
> +		char write_needed = 0;
> +		__le32 le_value;
> +
> +		if (sbi->free_clusters != -1) {
> +			le_value = cpu_to_le32(sbi->free_clusters);
> +			if (fsinfo->free_clusters != le_value) {
> +				fsinfo->free_clusters = le_value;
> +				write_needed = 1;
> +			}
> +		}
> +		if (sbi->prev_free != -1) {
> +			le_value = cpu_to_le32(sbi->prev_free);
> +			if (fsinfo->next_cluster != le_value) {
> +				fsinfo->next_cluster = le_value;
> +				write_needed = 1;
> +			}
> +		}
> +		if (write_needed)
> +			mark_buffer_dirty(bh);
>  	}
>  	brelse(bh);
>  }
>

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
