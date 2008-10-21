Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbYJUSgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbYJUSgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 14:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYJUSf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 14:35:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:58565 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbYJUSfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 14:35:55 -0400
Message-ID: <48FE20E1.4060307@windriver.com>
Date: Tue, 21 Oct 2008 13:35:13 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: sonic zhang <sonic.adi@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       kgdb mailing list <kgdb-bugreport@lists.sourceforge.net>
Subject: Re: [PATCH] [kgdb] Switch master cpu after gdb thread command for
 SMP(v2)
References: <1222252155.13662.2.camel@eight.analog.com>
In-Reply-To: <1222252155.13662.2.camel@eight.analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Oct 2008 18:35:13.0671 (UTC) FILETIME=[C1912970:01C933AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



sonic zhang wrote:
>   In blackfin SMP architecture, different core has its own L1 SRAM and MMR
>   memory, which code running on the other core can't access. In current
kgdb
>   impelemntation, cpus are represented by thread with minus prefix.
>
> If user run thread command in gdb to switch to the thread of the other cpu,
> kgdb should:
> 1. send IPI signal to master cpu
> 2. release the specific passive cpu waiting in IPI handler
> 3. exit kgdb exception loop on master cpu and trap into kgdb wait in
IPI handler
> 4. trap the released passive cpu into kgdb exception in IPI handler
>
> This patch is tested on bf561-ezkit board with SMP enabled.
>

It does look better this time around, but the patch does not apply to
the kgdb dev branch.

Hunk #10 FAILED at 1502.
Hunk #11 FAILED at 1518.
Hunk #12 FAILED at 1537.
Hunk #13 FAILED at 1550.
Hunk #14 succeeded at 1584 (offset -12 lines).
4 out of 14 hunks FAILED -- rejects in file kernel/kgdb.c


>
> Signed-off-by: Sonic Zhang <sonic.adi@gmail.com>
> ---
>  include/linux/kgdb.h |   14 +++++++++++
>  kernel/kgdb.c        |   64
+++++++++++++++++++++++++++++++++++++++++++-------
>  2 files changed, 69 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
> index cb8a3d6..4c3fd6c 100644
> --- a/include/linux/kgdb.h
> +++ b/include/linux/kgdb.h
> @@ -107,6 +107,7 @@ struct kgdb_bkpt {
>  #endif
> 
>  #define KGDB_HW_BREAKPOINT    1
> +#define KGDB_THR_PROC_SWAP    2


I can fix this later, but it should have always been
a bit mask indicated by 0x1 0x2...


> --- a/kernel/kgdb.c
> +++ b/kernel/kgdb.c
> @@ -566,6 +566,7 @@ static void kgdb_wait(struct pt_regs *regs)
>  {
>      unsigned long flags;
>      int cpu;
> +    struct task_struct *thread;
> 
>      local_irq_save(flags);
>      cpu = raw_smp_processor_id();
> @@ -578,6 +579,8 @@ static void kgdb_wait(struct pt_regs *regs)
>      smp_wmb();
>      atomic_set(&cpu_in_kgdb[cpu], 1);
> 
> +    kgdb_disable_hw_debug(regs);
> +


Good catch, this is a real arch independent defect,
which should be fixed.



> @@ -1223,7 +1253,13 @@ static int gdb_serial_stub(struct kgdb_state *ks)
>      /* Clear the out buffer. */
>      memset(remcom_out_buffer, 0, sizeof(remcom_out_buffer));
> 
> -    if (kgdb_connected) {
> +    if (kgdb_contthread) {

I thik that check needs to be
   if (arch_kgdb_ops.flags & KGDB_THR_PROC_SWAP &&
       kgdb_contthread)

Although I am not quite certain, and ther was no way to
further look at it since your patch did not apply.

The use of contthread changed a bit in the 2.6.27, as
it was found to not be doing what it was intended.

See commit d7161a65341556bacb5e6654e133803f46f51063
for the details.


> +        remcom_out_buffer[0] = 'O';
> +        remcom_out_buffer[1] = 'K';
> +        remcom_out_buffer[2] = 0;
> +        put_packet(remcom_out_buffer);
> +        kgdb_contthread = NULL;
> +    } else if (kgdb_connected) {
>          unsigned char thref[8];
>          char *ptr;
> 


Jason.
