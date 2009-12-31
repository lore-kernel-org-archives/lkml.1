Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbZLaCpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbZLaCpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 21:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbZLaCpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 21:45:45 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:60233 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbZLaCpo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 21:45:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M1uVnW7Vwhe5L8Df6jqsyx3BxlAp7s2tDC2uZiJqqHm9lKV65nlQAJCDswcoubPpMh
         P403AuBpgQg+qRE7L3hfpG3b2FmoRNhn10N9XqxChNsATJCZaF1ZG45xmcvsDJqF0tRg
         uwLxgdkTQKzkSoRadTQklD/DSpoCYUr2jj7FQ=
MIME-Version: 1.0
In-Reply-To: <0F1B54C89D5F954D8535DB252AF412FA0553E3A0@chinexm1.ad.analog.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
	 <1261603190-5036-4-git-send-email-jason.wessel@windriver.com>
	 <1261603190-5036-5-git-send-email-jason.wessel@windriver.com>
	 <1261603190-5036-6-git-send-email-jason.wessel@windriver.com>
	 <1261603190-5036-7-git-send-email-jason.wessel@windriver.com>
	 <1261603190-5036-8-git-send-email-jason.wessel@windriver.com>
	 <1261603190-5036-9-git-send-email-jason.wessel@windriver.com>
	 <1261603190-5036-10-git-send-email-jason.wessel@windriver.com>
	 <8bd0f97a0912261312x4b7c7df6s14ac0137b702044e@mail.gmail.com>
	 <0F1B54C89D5F954D8535DB252AF412FA0553E3A0@chinexm1.ad.analog.com>
Date: Thu, 31 Dec 2009 10:45:43 +0800
Message-ID: <4e5ebad50912301845p35b1ea98l2f91c2a209ee863a@mail.gmail.com>
Subject: Re: [PATCH 09/37] kgdb,blackfin: Add in kgdb_arch_set_pc for blackfin
From: Sonic Zhang <sonic.adi@gmail.com>
To: "Zhang, Sonic" <Sonic.Zhang@analog.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have to recall my last wrong patch.

In blackfin, kgdb is running in delayed exception IRQ5 other than in
exception IRQ3 directly.  Register reti other than retx in pt_regs is
the kgdb return address. So, don't put PC in gdb_regs into retx.

Sonic Zhang

Index: arch/blackfin/kernel/kgdb.c
============================
--- arch/blackfin/kernel/kgdb.c	(revision 8105)
+++ arch/blackfin/kernel/kgdb.c	(revision 8106)
@@ -147,7 +147,7 @@
 	regs->lb1 = gdb_regs[BFIN_LB1];
 	regs->usp = gdb_regs[BFIN_USP];
 	regs->syscfg = gdb_regs[BFIN_SYSCFG];
-	regs->retx = gdb_regs[BFIN_PC];
+	regs->retx = gdb_regs[BFIN_RETX];
 	regs->retn = gdb_regs[BFIN_RETN];
 	regs->rete = gdb_regs[BFIN_RETE];
 	regs->pc = gdb_regs[BFIN_PC];



On Mon, Dec 28, 2009 at 6:17 PM, Zhang, Sonic <Sonic.Zhang@analog.com> wrote:
> A little update.
>
> GDB uses field BFIN_PC as the resume address from debugging mode. But, field pc in struct pt_regs is where kernel resumes from an interrupt. So, BFIN_PC is actually retx when do kernel debugging.
>
>
> Sonic
>
>
> --- trunk/arch/blackfin/kernel/kgdb.c   2009-12-28 09:27:27 UTC (rev 8085)
> +++ trunk/arch/blackfin/kernel/kgdb.c   2009-12-28 10:08:30 UTC (rev 8086)
> @@ -79,7 +79,7 @@
>        gdb_regs[BFIN_RETX] = regs->retx;
>        gdb_regs[BFIN_RETN] = regs->retn;
>        gdb_regs[BFIN_RETE] = regs->rete;
> -       gdb_regs[BFIN_PC] = regs->pc;
> +       gdb_regs[BFIN_PC] = regs->retx;
>        gdb_regs[BFIN_CC] = 0;
>        gdb_regs[BFIN_EXTRA1] = 0;
>        gdb_regs[BFIN_EXTRA2] = 0;
> @@ -150,7 +150,7 @@
>        regs->retx = gdb_regs[BFIN_PC];
>        regs->retn = gdb_regs[BFIN_RETN];
>        regs->rete = gdb_regs[BFIN_RETE];
> -       regs->pc = gdb_regs[BFIN_PC];
> +       regs->pc = gdb_regs[BFIN_RETI];
>
>  #if 0                          /* can't change these */
>        regs->astat = gdb_regs[BFIN_ASTAT];
>
>
>
>
> -----Original Message-----
> From: Mike Frysinger [mailto:vapier.adi@gmail.com]
> Sent: Sunday, December 27, 2009 5:12 AM
> To: Jason Wessel
> Cc: linux-kernel@vger.kernel.org; kgdb-bugreport@lists.sourceforge.net; kdb@oss.sgi.com; mingo@elte.hu; Zhang, Sonic
> Subject: Re: [PATCH 09/37] kgdb,blackfin: Add in kgdb_arch_set_pc for blackfin
>
> On Wed, Dec 23, 2009 at 16:19, Jason Wessel wrote:
>> The new debug core api requires all architectures that use to debug
>> core to implement a function to set the program counter.
>>
>> CC: Mike Frysinger <vapier@gentoo.org>
>> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
>> ---
>>  arch/blackfin/kernel/kgdb.c |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/blackfin/kernel/kgdb.c b/arch/blackfin/kernel/kgdb.c
>> index f1036b6..5965188 100644
>> --- a/arch/blackfin/kernel/kgdb.c
>> +++ b/arch/blackfin/kernel/kgdb.c
>> @@ -644,6 +644,11 @@ int kgdb_arch_remove_breakpoint(unsigned long
>> addr, char *bundle)
>>        return bfin_probe_kernel_write((char *)addr, bundle,
>> BREAK_INSTR_SIZE);
>>  }
>>
>> +void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip) {
>> +       regs->retx = ip;
>> +}
>> +
>>  int kgdb_arch_init(void)
>>  {
>>        kgdb_single_step = 0;
>
> Sonic should be able to check this.  our pc handling seems a little wonky atm:
>
> arch/blackfin/kernel/kgdb.c:
> void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs) { ...
>    gdb_regs[BFIN_RETI] = regs->pc;
>    gdb_regs[BFIN_RETX] = regs->retx;
>    gdb_regs[BFIN_PC] = regs->pc;
> ...
> }
> ...
> void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs) { ...
>    regs->pc = gdb_regs[BFIN_PC];
>    regs->retx = gdb_regs[BFIN_PC];
>    /* nothing for BFIN_RETI */
> ...
> }
> -mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
