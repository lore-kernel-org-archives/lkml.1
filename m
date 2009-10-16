Return-Path: <linux-kernel-owner+w=401wt.eu-S1760414AbZJPO3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760414AbZJPO3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 10:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760215AbZJPO3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 10:29:24 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:55074 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbZJPO3X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 10:29:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vyvFwCx+/SbpAqhQqT9dxFWyMHDZQ08bvoVRJFrgqRORjMfwTl+uuNPuqpxKMxhV6G
         UCuGYeMEaX/xOVtoLVxn7VTFXxyTlDoKzpukzxG7zPRUmg3ODDm2GvhQeaGcA9vzL6NI
         MCDQ2dDj7i/gy2PXD0zgDzBBlUyZAarIvErtM=
MIME-Version: 1.0
In-Reply-To: <tnxbpk7a0ok.fsf@pc1117.cambridge.arm.com>
References: <c4e36d110910150159j6092d0d1lb20434bd9d43d8ce@mail.gmail.com>
	 <4AD6EF65.6080602@cn.fujitsu.com>
	 <1255605778.10164.49.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910160045y52d80450g1d803dd2090a2bd8@mail.gmail.com>
	 <1255690674.3008.24.camel@pc1117.cambridge.arm.com>
	 <c4e36d110910160632y4448475dp1ae66dfc01ff8448@mail.gmail.com>
	 <tnxbpk7a0ok.fsf@pc1117.cambridge.arm.com>
Date: Fri, 16 Oct 2009 16:28:47 +0200
Message-ID: <c4e36d110910160728n5ceefaa8u6b9989aec0564628@mail.gmail.com>
Subject: Re: Leaks in trace reported by kmemleak
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/16 Catalin Marinas <catalin.marinas@arm.com>:
> Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:
>> Yes -same - though I forget to mention that log contained these two
>> extra messages:
>> (got lost in other debug stuff :( )...
>>
>> So it could be the parameters in your first patch were not correct ?
>>
>> [drm] Initialized drm 1.1.0 20060810
>> kmemleak: Scan area larger than object 0xffffffffa033b000
>
> Ah, I forgot that kmemleak_scan_area takes an offset inside an object
> rather than an absolute address. Something like below (I should
> actually change this prototype of this function, it doesn't need to be
> so complex):
>
> diff --git a/kernel/module.c b/kernel/module.c
> index 8b7d880..8cc4406 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2383,6 +2383,10 @@ static noinline struct module *load_module(void __user *umod,
>                                         "_ftrace_events",
>                                         sizeof(*mod->trace_events),
>                                         &mod->num_trace_events);
> +       kmemleak_scan_area(mod->module_core, (unsigned long)mod->trace_events -
> +                          (unsigned long)mod->module_core,
> +                          sizeof(*mod->trace_events) * mod->num_trace_events,
> +                          GFP_KERNEL);
>  #endif
>  #ifdef CONFIG_FTRACE_MCOUNT_RECORD
>        /* sechdrs[0].sh_size is always zero */

Hmm - ok I'll retest this one - meanwhile here is my observation from
your previous post

It looks like this remove leaks from  i915 & kvm
But on the other hand there are ~4 other leaks now reported from
various kernel parts.


>
>> BTW - it's kind of ugly - that module removal destroys stack trace -
>> it would be nice to see some hook for module unload - to eventually
>> create a permanent stack trace for this occasion??
>
> Kmemleak only uses whatever stacktrace mechanism is available in the
> kernel. Resolving the symbol names when objects are allocated would
> slow it down and it takes up more space in the traces. I don't have a
> proper solution.
>

I think that no drastic solutions would need to be deployed in my case.
I would propose something like this:

When you display/resolve  stacktrace  with  cat
/sys/kernel/debug/kmemleak - you could remember decoded stacktraces in
some given buffer - and so next time - you would not need to decode
this stacktrace - and when the module is removed the stacktrace could
be displayed properly.

It's already time costly to keep stacktrace (very noticeable in drm -
where there is permanently something being allocated and deallocated)

IMHO it wouldn't be too time consuming to resolve traces even right
after scan command - as only new objects would need to be decoded.

Obviously it would cost slightly more memory to keep this string
output somewhere - but I think my machine will not miss that much 0.5M
for this purpose.

Zdenek
