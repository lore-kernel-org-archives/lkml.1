Return-Path: <linux-kernel-owner+w=401wt.eu-S1761689AbYBLNo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761689AbYBLNo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 08:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757554AbYBLNoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 08:44:16 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:21142 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128AbYBLNoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 08:44:15 -0500
From: Chris Mason <chris.mason@oracle.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [ANNOUNCE] Btrfs v0.12 released
Date: Tue, 12 Feb 2008 08:43:31 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       btrfs-devel@oss.oracle.com
References: <200802061200.14690.chris.mason@oracle.com> <200802110842.21312.chris.mason@oracle.com> <20080211.224338.07019204.davem@davemloft.net>
In-Reply-To: <20080211.224338.07019204.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802120843.31561.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2008, David Miller wrote:
> From: Chris Mason <chris.mason@oracle.com>
> Date: Mon, 11 Feb 2008 08:42:20 -0500
>
> > The kernel is actually worse, because the set/get macros are more
> > complex. Some live in ctree.h like in the progs, but the nasty ones live
> > in struct-funcs.c
>
> This is really problematic, because you've got these things called
> "btrfs_item_ptr()" which really isn't a pointer, it's a relative
> 'unsigned long' offset cast to a pointer.  The source of this
> seems to be btrfs_leaf_data().
>
> And then those things get passed down into the SETGET functions!

Explaining it won't make it pretty, but at least I can tell you what the code 
does.

This is all part of the btrfs code that supports tree block sizes larger than 
a page.  The extent_buffer code (extent_io.c) provides a read/write api into 
an extent_buffer based on offsets from the start of the multi-page buffer.  
That's where the relative unsigned long comes from.

The part where I cast it to pointers is me trying to maintain type checking 
throughout the code.  The pointers themselves are useless, they need to be 
matched with an extent_buffer to actually get to the bytes.

There are a few parts where the SETGET funcs are open coded, mostly in very 
performance critical functions.  Just look for lexxx_to_cpu

>
> Then deeper down we have terribly inconsistent things like
> btrfs_item_nr_offset() and
> btrfs_item_offset_nr().

Btree blocks have the offset of the item header from the start of the block 
and the offset of the item data.  And, I'm very bad at naming.

>
> Sigh... I'll see what I can do.

Thanks

-chris
