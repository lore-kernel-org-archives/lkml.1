Return-Path: <linux-kernel-owner+w=401wt.eu-S1758275AbXJNRK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbXJNRK1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 13:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758208AbXJNRJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 13:09:42 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:36290 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758153AbXJNRJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 13:09:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QqfGc+06WkyQmY3gFr4OynkVWxICjbi4r5rtkvfisCdBdVesUy1ygXuHsCZsEC5v9JS/PSeAglyJezZyDVD+YK0p8O/aVoNOiaUJM5r8TIiQ2DftkQMZJ5/jYc0Lu6s6SZSzgULTUqsIwGfWSWjBPHvRfiQ9Q41h53e04qKQfWE=
Message-ID: <84144f020710141009xbc5bb71w64e8288f364ab491@mail.gmail.com>
Date: Sun, 14 Oct 2007 20:09:34 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland
Cc: "Ryan Finnie" <ryan@finnie.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Erez Zadok" <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, cjwatson@ubuntu.com, linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0710140928470.23926@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710071920.l97JKJX5018871@agora.fsl.cs.sunysb.edu>
	 <20071011144740.136b31a8.akpm@linux-foundation.org>
	 <cfa94dc20710111512j9b6c038qf89c516ecd605411@mail.gmail.com>
	 <Pine.LNX.4.64.0710120129080.16588@blonde.wat.veritas.com>
	 <84144f020710121445p23fcc21am18482e01856cdc35@mail.gmail.com>
	 <Pine.LNX.4.64.0710140928470.23926@blonde.wat.veritas.com>
X-Google-Sender-Auth: d439828ac8cdb518
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

On Sat, 13 Oct 2007, Pekka Enberg wrote:
> Doesn't msync(2) get to it via mm/page-writeback.c:write_cache_pages()
> without unionfs even?

On 10/14/07, Hugh Dickins <hugh@veritas.com> wrote:
> I believe not.  Please do double-check my assertions, I've always found
> the _writepages paths rather twisty; but my belief (supported by the
> fact that we've not hit shmem_writepage's BUG_ON(page_mapped(page))
> in five years) is that tmpfs/shmem opts out of all of that with its
>         .capabilities   = BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_WRITEBACK,
> in shmem_backing_dev_info, which avoids all those _writepages avenues
> (e.g. through bdi_cap_writeback_dirty tests), and write_cache_pages is
> just a subfunction of the _writepages.

Thanks for the explanation, you're obviously correct.

However, I don't think the mapping_cap_writeback_dirty() check in
__filemap_fdatawrite_range() works as expected when tmpfs is a lower
mount for an unionfs mount. There's no BDI_CAP_NO_WRITEBACK capability
for unionfs mappings so do_fsync() will call write_cache_pages() that
unconditionally invokes shmem_writepage() via unionfs_writepage().
Unless, of course, there's some other unionfs magic I am missing.

                                   Pekka
