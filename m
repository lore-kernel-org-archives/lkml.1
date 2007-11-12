Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbXKLM6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbXKLM6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 07:58:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755045AbXKLM56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 07:57:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944AbXKLM56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 07:57:58 -0500
Message-ID: <47384D34.6070000@redhat.com>
Date: Mon, 12 Nov 2007 07:55:16 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, tglx@tglx.de, mingo@elte.hu, hpa@zytor.com,
       ananth@in.ibm.com
Subject: Re: [patch] prepare kprobes code for x86 unification
References: <20071024150047.4144fda0@laptopd505.fenrus.org>
In-Reply-To: <20071024150047.4144fda0@laptopd505.fenrus.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

Arjan van de Ven wrote:
> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: prepare kprobes code for x86 unification
> 
> This patch is a first step towards unification of the kprobes
> infrastructure between 32 and 64 bit x86; the patch is mostly
> about removing spurious whitespace changes and about adding
> harmless includes and the like to make the 32/64 files more
> identical.
> 
> Signed-off-by: Arjan van de Ven

I got a bug in this patch. In kprobes_64.c, Since this added __kprobes
to kretprobe_trampoline_holder(), the arch_init_kprobes() failed to
insert a kprobe into that function, and the initialization was failed.
This means that kprobe_exceptions_notify() was not registered to
die_notifier_chain. So, it caused a kernel crash.

> @@ -385,7 +428,7 @@ no_kprobe:
>   * here. When a retprobed function returns, this probe is hit and
>   * trampoline_probe_handler() runs, calling the kretprobe's handler.
>   */
> - void kretprobe_trampoline_holder(void)
> + void __kprobes kretprobe_trampoline_holder(void)
>   {
>   	asm volatile (  ".global kretprobe_trampoline\n"
>   			"kretprobe_trampoline: \n"

On i386, I introduced kretprobe-booster, which did not need to insert
a kprobe. Thus, I also added __kprobes to kretprobe_trampoline_holder()
on i386.

I think we can remove __kprobes from kretprobe_trampoline_holder()
in kprobes_32.c if you'd like to make the both same. However, it
is not safe. So we need a comment on top explaining why it does not
have that annotation and users must take care of it.

By the way, I'm porting boosters to x86-64 (and ia64). Since some parts
of that will be covered by this patch, I'd like to know your unification
plan.

Best regards,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

