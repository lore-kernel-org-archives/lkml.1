Return-Path: <linux-kernel-owner+w=401wt.eu-S1765053AbXGXBry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765053AbXGXBry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 21:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbXGXBrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 21:47:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:43801 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbXGXBrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 21:47:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,572,1175497200"; 
   d="scan'208";a="271825735"
Subject: Re: [RFC 0/8]KVM: swap out guest pages
From: Shaohua Li <shaohua.li@intel.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <46A4829C.9080104@qumranet.com>
References: <1185173489.2645.64.camel@sli10-conroe.sh.intel.com>
	 <46A4829C.9080104@qumranet.com>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 09:42:37 +0800
Message-Id: <1185241357.24201.12.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 18:27 +0800, Avi Kivity wrote:
> Shaohua Li wrote:
> > This patch series make kvm guest pages be able to be swapped out and
> > dynamically allocated. Without it, all guest memory is allocated at
> > guest start time.
> >
> > patches are against latest git, and you need first patch Avi's
> kvm-sch
> > integration patch
> >
> (http://sourceforge.net/mailarchive/forum.php?thread_name=11841693332609-git-send-email-avi%40qumranet.com&forum_name=kvm-devel ).
> >
> > Patch is quite stable in my test. With the patch, I can run a 256M
> > memory guest in a 300M memory host.
> 
> What about the opposite?
> 
> > If guest is idle, the memory it used
> > can be less than 10M. I did a simple performance test (measure
> kernel
> > build time in guest), if there is few swap, the performance w/wo the
> > patch difference isn't significent. If you have better measurement
> > approach, please let me try.
> >
> > Unresolved issue:
> > 1. swapoff doesn't work, we need a hook.
> > 2. SMP guest might not work, as kvm doesn't support smp till now.
> > 3. better algorithm to select swaped out guest pages according to
> > guest's memory usage.
> > Maybe more.
> >
> > Any suggests and comments are appreciated.
> >  
> 
> The big question is whether to have kvm's own address_space or not.
> 
> Having an address_space (like your patch does) is remarkably simple,
> and
> requires few hooks from the current vm.  However using existing vmas
> mapped by the user has many advantages:
> 
> - compatible with s390 requirements
> - allows the user to use hugetlbfs pages, which have a performance
> advantage using ept/npt (but which are unswappable)
> - allows the user to map a file (which can be regarded as way to
> specify
> the swap device)
> - better ingration with the rest of the vm
> 
> I am quite torn between the simplicity of your approach and the
> advantages of using generic vmas.  However, s390 pretty much forces
> our
> hand.
> 
> What is your opinion of extending generic vmas to back kvm guest
> memory?
several issues:
1. vma is to manage usersapce address, kvm guest uses full address
space.
2. qemu itself must use some address space.
3. kvm need special page fault for shadow page table. generic page table
operations can't be directly used for guest.
I have no idea if your idea is feasible. The s390 guys said their shadow
page table is the same as host, this is why they can easily implement
swap, x86 is hard.

Thanks,
Shaohua
