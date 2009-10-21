Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbZJUPx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbZJUPx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 11:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbZJUPx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 11:53:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034AbZJUPx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 11:53:58 -0400
Message-ID: <4ADF2F6F.1040300@redhat.com>
Date: Wed, 21 Oct 2009 11:57:35 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Jim Keniston <jkenisto@us.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip perf/probes 0/2] x86 insn decoder bugfixes
References: <20091020165518.4145.94115.stgit@dhcp-100-2-132.bos.redhat.com> <20091021112619.GA16586@elte.hu> <20091021122131.GA20626@elte.hu> <4ADF1E0B.5010708@redhat.com>
In-Reply-To: <4ADF1E0B.5010708@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Ingo Molnar wrote:
>>
>> there's still build failures:
>>
>>     TEST    posttest
>>    Error: ffffffff8103b917:        c5 59 fc ff             vpaddb %xmm7,%xmm4,%xmm15
>>    Error: objdump says 4 bytes, but insn_get_length() says 3 (attr:8000)
>>    make[1]: *** [posttest] Error 2
>>    make: *** [bzImage] Error 2
> 
> Aah, that's the AVX code...
> I assume, random-data-byte-sequence in the kernel binary
> contains it.

Hmm, I've found the actual code.

ffffffff81043917 <xen_sysret32_reloc>:
ffffffff81043917:       c5 59 fc ff             vpaddb %xmm7,%xmm4,%xmm15

---
ENTRY(xen_sysret32)
        /*
         * We're already on the usermode stack at this point, but
         * still with the kernel gs, so we can easily switch back
         */
        movq %rsp, PER_CPU_VAR(old_rsp)
        movq PER_CPU_VAR(kernel_stack), %rsp

        pushq $__USER32_DS
        pushq PER_CPU_VAR(old_rsp)
        pushq %r11
        pushq $__USER32_CS
        pushq %rcx

        pushq $VGCF_in_syscall
1:      jmp hypercall_iret
ENDPATCH(xen_sysret32)
RELOC(xen_sysret32, 1b+1)
---
#define RELOC(x, v)     .globl x##_reloc; x##_reloc=v
---

OK, it's not a random, but a data in kernel text.
Anyway, I'll add AVX support then.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

