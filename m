Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbYAGIM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbYAGIM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 03:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbYAGIMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 03:12:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:47979 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020AbYAGIMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 03:12:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,252,1196668800"; 
   d="scan'208";a="250397279"
Subject: Re: [PATCH 0/3 -mm] kexec jump -v8
From: "Huang, Ying" <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080106204925.GA19601@redhat.com>
References: <1198222399.1965.15.camel@caritas-dev.intel.com>
	 <20071228213331.GB4560@redhat.com>
	 <1198893644.17317.36.camel@caritas-dev.intel.com>
	 <20071231192621.GD27060@redhat.com>
	 <1199349746.6288.119.camel@caritas-dev.intel.com>
	 <20080106204925.GA19601@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 07 Jan 2008 16:12:55 +0800
Message-Id: <1199693575.8224.50.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 07 Jan 2008 08:12:10.0128 (UTC) FILETIME=[00453100:01C85105]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-01-06 at 15:49 -0500, Vivek Goyal wrote:
> > > Why should we exchange backup page map information between two kernels?
> > > What data has been swapped and how to restore it back should be known
> > > to the kernel who did it. I think the memory info and address of ELF
> > > headers we can still pass to second kernel the same way we do for
> > > /proc/vmcore. The only difference is that purgatory shall have to modify 
> > > the command line to reflect the new address of ELF headers just before
> > > jumping to new kernel (because of swapping).
> > > 
> > > We can also modify the actual ELF headers in purgatory to reflect the
> > > right data (because of swapping) and new kernel will not have to know
> > > anything about swapping.
> > >
[...]
>  
> > In addition to revising the ELF headers in purgatory, the /proc/kimgcore
> > interface can also be used to revise the ELF headers in kernel A. But
> > this needs to export backup pages map information to user space (another
> > sysfs/procfs file?).
> 
> This is kind of two step load process. Load image, then export backup
> page info to user space and then readjust the headers through
> /proc/kimgcore. I think purgatory doing it is cleaner.
[...] 
> > I think there may be no difference between two kinds of files. Nothing
> > prevents hibernated image produced through /proc/vmcore loaded with
> > normal kexec -l. I have just tested it. This means we need not use
> > krestore to resume the hibernated kernel after enhancing /sbin/kexec
> > (because it uses too much anonymous memory). And, the resuming process
> > will be more smooth.
> > 
> 
> Ok. So in a nutshell, any resumable image (be it is generated through
> /proc/vmcore or /proc/kimgcore) can be launched in the same way  (I think
> kexec --load-preserve-context). ?
> 
> In fact, if we are modifying the ELF headers in purgatory to reflect the
> swapped page action, then we don't require /proc/kimgcore interface
> at all?

But, how can purgatory get the "backup pages map" information? Which is
not available when purgatory is loaded. I think there are two methods:

Method1:

- A setup page is setup by original kernel, and the address of setup
page is passed to purgatory using a pre-defined protocol (such as in a
register). The "backup pages map" is in setup page.
- Purgatory uses the information in setup page to modify ELF headers
- kexeced kernel use ELF headers to build /proc/vmcore

Method2:

- A setup page is setup by /sbin/kexec
- The "backup pages map" information is written to purgatory
via /proc/kimgcore.
- Purgatory uses the information to modify ELF headers
- kexeced kernel use ELF headers to build /proc/vmcore


But, why not just exchanging the "backup pages map" information between
two kernels via the "setup page"? It is as follow:

- A setup page is setup by original kernel, and the address of setup
page is passed to kexeced kernel using a pre-defined protocol (such as
in a register). The "backup pages map" is in setup page.
- kexec kernel use "backup pages map" to build /proc/vmcore.

To keep it simple, another choice is not passing this "backup pages map"
information between two kernels now. The biggest issue is makedumpfile
can not exclude free pages without it, resulting in big hibernated
image. Another issue is that the information in /proc/vmcore is not
accurate, but that does not affect the hibernation implementation.

> In fact, if we are modifying the ELF headers in purgatory to reflect the
> swapped page action, then we don't require /proc/kimgcore interface
> at all?

/proc/kimgcore is mainly used to save the memory image of the kexeced
kernel. If this is not to be supported, /proc/kimgcore is not needed.
But, I think this is useful to accelerate the hibernating (no another
boot is needed for each hibernating).

> > For completion (although may be not a big issue now):
> > 
> > Whether using "krestore" or normal "kexec -l" depends on the memory used
> > by current kernel (/proc/iomem) and memory in image file (PT_LOAD
> > headers). If all memory in image file is outside memory used by current
> > kernel, "krestore" should be used. If all memory in image file is inside
> > memory used by current kernel, normal "kexec -l" should be used. If
> > there is intersection set between memory in image file and memory of
> > current kernel, the image file can not be loaded.
> > 
> 
> I think kexec should mask that difference. A user should be able to load
> a resumable image either by using "kexec -l" or "kexec
> --load-preserve-context" depending on whether user wants to come back to
> orignal kernel in future or not. Kexec-tools should recognize the image
> as resumable. Any page outside the current kernel can be written to
> final location through /dev/oldmem. And any pages which overlap with the
> current kernel, should be moved to destination when actual kexec 
> happens (existing functionality).
> 
> This will require merging krestore and kexec user space functionality
> so that resuming a hibernated image is effectively a "Kexec -l"
> operation.
> 
> So a user will not worry about whether he is kexecing a fresh kernel
> (bzImage or vmlinux) or resuming a already booted kernel. Kexec tools
> should determine that and setup the entry point accordingly (might
> require some purgatory changes to take care of transition while jumping
> to resume hibernated image).

Yes. This is a good idea. I will do it.

> > And, it is more useful for "invoking some code in physical mode". The
> > procedure is something as follow:
> > 
> > 1. load some code executing in physical mode via kexec --load-preserve-context.
> > 2. setup the parameters via amending /proc/kimgcore
> > 3. execute the code in physical mode via kexec -e
> > 4. get the result via reading /proc/kimgcore
> > 5. setup another groups of parameters via amending /proc/kimgcore
> > ...
> 
> This seems to be extended functionlity. If your focus is "Kexec based
> hibernation" then I would think of initially keeping the implementation
> simple and keeping patches small. Make kexec based hibernation work
> and then extend functionality for other purposes.

I think this is a important use case of "kexec jump" besides "kexec
based hibernation". But it can be separated from initial "kexec jump"
patchset if necessary.
 
[...]
> > The main issue of this mechanism is that: it is a kernel-to-kernel
> > communication mechanism, while Eric Biederman thinks we should use only
> > user-to-user communication mechanism. And he is not persuaded now.
> > 
> > Because kernel operations such as re-initialize/re-construct
> > the /proc/vmcore, etc are needed for kexec jump or resuming. I think a
> > "kernel-to-kernel" mechanism may be needed. But I don't know if Eric
> > Biederman will agree with this.
> 
> Hmm... Personally I am more inclined to exchanging information between
> two kernels on setup page, in a standard format (using ELF headers etc).
> This information can be prepared by kexec-tools in user space and be). 
> modified by purgatory (during transition to reflect the swapped pages.
> Alternatively, one can modify this setup page info from user space through
> some /proc/kimgcore like interface.  I prefer the first one...

Some information (such as "backup pages map") is not available
when /sbin/kexec is executed. So there should be a method to pass such
information to purgatory from original kernel. So why not change the
information between two kernel via "setup page" directly (need not
purgatory).

Best Regards,
Huang Ying

