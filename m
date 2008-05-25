Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbYEYXf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbYEYXf2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 19:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbYEYXfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 19:35:15 -0400
Received: from ns2.suse.de ([195.135.220.15]:47174 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbYEYXfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 19:35:14 -0400
From: Neil Brown <neilb@suse.de>
To: Adrian Bunk <bunk@kernel.org>
Date: Mon, 26 May 2008 09:35:04 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18489.63400.560248.222094@notabene.brown>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, kernel-testers@vger.kernel.org,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: x86_64 panic on latest linux-2.6
In-Reply-To: message from Adrian Bunk on Sunday May 25
References: <200805251051.33781.m.kozlowski@tuxland.pl>
	<20080525204229.GL1791@cs181133002.pp.htv.fi>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday May 25, bunk@kernel.org wrote:
> On Sun, May 25, 2008 at 10:51:33AM +0200, Mariusz Kozlowski wrote:
> > Hello,
> 
> Hi Mariusz,
> 
> > 	My x86_64 box is not willing to boot.
> > 
> > http://tuxland.pl/tmp/s7300372.jpg (275kB)
> > 
> > (gdb) p blk_lookup_devt
> > $1 = {dev_t (const char *, int)} 0xffffffff8032a430 <blk_lookup_devt>
> > (gdb) l *(0xffffffff8032a430+0x7f)
> > 0xffffffff8032a4af is in blk_lookup_devt (block/genhd.c:664).
> > 659             dev_t devt = MKDEV(0, 0);
> > 660     
> > 661             mutex_lock(&block_class_lock);
> > 662             list_for_each_entry(dev, &block_class.devices, node) {
> > 663                     if (strcmp(dev->bus_id, name) == 0) {
> > 664                             struct gendisk *disk = dev_to_disk(dev);
> > 665     
> > 666                             if (part < disk->minors)
> > 667                                     devt = MKDEV(MAJOR(dev->devt),
> > 668                                                  MINOR(dev->devt) + part);

Having decoded the "Code:", what is happening here is that 'dev' is
clearly not embedded inside a 'disk'.
The address of 'dev' is in RBX and is ffff81007f270010.
disk->minors is at and offset of -0x60 from 'dev' (as 'dev' is assumed
to be a structure embeded in a 'struct gendisk' - dev_to_disk uses
container_of to find the gendisk that holds the device).  But 0x60 from RBX
is in a different page, and presumably that memory doesn't exist.

So the question is: how can a 'struct device' which is not part of
a 'struct gendisk' be on 'block_class.devices'.

Unfortunately, I have no idea.

NeilBrown
