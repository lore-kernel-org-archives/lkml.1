Return-Path: <linux-kernel-owner+w=401wt.eu-S1759894AbYCGPLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894AbYCGPLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 10:11:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754073AbYCGPKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 10:10:52 -0500
Received: from mo10.iij4u.or.jp ([210.138.174.78]:45564 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020AbYCGPKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 10:10:50 -0500
Date: Sat, 8 Mar 2008 00:07:24 +0900
To: htejun@gmail.com
Cc: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp,
       James.Bottomley@HansenPartnership.com, bharrosh@panasas.com,
       efault@gmx.de, tomof@acm.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com
Subject: Re: [PATCH] blk: missing add of padded bytes to io completion byte
   count
From: FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <47D0873B.6090705@gmail.com>
References: <20080306134146A.fujita.tomonori@lab.ntt.co.jp>
	<20080306134138.GF17940@kernel.dk>
	<47D0873B.6090705@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080308000718H.tomof@acm.org>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Mar 2008 09:07:23 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Jens Axboe wrote:
> >>> If we want the use paradigm shared between block and driver, then I
> >>> think the best approach is to keep all the bios the same (so not adjust
> >>> for padding), but do adjust in the blk_rq_map_sg().  That way we have
> >>> the padding and draining unwind information by comparing with the bio.
> >> Adjusting only sg in blk_rq_map_sg (like drain) looks much
> >> better. This works with libata for me.
> > 
> > Looks like a much better solution to me. Anyone have any valid
> > objections against moving the padding to the sg map time?
> 
> Not necessarily objections but some concerns.
> 
> * As completion is done in bio terms, it makes completion from LLDs a
> bit cumbersome, but this is unavoidable if we break sum(bio) == sum(sg).

What do you mean? How does sub(bio) affect LLDs?


> * I've been wondering why we are not using sg chain / table or whatever
> directly in bios and maybe rq_map_sg can go away in future.

You mean that LLDs use bios directly? For me, sg and bio have very
different objectives and it's a clean layer separation.


> How about separating out the padding / draining adjustment into a
> separate interface?  Say, blk_rq_apply_extra() and blk_rq_undo_extra()
> and make it the responsibility of the LLD which requested
> padding/draining to apply and undo the adjustments?  It can undo the
> adjustments when it returns the the request to its upper layer.  If rq
> completion is handled by upper layer, it will do the right thing.  If rq
> completion is handled by LLD, it can see the bio it wants to see.

If possible, I'd like to avoid creating APIs for them. I think that
the current approach is much better than such APIs.
