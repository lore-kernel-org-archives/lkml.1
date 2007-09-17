Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbXIQLJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbXIQLJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 07:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbXIQLJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 07:09:28 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:31702 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbXIQLJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 07:09:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=SLOdHO64VzAHia5N2GPqLZvE7zeqfbmHyFp50v8XXeqTEkOYe98tE0tej5NwxWBX7PbnbW0qgOrBQ1X70+63ATsk3nq82yENcmimIrx8E2OMJD0zUZ8rBtpUZh3TJ6exfKFtye5Z3fQNSbBXsl32Fcb7dD7njYxId3p3mGBprro=
Message-ID: <46EE6060.8090609@gmail.com>
Date: Mon, 17 Sep 2007 13:09:20 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, airlied@linux.ie
Subject: Re: X freezes kernel during exit [Re: 2.6.23-rc3-mm1]
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46D17A7A.70609@gmail.com> <46D409FC.1070305@gmail.com> <46E3DCB8.5010709@gmail.com> <20070909054751.cbb27081.akpm@linux-foundation.org> <46E3FE6B.7010209@gmail.com> <20070909141730.GB25798@one.firstfloor.org> <46E4028E.9050007@gmail.com> <20070909143324.GC25798@one.firstfloor.org> <46E40699.7060000@gmail.com>
In-Reply-To: <46E40699.7060000@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2007 04:43 PM, Jiri Slaby wrote:
> On 09/09/2007 04:33 PM, Andi Kleen wrote:
>> On Sun, Sep 09, 2007 at 04:26:22PM +0200, Jiri Slaby wrote:
>>> BTW it is reproducible for me on two different machines (i386-x86_64,
>>> radeon-intel), don't you have the problem too?
>> No problems here with a radeon, no.
>>
>> Does your CPU have clflush or not in /proc/cpuinfo?
> 
> BTW this is how my flush_kernel_map looks like:
> 
> static void flush_kernel_map(void *arg)
> {
>         struct flush_arg *a = (struct flush_arg *)arg;
>         struct page *pg;
>         unsigned int xx = 0;
> 
>         /* When clflush is available use it because it is
>            much cheaper than WBINVD. */
>         printk("%s: 1\n", __func__);
>         if (a->full_flush || !cpu_has_clflush)
>                 asm volatile("wbinvd" ::: "memory");
>         else list_for_each_entry(pg, &a->l, lru) {
>         printk("%s: %10u 1a\n", __func__, xx++);
>                 if (PageFlush(pg))
>                         clflush_cache_range(page_address(pg), PAGE_SIZE);
>         }
>         printk("%s: 2\n", __func__);
>         __flush_tlb_all();
>         printk("%s: 3\n", __func__);
> }
> 
> It outputs 1a in the infinite loop with incrementing xx. But only in this case,
> some global_flush_tlb are OK. e.g.:
> Sep 10 01:39:19 localhost kernel: agpgart: Detected an Intel G33 Chipset.
> Sep 10 01:39:19 localhost kernel: global_flush_tlb: 1
> Sep 10 01:39:19 localhost kernel: flush_kernel_map: 1
> Sep 10 01:39:19 localhost kernel: flush_kernel_map:          0 1a
> Sep 10 01:39:19 localhost kernel: flush_kernel_map:          1 1a
> Sep 10 01:39:19 localhost kernel: flush_kernel_map: 2
> Sep 10 01:39:19 localhost kernel: flush_kernel_map: 3
> Sep 10 01:39:19 localhost kernel: flush_kernel_map: 1
> Sep 10 01:39:19 localhost kernel: flush_kernel_map:          0 1a
> Sep 10 01:39:19 localhost kernel: flush_kernel_map:          1 1a
> Sep 10 01:39:19 localhost kernel: flush_kernel_map: 2
> Sep 10 01:39:19 localhost kernel: flush_kernel_map: 3
> Sep 10 01:39:19 localhost kernel: global_flush_tlb: 2
> Sep 10 01:39:19 localhost kernel: global_flush_tlb: 3
> Sep 10 01:39:19 localhost kernel: agpgart: Detected 6140K stolen memory.
> 
> It seems, that the list is broken only on X shutdown. How can be deferred-pages
> list inited in some bad manner, when list_replace_init is called on it? Weird.

Ok, here comes a BUG with trace:
set status page addr 0x00033000
list_add corruption. next->prev should be prev (ffffffff8068ae70), but was
ffffffff80697a50. (next=ffff81000117fbd0).
------------[ cut here ]------------
kernel BUG at /home/l/latest/xxx/lib/list_debug.c:27!
invalid opcode: 0000 [1] SMP
last sysfs file: /devices/pci0000:00/0000:00:02.0/enable
CPU 0
Modules linked in: ipv6 floppy sr_mod rtc_cmos rtc_core cdrom ehci_hcd rtc_lib
usbhid
Pid: 1639, comm: X Not tainted 2.6.23-rc4-mm1_64 #23
RIP: 0010:[<ffffffff80332f49>]  [<ffffffff80332f49>] __list_add+0x39/0x60
RSP: 0018:ffff81000547bd48  EFLAGS: 00010296
RAX: 0000000000000079 RBX: ffff81000117a380 RCX: ffffffff8068b450
RDX: ffff81000317d6a0 RSI: 0000000000000001 RDI: ffffffff8068b420
RBP: ffff81000547bd48 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000006da2
R13: ffff810006c10d10 R14: ffff810006da2000 R15: 8000000000000163
FS:  00007f7a05258710(0000) GS:ffffffff806d1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000a33040 CR3: 0000000004a43000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process X (pid: 1639, threadinfo ffff81000547a000, task ffff81000317d6a0)
Stack:  ffff81000547bd58 ffffffff80332f7c ffff81000547bdc8 ffffffff80225c56
 ffffffff80225cb5 8000000000000163 ffffffff806830e8 ffffffff806830a0
 ffffffff806830a0 ffff810006da2000 ffff81000547bda8 0000000000006da2
Call Trace:
 [<ffffffff80332f7c>] list_add+0xc/0x10
 [<ffffffff80225c56>] __change_page_attr+0x376/0x390
 [<ffffffff80225cb5>] change_page_attr_addr+0x45/0x140
 [<ffffffff80225d16>] change_page_attr_addr+0xa6/0x140
 [<ffffffff80225de3>] change_page_attr+0x33/0x40
 [<ffffffff80387b64>] agp_generic_destroy_page+0x44/0x70
 [<ffffffff80388645>] agp_free_memory+0x65/0xd0
 [<ffffffff80386d49>] agp_free_memory_wrap+0x39/0x60
 [<ffffffff803873fb>] agp_release+0xdb/0x1c0
 [<ffffffff80299551>] __fput+0xd1/0x1b0
 [<ffffffff802996b6>] fput+0x16/0x20
 [<ffffffff802964e6>] filp_close+0x56/0x90
 [<ffffffff80297bed>] sys_close+0xad/0x110
 [<ffffffff8020bd0e>] system_call+0x7e/0x83

INFO: lockdep is turned off.

Code: 0f 0b eb fe 0f 1f 00 48 89 f1 4c 89 c2 48 89 c6 48 c7 c7 e8
RIP  [<ffffffff80332f49>] __list_add+0x39/0x60
 RSP <ffff81000547bd48>

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
