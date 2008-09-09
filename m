Return-Path: <linux-kernel-owner+w=401wt.eu-S1754234AbYIICDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbYIICDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 22:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbYIICC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 22:02:58 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:41925 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbYIICC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 22:02:57 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [Patch] hfs: fix namelength memory corruption
Date: Tue, 9 Sep 2008 02:02:55 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <ga4lgf$bl6$1@taverner.cs.berkeley.edu>
References: <20080908133505.GA3031@alice>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1220925775 11942 128.32.168.222 (9 Sep 2008 02:02:55 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Tue, 9 Sep 2008 02:02:55 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sesterhenn  wrote:
>this is basically the same as
>hfsplus-fix-buffer-overflow-with-a-corrupted-image.patch.
>We use the length parameter for a memcopy without checking it and
>thereby corruption memory. 
>
>Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
>
>--- linux/fs/hfs/catalog.c.orig	2008-09-08 15:20:15.000000000 +0200
>+++ linux/fs/hfs/catalog.c	2008-09-08 15:21:02.000000000 +0200
>@@ -190,6 +190,10 @@ int hfs_cat_find_brec(struct super_block
> 
> 	fd->search_key->cat.ParID = rec.thread.ParID;
> 	len = fd->search_key->cat.CName.len = rec.thread.CName.len;
>+	if (len > HFS_NAMELEN) {
>+		printk(KERN_ERR "hfs: bad catalog namelength\n");
>+		return -EIO;
>+	}
> 	memcpy(fd->search_key->cat.CName.name, rec.thread.CName.name, len);
> 	return hfs_brec_find(fd);
> }

Ahh.  Took me a second to see that this is saved from
signed/unsigned attacks by the fact that CName.len is u8.
In other words:
len is declared as an "int" (i.e., signed).
memcpy's third parameter is declared as size_t (i.e., unsigned).
Fortunately, len can't be negative, because CName.len is u8.
OK, got it.

I took a glance at some of the rest of fs/hfs/, to see whether
there are any other issues in there, and I couldn't tell whether
it's all OK.  e.g.,

  * hfs_asc2mac() doesn't seem to consistently check for buffer
    overflow.  If nls_io is non-NULL and nls_disk is false, what
    prevents this from writing beyond the end of dst?  Did I overlook
    something?

  * hfs_asc2mac() declares srclen, dstlen as ints, and compares
    them without checking for wraparound ("dstlen > srclen"): what
    if srclen is negative?  Couldn't tell if there's anything to
    worry about here.

  * hfs_cat_build_key doesn't check for integer overflow/wraparound
    ("6 + key->cat.CName.len"); is that safe?  I didn't check.

  * hfs_compare_dentry() declares len as an int.  This is harmless
    on typical compilers, but in principle could invoke undefined
    behavior.  What if s1->len == s2->len and both are > 2^31?  Then
    len is negative, bypassing the length check ("len >= HFS_NAMELEN"),
    and allowing the while() loop to cause integer underflow, which
    technically (according to the C spec) invokes undefined behavior.
    OK, on typical compilers I suspect this is harmless.

I might be talking nonsense.  Even if not, I suspect some or all of
these may actually be safe because of some facts about the callers,
but stylistically, whenever you are handling untrusted data, I wonder
if it would be safer to use code where it is locally obvious that the
code is free of buffer overruns and the like.

Would it be a good idea to review the rest of fs/hfs/ for other
potential signed/unsigned and integer overflow bugs as well?

Would the following practices be a good idea?

  * declare length values as size_t whereever possible.

  * write code where it's locally obvious that it is safe
    (minimize assumptions about how the rest of the code works,
    to reduce maintenance hazards, and make bugs more locally
    apparently by the fact that the code isn't obviously safe).
