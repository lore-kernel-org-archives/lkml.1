Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbYILNcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbYILNcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 09:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbYILNcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 09:32:41 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:35238 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYILNcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 09:32:41 -0400
Subject: Re: kernel BUG at drivers/pci/intel-iommu.c:1373!
From: Chris Mason <chris.mason@oracle.com>
To: mgross@linux.intel.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20080909161903.GA14986@linux.intel.com>
References: <1220883964.8537.27.camel@think.oraclecorp.com>
	 <20080909161903.GA14986@linux.intel.com>
Content-Type: text/plain
Date: Fri, 12 Sep 2008 09:32:30 -0400
Message-Id: <1221226350.28506.0.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-09 at 09:19 -0700, mark gross wrote:
> On Mon, Sep 08, 2008 at 10:26:04AM -0400, Chris Mason wrote:
> > Hello everyone,
> > 
> > I originally hit this with btrfs and assumed I was doing something
> > wrong, but it looks like it is a generic problem.  The stack trace at
> > the bottom of this email came from the following setup:
> > 
> > mdadm --create /dev/md0 --level=1 --raid-devices=4 --assume-clean /dev/sd[cdef]
> > mkfs.ext4dev /dev/md0 50000000
> > mount /dev/md0 /mnt
> > synctest -t 100 -F -f -u /mnt
> > 
> > synctest is an old benchmark from akpm that I dug up to test the btrfs
> > fsync code.  google doesn't seem to know much about it anymore, so I've
> > tossed it up here:
> > 
> > http://oss.oracle.com/~mason/synctest/synctest.c
> > 
> > The important part is that I have a software raid1 volume with 4 drives
> > and that I'm hammering on it has hard as I can with synchronous writes
> > from 100 procs.
> > 
> > MD uses bio_clone to make copies of bios for each device in the mirror
> > set.  So, using 4 devices means each bio is cloned 3 times, greatly
> > increases the chances that I'll send down the same page in different
> > bios to different devices.
> > 
> > Ext4 needs about 10 minutes to trigger on top of MD.  Btrfs needs about
> > 30 seconds when it controls the 4 devices itself.
> > 
> > I've been told this BUG in the io-mmu code comes when someone tries to
> > map a page into the iommu that has already been mapped.  It seems like
> > that is a natural result of bio_clone, and not an inherent race in the
> > code.  But, I've just said everything I know about the iommu code, so my
> > guesses don't mean much.
> 
> I have a bad feeling about this.  Can you retest booting with a kernel
> parrameter "intel_iommu=strict"?

Sorry, I'm going to have to try this again after the plumber's conf.

-chris


