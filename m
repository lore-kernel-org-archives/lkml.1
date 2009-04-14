Return-Path: <linux-kernel-owner+w=401wt.eu-S1752222AbZDNKYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbZDNKYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 06:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbZDNKY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 06:24:27 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34351 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbZDNKY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 06:24:26 -0400
Message-ID: <49E46437.5000804@garzik.org>
Date: Tue, 14 Apr 2009 06:23:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Szabolcs Szakacsits <szaka@ntfs-3g.com>,
       Grant Grundler <grundler@google.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
References: <20090412091228.GA29937@elte.hu> <Pine.LNX.4.62.0904121806060.9521@tamago.serverit.net> <20090412162018.6c1507b4@lxorguk.ukuu.org.uk> <49E213AE.4060506@redhat.com> <alpine.LFD.2.00.0904120950050.4583@localhost.localdomain> <49E2DC96.6090407@redhat.com> <alpine.LFD.2.00.0904130747440.4583@localhost.localdomain> <49E45E9C.1020105@redhat.com>
In-Reply-To: <49E45E9C.1020105@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Well, no one is talking about 64KB granularity for in-core files.  Like 
> you noticed, Windows uses the mmu page size.  We could keep doing that, 
> and still have 16KB+ sector sizes.  It just means a RMW if you don't 
> happen to have the adjoining clean pages in cache.
> 
> Sure, on a rotating disk that's a disaster, but we're talking SSD here, 
> so while you're doubling your access time, you're doubling a fairly 
> small quantity.  The controller would do the same if it exposed smaller 
> sectors, so there's no huge loss.
> 
> We still lose on disk storage efficiency, but I'm guessing that a modern 
> tree with some object files with debug information and a .git directory 
> it won't be such a great hit.  For more mainstream uses, it would be 
> negligible.


Speaking of RMW...    in one sense, we have to deal with RMW anyway. 
Upcoming ATA hard drives will be configured with a normal 512b sector 
API interface, but underlying physical sector size is 1k or 4k.

The disk performs the RMW for us, but we must be aware of physical 
sector size in order to determine proper alignment of on-disk data, to 
minimize RMW cycles.

At the moment, it seems like most of the effort to get these ATA devices 
to perform efficiently is in getting partition / RAID stripe offsets set 
up properly.

So perhaps for NVMHCI we could
(a) hardcode NVM sector size maximum at 4k
(b) do RMW in the driver for sector size >4k, and
(c) export information indicating the true sector size, in a manner 
similar to how the ATA driver passes that info to userland partitioning 
tools.

	Jeff



