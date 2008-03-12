Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbYCLTii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbYCLTii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 15:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbYCLTi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 15:38:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbYCLTi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 15:38:27 -0400
Date: Wed, 12 Mar 2008 15:37:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Huang, Ying" <ying.huang@intel.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm] kexec jump -v9
Message-ID: <20080312193740.GE13549@redhat.com>
References: <1204773188.4707.109.camel@caritas-dev.intel.com> <20080311211004.GA30164@redhat.com> <1205286326.29069.16.camel@caritas-dev.intel.com> <m1abl4znw6.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1abl4znw6.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 08:17:45PM -0600, Eric W. Biederman wrote:
> "Huang, Ying" <ying.huang@intel.com> writes:
> 
> > Yes. The entry point should be saved in dump.elf itself, this can be
> > done via a user-space tool such as "makedumpfile". Because
> > "makedumpfile" is also used to exclude free pages from disk image, it
> > needs a communication method between two kernels (to get backup pages
> > map or something like that from kernel A). We have talked about this
> > before.
> >
> > - Your opinion is to communicate via the purgatory. (But I don't know
> > how to communicate between kernel A and purgatory).
> 
> How about the return address on the stack?
> 

I think he needs to pass on much more data than just return address. 

IIUC, he needs to pass backup pages map to new kernel, so that any
user space tool can use backup pages map to reconstruct/rearrange the
first kernel's memory core and tools like makedumpfile can do filtering
before hibernated images is saved.

This brings me to a random thought. Can we break the process of loading
a hibernation kernel in two steps.

- In first step just do the memory reservation for running second kernel.
  (kexec -l <dummpy-file-for-reserving-memory>)

- This memory map of reserved pages is exported to user space.

- Use this memory map and regenerate the hibernation kernel initrd
  (rootfs.gz) and put the memory map there. This memory map can be used
  by makedumpfile in second kernel for filtering.

This way it will user space to user space communication of information 
which gets fixed at kernel loading time.

> > - Eric's opinion is to communicate between the user space in kernel A
> > and user space in kernel B.
> 
> Purgatory is for all intents and purposes user space.  Because the
> return address falls on the trampoline page we won't know it's
> address before we call kexec.  But a return address and a stack
> on that page should be a perfectly good way to communicate.
> 
> > - My opinion is to communicate between two kernel directly.
> >
> > I think as a minimal infrastructure patch, we can communicate minimal
> > information between user space of two kernels. When we have consensus on
> > this topic, we can use makedumpfile for both excluding free pages and
> > saving the entry point. Now, we can save the entry point in a separate
> > file or I can write a simple tool to do this.
> 
> We need a fixed protocol so we do not make assumptions about how things
> will be implemented, allowing kernels to diverge and kinds of other
> good things.
> 
> For communicating extra information from the kernel being shut down
> we have elf notes.
> 
> Direct kernel to kernel communication is forbidden.  We must have
> a well defined protocol.  Allowing the implementations to change
> at their different speeds, and still work together.
> 

Agreed. Without a proper protocol, we will often run into issues that
X version of kernel does not work with Y version of hibernation kernel
etc.

> >> May be we can have a separate load flag (--load-resume-image) to mark
> >> that we are resuming an hibernated image and kexec does not have to
> >> prepare commandline, does not have to prepare zero page/setup page etc.
> >
> > There is already similar flag in original kexec-tools implementation:
> > "--args-none". If it is specified, kexec-tools does not prepare command
> > line and zero page/setup page etc. I think we can just re-use this flag.
> > And If it is desired an alias is good for me too.
> 
> My gut feel is we look at the image and detect what kind it is, and simply
> not enable image processing after we have read the note that says it
> is a resumable core or whatever.
> 

That makes sense. Just that we shall have to put some kind of ELF NOTE
or some other identifier in resumable core file to identify it.

Thanks
Vivek
