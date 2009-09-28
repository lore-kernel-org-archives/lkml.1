Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360AbZI1NIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbZI1NIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 09:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbZI1NIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 09:08:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56869 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZI1NIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 09:08:11 -0400
Date: Mon, 28 Sep 2009 09:08:04 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Chinner <david@fromorbit.com>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20090928130804.GA25880@infradead.org>
References: <20090923022622.GB11918@localhost> <20090922193622.42c00012.akpm@linux-foundation.org> <20090923140058.GA2794@think> <20090924031508.GD6456@localhost> <20090925001117.GA9464@discord.disaster> <20090925003820.GK2662@think> <20090925050413.GC9464@discord.disaster> <20090925064503.GA30450@localhost> <20090928010700.GE9464@discord.disaster> <20090928071507.GA20068@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090928071507.GA20068@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 03:15:07PM +0800, Wu Fengguang wrote:
> +		if (!PageActive(page))
> +			SetPageReclaim(page);
> +		err = mapping->a_ops->writepage(page, wbc);
> +		if (err < 0)
> +			handle_write_error(mapping, page, res);
> +		if (err == AOP_WRITEPAGE_ACTIVATE) {
> +			ClearPageReclaim(page);
> +			res = PAGE_ACTIVATE;
> +			break;
> +		}

This should help a bit for XFS as it historically does multi-page
writeouts from ->writepages (and apprently btrfs that added some
write-around recently?) but not those brave filesystems only
implementing the multi-page writeout from writepages as designed.

But really, the best would be to leave the writeout to the flusher
threads and just reclaim the clean pages from the VM.
