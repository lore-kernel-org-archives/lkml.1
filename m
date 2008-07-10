Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbYGJKWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbYGJKWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 06:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYGJKWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 06:22:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:31518 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbYGJKWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 06:22:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZgziZ3Y6QugFSaW6G5hjSOYcVVtGXNB11DfTOxk8XeoBbyQisZUzUoJ1A7nm3Wbto2
         1+bee0AGFTvdHqqOQkdWzvB/ZP9bOCi/kv80WLJuCeayxgEYh8gHZcACStKPcFhhib7q
         6SqGMlchqNn+ftLLbVCopVmVQB0mO5WcntVkk=
Message-ID: <86802c440807100322uc2861c9mc3e99d73aa1691bf@mail.gmail.com>
Date: Thu, 10 Jul 2008 03:22:03 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 05/05] x86: Rename paravirtualized TSC functions
Cc: akataria@vmware.com, "Thomas Gleixner" <tglx@linutronix.de>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Daniel Hecht" <dhecht@vmware.com>, LKML <linux-kernel@vger.kernel.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
In-Reply-To: <86802c440807100111k5d2e31c4w2c73b7e30557a604@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214937816.20191.34.camel@promb-2n-dhcp368.eng.vmware.com>
	 <20080709061336.GG9760@elte.hu>
	 <86802c440807090020q516b6332qf8e0d65918e7001e@mail.gmail.com>
	 <1215624603.3930.8.camel@alok-dev1>
	 <86802c440807091038m6c14f165xede8b2b0316d0225@mail.gmail.com>
	 <20080710072201.GE14377@elte.hu>
	 <86802c440807100034w3a3ee192k8e565b75fd2df608@mail.gmail.com>
	 <20080710075030.GA27361@elte.hu>
	 <86802c440807100104s1e1f1cdeg421be2dbeffdcb75@mail.gmail.com>
	 <86802c440807100111k5d2e31c4w2c73b7e30557a604@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 1:11 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Thu, Jul 10, 2008 at 1:04 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> On Thu, Jul 10, 2008 at 12:50 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>>
>>> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>>
>>>> > that would be the tip/xen64 stuff, right? Does this revert:
>>>> >
>>>> > |    Revert "x86_64: there's no need to preallocate level1_fixmap_pgt"
>>>> > |
>>>> > |    This reverts commit 033786969d1d1b5af12a32a19d3a760314d05329.
>>>> > |
>>>> > |    Suresh Siddha reported that this broke booting on his 2GB testbox.
>>>> >
>>>> > solve your problems, or are there other problems still?
>>>>
>>>> still is bisecting it now...
>>>
>>> ok. I have no mystery crash on my test-systems.
>>>
>>> by the looks of it, your crashes seem to be pagetable related. If it's
>>> in the tip/xen-64bit branch, my candidates would be:
>>>
>>>  0f38c08: x86: use __page_aligned_data/bss
>>>  0337869: x86_64: there's no need to preallocate level1_fixmap_pgt
>>>  89d7bb5: x86_64: add workaround for no %gs-based percpu
>>>
>>> 0337869 is reverted already.
>>>
>>> Or if it's an older commit, two candidates would be:
>>>
>>>  b50efd2: x86: introduce page_size_mask for 64bit
>>>  3a9e189: x86: map UV chipset space - pagetable
>>>
>>> do you know the sha1 of the first broken tree? We know that
>>> tip-history-2008-07-08_16.08_Tue is known-good.
>>
>> first round bisect all works..
>>
>> it seems make oldconfig change setting between different setting...
>>
>> diff .config config.full.good
>> 4c4
>> < # Thu Jul 10 00:52:52 2008
>> ---
>>> # Thu Jul 10 00:40:03 2008
>> 295,296c295
>> < CONFIG_CC_STACKPROTECTOR_ALL=y
>> < CONFIG_CC_STACKPROTECTOR=y
>> ---
>>> # CONFIG_CC_STACKPROTECTOR is not set
>>
>> it seems some recent change doesn't like stackprotector.
>
> reeing unused kernel memory: 996k freed
> INIT: version 2.86 booting
> init[1]: segfault at 28 ip ffffffffff600108 sp 00007fff71647a40 error 4
> init[1]: segfault at 28 ip ffffffffff600108 sp 00007fff71646fc0 error 4
> Kernel panic - not syncing: Attempted to kill init!
> Pid: 1, comm: init Not tainted 2.6.26-rc9-tip-01539-g7ef7459 #280
>
> Call Trace:
>  [<ffffffff80268672>] ? do_exit+0x84/0x6ce
>  [<ffffffff80268d42>] ? do_group_exit+0x86/0xb3
>  [<ffffffff802745b8>] ? get_signal_to_deliver+0x309/0x33d
>  [<ffffffff80272877>] ? send_signal+0x23b/0x26e
>  [<ffffffff802297e8>] ? do_notify_resume+0xd3/0x8fd
>  [<ffffffff802c292b>] ? print_vma_addr+0x110/0x12f
>  [<ffffffff80a4f3af>] ? do_page_fault+0x8ac/0x8fe
>  [<ffffffff8022a4f4>] ? mcount_call+0x5/0x31
>  [<ffffffff8022a4f4>] ? mcount_call+0x5/0x31
>  [<ffffffff80270d34>] ? sigprocmask+0xbe/0xf6
>  [<ffffffff8022ac78>] ? retint_signal+0x3d/0x85
>

