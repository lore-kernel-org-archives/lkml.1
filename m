Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbYG2G0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbYG2G0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 02:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYG2G0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 02:26:31 -0400
Received: from gw.goop.org ([64.81.55.164]:42921 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbYG2G0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 02:26:30 -0400
Message-ID: <488EB813.6020903@goop.org>
Date: Mon, 28 Jul 2008 23:26:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Cliff Wickman <cpw@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Comments on UV tlb flushing
References: <488E644B.10801@goop.org> <200807291412.18495.nickpiggin@yahoo.com.au>
In-Reply-To: <200807291412.18495.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
>>    2. CONFIG_X86_UV should either depend on or select CONFIG_PARAVIRT.
>>    3. You should hook into paravirt_ops to enable your tlb-flush code.
>>       That is, in - say - uv_bau_init() you do
>>       "pv_mmu_ops.flush_tlb_others = uv_flush_tlb_others".  This removes
>>       a test/branch in the generic code.  Using paravirt_ops may open
>>       other opportunities to put UV-optimised functions in place without
>>       having to modify generic code.
>>     
>
> Really? It's not virtualized at all, although I don't like adding that
> branch for such a small class of systems either.
>   

It's not virtualized, but paravirt_ops provides a wide range of 
low-level hooks into all kinds of useful things; we may as well use them 
if they're there.  It's similar to VSMP's use of pvops: they do 
something odd with shadowing the interrupt flag in AC in flags, and hook 
irq_enable/disable/save/restore to implement it.

> It would possibly be better to have a new function (eg.
> override_flush_tlb_others()), which returns 0 if
> CONFIG_OVERRIDE_FLUSH_TLB is set, otherwise branches. And have *that*
> selected by CONFIG_PARAVIRT and X86_UV.
>   

There doesn't seem much point.  CONFIG_PARAVIRT will turn all the 
flush_tlb_others() into indirect calls which can be hooked, then the 
paravirt patching machinery will turn them back into direct calls.  So 
it basically gives you the flexibility of pluggin in arbitrary 
functions, but with zero runtime overhead.

    J
