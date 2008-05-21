Return-Path: <linux-kernel-owner+w=401wt.eu-S932647AbYEUHjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647AbYEUHjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 03:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758927AbYEUHjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 03:39:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758492AbYEUHjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 03:39:03 -0400
Date: Wed, 21 May 2008 00:38:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VFS: Pagecache usage optimization on pagesize !=
 blocksize environment
Message-Id: <20080521003849.0aabac4b.akpm@linux-foundation.org>
In-Reply-To: <20080521001930.202446eb.akpm@linux-foundation.org>
References: <6.0.0.20.2.20080513205758.03a7a6b0@172.19.0.2>
	<20080521001930.202446eb.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 00:19:30 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> I guess a suitable fix might be to implement the above using a new
> address_space_operations callback:
> 
> 	if (PagePrivate(page) && aops->is_partially_uptodate) {

This is a bit presumptuous.  A filesytem could in theory be able to
work out if a section of a page is uptodate without necessarily
maintaining per-page metadata at page.private.

So one really should just do

	if (aops->is_partially_uptodate)

however it's hard to conceive how a filesystem could sanely do this
_without_ putting data at page.private, so the PagePrivate() test could
perhaps be retained as a microoptimisation, as long as it is suitably
commented.

otoh, non-zero aops->is_partially_uptodate might well be less common
than non-zero PagePrivate(), so perhaps these should be tested in the
other order.  Not sure.

> 		if (aops->is_partially_uptodate(page, desc, offset))
> 			<OK, we can copy the data>
> 
> then implement a generic_file_is_partially_uptodate() in fs/buffer.c

Make that block_is_partially_uptodate().

> and wire that up in the filesystems.
> 
> Note that things like network filesystems can then implement this also.

