Return-Path: <linux-kernel-owner+w=401wt.eu-S965635AbXCBVHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965635AbXCBVHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 16:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965636AbXCBVHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 16:07:53 -0500
Received: from jade.aracnet.com ([216.99.193.136]:41411 "EHLO jade.aracnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965635AbXCBVHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 16:07:52 -0500
Message-ID: <45E891E6.7090807@BitWagon.com>
Date: Fri, 02 Mar 2007 13:06:46 -0800
From: John Reiser <jreiser@BitWagon.com>
Organization: -
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + fully-honor-vdso_enabled.patch added to -mm tree
References: <20070301175207.GA849@tv-sign.ru>
In-Reply-To: <20070301175207.GA849@tv-sign.ru>
X-Enigmail-Version: 0.92.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> John Reiser wrote:

>>+	switch (vdso_enabled) {
>>+	case 0:  /* none */
>>+		return 0;
> 
> 
> This means we don't initialize mm->context.vdso and ->sysenter_return.
> 
> Is it ok? For example, setup_rt_frame() uses VDSO_SYM(&__kernel_rt_sigreturn),
> sysenter_past_esp pushes ->sysenter_return on stack.

Paul Mundt has commented on setup_rt_frame() and provided a patch which
bullet-proofs that area.  I will include that patch into the next revision.

The value of ->sysenter_return is interpreted in user space by the
sysexit instruction; nobody else cares what the value is.  The kernel
is not required to provide a good value when vdso_enabled is zero,
because the kernel has not told the process that sysenter is valid
(by setting AT_SYSINFO.)  The kernel requires specific register values
for sysenter+sysexit and these values may change at the whim of the
kernel, so correct code must follow the kernel's protocol.
glibc uses sysenter only when AT_SYSINFO is present.  User code can
screw up even when vdso_enabled is non-zero, by overwriting or re-
mapping the vdso page (clobber memory at the destination of sysexit.)

Both context.vdso and sysenter_return could be set to zero whenever
vdso_enabled is zero; those two values might even be defaulted.
I'll add such a change to the next revision of the patch, if you'll
defend it against claims of "unnecessary code."

> 
> Note also that load_elf_binary does
> 
> 	arch_setup_additional_pages()
> 	create_elf_tables()
> 
> , looks like application can crash after exec if vdso_enabled changes from 0
> to 1 in between.

Correct.  Changing vdso_enabled from 0 to non-zero must be prepared
to lose this race if it is not prevented.  Ordinarily it won't matter
because the administrator will perform such changes at a "quiet" time.

-- 
John Reiser, jreiser@BitWagon.com
