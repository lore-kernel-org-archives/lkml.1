Return-Path: <linux-kernel-owner+w=401wt.eu-S1762329AbXGMDoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762329AbXGMDoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 23:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757451AbXGMDoC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 23:44:02 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:42119 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbXGMDoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 23:44:00 -0400
Date: Fri, 13 Jul 2007 09:13:58 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Dan Aloni <da-x@monatomic.org>
Cc: Neil Horman <nhorman@redhat.com>,
       "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070713034358.GA4975@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070706132814.GA7079@suse.de> <20070706145804.GA31409@localdomain> <20070710064817.GC5471@in.ibm.com> <20070710120904.GB10121@hmsendeavour.rdu.redhat.com> <20070710165201.GA7984@localdomain> <20070711060726.GA5310@in.ibm.com> <20070711073216.GA11757@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711073216.GA11757@localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 10:32:16AM +0300, Dan Aloni wrote:
[..]
> > This implementation looks interesting. No need of debug compiled
> > vmlinux for dump filtering purposes. No run time vmlinux binary modifications
> > as suggested by your previous mails. People can export kernel CONFIG info
> > like PAGESIZE etc with the help of this ELF note and any tool which is
> > processing kernel core file can benifit from this. No guesses required for
> > determining the page size of crashed kernel.
> > 
> > All the info required by dump filtering tool, put it into an ELF note, 
> > pass it to second kernel which appends it to final vmcore. The only concern
> > here again is that type of ELF note is not standard. The contents of 
> > ELF notes will keep on changing over a period of time. For example if a 
> > new memory model evolves. Now everytime this note data changes one shall
> > have to update mkdumpfile and user shall have to newer version. If there
> > are any issues, user will not come to know about the issue during kdump
> > service enablement time, instead it will be detected during dump 
> > capture time. It is too late till then.
> 
> I guess that dump filtering will needed to be tested at least once 
> under various platforms for every major release of the kernel to see 
> if the information exported by the kernel through this elf note is 
> still sufficient. 
> 
> Adding more info to this elf note as needed can be done through a simple 
> patch to the kernel and it can be tested along with mkdumpfile changes 
> even before a major version gets released.
> 
> More things to consider:
> 
>  * Elf note size is currently limited to 1024, we might need a bit more
>    (currently this elf note is in the 900-area).

How about putting all the required info in a structure and then do
sizeof(struct) and reserve that much of memory at compile time for the
note. This will mean there are no hardcodings about the size of the note.

But I guess, one shall have to keep user space kexec-tools in sync to
create a PT_NOTE for that. May be exporting this info in header files to
user space might help.

>  * If we move the generation of the elf note to the boot time instead 
>    of crash time as you suggested, we can also make it viewable as a 
>    virtual file.

That would make sense. In that case, makedumpfile can do some verification
on the exported data and scream if something is not right at kdump service
start time.

>  * We should come up with a standard name for the note (LINUX, or 
>    LINUX-VMCORE, etc).
> 

How about VMCOREINFO?

> > I think we can make OSRELEASE info into a separate ELF note. Something
> > like a note type "UTS_RELEASE". This ELF note type then can also be 
> > reused for appending an ELF note to vmlinux to determine the kernel
> > version.
> 
> Agreed.
> 
> Actually, having a UTS_RELEASE note attached to vmlinux itself is quite 
> easy to implement. All we need is some .s file in the kernel doing 
> something similar to this (inspired by some post made by Ulrich Drepper):
> 
> #include <linux/utsrelease.h>
> 
> 	.section ".note.UTS_RELEASE", "a"
> 	.align 4
> 	.long 1f - 0f		/* name length */
> 	.long 3f - 2f		/* data length */
> 	.long  1		/* note type */
> 0:	.asciz "UTS_RELEASE"	/* uts release */
> 1:	.align 4	
> 2:	.asciz UTS_RELEASE     	/* note data */
> 3:	.align 4		/* pad out section */
> 
> > We don't have to save this info in ELF note format after the crash. This
> > info gets fixed once kernel is booted. I think we should save it in some
> > init routine and not in crash_kexec().
> 
> Agreed.
> 
> > > +extern unsigned char mkdfinfo_data[MAX_NOTE_BYTES];
> > > +extern unsigned int mkdfinfo_size;
> > > +extern unsigned int mkdfinfo_max_size;
> > > +extern note_buf_t mkdfinfo_note;
> > 
> > mkdfinfo does not seem to be very appropriate name. We probably need to have a
> > better name. This all seems to be debug data (symbol info, structure size,
> > offsets of struct members) so how about "debuginfo"?
> 
> 'debuginfo' can be confused with the more standard DWARF debuginfo. 
> How about vmcoreinfo, dumpinfo, debugaux, debugauxinfo, or 
> dumpauxinfo?
> 

To me vmcoreinfo looks like a good name to begin with. As of today vmcore
is the only consumer of the info. We might have to migrate to a more generic
name down the line if consumers of the info pop-up.

Thanks
Vivek
