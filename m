Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbYLPJ0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbYLPJ0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 04:26:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbYLPJ0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 04:26:45 -0500
Received: from gw.goop.org ([64.81.55.164]:33442 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbYLPJ0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 04:26:44 -0500
Message-ID: <49477452.6030307@goop.org>
Date: Tue, 16 Dec 2008 01:26:42 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ken Chen <kenchen@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] x86: convert rdtscll() to use __native_read_tsc
References: <b040c32a0812160032pf681f13s9e5e86c4b5448012@mail.gmail.com> <20081216091509.GA29872@elte.hu>
In-Reply-To: <20081216091509.GA29872@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> The reason for the __native_read_tsc() / native_read_tsc() distinction is 
> and obscure problem with paravirt function pointers. Such constructs:
>
>   ./xen/enlighten.c:	.read_tsc = native_read_tsc,
>
> do not always work fine with all versions of gcc, if native_read_tsc() is 
> a simple static inline (as it should be) - the build would fail with 
> certain gcc flags.

I don't think that's true.  We rely on taking function pointers of 
static inlines pretty extensively; native_read_tsc is hardly unique in 
this respect.  I don't remember seeing any problems of the sort you 
describe.  (I can well believe this may have been a problem at some 
point, but not during the pv-ops development timeframe.)

> Perhaps the real fix is to do this rename as well:
>
>     native_read_tsc => native_read_tsc_paravirt
>   __native_read_tsc => native_read_tsc
>
> as this makes the native_read_tsc_paravirt() a pure technical variant, to 
> be used in paravirt_ops function pointer assignments. People would thus 
> just use the obvious native_read_tsc() inline function most of the time 
> and could forget about native_read_tsc_paravirt().
>
> Jeremy?
>   

I'm trying to remember the real reason for 
__native_read_tsc/native_read_tsc.  At least part of it is that 
__native_read_tsc is used in a vdso, and so *must* be inlined to avoid a 
bogus call from user to kernel space.  But I don't know why you wouldn't 
want to inline native_read_tsc everywhere.  I have a feeling it may be a 
relic from unification - possibly because x86-64 was late to the 
clocksource party - but I don't remember anything specific.

I think we can probably make do with a single native_read_tsc, so long 
as its always inlined.

    J
