Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbYLCGGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbYLCGGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 01:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbYLCGGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 01:06:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751977AbYLCGGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 01:06:07 -0500
Date: Tue, 2 Dec 2008 22:05:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: roel kluin <roel.kluin@gmail.com>
Cc: davidsen@tmr.com, tytso@mit.edu, adilger@sun.com,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext3, ext4: do_split() fix loop, with obvious
 unsigned wrap
Message-Id: <20081202220510.ddef1115.akpm@linux-foundation.org>
In-Reply-To: <49343AD9.4020606@gmail.com>
References: <49343AD9.4020606@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Dec 2008 14:28:25 -0500 roel kluin <roel.kluin@gmail.com> wrote:

> Fix loop, with obvious unsigned wrap
> 

Please raise separate patches for ext3 and ext4 - their paths into the
tree are different.

> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -1188,7 +1188,7 @@ static struct ext3_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
>  	/* Split the existing block in the middle, size-wise */
>  	size = 0;
>  	move = 0;
> -	for (i = count-1; i >= 0; i--) {
> +	for (i = count; i--; ) {

So we're replacing an accidental for(;;) with something which can
really terminate.  This is potentially a functional change, and it's
perhaps telling us that we should replace it with a real for (;;) loop
anyway.

Plus we still have a local unsigned variable called "i".

Ted, could you please take a look at this sometime, work out the best
course of action?

Thanks.

>  		/* is more than half of this entry in 2nd half of the block? */
>  		if (size + map[i].size/2 > blocksize/2)
>  			break;
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 63adcb7..34232c6 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1198,7 +1198,7 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
>  	/* Split the existing block in the middle, size-wise */
>  	size = 0;
>  	move = 0;
> -	for (i = count-1; i >= 0; i--) {
> +	for (i = count; i--; ) {
>  		/* is more than half of this entry in 2nd half of the block? */
>  		if (size + map[i].size/2 > blocksize/2)
>  			break;

