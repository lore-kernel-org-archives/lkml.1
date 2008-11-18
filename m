Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbYKRRf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbYKRRf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYKRRfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:35:18 -0500
Received: from gv-out-0910.google.com ([216.239.58.184]:50146 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbYKRRfQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:35:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:content-disposition:from:date:cc:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=pf5IZbMcPc5CMtxmyb7P28dXB0HKxkwdUfvkzBPbC0YSB220kv8qPzg9EDOwgh9iUV
         CJe6p9O9BoXenadhVfK5m9NR8tnGeMPhct54trDwQsjgzm2LWnYJLPCYF1/XFiSEzlfD
         1WZF13klvrIO8jzyNuLae5zrELsjTAiPrA7Vs=
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [x86] do_arch_prctl - bug?
Content-Disposition: inline
From: Eric Lacombe <goretux@gmail.com>
Date: Tue, 18 Nov 2008 18:35:07 +0100
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200811181835.07360.goretux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 18 novembre 2008 15:45:56, vous avez écrit :
> On Tue, 18 Nov 2008 15:33:32 +0100
>
> Eric Lacombe <goretux@gmail.com> wrote:
> > Hello,
> >
> > I would like to know why the ARCH_SET_GS action of sys_arch_prctl,
> > write the MSR MSR_KERNEL_GS_BASE and not the MSR MSR_GS_BASE when the
> > variable "doit" equals 1? Is that a bug?
>
> I don't think it is.
> The trick is that we use "swapgs" on entering/leaving the kernel, and
> that will "swap" gs with the MSR, so when we return to userspace, GS
> gets loaded from the MSR_KERNEL_GS_BASE ...

Yeah when we enter the kernel swapgs is used, so the MSR_GS_BASE is switched 
with the MSR_KERNEL_GS_BASE.

In fact, what I certainly misunderstand is why load_gs_index use swapgs 
inside.
>From that function, I trust that only when gs is loaded, its hidden part is 
loaded with the MSR_GS_BASE.

ENTRY(native_load_gs_index)
        CFI_STARTPROC
        pushf
        CFI_ADJUST_CFA_OFFSET 8
        DISABLE_INTERRUPTS(CLBR_ANY | ~(CLBR_RDI))
        SWAPGS
gs_change:     
        movl %edi,%gs   
2:      mfence          /* workaround */
        SWAPGS
        popf
        CFI_ADJUST_CFA_OFFSET -8
        ret
        CFI_ENDPROC
ENDPROC(native_load_gs_index)

Regards,

	Eric

