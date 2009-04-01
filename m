Return-Path: <linux-kernel-owner+w=401wt.eu-S1764370AbZDAM34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764370AbZDAM34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 08:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761336AbZDAM3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 08:29:45 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34812 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757953AbZDAM3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 08:29:45 -0400
Date: Wed, 1 Apr 2009 14:29:42 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, bharrosh@panasas.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] block: fix SG_IO vector request data length
	handling
Message-ID: <20090401122942.GF5178@kernel.dk>
References: <1238583884-13517-3-git-send-email-tj@kernel.org> <20090401204716N.fujita.tomonori@lab.ntt.co.jp> <20090401115058.GD5178@kernel.dk> <20090401211851Y.fujita.tomonori@lab.ntt.co.jp> <49D35D9F.3000204@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D35D9F.3000204@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01 2009, Tejun Heo wrote:
> FUJITA Tomonori wrote:
> > On Wed, 1 Apr 2009 13:50:58 +0200
> > Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> >> On Wed, Apr 01 2009, FUJITA Tomonori wrote:
> >>> On Wed,  1 Apr 2009 20:04:38 +0900
> >>> Tejun Heo <tj@kernel.org> wrote:
> >>>
> >>>> Impact: fix SG_IO behavior such that it matches the documentation
> >>>>
> >>>> SG_IO howto says that if ->dxfer_len and sum of iovec disagress, the
> >>>> shorter one wins.  However, the current implementation returns -EINVAL
> >>>> for such cases.  Trim iovc if it's longer than ->dxfer_len.
> >>> Is that description about sg's SG_IO?
> 
> It looks like it's the closest thing.
> 
> >> The more important question is what sg.c actually does, that's more
> >> important than the documentation.
> 
> The current code would fail it with -EINVAL but after brief look into
> 2.6.12-rc2, it seems like it would use the shorter one.  On direct
> mapping path, it builds considering both lengths and on indirect path
> it doesn't seem to look at the iov supplied till the transfer is
> actually complete using the dxfer_len and then copy out whatever can
> be copied out.
> 
> > Do you think that Doug is a person who makes such mistake? ;)
> > 
> > Seems that sg worked as the howto says. But I think that I broke it
> > when I converted sg to use the block layer. I'll fix it soon.
> > 
> > About this patch, as we know, there are lots of subtle differences
> > between sg's SG_IO and the block's. I'm not sure that it's a good idea
> > to change the behavior of the block's SG_IO.
> 
> I think it's better to make the behavior more consistent.  Using
> shorter dxfer_len can be considered a feature too, so...

It's definitely a good feature, it's how you'd probe lots of scsi
command returns. Setting up the iovec once and passing first a smaller
than a larger dxfer_len would be a perfectly reasonable way to do that.

-- 
Jens Axboe

