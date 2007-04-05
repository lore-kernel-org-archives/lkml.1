Return-Path: <linux-kernel-owner+w=401wt.eu-S1946023AbXDEHeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946023AbXDEHeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 03:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946044AbXDEHeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 03:34:22 -0400
Received: from relay4.usu.ru ([194.226.235.39]:35239 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946023AbXDEHeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 03:34:21 -0400
Message-ID: <4614A692.5020605@ums.usu.ru>
Date: Thu, 05 Apr 2007 13:34:42 +0600
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: lepton <ytht.net@gmail.com>, lkm <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 2.6.20.4 fix kernel panic on corrupted reiserfs directory
References: <20070405064140.GA19620@router.lepton.home>
In-Reply-To: <20070405064140.GA19620@router.lepton.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

lepton wrote:
> Hi,
>   When reading corrupted reiserfs directory data, d_reclen
>   could be a negative number, then memcpy will overflow
>   kernel stack. This can lead to kernel panic.
>   The following patch adds a sanity check. (against 2.6.20.4)

Is it possible to get a large positive number here due to other fs 
corruption and bypass your sanity check? If I read the code correctly, this 
would still oops in the "if" statement just below the part you patched.

> Signed-off-by: Lepton Wu <ytht.net@gmail.com>
> 
> diff -pru linux-2.6/fs/reiserfs/dir.c linux-2.6-lepton/fs/reiserfs/dir.c
> --- linux-2.6/fs/reiserfs/dir.c	2007-02-20 14:34:32.000000000 +0800
> +++ linux-2.6-lepton/fs/reiserfs/dir.c	2007-04-05 14:35:58.000000000 +0800
> @@ -121,6 +121,11 @@ static int reiserfs_readdir(struct file 
>  					/* it is hidden entry */
>  					continue;
>  				d_reclen = entry_length(bh, ih, entry_num);
> +				if (d_reclen < 0) {
> +					pathrelse(&path_to_entry);
> +					ret = -EIO;
> +					goto out;
> +				}
>  				d_name = B_I_DEH_ENTRY_FILE_NAME(bh, ih, deh);
>  				if (!d_name[d_reclen - 1])
>  					d_reclen = strlen(d_name);
> O
