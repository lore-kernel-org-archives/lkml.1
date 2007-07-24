Return-Path: <linux-kernel-owner+w=401wt.eu-S1759064AbXGXNkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759064AbXGXNkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 09:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbXGXNkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 09:40:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:10591 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbXGXNkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 09:40:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rr4uWBDatshqXUCiETVSwDlB/GOiIwM3GN6om0JYTpk/cm5KKjYahtpKz9UymrAzhIYEB9N9D7PpcUSrpzxmiSHH/3krjEZvGmA1zHsN+VclqaFOe9qzbW9aGOjkSGfga4RVcZp9Bwje1Hzj3UNTZsArm9Ufkro9nPJssmR0nMI=
Message-ID: <288dbef70707240640t5c8e798do677996c7a4b705fe@mail.gmail.com>
Date: Tue, 24 Jul 2007 21:40:22 +0800
From: "Shaohua Li" <shaoh.li@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re:
Cc: lkml <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
In-Reply-To: <FC1D1B23302A22499C60C967336B2AE00186B15C@pdsmsx411.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <FC1D1B23302A22499C60C967336B2AE00186B15C@pdsmsx411.ccr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: "Avi Kivity" <avi@qumranet.com>
> To: "Li, Shaohua" <shaohua.li@intel.com>
> Date: Tue, 24 Jul 2007 13:42:29 +0800
> Subject: Re: [RFC 0/8]KVM: swap out guest pages
>
>
> Shaohua Li wrote:
> > On Mon, 2007-07-23 at 18:27 +0800, Avi Kivity wrote:
> >
> >> Shaohua Li wrote:
> >>
> >>> This patch series make kvm guest pages be able to be swapped out and
> >>> dynamically allocated. Without it, all guest memory is allocated at
> >>> guest start time.
> >>>
> >>> patches are against latest git, and you need first patch Avi's
> >>>
> >> kvm-sch
> >>
> >>> integration patch
> >>>
> >>>
> >>
> (http://sourceforge.net/mailarchive/forum.php?thread_name=11841693332609-git-send-email-avi%40qumranet.com&forum_name=kvm-devel
> ).
> >>
> >>> Patch is quite stable in my test. With the patch, I can run a 256M
> >>> memory guest in a 300M memory host.
> >>>
> >> What about the opposite?
> >>
> >>
> >>> If guest is idle, the memory it used
> >>> can be less than 10M. I did a simple performance test (measure
> >>>
> >> kernel
> >>
> >>> build time in guest), if there is few swap, the performance w/wo the
> >>> patch difference isn't significent. If you have better measurement
> >>> approach, please let me try.
> >>>
> >>> Unresolved issue:
> >>> 1. swapoff doesn't work, we need a hook.
> >>> 2. SMP guest might not work, as kvm doesn't support smp till now.
> >>> 3. better algorithm to select swaped out guest pages according to
> >>> guest's memory usage.
> >>> Maybe more.
> >>>
> >>> Any suggests and comments are appreciated.
> >>>
> >>>
> >> The big question is whether to have kvm's own address_space or not.
> >>
> >> Having an address_space (like your patch does) is remarkably simple,
> >> and
> >> requires few hooks from the current vm.  However using existing vmas
> >> mapped by the user has many advantages:
> >>
> >> - compatible with s390 requirements
> >> - allows the user to use hugetlbfs pages, which have a performance
> >> advantage using ept/npt (but which are unswappable)
> >> - allows the user to map a file (which can be regarded as way to
> >> specify
> >> the swap device)
> >> - better ingration with the rest of the vm
> >>
> >> I am quite torn between the simplicity of your approach and the
> >> advantages of using generic vmas.  However, s390 pretty much forces
> >> our
> >> hand.
> >>
> >> What is your opinion of extending generic vmas to back kvm guest
> >> memory?
> >>
> > several issues:
> > 1. vma is to manage usersapce address, kvm guest uses full address
> > space.
> > 2. qemu itself must use some address space.
> >
>
> My idea is to keep the current slot concept, but instead of having kvm
> allocate pages for a slot, it would call get_user_pages() for a virtual
> address range.  Userspace doesn't directly talk about vmas, just virtual
> address ranges.
all the APIs need vma/page table handling. swap also needs vma for
rmap for generic file.

Thanks,
Shaohua
