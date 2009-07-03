Return-Path: <linux-kernel-owner+w=401wt.eu-S1756947AbZGCKyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbZGCKyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbZGCKy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:54:29 -0400
Received: from brick.kernel.dk ([93.163.65.50]:41176 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbZGCKy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:54:28 -0400
Date: Fri, 3 Jul 2009 12:54:31 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Niel Lambrechts <niel.lambrechts@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCHSET] block: fix merge of requests with different
	failfast settings
Message-ID: <20090703105431.GN23611@kernel.dk>
References: <1246610898-22350-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246610898-22350-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03 2009, Tejun Heo wrote:
> Hello,
> 
> Block layer didn't consider failfast status while merging requests and
> it led to premature failure of normal (non-failfast) IOs.  Niel
> Lambrechts could trigger the problem semi-reliably on ext4 when
> resuming from STR.  ext4 uses readahead when reading inodes and
> combined with the deterministic extra SATA PHY exception cycle during
> resume on the specific configuration, non-readahead inode read would
> fail causing ext4 errors.  Please read the following thread for
> details.
> 
>   http://lkml.org/lkml/2009/5/23/21
> 
> This patchset contains the following four patches to fix the problem.
> 
>  0001-block-don-t-merge-requests-of-different-failfast-se.patch
>  0002-block-use-the-same-failfast-bits-for-bio-and-reques.patch
>  0003-block-implement-mixed-merge-of-different-failfast-r.patch
>  0004-scsi-block-update-SCSI-to-handle-mixed-merge-failur.patch
> 
> 0001 disallows merge between requests with different failfast
> settings.  This one is the quick fix and should go into 2.6.31 and
> later to -stable as the bug is pretty serious and may lead to data
> loss.
> 
> 0002 preps for later changes.
> 
> 0003-0004 implements and applies mixed merge.  Requests of different
> failfast settings are merged as before but failure handling is updated
> such that parts which shouldn't fail without retrial are properly
> retried.
> 
> I spent quite some time thinking about and testing it but I'd really
> like more pairs of eyes on this patchset as dangerous bugs can go
> unnoticed for quite a while in this area (anyone knows when the
> failfast bug was introduced?).

It must have been several releases ago. So while the bug is indeed very
nasty, I don't think there's been much fallout from it.

> Jens, I think the best way to merge this is to first push 0001 to
> Linus's tree and then pull it into for-next and then apply the rest on
> top of them.

Yeah I'll do that, #1 for 2.6.31 and the rest for .32. Thanks for
finding and fixing this bug!

-- 
Jens Axboe

