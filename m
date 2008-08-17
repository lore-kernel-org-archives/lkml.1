Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbYHQOFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbYHQOFS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 10:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbYHQOFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 10:05:04 -0400
Received: from smtp.vip.sina.com ([202.108.3.172]:63892 "EHLO
	smtp-6-99.vip.sina.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751669AbYHQOFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 10:05:01 -0400
Message-ID: <48A82F12.70205@vip.sina.com>
Date: Sun, 17 Aug 2008 22:00:50 +0800
From: zhang wenjie <zwjsq@vip.sina.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Jaya Kumar <jayakumar.lkml@gmail.com>
CC: Markus Armbruster <armbru@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Hugh Dickins <hugh@veritas.com>,
       Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
       Kel Modderman <kel@otaku42.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: kernel BUG at lib/radix-tree.c:473!
References: <1218697362.26014.9.camel@localhost.localdomain>	 <Pine.LNX.4.64.0808141347480.11013@blonde.site>	 <48A48879.2000309@goop.org>	 <Pine.LNX.4.64.0808142104080.29719@blonde.site>	 <48A4AC01.7040402@goop.org> <m33al7ciwr.fsf@crossbow.pond.sub.org> <45a44e480808170509r48060254w7d85e51e8f09ffd0@mail.gmail.com>
In-Reply-To: <45a44e480808170509r48060254w7d85e51e8f09ffd0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaya Kumar wrote:
> On Thu, Aug 14, 2008 at 6:48 PM, Markus Armbruster <armbru@redhat.com> wrote:
>> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>>
>>> Hugh Dickins wrote:
>>>> As you can see, I'm still groping towards the right answer.
>>>> The driver probably needs to provide its own backing_dev_info
>>>> (or point to a suitable default), and its own address_space_ops,
>>>> and perhaps more (there should be examples elsewhere).  But whether
>>>> it is actually wrong, or whether I was wrong to mess it up, I've
>>>> not yet decided.
>>>>
>>> My understanding is that the driver is doing something a bit clever:
>>> it uses the page dirty flags to determine which parts of the
>>> framebuffer have been written to, and uses that information to
>>> minimize the amount of stuff that needs to be copied out.  The writes
>> Yes.
>>
>>> to the pages are not expected to generate actual page faults.
>>>
>>> But I haven't really looked at it closely, and I'm not at all familiar
>>> with the vm at this layer.  I'm not sure how it actually allocates the
>>> framebuffer memory for example (vmalloc?  incrementally on faults?).
>> vmalloc()
>>
>>> I'm hoping Markus will leap in, since wrote this stuff.  Or, gasp,
>>> I'll read the code myself.
>> The actual cleverness is in fb_defio[*], which was written by Jaya
>> Kumar (cc'ed).  I merely ripped out the old, somewhat racy cleverness
>> I inherited from Anthony Liguori (which you can still admire in Xen's
>> 2.6.18 kernel), and switched over to use fb_defio instead.  Because
>> one instance of clever code is enough.
>>
>> My understanding of fb_defio's inner workings is rather limited I
>> fear.  I'm just using it.
>>
>> Jaya, could you help?
>>
> 
> I will try my best. Ok, I read through the thread. My current
> understanding is as follows:
> 
> - Jeremy observed this issue when starting Xorg with Xen pvfb on 2.6.27-rc1
> - Ian bisected it to 14fcc23fdc78e9d32372553ccf21758a9bd56fa1
> - Peter pointed out from the trace we may be dirtying a page not in
> the page cache
> - Hugh mentioned prior to the bisected patch maybe the faulting page
> had a .set_page_dirty that was ok but now it doesn't.
> - Jeremy pointed out that the fault is at 1 page in to the /dev/fb0 mapping
> - Hugh mentioned:
> "  The driver probably needs to provide its own backing_dev_info
> (or point to a suitable default), and its own address_space_ops,
> and perhaps more (there should be examples elsewhere).  But whether
> it is actually wrong, or whether I was wrong to mess it up, I've
> not yet decided. "
> 
> In defio, the page mapping is provided through the vm_file that got
> setup during mmap.
>                 page->mapping = vma->vm_file->f_mapping;
> 
> I haven't figured how setting inode->i_mapping->a_ops is affecting
> this. I will pull tip and test with metronomefb and see if I can
> reproduce the issue when starting Xfbdev on that and start debugging
> from there.
> 
> Thanks,
> jaya

I have counted the same problem when i mmap the /dev/fb0 and memset it 
to 0(the fb driver use deferred_io and when i do not use deferred_io it 
works well) .This bug also showed int linux2.6.26 and linux2.6.25. and i
set some printk in the radix_tree_tag_set and fb_deferred_io_fault.

radix_tree_tag_set: height is 0
radix_tree_tag_set: index is 0
radix_tree_tag_set: radix_tree_maxindex(height) is 0
radix_tree_tag_set: height is 0
radix_tree_tag_set: index is 0
radix_tree_tag_set: radix_tree_maxindex(height) is 0
radix_tree_tag_set: height is 0
radix_tree_tag_set: index is 0
radix_tree_tag_set: radix_tree_maxindex(height) is 0
radix_tree_tag_set: height is 0
radix_tree_tag_set: index is 0
radix_tree_tag_set: radix_tree_maxindex(height) is 0
mmap address :0x40135000fb_deferred_io_fault, enter

fb_deferred_io_fault, leave
fb_deferred_io_mkwrite, enter
fb_deferred_io_mkwrite, leave
------------[ cut here ]------------
WARNING: at fs/buffer.c:711 __set_page_dirty+0xbc/0x18c()
Modules linked in: etrackfb_new sony_prs_505
[<c0024198>] (dump_stack+0x0/0x14) from [<c003bf40>] 
(warn_on_slowpath+0x4c/0x84)
[<c003bef4>] (warn_on_slowpath+0x0/0x84) from [<c00a403c>] 
(__set_page_dirty+0xbc/0x18c)
  r6:c38114b0 r5:c0319b80 r4:c0272114
[<c00a3f80>] (__set_page_dirty+0x0/0x18c) from [<c00a433c>] 
(__set_page_dirty_buffers+0xbc/0xd0)
  r6:c3d01738 r5:00000001 r4:c0319b80
[<c00a4280>] (__set_page_dirty_buffers+0x0/0xd0) from [<c0069dc4>] 
(set_page_dirty+0x54/0xdc)
[<c0069d70>] (set_page_dirty+0x0/0xdc) from [<c006a8a4>] 
(set_page_dirty_balance+0x18/0x64)
  r5:00000001 r4:c0319b80
[<c006a88c>] (set_page_dirty_balance+0x0/0x64) from [<c0071524>] 
(__do_fault+0x3b8/0x3f0)
  r5:c0319b80 r4:0bd5c0ff
[<c007116c>] (__do_fault+0x0/0x3f0) from [<c0072acc>] 
(handle_mm_fault+0x2a8/0x3bc)
[<c0072824>] (handle_mm_fault+0x0/0x3bc) from [<c0025be0>] 
(do_page_fault+0xe8/0x224)
[<c0025af8>] (do_page_fault+0x0/0x224) from [<c00201dc>] 
(do_DataAbort+0x3c/0xa0)
[<c00201a0>] (do_DataAbort+0x0/0xa0) from [<c00209c0>] 
(ret_from_exception+0x0/0x10)
Exception stack(0xc3edffb0 to 0xc3edfff8)
ffa0:                                     40135000 ffffffff 000752f8 
40135000
ffc0: becdced4 000086b8 000086c4 00000001 00008520 00000000 4012f000 
becdcea8
ffe0: 40089810 becdcd6c 00008670 40089838 20000010 ffffffff 

  r8:00008520 r7:00000001 r6:000086c4 r5:000086b8 r4:ffffffff
---[ end trace 7cf699b159b0c732 ]---
radix_tree_tag_set: height is 0
radix_tree_tag_set: index is 0
radix_tree_tag_set: radix_tree_maxindex(height) is 0
fb_deferred_io_fault, enter
fb_deferred_io_fault, leave
fb_deferred_io_mkwrite, enter
fb_deferred_io_mkwrite, leave
radix_tree_tag_set: height is 0
radix_tree_tag_set: index is 1
radix_tree_tag_set: radix_tree_maxindex(height) is 0
kernel BUG at lib/radix-tree.c:477!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c3d3c000
[00000000] *pgd=0bd53031, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#1]
Modules linked in: etrackfb_new sony_prs_505
CPU: 0    Tainted: G        W  (2.6.26-00011-g15bc467-dirty #1)
PC is at __bug+0x20/0x2c
LR is at log_wait+0x0/0x8
pc : [<c002418c>]    lr : [<c0259200>]    psr: 60000093
sp : c3edfda8  ip : c0259200  fp : c3edfdb4
r10: 00000000  r9 : c3edb780  r8 : c38114b4
r7 : 00000001  r6 : c38114b0  r5 : 00000000  r4 : c027ac68
r3 : 00000000  r2 : 00000001  r1 : 00000001  r0 : 00000027
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: c000717f  Table: 0bd3c000  DAC: 00000015
Process framebuff.ko (pid: 215, stack limit = 0xc3ede260)
Stack: (0xc3edfda8 to 0xc3ee0000)
fda0:                   c3edfde4 c3edfdb8 c010fce4 c002417c 00000000 
00000000
fdc0: c0319b60 c38114b0 00000000 40136000 c3edb780 00000000 c3edfe00 
c3edfde8
fde0: c00a40d8 c010fc1c c0319b60 00000001 c3d01738 c3edfe10 c3edfe04 
c00a433c
fe00: c00a3f90 c3edfe28 c3edfe14 c0069dc4 c00a4290 c0319b60 00000001 
c3edfe40
fe20: c3edfe2c c006a8a4 c0069d80 0bd5b0ff c0319b60 c3edfe88 c3edfe44 
c0071524
fe40: c006a89c 00000001 c3d3d000 00000001 00000001 00000001 40136000 
c0319b60
fe60: 00000000 00001000 00000800 c3d01738 40136000 000004d8 c3edb780 
c3edfecc
fe80: c3edfe8c c0072acc c007117c 00000001 00000001 00000000 c3d3d000 
c3d01738
fea0: c3c5f800 ffffffff c3d01738 c3c5f800 c3edb7b8 c3edb780 c3edffb0 
40136000
fec0: c3edff04 c3edfed0 c0025be0 c0072834 c0151c64 c014c444 00000817 
ffffffff
fee0: c0258638 00000817 c3edffb0 40136000 00000000 4012f000 c3edffac 
c3edff08
ff00: c00201dc c0025b08 00000083 00008520 00000083 4012f000 c3edff44 
c025cb4c
ff20: 00000083 c3c12600 00000000 00008520 c3ede000 4012f000 c3edff60 
c3edff48
ff40: c005fe38 c005ef6c 00000000 c025cb4c 00000084 c3edff7c c3edff64 
c0028bb4
ff60: c005fd28 c025b17c 0000000d c027abb8 c3edff8c c3edff80 c0028c38 
c0028b84
ff80: c3edffac c3edff90 c0020048 ffffffff 000086b8 000086c4 00000001 
00008520
ffa0: 00000000 c3edffb0 c00209c0 c00201b0 40135000 ffffffff 000742f8 
40136000
ffc0: becdced4 000086b8 000086c4 00000001 00008520 00000000 4012f000 
becdcea8
ffe0: 40089810 becdcd6c 00008670 40089838 20000010 ffffffff ffffffff 
ffffffff
Backtrace:
[<c002416c>] (__bug+0x0/0x2c) from [<c010fce4>] 
(radix_tree_tag_set+0xd8/0x12c)
[<c010fc0c>] (radix_tree_tag_set+0x0/0x12c) from [<c00a40d8>] 
(__set_page_dirty+0x158/0x18c)
[<c00a3f80>] (__set_page_dirty+0x0/0x18c) from [<c00a433c>] 
(__set_page_dirty_buffers+0xbc/0xd0)
  r6:c3d01738 r5:00000001 r4:c0319b60
[<c00a4280>] (__set_page_dirty_buffers+0x0/0xd0) from [<c0069dc4>] 
(set_page_dirty+0x54/0xdc)
[<c0069d70>] (set_page_dirty+0x0/0xdc) from [<c006a8a4>] 
(set_page_dirty_balance+0x18/0x64)
  r5:00000001 r4:c0319b60
[<c006a88c>] (set_page_dirty_balance+0x0/0x64) from [<c0071524>] 
(__do_fault+0x3b8/0x3f0)
  r5:c0319b60 r4:0bd5b0ff
[<c007116c>] (__do_fault+0x0/0x3f0) from [<c0072acc>] 
(handle_mm_fault+0x2a8/0x3bc)
[<c0072824>] (handle_mm_fault+0x0/0x3bc) from [<c0025be0>] 
(do_page_fault+0xe8/0x224)
[<c0025af8>] (do_page_fault+0x0/0x224) from [<c00201dc>] 
(do_DataAbort+0x3c/0xa0)
[<c00201a0>] (do_DataAbort+0x0/0xa0) from [<c00209c0>] 
(ret_from_exception+0x0/0x10)
Exception stack(0xc3edffb0 to 0xc3edfff8)
ffa0:                                     40135000 ffffffff 000742f8 
40136000
ffc0: becdced4 000086b8 000086c4 00000001 00008520 00000000 4012f000 
becdcea8
ffe0: 40089810 becdcd6c 00008670 40089838 20000010 ffffffff 

  r8:00008520 r7:00000001 r6:000086c4 r5:000086b8 r4:ffffffff
Code: e1a01000 e59f000c eb0061f3 e3a03000 (e5833000)
---[ end trace 7cf699b159b0c732 ]---
  Thanks
  Wenjie
