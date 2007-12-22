Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbXLVKG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbXLVKG3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 05:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbXLVKGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 05:06:22 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60536 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbXLVKGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 05:06:22 -0500
Date: Sat, 22 Dec 2007 02:06:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: richard <richard@rsk.demon.co.uk>
Cc: den@openvz.org, lkml <linux-kernel@vger.kernel.org>,
       Michael Rubin <mrubin@google.com>
Subject: Re: Possible fix for lockup in drop_caches
Message-Id: <20071222020611.9e4e78dd.akpm@linux-foundation.org>
In-Reply-To: <1197893602.2866.13.camel@castor.localdomain>
References: <1197893602.2866.13.camel@castor.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 12:13:22 +0000 richard <richard@rsk.demon.co.uk> wrote:

>     fix lockup in when calling drop_caches
>     
>     calling /proc/sys/vm/drop_caches can hang due to a AB/BA lock dependency
>     between j_list_lock and the inode_lock. This patch moves the redirtying of the buffer head out
>     from under the j_list_lock.
>     
>     based on a suggestion by Andrew Morton.
>     

Oh boy.  Do we really want to add all this stuff to JBD just for
drop_caches which is a silly root-only broken-in-22-other-ways thing?

Michael, might your convert-inode-lists-to-tree patches eliminate the need
for taking inode_lock in drop_pagecache_sb()?  Probably not, as it uses an
rbtree.  It would have been possible if it was using a radix-tree, I
suspect..

> -void __journal_unfile_buffer(struct journal_head *jh)
> +void __journal_unfile_buffer(struct journal_head *jh,
> +		struct buffer_head **dirty_bh)
>  {
> -	__journal_temp_unlink_buffer(jh);
> +	__journal_temp_unlink_buffer(jh, dirty_bh);
>  	jh->b_transaction = NULL;
>  }

I suspect the code would end up simpler if __journal_unfile_buffer() were
to take an additional ref on the bh which it placed at *dirty_bh.

Callers of __journal_unfile_buffer() could then call

void handle_dirty_bh(struct buffer_head *bh)
{
	if (bh) {
		jbd_mark_buffer_dirty(bh);
		put_bh(bh);
	}
}

?
