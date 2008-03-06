Return-Path: <linux-kernel-owner+w=401wt.eu-S1761264AbYCFFD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761264AbYCFFD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 00:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759014AbYCFFDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 00:03:43 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:58061 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbYCFFDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 00:03:41 -0500
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, htejun@gmail.com, efault@gmx.de,
       jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com,
       tomof@acm.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com, bzolnier@gmail.com
Subject: Re: [PATCH] blk: missing add of padded bytes to io completion byte
 count
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <47CE72EF.7050302@panasas.com>
References: <47CDDC31.4070806@gmail.com>
	<20080305092619Y.fujita.tomonori@lab.ntt.co.jp>
	<47CE72EF.7050302@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080306140233W.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 06 Mar 2008 14:02:33 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2008 12:16:15 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On Wed, Mar 05 2008 at 2:26 +0200, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > On Wed, 05 Mar 2008 08:33:05 +0900
> > Tejun Heo <htejun@gmail.com> wrote:
> > 
> >> FUJITA Tomonori wrote:
> >>> Hmm, does SCSI mid-layer need to care about how many bytes the block
> >>> layer allocates? I don't think that extra_len is NOT good_bytes.
> >>>
> >>> I think that the block layer had better take care about it (fix
> >>> __end_that_request_first?).
> >> Yeah, probably calling completion functions w/o bytes count is the right
> >> thing to do but what I was talking about was what could break when the
> >> semantics of rq->data_len changed.  If we keep rq->data_len() ==
> >> sum(sg), we keep it business as usual for all the rest except for the
> >> device application layer if we don't we do the reverse and SCSI midlayer
> >> completion was a good example, I think.
> > 
> > sglist is a low-level I/O representation for device drivers. SCSI
> > midlayer should not care about sglist. We should not fix SCSI midlayer
> > for rq->data_len != sum(sg) change (so I can't agree with your
> > diagrams in another mail).
> > 
> > When if we change a rule, we need to fix something.
> > 
> > If we keep rq->data_len == sum(sg), we need to fix the device
> > application layer. If we keep rq->data_len == the true data length, we
> > need to fix the low-level drivers.
> > 
> > Now I'm fine with the commit e97a294ef6938512b655b1abf17656cf2b26f709
> > since we are in -rc stages. But I plan to send a patch to revert it
> > and fix this issue in the block layer. I'd like to test it in -mm for
> > a while.
> 
> No this commit is a serious bug, and the only fix is like you suggested
> in __end_that_request_first. This is because it breaks that scsi-ml loop
> where scsi_bufflen() can be less then blk_rq_bytes(). In that case this 
> commit is a data corruption.

Ah, I knew that the patch doesn't work with partial completion but I
thought that it doesn't happen with PC commands... And touching
__end_that_request_first looked really hacky so I didn't send such
patch.

Moving the padding adjustment to blk_rq_map_sg (James' proposal) looks
fine. Maybe Jens will come up with something better.
