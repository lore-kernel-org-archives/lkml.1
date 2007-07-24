Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbXGXFmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbXGXFmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 01:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbXGXFmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 01:42:44 -0400
Received: from il.qumranet.com ([82.166.9.18]:53701 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbXGXFmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 01:42:43 -0400
Message-ID: <46A59145.3040705@qumranet.com>
Date: Tue, 24 Jul 2007 08:42:29 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC 0/8]KVM: swap out guest pages
References: <1185173489.2645.64.camel@sli10-conroe.sh.intel.com>	 <46A4829C.9080104@qumranet.com> <1185241357.24201.12.camel@sli10-conroe.sh.intel.com>
In-Reply-To: <1185241357.24201.12.camel@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Tue, 24 Jul 2007 08:42:28 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li wrote:
> On Mon, 2007-07-23 at 18:27 +0800, Avi Kivity wrote:
>   
>> Shaohua Li wrote:
>>     
>>> This patch series make kvm guest pages be able to be swapped out and
>>> dynamically allocated. Without it, all guest memory is allocated at
>>> guest start time.
>>>
>>> patches are against latest git, and you need first patch Avi's
>>>       
>> kvm-sch
>>     
>>> integration patch
>>>
>>>       
>> (http://sourceforge.net/mailarchive/forum.php?thread_name=11841693332609-git-send-email-avi%40qumranet.com&forum_name=kvm-devel ).
>>     
>>> Patch is quite stable in my test. With the patch, I can run a 256M
>>> memory guest in a 300M memory host.
>>>       
>> What about the opposite?
>>
>>     
>>> If guest is idle, the memory it used
>>> can be less than 10M. I did a simple performance test (measure
>>>       
>> kernel
>>     
>>> build time in guest), if there is few swap, the performance w/wo the
>>> patch difference isn't significent. If you have better measurement
>>> approach, please let me try.
>>>
>>> Unresolved issue:
>>> 1. swapoff doesn't work, we need a hook.
>>> 2. SMP guest might not work, as kvm doesn't support smp till now.
>>> 3. better algorithm to select swaped out guest pages according to
>>> guest's memory usage.
>>> Maybe more.
>>>
>>> Any suggests and comments are appreciated.
>>>  
>>>       
>> The big question is whether to have kvm's own address_space or not.
>>
>> Having an address_space (like your patch does) is remarkably simple,
>> and
>> requires few hooks from the current vm.  However using existing vmas
>> mapped by the user has many advantages:
>>
>> - compatible with s390 requirements
>> - allows the user to use hugetlbfs pages, which have a performance
>> advantage using ept/npt (but which are unswappable)
>> - allows the user to map a file (which can be regarded as way to
>> specify
>> the swap device)
>> - better ingration with the rest of the vm
>>
>> I am quite torn between the simplicity of your approach and the
>> advantages of using generic vmas.  However, s390 pretty much forces
>> our
>> hand.
>>
>> What is your opinion of extending generic vmas to back kvm guest
>> memory?
>>     
> several issues:
> 1. vma is to manage usersapce address, kvm guest uses full address
> space.
> 2. qemu itself must use some address space.
>   

My idea is to keep the current slot concept, but instead of having kvm
allocate pages for a slot, it would call get_user_pages() for a virtual
address range.  Userspace doesn't directly talk about vmas, just virtual
address ranges.


> 3. kvm need special page fault for shadow page table. generic page table
> operations can't be directly used for guest.
> I have no idea if your idea is feasible. The s390 guys said their shadow
> page table is the same as host, this is why they can easily implement
> swap, x86 is hard.
>   

No question that it is hard.  I'd like to explore just how hard it is.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

