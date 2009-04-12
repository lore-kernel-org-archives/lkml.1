Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbZDLR0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbZDLR0m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 13:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZDLR0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 13:26:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753210AbZDLR0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 13:26:04 -0400
Date: Sun, 12 Apr 2009 10:20:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Robert Hancock <hancockrwd@gmail.com>
cc: Szabolcs Szakacsits <szaka@ntfs-3g.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Grant Grundler <grundler@google.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
In-Reply-To: <49E21E8A.2040005@gmail.com>
Message-ID: <alpine.LFD.2.00.0904121012500.4583@localhost.localdomain>
References: <20090412091228.GA29937@elte.hu> <Pine.LNX.4.62.0904121806060.9521@tamago.serverit.net> <alpine.LFD.2.00.0904120820410.4583@localhost.localdomain> <49E21E8A.2040005@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 12 Apr 2009, Robert Hancock wrote:
>
> What about FAT? It supports cluster sizes up to 32K at least (possibly up to
> 256K as well, although somewhat nonstandard), and that works.. We support that
> in Linux, don't we?

Sure. 

The thing is, "cluster size" in an FS is totally different from sector 
size.

People are missing the point here. You can trivially implement bigger 
cluster sizes by just writing multiple sectors. In fact, even just a 4kB 
cluster size is actually writing 8 512-byte hardware sectors on all normal 
disks.

So you can support big clusters without having big sectors. A 32kB cluster 
size in FAT is absolutely trivial to do: it's really purely an allocation 
size. So a fat filesystem allocates disk-space in 32kB chunks, but then 
when you actually do IO to it, you can still write things 4kB at a time 
(or smaller), because once the allocation has been made, you still treat 
the disk as a series of smaller blocks.

IOW, when you allocate a new 32kB cluster, you will have to allocate 8 
pages to do IO on it (since you'll have to initialize the diskspace), but 
you can still literally treat those pages as _individual_ pages, and you 
can write them out in any order, and you can free them (and then look them 
up) one at a time.

Notice? The cluster size really only ends up being a disk-space allocation 
issue, not an issue for actually caching the end result or for the actual 
size of the IO.

The hardware sector size is very different. If you have a 32kB hardware 
sector size, that implies that _all_ IO has to be done with that 
granularity. Now you can no longer treat the eight pages as individual 
pages - you _have_ to write them out and read them in as one entity. If 
you dirty one page, you effectively dirty them all. You can not drop and 
re-allocate pages one at a time any more.

				Linus
