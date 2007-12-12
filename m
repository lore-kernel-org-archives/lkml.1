Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbXLLMyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbXLLMyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 07:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbXLLMxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 07:53:50 -0500
Received: from adsl-76-243-235-52.dsl.chcgil.sbcglobal.net ([76.243.235.52]:58883
	"EHLO accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779AbXLLMxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 07:53:49 -0500
Subject: Re: [PATCH 01/30] blk_end_request: add new request completion
	interface (take 4)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com
In-Reply-To: <20071211.174030.10291764.k-ueda@ct.jp.nec.com>
References: <20071211.174030.10291764.k-ueda@ct.jp.nec.com>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 07:53:36 -0500
Message-Id: <1197464017.4203.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-12-11 at 17:40 -0500, Kiyoshi Ueda wrote:
> This patch adds 2 new interfaces for request completion:
>   o blk_end_request()   : called without queue lock
>   o __blk_end_request() : called with queue lock held
> 
> blk_end_request takes 'error' as an argument instead of 'uptodate',
> which current end_that_request_* take.
> The meanings of values are below and the value is used when bio is
> completed.
>     0 : success
>   < 0 : error
> 
> Some device drivers call some generic functions below between
> end_that_request_{first/chunk} and end_that_request_last().
>   o add_disk_randomness()
>   o blk_queue_end_tag()
>   o blkdev_dequeue_request()

If we can roll the whole thing together, that would be nice.  However,
the way you're doing it with this patch, we now have an asymmetrical
interface:  The request routine must explicitly start the tag, but now
doesn't have to end it.

We really need symmetry.  Either go back to start tag/end tag, or absorb
the whole lot into the block infrastructure.

The original reason for the explicit start/end is that there are some
requests on a tagged device that aren't able to be tagged by the block
layer (some devices reserve tag numbers for specific meanings).
However, I don't think there's any driver that actually implemented this
feature.

James


