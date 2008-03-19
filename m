Return-Path: <linux-kernel-owner+w=401wt.eu-S965859AbYCSXu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965859AbYCSXu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940453AbYCSWTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:19:09 -0400
Received: from gw.goop.org ([64.81.55.164]:53182 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939093AbYCSWTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:19:06 -0400
Message-ID: <47E19085.2020308@goop.org>
Date: Wed, 19 Mar 2008 15:15:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [PATCH 00 of 31] x86: unification and xen updates
References: <patchbomb.1205797011@localhost> <20080319190536.GA11432@elte.hu> <20080319194648.GA20088@elte.hu> <47E17171.9090108@goop.org> <20080319200931.GA24828@elte.hu> <20080319213343.GA2195@elte.hu> <47E18B8E.8080104@goop.org> <20080319220028.GA10480@elte.hu> <47E18C9D.4010007@goop.org> <20080319220431.GA11606@elte.hu>
In-Reply-To: <20080319220431.GA11606@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>>> config attached. randconfig generated, so it can have random 
>>> surprises enabled :)
>>>       
>> Thanks.  What was the workload?  Did it just happen, or were you doing 
>> something specific?
>>     
>
> simple bootup triggered it.
>   

Haven't managed to repro it yet, but DEBUG_PAGE_ALLOC turned up another 
case of doing tlb flushes with preempt on:

BUG: using smp_processor_id() in preemptible [00000000] code: init/1
caller is xen_flush_tlb+0xe/0xa2
Pid: 1, comm: init Not tainted 2.6.25-rc6-x86-latest.git #281
 [<c0234eed>] debug_smp_processor_id+0x99/0xb0
 [<c0103ca0>] xen_flush_tlb+0xe/0xa2
 [<c011d46b>] kernel_map_pages+0x104/0x125
 [<c0154f45>] get_page_from_freelist+0x32f/0x433
 [<c01444c4>] ? lock_acquire+0x90/0x9d
 [<c01550bd>] __alloc_pages+0x5e/0x2a5
 [<c015c5b3>] do_wp_page+0x2c9/0x653
 [<c017953f>] ? do_lookup+0x4f/0x146
 [<c0103e11>] ? xen_restore_fl+0x2e/0x52
 [<c01444c4>] ? lock_acquire+0x90/0x9d
 [<c015f720>] ? handle_mm_fault+0xa37/0xbb8
 [<c015f7a4>] handle_mm_fault+0xabb/0xbb8
 [<c0179332>] ? path_put+0x20/0x23
 [<c0103e11>] ? xen_restore_fl+0x2e/0x52
 [<c0103e11>] ? xen_restore_fl+0x2e/0x52
 [<c045699d>] ? do_page_fault+0x460/0x952
 [<c013b80d>] ? down_read_trylock+0x37/0x41
 [<c0456a51>] do_page_fault+0x514/0x952
 [<c0232116>] ? copy_to_user+0x2a/0x34
 [<c017e3ce>] ? sys_select+0x13e/0x164
 [<c045653d>] ? do_page_fault+0x0/0x952
 [<c0454eaa>] error_code+0x72/0x78


This code seems a bit fast and loose anyway, since it only does a local 
TLB flush, which means that other CPUs can still accessed free memory if 
they still have a stale TLB for it.  Having the tlb flush happen on a 
random CPU doesn't really affect things much.

    J
