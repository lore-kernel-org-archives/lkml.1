Return-Path: <linux-kernel-owner+w=401wt.eu-S935376AbXLQKkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935376AbXLQKkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 05:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765008AbXLQKkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 05:40:35 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:4309 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764394AbXLQKke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 05:40:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=L+4e4bbq3ktDNFL2y1v81OI6nvYM8y3Ae5Q0eV/on5bGTVNfYm/fHk5NYt+TRyWuZbga5rB+FUcpfxix6DJ8+paMpBCFMyPfYrrqcAblBl7XqI52wUkq0X1uwILeg3bn0/JfNp20KyqoJpIh046JMIXNoaCBTJh3P1XZ7AxjamE=
Message-ID: <6278d2220712170240h1d7b799djf50b6cb4ea47c38@mail.gmail.com>
Date: Mon, 17 Dec 2007 10:40:33 +0000
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: PAT 64b: Basic PAT implementation
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Dec, 00:50, Andi Kleen <a...@muc.de> wrote:
> > +void __cpuinit pat_init(void)
> > +{
> > +  /* Set PWT+PCD to Write-Combining. All other bits stay the same */
> > +  if (cpu_has_pat) {
>
> All the old CPUs (PPro etc.) with known PAT bugs need to clear this flag
> now in their CPU init functions. It is fine to be aggressive there
> because these old systems have lived so long without PAT they can do
> so forever. So perhaps it's best to just white list it only for newer
> CPUs on the Intel side at least.

> Another problem is that there are some popular modules (ATI, Nvidia for once)
> who reprogram the PAT registers on their own, likely different. Need some way to detect
> that case I guess, otherwise lots of users will see strange malfunctions.
> Maybe recheck after module load?

This may not be as big problem as thought, since sane and at least one
vendor driver (Quadrics QsNetII) searches the PAT slots for a WC entry
- where this has already been setup by the kernel, it'll use the right
one.

> > +                   |||
> > +             000 WB         default
> > +             010 UC_MINUS   _PAGE_PCD
> > +             011 WC         _PAGE_WC
> > +             PAT bit unused */
> > +          pat = PAT(0,WB) | PAT(1,WT) | PAT(2,UC_MINUS) | PAT(3,WC) |
> > +                PAT(4,WB) | PAT(5,WT) | PAT(6,UC_MINUS) | PAT(7,WC);
> > +          rdmsrl(MSR_IA32_CR_PAT, boot_pat_state);
> > +          wrmsrl(MSR_IA32_CR_PAT, pat);
> > +          __flush_tlb_all();
> > +          asm volatile("wbinvd");
>
> Have you double checked this is the full procedure from the manual? iirc there
> were some steps missing.
>
> -Andi
-- 
Daniel J Blueman
