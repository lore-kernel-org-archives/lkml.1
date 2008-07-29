Return-Path: <linux-kernel-owner+w=401wt.eu-S1753081AbYG2EMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbYG2EMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 00:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbYG2EMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 00:12:32 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:39407 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750886AbYG2EMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 00:12:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=msKfbfFQQbAOJWran66hlCSBjyYJaW7aJ8bytFOaWVwcV1EshoRKgw8fOSKN+EUBh0+N1m0joaribuizQOyEQ3I7dBcMG9CgZyFfKV5EUri1TRIK+dDG465mVZOJwACKY3DMz8aBkceH/m/2/gU2GQtnlvfVQQ6mhRiLFagpTGE=  ;
X-YMail-OSG: rwNRqQ4VM1lCJQhHDHlww.ijTfDsDHkCVdB_Vgr9bEBv5N98tn97LZT4J4esnx_cRJlKOgGV.MV5AWcitugpb33oMz0EKXl.2cWuTEim3m8MgynvDfCbrMYftAX6Yi_nSPk-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Comments on UV tlb flushing
Date: Tue, 29 Jul 2008 14:12:18 +1000
User-Agent: KMail/1.9.5
Cc: Cliff Wickman <cpw@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <488E644B.10801@goop.org>
In-Reply-To: <488E644B.10801@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807291412.18495.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2008 10:28, Jeremy Fitzhardinge wrote:
> I'm just reworking the x86 tlb code to use smp_call_function_mask, and I
> see how the UV tlb flushing hooks in.  A few things occur to me:
>
>    1. There should be a CONFIG_X86_UV to select this code.  tlb_uv.o is
>       around 6k, which is not trivial overhead to subject every x86_64
>       kernel to.

Definitely.


>    2. CONFIG_X86_UV should either depend on or select CONFIG_PARAVIRT.
>    3. You should hook into paravirt_ops to enable your tlb-flush code.
>       That is, in - say - uv_bau_init() you do
>       "pv_mmu_ops.flush_tlb_others = uv_flush_tlb_others".  This removes
>       a test/branch in the generic code.  Using paravirt_ops may open
>       other opportunities to put UV-optimised functions in place without
>       having to modify generic code.

Really? It's not virtualized at all, although I don't like adding that
branch for such a small class of systems either.

It would possibly be better to have a new function (eg.
override_flush_tlb_others()), which returns 0 if
CONFIG_OVERRIDE_FLUSH_TLB is set, otherwise branches. And have *that*
selected by CONFIG_PARAVIRT and X86_UV.


> My understanding is that the UV hardware has some kind of
> payload-carrying IPI mechanism, which is a capability could be useful to
> express in a higher-level way in the kernel.  Certainly I could imagine
> using it in a virtual environment as a way to do inter-VCPU messaging
> with less context switch overhead.

Yes, as I said in my review of that part of the UV tlb flushing, it would
be nice to have a generic mechanism to IPI with payload, which falls back
to a smp_call_function-like approach on platforms that don't have the
capability.
