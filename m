Return-Path: <linux-kernel-owner+w=401wt.eu-S1753674AbYCLSzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbYCLSzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 14:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbYCLSzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 14:55:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbYCLSzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 14:55:37 -0400
Date: Wed, 12 Mar 2008 14:53:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm] kexec jump -v9
Message-ID: <20080312185356.GD13549@redhat.com>
References: <1204773188.4707.109.camel@caritas-dev.intel.com> <20080311211004.GA30164@redhat.com> <1205272758.7990.37.camel@nigel-laptop> <1205288074.29875.22.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205288074.29875.22.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 10:14:34AM +0800, Huang, Ying wrote:
> On Wed, 2008-03-12 at 08:59 +1100, Nigel Cunningham wrote:
> > Hi all.
> > 
> > I hope kexec turns out to be a good, usable solution. Unfortunately,
> > however, I still have some areas where I'm not convinced that kexec is
> > going to work or work well:
> > 
> > 1. Reliability.
> > 
> > It's being sold as a replacement for freezing processes, yet AFAICS it's
> > still going to require the freezer in order to be reliable. In the
> > normal case, there isn't much of an issue with freeing memory or
> > allocating swap, and so these steps can be expected to progress without
> > pain. Imagine, however, the situation where another process or processes
> > are trying to allocate large amounts of memory at the same time, or the
> > system is swapping heavily. Although such situations will not be common,
> > they are entirely conceivable, and any implementation ought to be able
> > to handle such a situation efficiently. If the freezer is removed, any
> > hibernation implementation - not just kexec - is going to have a much
> > harder job of being reliable in all circumstances. AFAICS, the only way
> > a kexec based solution is going to be able to get around this will be to
> > not have to allocate memory, but that will require permanent allocation
> > of memory for the kexec kernel and it's work area as well as the
> > permanent, exclusive allocation of storage for the kexec hibernation
> > implementation that's currently in place (making the LCA complaint about
> > not being able to hibernate to swap on NTFS on fuse equally relevant).
> 
> As Eric said kexec need only to allocate memory during loading, not
> executing.

Yes. But this memory gets reserved at loading time and then this memory
remains unused for the whole duration (except hibernation).

In the example you gave, looks like you are reserving 15MB of memory for
second kernel. In practice, we we finding it difficult to boot a regular
kernel in 16MB of memory in kdump. We are now reserving 128MB of memory
for kdump kernel on x86 arch, otheriwse OOM kill kicks in during init
or while core is being copied.

Kexec based hibernation does not look any different than kdump in terms
of memory requirements. The only difference seems to be that kdump does
the contiguous memory reservation at boot time and kexec based hibernation
does the memory reservation at kernel loading time.

The only difference I can think of is, kdump will generally run on servers
and hibernation will be required on desktops/laptops and run time memory
requirements might be little different. I don't have numbers though.

At the same time carrying a separate kernel binary just for hibernation
purposes does not sound very good.
  
[..]
> > 3. Usability.
> > 
> > Right now, kexec based hibernation looks quite complicated to configure,
> > and the user is apparently going to have to remember to boot a different
> > kernel or at least a different bootloader entry in order to resume. Not
> 
> No, the newest implementation need not to boot a different kernel or
> different bootloader entry. You just use one bootloader entry, it will
> resume if there's an image, booting normally if there's not. You can
> look at the newest hibernation example description.
> 

Following is the step from new method you have given.

7. Boot kernel compiled in step 1 (kernel C). Use the rootfs.gz as
   root file system.

This mentions that use rootfs.gz as initrd. Without modifying the boot
loader entry, how would I switch the initrd dynamically.

Looks like it might be a typo. So basically we can just boot back into
normal kernel and then a user can load the resumable core file and kexec
to it?

I think all this functionality can be packed into normal initrd itself
to make user interface better.

A user can configure the destination for hibernated image at system
installation time and initrd will be modified accordingly to save the
hibernated image as well to check that user specfied location to find out
if a hibernation image is available and needs to be resumed.

Thanks
Vivek
