Return-Path: <linux-kernel-owner+w=401wt.eu-S1752010AbZLZVMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbZLZVMh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 16:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbZLZVMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 16:12:36 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:34623 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbZLZVMf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 16:12:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ItGv9B5CiPSb31LVIW5ewI7v2bMf88Fm/hkQNkXxF2/gpiA79u/KR8qDGEzAP0x/ky
         TMEnII3Nuhr+7x3PXZkwkqlV4PUv/K+SqCr0p82NBadTcOqvInegFLhvqQ0wRD56AXnt
         AxHe4FrLs3vqaakDiu1522AToCbOGW9QqUPXE=
MIME-Version: 1.0
In-Reply-To: <1261603190-5036-10-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com> 
	<1261603190-5036-2-git-send-email-jason.wessel@windriver.com> 
	<1261603190-5036-3-git-send-email-jason.wessel@windriver.com> 
	<1261603190-5036-4-git-send-email-jason.wessel@windriver.com> 
	<1261603190-5036-5-git-send-email-jason.wessel@windriver.com> 
	<1261603190-5036-6-git-send-email-jason.wessel@windriver.com> 
	<1261603190-5036-7-git-send-email-jason.wessel@windriver.com> 
	<1261603190-5036-8-git-send-email-jason.wessel@windriver.com> 
	<1261603190-5036-9-git-send-email-jason.wessel@windriver.com> 
	<1261603190-5036-10-git-send-email-jason.wessel@windriver.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 26 Dec 2009 16:12:13 -0500
Message-ID: <8bd0f97a0912261312x4b7c7df6s14ac0137b702044e@mail.gmail.com>
Subject: Re: [PATCH 09/37] kgdb,blackfin: Add in kgdb_arch_set_pc for blackfin
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       kdb@oss.sgi.com, mingo@elte.hu, Sonic Zhang <Sonic.Zhang@analog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 16:19, Jason Wessel wrote:
> The new debug core api requires all architectures that use to debug
> core to implement a function to set the program counter.
>
> CC: Mike Frysinger <vapier@gentoo.org>
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> ---
>  arch/blackfin/kernel/kgdb.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/arch/blackfin/kernel/kgdb.c b/arch/blackfin/kernel/kgdb.c
> index f1036b6..5965188 100644
> --- a/arch/blackfin/kernel/kgdb.c
> +++ b/arch/blackfin/kernel/kgdb.c
> @@ -644,6 +644,11 @@ int kgdb_arch_remove_breakpoint(unsigned long addr, char *bundle)
>        return bfin_probe_kernel_write((char *)addr, bundle, BREAK_INSTR_SIZE);
>  }
>
> +void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
> +{
> +       regs->retx = ip;
> +}
> +
>  int kgdb_arch_init(void)
>  {
>        kgdb_single_step = 0;

Sonic should be able to check this.  our pc handling seems a little wonky atm:

arch/blackfin/kernel/kgdb.c:
void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
{
...
    gdb_regs[BFIN_RETI] = regs->pc;
    gdb_regs[BFIN_RETX] = regs->retx;
    gdb_regs[BFIN_PC] = regs->pc;
...
}
...
void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs)
{
...
    regs->pc = gdb_regs[BFIN_PC];
    regs->retx = gdb_regs[BFIN_PC];
    /* nothing for BFIN_RETI */
...
}
-mike
