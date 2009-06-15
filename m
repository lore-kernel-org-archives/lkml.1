Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbZFOF7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbZFOF7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 01:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbZFOF70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 01:59:26 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:33307 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbZFOF70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 01:59:26 -0400
Message-ID: <4A35E32C.30609@oracle.com>
Date: Mon, 15 Jun 2009 13:59:08 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Amerigo Wang <xiyou.wangcong@gmail.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [Patch BUGFIX] kcore: fix its wrong size on x86_64
References: <20090608015242.GB2596@cr0.nay.redhat.com> <4A2CA96D.3090502@oracle.com> <2375c9f90906072341o2cded749m45bdddfdb499469@mail.gmail.com> <4A2CC52B.9010602@oracle.com> <2375c9f90906081743p77934f47n8ba1a018d333b95b@mail.gmail.com> <m1ab4i11zx.fsf@fess.ebiederm.org> <20090611050929.GA2706@cr0.nay.redhat.com> <m11vpqvozl.fsf@fess.ebiederm.org> <20090613040958.GA2959@cr0> <m17hzg7oil.fsf@fess.ebiederm.org> <20090615021457.GA3388@cr0.nay.redhat.com>
In-Reply-To: <20090615021457.GA3388@cr0.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4A35E331.00A0:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amerigo,
	Just patched my kernel and tested.
	The bad news is that although the number is changed, but it isn't right 
either.

Here is the output.
[root@test3 ~]# ls -l /proc/kcore
-r-------- 1 root root 131941393240064 Jun 15 13:39 /proc/kcore

But your patch does change something. I just try your commands in 
another box which show the right value after reboot. And the result is:

[root@test8 ~]# ls -l /proc/kcore
-r-------- 1 root root 5301604352 Jun 15 13:35 /proc/kcore
[root@test8 ~]# readelf -l /proc/kcore

Elf file type is CORE (Core file)
Entry point 0x0
There are 6 program headers, starting at offset 64

Program Headers:
   Type           Offset             VirtAddr           PhysAddr
                  FileSiz            MemSiz              Flags  Align
   NOTE           0x0000000000000190 0x0000000000000000 0x0000000000000000
                  0x00000000000008bc 0x0000000000000000         0
   LOAD           0x000077ffff601000 0xffffffffff600000 0x0000000000000000
                  0x0000000000800000 0x0000000000800000  RWE    1000
   LOAD           0x000077ffa0001000 0xffffffffa0000000 0x0000000000000000
                  0x000000005f000000 0x000000005f000000  RWE    1000
   LOAD           0x000077ff8200a000 0xffffffff82009000 0x0000000000000000
                  0x00000000006ceb50 0x00000000006ceb50  RWE    1000
   LOAD           0x00003a0000001000 0xffffc20000000000 0x0000000000000000
                  0x00001fffffffffff 0x00001fffffffffff  RWE    1000
   LOAD           0x0000000000001000 0xffff880000000000 0x0000000000000000
                  0x000000013c000000 0x000000013c000000  RWE    1000
[root@test8 ~]# ls -l /proc/kcore
-r-------- 1 root root 131941393240064 Jun 15 13:35 /proc/kcore

So you see, the second "ls -l" will show the wrong value.

Regards,
Tao

Amerigo Wang wrote:
> On Fri, Jun 12, 2009 at 09:20:50PM -0700, Eric W. Biederman wrote:
>> Amerigo Wang <xiyou.wangcong@gmail.com> writes:
>>
>>> Fix wrong /proc/kcore size on x86_64.
>> How does that change anything?
> 
> Please check the description below.
> 
>>> x86_64 uses __va() macro to caculate the virtual address passed to kclist_add()
>>> but decodes it with its own macro kc_vadd_to_offset(). This is wrong.
>>>
>>> Also, according to Documentation/x86/x86_64/mm.txt, kc_vaddr_to_offset()
>>> is wrong too.
>>>
>>> So just remove them, use the generic macro.
>>>
>>> BTW, the man page for /proc/kcore is wrong, its size can be more than
>>> the physical memory size, because it also contains memory area of
>>> vmalloc(), vsyscall etc...
>> The set of offsets that are usable sure.
> 
> We have generic kc_vaddr_to_offset() etc. in fs/proc/kcore.c.
> 
> 
>> However the size from stat is:
>>          proc_root_kcore->size = (size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
>>
>> Which can not be different than the physical memory size.
> 
> I never say this is not different, of course they are same, but what Tao
> reported is the wrong size after a read operation, please try the following:
> 
> #ls -l /proc/kcore
> #readelf -l /proc/kcore
> #ls -l /proc/kcore
> 
> You will find the *second* 'ls -l /proc/kcore' reports a size much more
> than the physical mem size.
> 
> And you will notice the difference of it after this patch applied.
> 
> 
