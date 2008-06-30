Return-Path: <linux-kernel-owner+w=401wt.eu-S1759797AbYF3MLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759797AbYF3MLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 08:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755751AbYF3MLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 08:11:31 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:54460 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122AbYF3MLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 08:11:30 -0400
Date: Mon, 30 Jun 2008 13:10:55 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: hooanon05@yahoo.co.jp
cc: Erez Zadok <ezk@cs.sunysb.edu>, Andrew Morton <akpm@linux-foundation.org>,
       mhalcrow@us.ibm.com, hch@infradead.org, viro@zeniv.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fsstack: fsstack_copy_inode_size locking 
In-Reply-To: <8725.1214800317@jrobl>
Message-ID: <Pine.LNX.4.64.0806301238080.6538@blonde.site>
References: <Pine.LNX.4.64.0806290101160.20280@blonde.site> <8725.1214800317@jrobl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008, hooanon05@yahoo.co.jp wrote:
> Hugh Dickins:
> > LTP's iogen01 doio tests used to hang nicely on 32-bit SMP when /tmp was a
> > unionfs mount of a tmpfs, i_size_read spinning forever, waiting for a lost
> > seqcount update: fixed by taking i_lock around i_size_write when 32-bit SMP.

(That, of course, is already fixed in Erez's unionfs git, so in mm;
but I thought I'd better repeat the history because some of akpm's
objections to pushing the fix to mainline came from the lack of
this explanation when the patch was submitted for mainline.)

> 
> I don't know why dst->i_lock is affected by src->i_size_seqcount.

It certainly shouldn't be.  The problem would have come from two
racing i_size_write(dst)s, one of the unlocked increments getting
lost, leaving seqcount odd, so the next i_size_read(dst) would
spin forever waiting for it to go even.

> Do you mean that your test issued write(2) to the lower/actual file

I was merely running LTP, on a Core(2) Quad machine, with /tmp as
unionfs mount of a tmpfs.  It wouldn't have been doing anything
directly to the lower file, that would all have been coming via
the unionfs mount.

> so frequently that i_size_read() in unionfs always failed?

I'm not sure what you mean by that.  i_size_read() doesn't fail,
but it may loop; and if the seqcount has got out of step from
concurrent unlocked i_size_write()s, then it'll spin forever.

> 
> Is your test
> iogen01 export LTPROOT; rwtest -N iogen01 -i 120s -s read,write -Da -Dv -n 2 500b:doio.f1.$$ 1000b:doio.f2.$$
> line in runtest/fs?

That looks like it: I don't think I ever tried it as a standalone test,
just investigated what was happening when standard LTP runs hung here.

Hugh
