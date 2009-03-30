Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbZC3Rsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbZC3Rsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbZC3Rsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:48:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752165AbZC3Rsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:48:38 -0400
Date: Mon, 30 Mar 2009 10:34:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: =?ISO-8859-15?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>
cc: Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
In-Reply-To: <49D0B687.1030407@oss.ntt.co.jp>
Message-ID: <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain>
References: <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org>
 <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain> <20090325212923.GA5620@havoc.gtf.org> <20090326032445.GA16999@havoc.gtf.org> <20090327205046.GA2036@havoc.gtf.org> <20090329082507.GA4242@infradead.org> <49D01F94.6000101@oss.ntt.co.jp>
 <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Mar 2009, Fernando Luis Vázquez Cao wrote:
> +	int ret = 0;
> +
> +	ret = blkdev_issue_flush(bdev, NULL);
> +
> +	return (ret == -EOPNOTSUPP) ? 0 : ret;

Btw, why do we do that silly EOPNOTSUPP at all?

If the device doesn't support flushing, we should

 - set a flag in the device saying so, and not ever try to flush again on 
   that device (who knows how long it took for the device to say "I can't 
   do this"? We don't want to keep on doing it)

 - return "done". There's nothing sane the caller can do with the error 
   code anyway, it just has to assume that the device basically doesn't 
   reorder writes.

So wouldn't it be better to just fix blkdev_issue_flush() to not do those 
crazy error codes?

[ The same thing probably goes for those ENXIO errors, btw. If we don't 
  have a bd_disk or a queue, why would the caller care about it? ]

Jens?

			Linus
