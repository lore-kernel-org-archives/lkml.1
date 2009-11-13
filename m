Return-Path: <linux-kernel-owner+w=401wt.eu-S932592AbZKMXc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592AbZKMXc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932506AbZKMXcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:32:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932465AbZKMXcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:32:54 -0500
Date: Fri, 13 Nov 2009 15:32:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] hpfs: Use hweight32
Message-Id: <20091113153255.9726be89.akpm@linux-foundation.org>
In-Reply-To: <1258096028-13426-1-git-send-email-akinobu.mita@gmail.com>
References: <1258096028-13426-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Nov 2009 16:07:08 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> Use hweight32 instead of counting for each bit
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  fs/hpfs/super.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
> index f2feaa0..cf6fe4a 100644
> --- a/fs/hpfs/super.c
> +++ b/fs/hpfs/super.c
> @@ -119,11 +119,8 @@ unsigned hpfs_count_one_bitmap(struct super_block *s, secno secno)
>  	unsigned i, count;
>  	if (!(bits = hpfs_map_4sectors(s, secno, &qbh, 4))) return 0;
>  	count = 0;
> -	for (i = 0; i < 2048 / sizeof(unsigned); i++) {
> -		unsigned b; 
> -		if (!bits[i]) continue;
> -		for (b = bits[i]; b; b>>=1) count += b & 1;
> -	}
> +	for (i = 0; i < 2048 / sizeof(unsigned); i++)
> +		count += hweight32(bits[i]);
>  	hpfs_brelse4(&qbh);
>  	return count;

Could actualy use bitmap_weight() here.

It's a bit naughty, because bitmap_weight() operates on long*'s, but it
will work OK.

Shrug.
