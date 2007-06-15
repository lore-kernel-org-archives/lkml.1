Return-Path: <linux-kernel-owner+w=401wt.eu-S1759433AbXFOV76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433AbXFOV76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbXFOV7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:59:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:52463 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685AbXFOV7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:59:46 -0400
From: Neil Brown <neilb@suse.de>
To: Avi Kivity <avi@argo.co.il>
Date: Sat, 16 Jun 2007 07:59:29 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18035.3009.568832.785308@notabene.brown>
Cc: david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: limits on raid
In-Reply-To: message from Avi Kivity on Friday June 15
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
	<18034.479.256870.600360@notabene.brown>
	<Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
	<18034.3676.477575.490448@notabene.brown>
	<467273AB.9010202@argo.co.il>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday June 15, avi@argo.co.il wrote:
> Neil Brown wrote:
> >   
> >> while I consider zfs to be ~80% hype, one advantage it could have (but I 
> >> don't know if it has) is that since the filesystem an raid are integrated 
> >> into one layer they can optimize the case where files are being written 
> >> onto unallocated space and instead of reading blocks from disk to 
> >> calculate the parity they could just put zeros in the unallocated space, 
> >> potentially speeding up the system by reducing the amount of disk I/O.
> >>     
> >
> > Certainly.  But the raid doesn't need to be tightly integrated
> > into the filesystem to achieve this.  The filesystem need only know
> > the geometry of the RAID and when it comes to write, it tries to write
> > full stripes at a time.  If that means writing some extra blocks full
> > of zeros, it can try to do that.  This would require a little bit
> > better communication between filesystem and raid, but not much.  If
> > anyone has a filesystem that they want to be able to talk to raid
> > better, they need only ask...
> >   
> 
> Some things are not achievable with block-level raid.  For example, with
> redundancy integrated into the filesystem, you can have three copies for
> metadata, two copies for small files, and parity blocks for large files,
> effectively using different raid levels for different types of data on
> the same filesystem.

Absolutely.  And doing that is a very good idea quite independent of
underlying RAID.  Even ext2 stores multiple copies of the superblock.

Having the filesystem duplicate data, store checksums, and be able to
find a different copy if the first one it chose was bad is very
sensible and cannot be done by just putting the filesystem on RAID.

Having the filesystem keep multiple copies of each data block so that
when one drive dies, another block is used does not excite me quite so
much.  If you are going to do that, then you want to be able to
reconstruct the data that should be on a failed drive onto a new
drive.
For a RAID system, that reconstruction can go at the full speed of the
drive subsystem - but needs to copy every block, whether used or not.
For in-filesystem duplication, it is easy to imagine that being quite
slow and complex.  It would depend a lot on how you arrange data,
and maybe there is some clever approach to data layout that I haven't
thought of.  But I think that sort of thing is much easier to do in a
RAID layer below the filesystem.

Combining these thoughts, it would make a lot of sense for the
filesystem to be able to say to the block device "That blocks looks
wrong - can you find me another copy to try?".  That is an example of
the sort of closer integration between filesystem and RAID that would
make sense.

NeilBrown
