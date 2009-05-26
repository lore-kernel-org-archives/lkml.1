Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbZEZGYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbZEZGYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 02:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbZEZGY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 02:24:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52041 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674AbZEZGY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 02:24:29 -0400
Date: Tue, 26 May 2009 09:22:35 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Kay Sievers <kay.sievers@vrfy.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: 2.a.30-rc7: fat filesystem misdetected as amiga
Message-ID: <20090526062235.GG6856@redhat.com>
References: <20090525205353.GB6856@redhat.com> <Pine.LNX.4.44L0.0905251704490.27717-100000@netrider.rowland.org> <20090525214755.GE6856@redhat.com> <20090525223120.GC11648@ub>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525223120.GC11648@ub>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 12:31:20AM +0200, Andries E. Brouwer wrote:
> On Tue, May 26, 2009 at 12:47:55AM +0300, Michael S. Tsirkin wrote:
> > On Mon, May 25, 2009 at 05:08:12PM -0400, Alan Stern wrote:
> >> On Mon, 25 May 2009, Michael S. Tsirkin wrote:
> >> 
> >>>> So apparently this is a bug in the device; it doesn't respond correctly
> >>>> to the first READ command.  But since it does respond correctly to 
> >>>> later commands, everything works okay thereafter.  You ought to be able 
> >>>> to recover from the error by running
> >>>> 
> >>>> 	blockdev --rereadpt /dev/sdb
> >>>> 
> >>>> manually.
> >>> 
> >>> Yes, this helps.
> >>> Would it make sense for kernel to retry automatically?
> >>> Why doesn't it?
> >> 
> >> I don't know the details in this case.  Most likely the error code 
> >> (Logical Block Address Out of Range) is interpreted as a fatal 
> >> non-retryable error.  For other sorts of errors, the kernel does retry.
> >> 
> >>>> As far as I can tell, this has nothing to do with any user programs in 
> >>>> the distribution.  It appears to be entirely the device's fault.
> >>>> 
> >>>> Alan Stern
> >>> 
> >>> BTW, any idea how come I later get errors apparently from amiga fs?
> >> 
> >> Not a clue.  Unless it was some odd side effect of the partition code 
> >> trying to interpret an uninitialized buffer.
> >> 
> >> Alan Stern
> 
> Comments:
> 
> The partition reading code tries one by one all partition types that
> you have configured. If amigafs is one of these, also that will be tried.
> 
> I can imagine that your device is a slow starter and needs some time
> to initialize itself, so that the first, or the first few, commands fail,
> and after that all is well.
> 
> I hate retrying code. Such code is the reason that boot time increases
> all the time. Usually a read failure is missing media or so, and retrying
> is totally meaningless. Only at the lowest level should a retry be done,
> and preferably not blindly "let us try a few times" but only when there
> is a positive reason to expect that a second time might fare better.

Yea. But I don't know where that is.
I noted that if I stick a loop around check_partition
I just get the error reported each time.


> (Amiga is not usually the first or second to be tried, so if it fails
> then either the first few reads fail, or the first read failure is cached.)

Maybe it shouldn't printk stuff on IO failure when probing for
partitions then.

> Andries
> 
> 
> > So, the following works for me as a work-around.  But it's probably not
> > the appropriate way to solve the problem. Or is it? Can someone who
> > understands partitions and filesystems tell?
> > 
> > 
> > 
> > block: retry on I/O error when reading partition table
> > 
> > Retry once on an I/O error when reading the partition table:
> > there's no much to loose, and this helps with some disk on
> > key devices I have.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

-- 
MST
