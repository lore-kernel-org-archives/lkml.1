Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbYKIKVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbYKIKVX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 05:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbYKIKVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 05:21:14 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:53583 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753812AbYKIKVM convert rfc822-to-8bit
	(ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 05:21:12 -0500
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: linux-rt-users@vger.kernel.org
Date: Sun, 9 Nov 2008 11:20:58 +0100
User-Agent: KMail/1.9.9
Cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       LKML <Linux-kernel@vger.kernel.org>, Tony Jones <tonyj@suse.de>
References: <1226092407.5685.7.camel@dd>
In-Reply-To: <1226092407.5685.7.camel@dd>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811091121.00213.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 83.236.181.29
X-SA-Exim-Mail-From: jbe@pengutronix.de
Subject: Re: [PATCH][RT] Dereference pointer to cpu id, not to address of CPUID
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.extern.pengutronix.de)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Freitag, 7. November 2008, Sven-Thorsten Dietrich wrote:
> This patch applies to 2.6.25-rt, 2.6.26-rt and 2.6.27-rt
>
> From: Sven-Thorsten Dietrich <sdietrich@suse.de>
> Subject: Dereference pointer to cpu id, when evaluating condition.
>
> Without dereferencing, the condition always evaluates to true.
>
> Signed-off-by: Sven-Thorsten Dietrich <sdietrich@suse.de>
> ---
>  mm/slab.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2033,7 +2033,7 @@ slab_destroy(struct kmem_cache *cachep,
>  	} else {
>  		kmem_freepages(cachep, addr);
>  		if (OFF_SLAB(cachep)) {
> -			if (this_cpu)
> +			if (*this_cpu)
>  				__cache_free(cachep->slabp_cache, slabp, this_cpu);
>  			else
>  				kmem_cache_free(cachep->slabp_cache, slabp);

When I use this patch, I get the following (architecture is PowerPC MPC5200B):

Oops: Exception in kernel mode, sig: 5 [#1]
PREEMPT ksp0058
Modules linked in:
NIP: c01bdda4 LR: c006f60c CTR: 00000000
REGS: c1845db0 TRAP: 0700   Not tainted  (2.6.26.7-rt11-ptx-trunk)
MSR: 00021032 <ME,IR,DR>  CR: 82002028  XER: 00000000
TASK = c183b0b0[15] 'events/0' THREAD: c1844000
GPR00: 00000001 c1845e60 c183b0b0 c028ac60 c1a23de0 00009032 c02ca680 c02d6000
GPR08: c183b0b0 00000001 c028ac60 c183b0b0 c1a35000 ffffffff 01ffe000 ffffffff
GPR16: 00000001 c027d000 c026019c c0260000 c026019c c1821f98 00000000 00000002
GPR24: 00100100 00200200 c1800540 c028ac60 c1844000 c028ac60 c1802490 c1802480
NIP [c01bdda4] rt_spin_lock_slowlock+0x5c/0x26c
LR [c006f60c] kmem_cache_free+0x30/0x5c
Call Trace:
[c1845e60] [c01bbea0] preempt_schedule_irq+0x70/0xa0 (unreliable)
[c1845ed0] [c006f60c] kmem_cache_free+0x30/0x5c
[c1845f00] [c006fb58] drain_freelist+0x88/0x108
[c1845f40] [c0070f4c] cache_reap+0x100/0x140
[c1845f60] [c002fe84] run_workqueue+0x13c/0x240
[c1845f90] [c0030620] worker_thread+0x74/0xd4
[c1845fd0] [c0034468] kthread+0x48/0x84
[c1845ff0] [c000fcdc] kernel_thread+0x44/0x60
Instruction dump:
543c0024 813c000c 39290001 913c000c 80030004 2f800000 419e01f4 801b0010
5400003a 7c001278 7c000034 5400d97e <0f000000> 38800001 7f63db78 83220000
Oops: Exception in kernel mode, sig: 5 [#2]
PREEMPT ksp0058
Modules linked in:
NIP: c01bdda4 LR: c006f60c CTR: 00000000
REGS: c1845ab0 TRAP: 0700   Tainted: G      D    (2.6.26.7-rt11-ptx-trunk)
MSR: 00021032 <ME,IR,DR>  CR: 84008048  XER: 20000000
TASK = c183b0b0[15] 'events/0' THREAD: c1844000
GPR00: 00000001 c1845b60 c183b0b0 c028ac60 c1842580 00001032 c0260148 c0260144
GPR08: c183b0b0 00000002 c028ac60 c183b0b0 c1835710 ffffffff 01ffe000 ffffffff
GPR16: 00000001 c027d000 c026019c c0260000 c026019c c1821f98 c0020000 c0280000
GPR24: c0280000 c1844000 c1842580 c028ac60 c1844000 c028ac60 c1835580 c183b0b0
NIP [c01bdda4] rt_spin_lock_slowlock+0x5c/0x26c
LR [c006f60c] kmem_cache_free+0x30/0x5c
Call Trace:
[c1845b60] [0000000f] 0xf (unreliable)
[c1845bd0] [c006f60c] kmem_cache_free+0x30/0x5c
[c1845c00] [c001aae0] __cleanup_sighand+0x34/0x44
[c1845c10] [c001fefc] release_task+0x23c/0x3b4
[c1845c50] [c00214b4] do_exit+0x5e8/0x66c
[c1845c90] [c000de78] kernel_bad_stack+0x0/0x4c
[c1845cb0] [c000e128] _exception+0x16c/0x180
[c1845da0] [c00104e8] ret_from_except_full+0x0/0x4c
--- Exception: 700 at rt_spin_lock_slowlock+0x5c/0x26c
    LR = kmem_cache_free+0x30/0x5c
[c1845e60] [c01bbea0] preempt_schedule_irq+0x70/0xa0 (unreliable)
[c1845ed0] [c006f60c] kmem_cache_free+0x30/0x5c
[c1845f00] [c006fb58] drain_freelist+0x88/0x108
[c1845f40] [c0070f4c] cache_reap+0x100/0x140
[c1845f60] [c002fe84] run_workqueue+0x13c/0x240
[c1845f90] [c0030620] worker_thread+0x74/0xd4
[c1845fd0] [c0034468] kthread+0x48/0x84
[c1845ff0] [c000fcdc] kernel_thread+0x44/0x60
Instruction dump:
543c0024 813c000c 39290001 913c000c 80030004 2f800000 419e01f4 801b0010
5400003a 7c001278 7c000034 5400d97e <0f000000> 38800001 7f63db78 83220000

It happens immediately after the system shows the login prompt.

jbe

-- 
Dipl.-Ing. Juergen Beisert | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
    Handelsregister: Amtsgericht Hildesheim, HRA 2686
         Vertretung Sued/Muenchen, Germany
   Phone: +49-8766-939 228 |  Fax: +49-5121-206917-9
