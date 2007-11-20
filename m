Return-Path: <linux-kernel-owner+w=401wt.eu-S1760470AbXKTND0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760470AbXKTND0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 08:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755714AbXKTNDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 08:03:18 -0500
Received: from tomts25.bellnexxia.net ([209.226.175.188]:37837 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375AbXKTNDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 08:03:17 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAN1pQkdMROHU/2dsb2JhbACBWw
Date: Tue, 20 Nov 2007 08:03:15 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: clameter@sgi.com
Cc: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 12/45] cpu alloc: crash_notes conversion
Message-ID: <20071120130315.GF10127@Krystal>
References: <20071120011132.143632442@sgi.com> <20071120011334.564309282@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071120011334.564309282@sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:02:58 up 16 days, 18:08,  2 users,  load average: 0.51, 1.32,
	2.03
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* clameter@sgi.com (clameter@sgi.com) wrote:
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> ---
>  arch/ia64/kernel/crash.c |    2 +-
>  drivers/base/cpu.c       |    2 +-
>  kernel/kexec.c           |    4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/arch/ia64/kernel/crash.c
> ===================================================================
> --- linux-2.6.orig/arch/ia64/kernel/crash.c	2007-11-15 21:18:10.647904573 -0800
> +++ linux-2.6/arch/ia64/kernel/crash.c	2007-11-15 21:25:29.423155123 -0800
> @@ -71,7 +71,7 @@ crash_save_this_cpu(void)
>  	dst[46] = (unsigned long)ia64_rse_skip_regs((unsigned long *)dst[46],
>  			sof - sol);
>  
> -	buf = (u64 *) per_cpu_ptr(crash_notes, cpu);
> +	buf = (u64 *) CPU_PTR(crash_notes, cpu);
>  	if (!buf)
>  		return;
>  	buf = append_elf_note(buf, KEXEC_CORE_NOTE_NAME, NT_PRSTATUS, prstatus,
> Index: linux-2.6/drivers/base/cpu.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/cpu.c	2007-11-15 21:18:10.655904442 -0800
> +++ linux-2.6/drivers/base/cpu.c	2007-11-15 21:25:29.423155123 -0800
> @@ -95,7 +95,7 @@ static ssize_t show_crash_notes(struct s
>  	 * boot up and this data does not change there after. Hence this
>  	 * operation should be safe. No locking required.
>  	 */
> -	addr = __pa(per_cpu_ptr(crash_notes, cpunum));
> +	addr = __pa(CPU_PTR(crash_notes, cpunum));
>  	rc = sprintf(buf, "%Lx\n", addr);
>  	return rc;
>  }
> Index: linux-2.6/kernel/kexec.c
> ===================================================================
> --- linux-2.6.orig/kernel/kexec.c	2007-11-15 21:18:10.663904549 -0800
> +++ linux-2.6/kernel/kexec.c	2007-11-15 21:25:29.423155123 -0800
> @@ -1122,7 +1122,7 @@ void crash_save_cpu(struct pt_regs *regs
>  	 * squirrelled away.  ELF notes happen to provide
>  	 * all of that, so there is no need to invent something new.
>  	 */
> -	buf = (u32*)per_cpu_ptr(crash_notes, cpu);
> +	buf = (u32*)CPU_PTR(crash_notes, cpu);

Nitpick : (u32 *)

>  	if (!buf)
>  		return;
>  	memset(&prstatus, 0, sizeof(prstatus));
> @@ -1136,7 +1136,7 @@ void crash_save_cpu(struct pt_regs *regs
>  static int __init crash_notes_memory_init(void)
>  {
>  	/* Allocate memory for saving cpu registers. */
> -	crash_notes = alloc_percpu(note_buf_t);
> +	crash_notes = CPU_ALLOC(note_buf_t, GFP_KERNEL|__GFP_ZERO);
>  	if (!crash_notes) {
>  		printk("Kexec: Memory allocation for saving cpu register"
>  		" states failed\n");
> 
> -- 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
