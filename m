Return-Path: <linux-kernel-owner+w=401wt.eu-S1760728AbXGKHct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760728AbXGKHct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 03:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756768AbXGKHcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 03:32:43 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:25339 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247AbXGKHcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 03:32:42 -0400
Date: Wed, 11 Jul 2007 10:32:16 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Neil Horman <nhorman@redhat.com>,
       "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070711073216.GA11757@localdomain>
References: <20070706132814.GA7079@suse.de> <20070706145804.GA31409@localdomain> <20070710064817.GC5471@in.ibm.com> <20070710120904.GB10121@hmsendeavour.rdu.redhat.com> <20070710165201.GA7984@localdomain> <20070711060726.GA5310@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711060726.GA5310@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 11:37:26AM +0530, Vivek Goyal wrote:
> On Tue, Jul 10, 2007 at 07:52:01PM +0300, Dan Aloni wrote:
> > On Tue, Jul 10, 2007 at 08:09:04AM -0400, Neil Horman wrote:
> > > On Tue, Jul 10, 2007 at 12:18:17PM +0530, Vivek Goyal wrote:
> > > > On Fri, Jul 06, 2007 at 05:58:04PM +0300, Dan Aloni wrote:
> > > > > On Fri, Jul 06, 2007 at 03:28:14PM +0200, Bernhard Walle wrote:
> > > > > > Hello,
> > [...]
> > > > > It contains enough information in order to make a compact kernel
> > > > > dump (makedumpinfo needs to go over the struct page arrays). As
> > > > > you see, it also contains the kernel version.
> > > > > 
> > > > 
> > > > But this will not solve Bernhard's problem where looking at a vmcore
> > > > he wants to know which vmlinux (kernel version with time stamp) has
> > > > generated this vmcore. So adding a ELF NOTE should help.
> > > > 
> > > I think an ELF note would be a fine idea.
> > 
> > Okay, so here's an implemenation.
> > 
> > See the attached proof-of-concept patches to the kernel-side kexec and 
> > kexec-tools (might need some cleanup though). Next to follow, a patch 
> > to makedumpfile. With these patches a new "LINUX" elf note generated 
> > by the kernel in the format that makedumpfile expects and is being 
> > passed on by the kexec util to the kdump kernel.
> > 
> > As a bonus, with this patch you don't even have to compile the kernel 
> > with debug information in order for the filtering to work.
> > 
> 
> This implementation looks interesting. No need of debug compiled
> vmlinux for dump filtering purposes. No run time vmlinux binary modifications
> as suggested by your previous mails. People can export kernel CONFIG info
> like PAGESIZE etc with the help of this ELF note and any tool which is
> processing kernel core file can benifit from this. No guesses required for
> determining the page size of crashed kernel.
> 
> All the info required by dump filtering tool, put it into an ELF note, 
> pass it to second kernel which appends it to final vmcore. The only concern
> here again is that type of ELF note is not standard. The contents of 
> ELF notes will keep on changing over a period of time. For example if a 
> new memory model evolves. Now everytime this note data changes one shall
> have to update mkdumpfile and user shall have to newer version. If there
> are any issues, user will not come to know about the issue during kdump
> service enablement time, instead it will be detected during dump 
> capture time. It is too late till then.

I guess that dump filtering will needed to be tested at least once 
under various platforms for every major release of the kernel to see 
if the information exported by the kernel through this elf note is 
still sufficient. 

Adding more info to this elf note as needed can be done through a simple 
patch to the kernel and it can be tested along with mkdumpfile changes 
even before a major version gets released.

More things to consider:

 * Elf note size is currently limited to 1024, we might need a bit more
   (currently this elf note is in the 900-area).
 * If we move the generation of the elf note to the boot time instead 
   of crash time as you suggested, we can also make it viewable as a 
   virtual file.
 * We should come up with a standard name for the note (LINUX, or 
   LINUX-VMCORE, etc).
 
> I think we can make OSRELEASE info into a separate ELF note. Something
> like a note type "UTS_RELEASE". This ELF note type then can also be 
> reused for appending an ELF note to vmlinux to determine the kernel
> version.

Agreed.

Actually, having a UTS_RELEASE note attached to vmlinux itself is quite 
easy to implement. All we need is some .s file in the kernel doing 
something similar to this (inspired by some post made by Ulrich Drepper):

#include <linux/utsrelease.h>

	.section ".note.UTS_RELEASE", "a"
	.align 4
	.long 1f - 0f		/* name length */
	.long 3f - 2f		/* data length */
	.long  1		/* note type */
0:	.asciz "UTS_RELEASE"	/* uts release */
1:	.align 4	
2:	.asciz UTS_RELEASE     	/* note data */
3:	.align 4		/* pad out section */

> We don't have to save this info in ELF note format after the crash. This
> info gets fixed once kernel is booted. I think we should save it in some
> init routine and not in crash_kexec().

Agreed.
 
> > +extern unsigned char mkdfinfo_data[MAX_NOTE_BYTES];
> > +extern unsigned int mkdfinfo_size;
> > +extern unsigned int mkdfinfo_max_size;
> > +extern note_buf_t mkdfinfo_note;
> 
> mkdfinfo does not seem to be very appropriate name. We probably need to have a
> better name. This all seems to be debug data (symbol info, structure size,
> offsets of struct members) so how about "debuginfo"?

'debuginfo' can be confused with the more standard DWARF debuginfo. 
How about vmcoreinfo, dumpinfo, debugaux, debugauxinfo, or 
dumpauxinfo?

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
