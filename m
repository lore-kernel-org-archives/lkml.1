Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbXJNIpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbXJNIpJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 04:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbXJNIoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 04:44:55 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:33850 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbXJNIox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 04:44:53 -0400
Date: Sun, 14 Oct 2007 09:44:08 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Ryan Finnie <ryan@finnie.org>, Andrew Morton <akpm@linux-foundation.org>,
       Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, cjwatson@ubuntu.com, linux-mm@kvack.org
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland
In-Reply-To: <84144f020710121445p23fcc21am18482e01856cdc35@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0710140928470.23926@blonde.wat.veritas.com>
References: <200710071920.l97JKJX5018871@agora.fsl.cs.sunysb.edu> 
 <20071011144740.136b31a8.akpm@linux-foundation.org> 
 <cfa94dc20710111512j9b6c038qf89c516ecd605411@mail.gmail.com> 
 <Pine.LNX.4.64.0710120129080.16588@blonde.wat.veritas.com>
 <84144f020710121445p23fcc21am18482e01856cdc35@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Oct 2007, Pekka Enberg wrote:
> On 10/12/07, Hugh Dickins <hugh@veritas.com> wrote:
> > But I keep suspecting that the answer might be the patch below (which
> > rather follows what drivers/block/rd.c is doing).  I'm especially
> > worried that, rather than just AOP_WRITEPAGE_ACTIVATE being returned
> > to userspace, bad enough in itself, you might be liable to hit that
> > BUG_ON(page_mapped(page)).  shmem_writepage does not expect to be
> > called by anyone outside mm/vmscan.c, but unionfs can now get to it?
> 
> Doesn't msync(2) get to it via mm/page-writeback.c:write_cache_pages()
> without unionfs even?

I believe not.  Please do double-check my assertions, I've always found
the _writepages paths rather twisty; but my belief (supported by the
fact that we've not hit shmem_writepage's BUG_ON(page_mapped(page))
in five years) is that tmpfs/shmem opts out of all of that with its
	.capabilities	= BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_WRITEBACK,
in shmem_backing_dev_info, which avoids all those _writepages avenues
(e.g. through bdi_cap_writeback_dirty tests), and write_cache_pages is
just a subfunction of the _writepages.

So, while I don't disagree with your patch to write_cache_pages (though
it wasn't clear to me whether it should break from or continue the loop
if it ever does meet an AOP_WRITEPAGE_ACTIVATE), I don't think that's
really the root of the problem.

Hugh
