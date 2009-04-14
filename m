Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbZDNKly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbZDNKly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 06:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbZDNKln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 06:41:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57158 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbZDNKlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 06:41:42 -0400
Message-ID: <49E46779.1040106@redhat.com>
Date: Tue, 14 Apr 2009 13:37:45 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Szabolcs Szakacsits <szaka@ntfs-3g.com>,
       Grant Grundler <grundler@google.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
References: <20090412091228.GA29937@elte.hu> <Pine.LNX.4.62.0904121806060.9521@tamago.serverit.net> <20090412162018.6c1507b4@lxorguk.ukuu.org.uk> <49E213AE.4060506@redhat.com> <alpine.LFD.2.00.0904120950050.4583@localhost.localdomain> <49E2DC96.6090407@redhat.com> <alpine.LFD.2.00.0904130747440.4583@localhost.localdomain> <49E45E9C.1020105@redhat.com> <49E46437.5000804@garzik.org>
In-Reply-To: <49E46437.5000804@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Speaking of RMW...    in one sense, we have to deal with RMW anyway. 
> Upcoming ATA hard drives will be configured with a normal 512b sector 
> API interface, but underlying physical sector size is 1k or 4k.
>
> The disk performs the RMW for us, but we must be aware of physical 
> sector size in order to determine proper alignment of on-disk data, to 
> minimize RMW cycles.
>

Virtualization has the same issue.  OS installers will typically setup 
the first partition at sector 63, and that means every page-sized block 
access will be misaligned.  Particularly bad when the guest's disk is 
backed on a regular file.

Windows 2008 aligns partitions on a 1MB boundary, IIRC.

> At the moment, it seems like most of the effort to get these ATA 
> devices to perform efficiently is in getting partition / RAID stripe 
> offsets set up properly.
>
> So perhaps for NVMHCI we could
> (a) hardcode NVM sector size maximum at 4k
> (b) do RMW in the driver for sector size >4k, and

Why not do it in the block layer?  That way it isn't limited to one driver.

> (c) export information indicating the true sector size, in a manner 
> similar to how the ATA driver passes that info to userland 
> partitioning tools.

Eventually we'll want to allow filesystems to make use of the native 
sector size.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

