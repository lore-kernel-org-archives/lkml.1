Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551AbZGDS3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbZGDS3s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 14:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZGDS3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 14:29:41 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:34083 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbZGDS3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 14:29:41 -0400
Date: Sat, 4 Jul 2009 14:29:40 -0400
From: "Doug Graham" <dgraham@nortel.com>
To: linux-kernel@vger.kernel.org
Subject: More fun with MinixFS V3
Message-ID: <20090704182940.GA19185@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was just looking over an old thread about MinixFs V3 support and
starting to get worried that my tweaks to support blocksizes of 512
bytes (for a small filesystem with many small files) might be broken.
This is the thread here: http://lkml.org/lkml/2006/5/6/50.
The nblocks() routine in fs/minix/itree_common.c now looks like this:

static inline unsigned nblocks(loff_t size, struct super_block *sb)
{
        int k = sb->s_blocksize_bits - 10;
        unsigned blocks, res, direct = DIRECT, i = DEPTH;
        blocks = (size + sb->s_blocksize - 1) >> (BLOCK_SIZE_BITS + k);
        ...

and what had be worred at first is that sb->s_blocksize_bits will be 9
with a blocksize of 512, which makes k negative.  But all may not be lost,
since k is only used once after this, after adding BLOCK_SIZE_BITS (10)
to it.  At least that makes it nonnegative again, but then the question
is: what exactly is being accomplished here?  First we subtract 10,
then add it back?  The result is effectively this:

  blocks = (size + sb->s_blocksize - 1) >> sb->s_blocksize_bits

which looks entirely correct to me.  Is there any reason the code couldn't
just be written this way to begin with?

--Doug
