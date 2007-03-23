Return-Path: <linux-kernel-owner+w=401wt.eu-S1422831AbXCWMLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422831AbXCWMLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 08:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422833AbXCWMLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 08:11:33 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:54520 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422831AbXCWMLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 08:11:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=XKKNQCd0uBzGylwg0sjHRmQ4AtyoB9RCJvW4HMMLYcnzqF2Dmt/0/Cp50GnNMg37NIXYbfF+/tfG0qmLryTq3QKsDumi6ciOehScnEoT2FRHUSSraznxAsnjAnLF+Y4rYiCKJ37CrUYxZqJoD3Zba+SLdkV3UHWqKGqRpnN/xpY=
Message-ID: <4603C3C8.6000808@googlemail.com>
Date: Fri, 23 Mar 2007 13:10:48 +0100
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: vgoyal@in.ibm.com
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc4-rt0-kdump
References: <6bffcb0e0703211338i2aa6f933ube53c6604c78e285@mail.gmail.com> <20070322093119.GA19394@elte.hu> <6bffcb0e0703220557h7ff64282qf378623452c07d03@mail.gmail.com> <4602843D.9000306@googlemail.com> <20070323052501.GA1421@in.ibm.com>
In-Reply-To: <20070323052501.GA1421@in.ibm.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal napisał(a):
> On Thu, Mar 22, 2007 at 02:27:25PM +0100, Michal Piotrowski wrote:
>> Michal Piotrowski napisał(a):
>>> On 22/03/07, Ingo Molnar <mingo@elte.hu> wrote:
>>>> * Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>>>>
>>>>> Hi Ingo,
>>>>> 2.6.21-rc4-rt0
>>>>> BUG: at kernel/fork.c:1033 copy_process()
>>>> thanks Michal - this is a real bug that affects upstream too. Find the
>>>> fix below - i've test-booted it and it fixes the warning.
>>> Problem is fixed, thanks.
>> BTW. It seems that nobody uses -rt as a crash dump kernel ;)
>>
>> BUG: unable to handle kernel paging request at virtual address f7ebf8c4
>>  printing eip:
>> c1610192
>> *pde = 00000000
>> stopped custom tracer.
>> Oops: 0000 [#1]
>> PREEMPT 
>> Modules linked in:
>> CPU:    0
>> EIP:    0060:[<c1610192>]    Not tainted VLI
>> EFLAGS: 00010206   (2.6.21-rc4-rt0-kdump #3)
>> EIP is at copy_oldmem_page+0x4a/0xd0
>> eax: 000008c4   ebx: f7ebf000   ecx: 00000100   edx: 00000246
>> esi: f7ebf8c4   edi: c4c520fc   ebp: c4d54e30   esp: c4d54e18
>> ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068  preempt:00000001
>> Process swapper (pid: 1, ti=c4d54000 task=c4d52c20 task.ti=c4d54000)
>> Stack: c17ab7e0 c183f982 c1969658 00000400 00000400 00037ebf c4d54e5c c16af187 
>>        00037ebf c4c520fc 00000400 000008c4 00000000 00000000 c4c696e0 00000400 
>>        c4c520fc c4d54f94 c19a9cfd c4c520fc 00000400 c4d54f78 00000000 c1840996 
>> Call Trace:
>>  [<c16af187>] read_from_oldmem+0x73/0x98
>>  [<c19a9cfd>] vmcore_init+0x26c/0xab7
>>  [<c199979b>] init+0xaa/0x287
>>  [<c16044eb>] kernel_thread_helper+0x7/0x10
>>  =======================
>>
>> l *copy_oldmem_page+0x4a/0xd0
>> 0xc1610148 is in copy_oldmem_page (arch/i386/kernel/crash_dump.c:35).
>> 30       * copying the data to a pre-allocated kernel page and then copying to user
>> 31       * space in non-atomic context.
>> 32       */
>> 33      ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
>> 34                                     size_t csize, unsigned long offset, int userbuf)
>> 35      {
>> 36              void  *vaddr;
>> 37
>> 38              if (!csize)
>> 39                      return 0;
>>
> 
> Can you please paste the disassembly of copy_oldmem_page() on your system.
> Not sure from where this faulting address 0xf7ebf8c4 is coming. We are still
> in vmcore_init(), so we should be copying the data to kernel buffers only.
> This looks like a valid kernel address.
> 
> Can you also put some printk() here to find out from where 0xf7ebf8c4 has
> come? It does not look like a fixed kernel virutual address returned by
> kmap_atomic_pfn(). Then is it passed by kernel as a parameter to
> copy_oldmem_page()?

I added
printk(KERN_WARNING "copy_oldmem_page() pfn=%lu , buf=%s , nr_bytes=%d , offset=%lu , userbuf=%d\n", pfn, buf, nr_bytes, offset, userbuf);

before
tmp = copy_oldmem_page(pfn, buf, nr_bytes, offset, userbuf);

result is here
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc4-rt0/kdump-console2.log

'buf' might be broken.

> 
> Thanks
> Vivek
> 

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