bisecting get lost between the branch... some time it allows
STACKPROTECTOR... sometime it doesn't

git-bisect log
git-bisect start
# bad: [5c929086ab3c2e42554099930c352c584b09fb49] Merge branch
'timers/clocksource'
git-bisect bad 5c929086ab3c2e42554099930c352c584b09fb49
# good: [fc9036ea1a4b14229788e6df3936b451a6abac98] x86: let
early_reserve_e820 update e820_saved too
git-bisect good fc9036ea1a4b14229788e6df3936b451a6abac98
# good: [e624188cbd347f134b4827c201cac7e59cd6cf46] Merge branch
'auto-core-next' into auto-generic-ipi-next
git-bisect good e624188cbd347f134b4827c201cac7e59cd6cf46
# bad: [6412367fe22dc54cc727e7bec5bd65c36c1a0754] x86,
paravirt-spinlocks: fix boot hang
git-bisect bad 6412367fe22dc54cc727e7bec5bd65c36c1a0754
# good: [db8e85a69d45f1692e216392a652f9652232016e] Merge branch
'generic-ipi-mergefixups' into auto-generic-ipi-next
git-bisect good db8e85a69d45f1692e216392a652f9652232016e
# good: [a0ba7c30f129d94f8a5e97ed065b510996f813b2] Merge branch
'x86/core' into xen-64bit
git-bisect good a0ba7c30f129d94f8a5e97ed065b510996f813b2
# bad: [c370cb1843a68485e64fb956b6a2beb0c6f7f5f1] xen: fix truncation
of machine address
git-bisect bad c370cb1843a68485e64fb956b6a2beb0c6f7f5f1
# bad: [9ed13f242bb9d30bb7502a69a67fefb909d2842e] xen64: fix calls
into hypercall page
git-bisect bad 9ed13f242bb9d30bb7502a69a67fefb909d2842e
# bad: [3ab876c861e0bc631f5cda803ddd435a45b4d1b4] x86_64: unstatic get_local_pda
git-bisect bad 3ab876c861e0bc631f5cda803ddd435a45b4d1b4
# bad: [033786969d1d1b5af12a32a19d3a760314d05329] x86_64: there's no
need to preallocate level1_fixmap_pgt
git-bisect bad 033786969d1d1b5af12a32a19d3a760314d05329
# bad: [c2fb47e5163096e238853ff551e69d24d4084633] x86/paravirt: call
paravirt_pagetable_setup_{start, done}
git-bisect bad c2fb47e5163096e238853ff551e69d24d4084633
# bad: [adbb486a333bffdde8821d09dd5a75493a4abe8c] manual merge of
auto-generic-ipi-next
git-bisect bad adbb486a333bffdde8821d09dd5a75493a4abe8c


anyway to convert tip/master to be one linear git tree locally.?

YH
