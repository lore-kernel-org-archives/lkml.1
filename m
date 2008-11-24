Return-Path: <linux-kernel-owner+w=401wt.eu-S1752948AbYKXJFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbYKXJFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 04:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYKXJE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 04:04:28 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35932 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbYKXJEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 04:04:24 -0500
Subject: Re: about TRIM/DISCARD support and barriers
From: David Woodhouse <dwmw2@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Tejun Heo <teheo@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Dongjun Shin <djshin90@gmail.com>,
       chris.mason@oracle.com
In-Reply-To: <1227480776.25499.3.camel@localhost.localdomain>
References: <4928E010.4090801@kernel.org> <4929023C.2060302@suse.de>
	 <20081123123514.GI5707@parisc-linux.org>
	 <1227447584.4901.405.camel@macbook.infradead.org>
	 <1227480776.25499.3.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 09:03:50 +0000
Message-Id: <1227517430.26957.20.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-24 at 07:52 +0900, James Bottomley wrote:
> On Sun, 2008-11-23 at 13:39 +0000, David Woodhouse wrote:
> > > We don't attempt to put non-contiguous ranges into a single TRIM yet.
> > 
> > We don't even merge contiguous ranges -- I still need to fix the
> > elevators to stop writes crossing writes,
> 
> I don't think we want to do that ... it's legal if the write isn't a
> barrier and it will inhibit merging.  That may be just fine for a SSD,
> but it's not for spinning media since they get better performance out of
> merged writes.

No, I just mean writes _to the same sector_. At the moment, we happily
let those cross each other in the queue.

We do notice this situation and preserve the ordering if the two
requests cover _precisely_ the same range, but _overlapping_ writes may
happen in any order.

We should fix that, and it's only for _that_ purpose that I'm saying we
treat writes and discards as identical. And then we can drop the barrier
flag on discards.

And _then_ we can think about special cases which let us merge
non-contiguous discards.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

