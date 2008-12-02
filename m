Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbYLBNYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbYLBNYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbYLBNYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:24:45 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:55991 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753320AbYLBNYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:24:44 -0500
Date: Tue, 2 Dec 2008 08:24:41 -0500
From: Theodore Tso <tytso@mit.edu>
To: roel kluin <roel.kluin@gmail.com>
Cc: davidsen@tmr.com, adilger@sun.com, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext3, ext4: do_split() fix loop, with obvious
	unsigned wrap
Message-ID: <20081202132441.GC16172@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	roel kluin <roel.kluin@gmail.com>, davidsen@tmr.com,
	adilger@sun.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <49343AD9.4020606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49343AD9.4020606@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 02:28:25PM -0500, roel kluin wrote:
> Fix loop, with obvious unsigned wrap
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Um, no.  Sorry, I didn't have a chance to reply earlier but this is
obviously wrong.

> ---
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index 3e5edc9..b0dcfb3 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -1188,7 +1188,7 @@ static struct ext3_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
>  	/* Split the existing block in the middle, size-wise */
>  	size = 0;
>  	move = 0;
> -	for (i = count-1; i >= 0; i--) {
> +	for (i = count; i--; ) {
>  		/* is more than half of this entry in 2nd half of the block? */
>  		if (size + map[i].size/2 > blocksize/2)
>  			break;

Note that i is actually **used** in the loop?  So changing the
starting value of the counter without also adjusting all of the places
where i is used will cause the code to break, and in hard to find
ways...

Given that there are two loop termination conditions, and in fact the
one in the loop is the one that actually gets used 99% of the time
(which is why we've never noticed the problem in real life), probably
the best way of handling this is to recast it not as a for loop, but
as a while loop.

						- Ted
