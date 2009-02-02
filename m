Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbZBBUvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbZBBUvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbZBBUvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:51:41 -0500
Received: from mail2.shareable.org ([80.68.89.115]:43527 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbZBBUvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:51:40 -0500
Date: Mon, 2 Feb 2009 20:51:02 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>,
       Christoph Hellwig <hch@infradead.org>,
       Eric Sandeen <sandeen@sandeen.net>, mfasheh@suse.com,
       joel.becker@oracle.com, linux-kernel@vger.kernel.org,
       xfs-masters@oss.sgi.com, viro@zeniv.linux.org.uk,
       Ankit Jain <me@ankitjain.org>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com,
       ocfs2-devel@oss.oracle.com
Subject: Re: [xfs-masters] [PATCH] fs: Add new pre-allocation ioctls to vfs for compatibility with legacy xfs ioctls
Message-ID: <20090202205102.GG28129@shareable.org>
References: <20090130171423.f99c88d0.akpm@linux-foundation.org> <20090201164130.GA32276@infradead.org> <4985D48A.6090007@panasas.com> <200902020131.04203.arnd@arndb.de> <4986AEE8.5040609@panasas.com> <Pine.LNX.4.64.0902020942230.11930@anakin> <4986BE07.6090000@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4986BE07.6090000@panasas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> No the natural alignment is what it is, after the application of
> __attribute__((packed(1))). In a well defined structure that is a no-opt.
> But yes in ai64 the gcc programmers got lazy and did not make that analysis
> after laying out the structure.

No.  That's what you *want* packed to mean, but it doesn't mean that.

__attribute__ packed on a struct definition means to pack the
structure _and_ set its assumed alignment to 1.

This is what the packed attribute historically means, and it cannot be
changed without breaking existing code.

If you want to remove padding from a structure, but still keep its
natural alignment, you do it with two attributes together:
__attribute__((packed, aligned(4))).  You have to choose the alignment
you want in that case.

GCC manual:
     When used on a struct, or struct member, the `aligned' attribute
     can only increase the alignment; in order to decrease it, the
     `packed' attribute must be specified as well.  When used as part
     of a typedef, the `aligned' attribute can both increase and
     decrease alignment, and specifying the `packed' attribute will
     generate a warning.

It's a counterintuitive, because you must use
__attribute__((aligned(1))) when declaring a variable to reduce its
alignment, but you must use __attribute__((packed)) when declaring a
struct type.  Doing it at the end of a struct typedef is a weird mix
of semantics, so don't do that.

By the way, this discussion is why the "-Wpacked" and "-Wpadding"
options are available.

> The base address can be unaligned even if the structure is aligned. In that
> case you need the __atrubute__((aligned)) thingy.

No, because __attribute__((packed)) on a struct doesn't mean what you
want it to mean.  Use __attribute((packed,aligned(4))) if that's what
you want.

> Please note that I gave up on the compiler and understand that the
> use of __packed is dangerous in some cases, sigh. My standing point
> is to make sure there are no guesses left, and a BUILD_BUG_ON to
> make sure of that.

In this code, it's not a bug because it must be backward compatible
with existing binary code.  "Fixing" the padding breaks
compatibility, which is pointless for this patch.

-- Jamie
