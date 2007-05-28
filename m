Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbXE1EJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbXE1EJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 00:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbXE1EJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 00:09:22 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:38864 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750773AbXE1EJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 00:09:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Db7Qzt6Mo30Dj1aQivTrFb2R4kB+n3IPeblZ0kK/OvOINr/KOKVKB841ExeXmad1hIF64RJIRE4SFZ8CUAMXPEVv5rn7FPNuBUst5jD4jYU7bB0ZHDMInrb2Y0ZULr4a+C1Nnklj3okEuw2oLUAuIXgKEt+pQf+bLhdZSL8myEk=  ;
X-YMail-OSG: _sN9zQAVM1kvaoGc4zS0iC3PgNaiBgdz_pN2W_Ktg0bTKetC
Message-ID: <465A55E7.50904@yahoo.com.au>
Date: Mon, 28 May 2007 14:09:11 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Preserve the dirty bit in init_page_buffers
References: <m14pm5io6h.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m14pm5io6h.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> The problem:  When we are trying to free buffers try_to_free_buffers
> will look at ramdisk pages with clean buffer heads and remove the
> dirty bit from the page.  Resulting in ramdisk pages with data that
> get removed from the page cache.  Ouch!
> 
> Buffer heads appear on ramdisk pages when a filesystem calls getblk,
> which through a series of function calls eventually calls
> init_page_buffers. 
> 
> So to fix the mismatch between buffer head state and page state this
> patch modifies init_page_buffers to transfer the dirty bit from the
> page to the buffer heads like we currently do for the uptodate bit.

Ouch indeed!

But can we ever have a dirty page at init_page_buffers-time?

I would have thought we can fix this simply by removing the
broken ramdisk_set_page_dirty (as far as the comment goes, we
set CAP_NO_ACCT_DIRTY anyway, so the normal set_page_dirty
should handle everything properly, no?).


> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  fs/buffer.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index aa68206..c6b58e8 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -953,6 +953,7 @@ init_page_buffers(struct page *page, struct block_device *bdev,
>  	struct buffer_head *head = page_buffers(page);
>  	struct buffer_head *bh = head;
>  	int uptodate = PageUptodate(page);
> +	int dirty = PageDirty(page);
>  
>  	do {
>  		if (!buffer_mapped(bh)) {
> @@ -961,6 +962,8 @@ init_page_buffers(struct page *page, struct block_device *bdev,
>  			bh->b_blocknr = block;
>  			if (uptodate)
>  				set_buffer_uptodate(bh);
> +			if (dirty)
> +				set_buffer_dirty(bh);
>  			set_buffer_mapped(bh);
>  		}
>  		block++;


-- 
SUSE Labs, Novell Inc.
