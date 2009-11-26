Return-Path: <linux-kernel-owner+w=401wt.eu-S1760628AbZKZPru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628AbZKZPru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 10:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756484AbZKZPrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 10:47:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432AbZKZPrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 10:47:45 -0500
Message-ID: <4B0EA3AA.5070003@redhat.com>
Date: Thu, 26 Nov 2009 10:50:02 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, dhowells@redhat.com,
       hidehiro.kawai.ez@hitachi.com, lethal@linux-sh.org, mingo@elte.hu,
       oleg@redhat.com, roland@redhat.com, vapier@gentoo.org,
       Takahiro Yasui <tyasui@redhat.com>
Subject: Re: + binfmt-introduce-coredump-parameter-structure.patch added to
 -mm tree
References: <200911202212.nAKMCF2v012068@imap1.linux-foundation.org> <20091126174835.5A73.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091126174835.5A73.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kosaki-san,

KOSAKI Motohiro wrote:
> Hi Hiramatsu-san,
> 
>>
>> The patch titled
>>      binfmt: introduce coredump parameter structure
>> has been added to the -mm tree.  Its filename is
>>      binfmt-introduce-coredump-parameter-structure.patch
>>
>> Before you just go and hit "reply", please:
>>    a) Consider who else should be cc'ed
>>    b) Prefer to cc a suitable mailing list as well
>>    c) Ideally: find the original patch on the mailing list and do a
>>       reply-to-all to that, adding suitable additional cc's
>>
>> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>>
>> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
>> out what to do about this
>>
>> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
>>
>> ------------------------------------------------------
>> Subject: binfmt: introduce coredump parameter structure
>> From: Masami Hiramatsu <mhiramat@redhat.com>
>>
>> These patches are for fixing coredump mm->flags consistency issue.
>>
>> ---
>> 1787         if (mm->core_state || !get_dumpable(mm)) {  <- (1)
>> 1788                 up_write(&mm->mmap_sem);
>> 1789                 put_cred(cred);
>> 1790                 goto fail;
>> 1791         }
>> 1792
>> [...]
>> 1798         if (get_dumpable(mm) == 2) {    /* Setuid core dump mode */ <-(2)
>> 1799                 flag = O_EXCL;          /* Stop rewrite attacks */
>> 1800                 cred->fsuid = 0;        /* Dump root private */
>> 1801         }
>> ---
>>
>> Since dumpable bits are not protected by lock, there is a chance to change
>> these bits between (1) and (2).
>>
>> To solve this issue, this patch copies mm->flags to
>> coredump_params.mm_flags at the beginning of do_coredump() and uses it
>> instead of get_dumpable() while dumping core.  This series also introduce
>> coredump parameter structure for simplify bimfmt->core_dump interface.
>>
>>
>>
>> This patch:
>>
>> Introduce coredump parameter data structure (struct coredump_params) for
>> simplifying binfmt->core_dump() arguments.  This also cleanup DUMP_WRITE()
>> in elf_core_dump() by style issue.
> 
> 
> This patch break ia64 because arch specific ELF_CORE_EXTRA_PHDRS and 
> ELF_CORE_WRITE_EXTRA_DATA still use DUMP_WRITE. I expect this patch 
> break uml too.

$ grep -r DUMP_WRITE arch/*/include
arch/ia64/include/asm/elf.h:            DUMP_WRITE(&phdr, sizeof(phdr));       \
arch/ia64/include/asm/elf.h:                    DUMP_WRITE((void *) gate_phdrs[\

Oops, certainly, that's a problem.
IMHO, we should not do like that, all parameter required by a macro should be
specified explicitly, since it reduces readability so much...
I think we'd better make those macros inline function, check it's return value
for error handling.

What would you think about it?

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

