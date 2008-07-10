Return-Path: <linux-kernel-owner+w=401wt.eu-S1752152AbYGJIMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbYGJIMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 04:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYGJILe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 04:11:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:21764 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbYGJILb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 04:11:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Lh8LdkVEeG0oCVot6PCzqxIfL07VnkZL/RVPNJug5VCfgRzuFCfpHNcdW6DiWWS6Vr
         ufzHYnt1qAfjqbdw0Y6wGJju3FXXUu1qHI0DbVpGEj22U6+sO6BfqIiLrZ8MWArzhPSu
         b0DU2jGppAf0om2oxT3oxLkzlVAzUUKSjXY+8=
Message-ID: <86802c440807100111k5d2e31c4w2c73b7e30557a604@mail.gmail.com>
Date: Thu, 10 Jul 2008 01:11:29 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 05/05] x86: Rename paravirtualized TSC functions
Cc: akataria@vmware.com, "Thomas Gleixner" <tglx@linutronix.de>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Daniel Hecht" <dhecht@vmware.com>, LKML <linux-kernel@vger.kernel.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
In-Reply-To: <86802c440807100104s1e1f1cdeg421be2dbeffdcb75@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 1:04 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Thu, Jul 10, 2008 at 12:50 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>
>>> > that would be the tip/xen64 stuff, right? Does this revert:
>>> >
>>> > |    Revert "x86_64: there's no need to preallocate level1_fixmap_pgt"
>>> > |
>>> > |    This reverts commit 033786969d1d1b5af12a32a19d3a760314d05329.
>>> > |
>>> > |    Suresh Siddha reported that this broke booting on his 2GB testbox.
>>> >
>>> > solve your problems, or are there other problems still?
>>>
>>> still is bisecting it now...
>>
>> ok. I have no mystery crash on my test-systems.
>>
>> by the looks of it, your crashes seem to be pagetable related. If it's
>> in the tip/xen-64bit branch, my candidates would be:
>>
>>  0f38c08: x86: use __page_aligned_data/bss
>>  0337869: x86_64: there's no need to preallocate level1_fixmap_pgt
>>  89d7bb5: x86_64: add workaround for no %gs-based percpu
>>
>> 0337869 is reverted already.
>>
>> Or if it's an older commit, two candidates would be:
>>
>>  b50efd2: x86: introduce page_size_mask for 64bit
>>  3a9e189: x86: map UV chipset space - pagetable
>>
>> do you know the sha1 of the first broken tree? We know that
>> tip-history-2008-07-08_16.08_Tue is known-good.
>
> first round bisect all works..
>
> it seems make oldconfig change setting between different setting...
>
> diff .config config.full.good
> 4c4
> < # Thu Jul 10 00:52:52 2008
> ---
>> # Thu Jul 10 00:40:03 2008
> 295,296c295
> < CONFIG_CC_STACKPROTECTOR_ALL=y
> < CONFIG_CC_STACKPROTECTOR=y
> ---
>> # CONFIG_CC_STACKPROTECTOR is not set
>
> it seems some recent change doesn't like stackprotector.

reeing unused kernel memory: 996k freed
INIT: version 2.86 booting
init[1]: segfault at 28 ip ffffffffff600108 sp 00007fff71647a40 error 4
init[1]: segfault at 28 ip ffffffffff600108 sp 00007fff71646fc0 error 4
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: init Not tainted 2.6.26-rc9-tip-01539-g7ef7459 #280

Call Trace:
 [<ffffffff80268672>] ? do_exit+0x84/0x6ce
 [<ffffffff80268d42>] ? do_group_exit+0x86/0xb3
 [<ffffffff802745b8>] ? get_signal_to_deliver+0x309/0x33d
 [<ffffffff80272877>] ? send_signal+0x23b/0x26e
 [<ffffffff802297e8>] ? do_notify_resume+0xd3/0x8fd
 [<ffffffff802c292b>] ? print_vma_addr+0x110/0x12f
 [<ffffffff80a4f3af>] ? do_page_fault+0x8ac/0x8fe
 [<ffffffff8022a4f4>] ? mcount_call+0x5/0x31
 [<ffffffff8022a4f4>] ? mcount_call+0x5/0x31
 [<ffffffff80270d34>] ? sigprocmask+0xbe/0xf6
 [<ffffffff8022ac78>] ? retint_signal+0x3d/0x85
