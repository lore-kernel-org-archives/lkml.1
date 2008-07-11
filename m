Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbYGKXjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbYGKXjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 19:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYGKXjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 19:39:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39938 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752278AbYGKXjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 19:39:36 -0400
Date: Fri, 11 Jul 2008 16:39:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] VFS: Pagecache usage optimization onpagesize!=blocksize
 environment
Message-Id: <20080711163901.e6adee6c.akpm@linux-foundation.org>
In-Reply-To: <6.0.0.20.2.20080527175418.0554f348@172.19.0.2>
References: <6.0.0.20.2.20080513205758.03a7a6b0@172.19.0.2>
	<20080521001930.202446eb.akpm@linux-foundation.org>
	<6.0.0.20.2.20080522160939.051ca938@172.19.0.2>
	<20080522010355.32590474.akpm@linux-foundation.org>
	<6.0.0.20.2.20080527172732.05447770@172.19.0.2>
	<20080527015135.561eeb6d.akpm@linux-foundation.org>
	<6.0.0.20.2.20080527175418.0554f348@172.19.0.2>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 18:34:02 +0900 Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> wrote:

> When we read some part of a file through pagecache, if there is a pagecache 
> of corresponding index but this page is not uptodate, read IO is issued and
> this page will be uptodate.
> I think this is good for pagesize == blocksize environment but there is room
> for improvement on pagesize != blocksize environment. Because in this case
> a page can have multiple buffers and even if a page is not uptodate, some buffers 
> can be uptodate. So I suggest that when all buffers which correspond to a part
> of a file that we want to read are uptodate, use this pagecache and copy data
> from this pagecache to user buffer even if a page is not uptodate. This can
> reduce read IO and improve system throughput.
> 
> v2: add new address_space_operations member is_partially_uptodate, and 
>      block_is_partially_uptodate was registered to ext2/3/4's aops.
>      modify do_generic_file_read to use this aops callback.
> v3: use unsigned instead of unsigned long in block_is_partially_uptodate.
>      cleaned up and simplified page buffer iteration code in block_is_partially_uptodate.
> 
> Signed-off-by :Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

ext4 has now gained a new set of address_space_operations:
ext4_da_aops.  I put a

        .is_partially_uptodate  = block_is_partially_uptodate,

into there as well, but I have no clue whether it will work OK.

