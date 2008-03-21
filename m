Return-Path: <linux-kernel-owner+w=401wt.eu-S1760595AbYCUTN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760595AbYCUTN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 15:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYCUTNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 15:13:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbYCUTNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 15:13:16 -0400
Date: Fri, 21 Mar 2008 15:12:26 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm] kexec jump -v9
Message-ID: <20080321191226.GA12609@redhat.com>
References: <1204773188.4707.109.camel@caritas-dev.intel.com> <20080311211004.GA30164@redhat.com> <1205286326.29069.16.camel@caritas-dev.intel.com> <m1abl4znw6.fsf@ebiederm.dsl.xmission.com> <20080312193740.GE13549@redhat.com> <1205481808.867.0.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205481808.867.0.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 04:03:28PM +0800, Huang, Ying wrote:
> On Wed, 2008-03-12 at 15:37 -0400, Vivek Goyal wrote:
> > On Tue, Mar 11, 2008 at 08:17:45PM -0600, Eric W. Biederman wrote:
> > > "Huang, Ying" <ying.huang@intel.com> writes:
> > > 
> > > > Yes. The entry point should be saved in dump.elf itself, this can be
> > > > done via a user-space tool such as "makedumpfile". Because
> > > > "makedumpfile" is also used to exclude free pages from disk image, it
> > > > needs a communication method between two kernels (to get backup pages
> > > > map or something like that from kernel A). We have talked about this
> > > > before.
> > > >
> > > > - Your opinion is to communicate via the purgatory. (But I don't know
> > > > how to communicate between kernel A and purgatory).
> > > 
> > > How about the return address on the stack?
> > > 
> > 
> > I think he needs to pass on much more data than just return address. 
> > 
> > IIUC, he needs to pass backup pages map to new kernel, so that any
> > user space tool can use backup pages map to reconstruct/rearrange the
> > first kernel's memory core and tools like makedumpfile can do filtering
> > before hibernated images is saved.
> > 
> > This brings me to a random thought. Can we break the process of loading
> > a hibernation kernel in two steps.
> > 
> > - In first step just do the memory reservation for running second kernel.
> >   (kexec -l <dummpy-file-for-reserving-memory>)
> > 
> > - This memory map of reserved pages is exported to user space.
> > 
> > - Use this memory map and regenerate the hibernation kernel initrd
> >   (rootfs.gz) and put the memory map there. This memory map can be used
> >   by makedumpfile in second kernel for filtering.
> > 
> > This way it will user space to user space communication of information 
> > which gets fixed at kernel loading time.
> 
> Doing kexec load in two steps is a possible solution. Although this is a
> little complex, we can wrap the two steps into one /sbin/kexec invoking.
> That is, When do /sbin/kexec --load-preserve-context
> <kernel-image>, /sbin/kexec first call sys_kexec_load() to load the
> kernel image and reserving memory, then amend the memory image of loaded
> kernel (B) according to the new information available such as return
> address and backup pages map. For this solution, something still need to
> be solved is how to pass some information back from kernel B
> (hibernating kernel) to kernel A (original kernel) and how to pass some
> information from kernel C (resuming kernel) to kernel A (original
> kernel).
> 

Hi Huang,

I am kind of ok with both the methods.

- Communicate information between two kernels using an ELF NOTE
  prepared by kernel.

- Communicate information between user space tools using initrd.

But which method to use will depend on what information we want to 
exchange between two kernels. 

For example, re-entry points can be on stack or in ELF NOTE.

Backup page map probably can be communicated using initrd as only user
space need to access that (ELF Core headers can be put in a memory area
which is not swapped during transition from kernel A to B. This way
kernel B never needs to know that kernel A had done some swapping of
pages?). 

So far I have understood only following.

1. We need to pass around entry/re-entry points between kernels.

2. We need to pass backup pages map from kernel A to kernel B, so that user
  space tool can do filtering.

3. We need to pass address of ELF core headers from kernel A to kernel B so
  that a valid vmcore of kernel A can be exported.

	- For first time boot of kernel B, address of ELF core header is
	  passed through command line.

	- For re-entry into B, ELF core header address can be passed
 	  using some register, or on stack or using kernel ELF NOTE.

What else? What information do we need to communicate from kernel B to 
kernel A or from kernel C to kernel A?

I am sure that you have told it in the past. Just that I don't recollect
it.

Thanks
Vivek
