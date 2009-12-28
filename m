Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbZL1Jou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbZL1Jou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 04:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbZL1Jot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 04:44:49 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:57719 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbZL1Jot convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 04:44:49 -0500
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
X-IronPort-AV: E=Sophos;i="4.47,461,1257138000"; 
   d="scan'208";a="9451782"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 09/37] kgdb,blackfin: Add in kgdb_arch_set_pc for blackfin
Date: Mon, 28 Dec 2009 17:49:15 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA0553E367@chinexm1.ad.analog.com>
In-Reply-To: <8bd0f97a0912261312x4b7c7df6s14ac0137b702044e@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 09/37] kgdb,blackfin: Add in kgdb_arch_set_pc for blackfin
Thread-Index: AcqGcCfI8PfSjo8ZQ3SJCF39GAgpCwBLvsQg
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com> <1261603190-5036-2-git-send-email-jason.wessel@windriver.com> <1261603190-5036-3-git-send-email-jason.wessel@windriver.com> <1261603190-5036-4-git-send-email-jason.wessel@windriver.com> <1261603190-5036-5-git-send-email-jason.wessel@windriver.com> <1261603190-5036-6-git-send-email-jason.wessel@windriver.com> <1261603190-5036-7-git-send-email-jason.wessel@windriver.com> <1261603190-5036-8-git-send-email-jason.wessel@windriver.com> <1261603190-5036-9-git-send-email-jason.wessel@windriver.com> <1261603190-5036-10-git-send-email-jason.wessel@windriver.com> <8bd0f97a0912261312x4b7c7df6s14ac0137b702044e@mail.gmail.com>
To: "Mike Frysinger" <vapier.adi@gmail.com>,
       "Jason Wessel" <jason.wessel@windriver.com>
CC: <linux-kernel@vger.kernel.org>, <kgdb-bugreport@lists.sourceforge.net>,
       <kdb@oss.sgi.com>, <mingo@elte.hu>
X-OriginalArrivalTime: 28 Dec 2009 09:44:47.0754 (UTC) FILETIME=[64B55EA0:01CA87A2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no wonky.

Field pc in blackfin struct pt_regs is the same as reti register. 
    gdb_regs[BFIN_RETI] = regs->pc;

Field BFIN_PC in array gdb_regs contains the address which gdb thinks the kernel should resume from. And field retx is the resume address on current kernel stack.
    regs->retx = gdb_regs[BFIN_PC];


Jason's patch is fine to me.


Sonic


-----Original Message-----
From: Mike Frysinger [mailto:vapier.adi@gmail.com] 
Sent: Sunday, December 27, 2009 5:12 AM
To: Jason Wessel
Cc: linux-kernel@vger.kernel.org; kgdb-bugreport@lists.sourceforge.net; kdb@oss.sgi.com; mingo@elte.hu; Zhang, Sonic
Subject: Re: [PATCH 09/37] kgdb,blackfin: Add in kgdb_arch_set_pc for blackfin

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
> @@ -644,6 +644,11 @@ int kgdb_arch_remove_breakpoint(unsigned long 
> addr, char *bundle)
>        return bfin_probe_kernel_write((char *)addr, bundle, 
> BREAK_INSTR_SIZE);
>  }
>
> +void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip) {
> +       regs->retx = ip;
> +}
> +
>  int kgdb_arch_init(void)
>  {
>        kgdb_single_step = 0;

Sonic should be able to check this.  our pc handling seems a little wonky atm:

arch/blackfin/kernel/kgdb.c:
void pt_regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs) { ...
    gdb_regs[BFIN_RETI] = regs->pc;
    gdb_regs[BFIN_RETX] = regs->retx;
    gdb_regs[BFIN_PC] = regs->pc;
...
}
...
void gdb_regs_to_pt_regs(unsigned long *gdb_regs, struct pt_regs *regs) { ...
    regs->pc = gdb_regs[BFIN_PC];
    regs->retx = gdb_regs[BFIN_PC];
    /* nothing for BFIN_RETI */
...
}
-mike
