Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbZINJmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbZINJmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 05:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbZINJmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 05:42:32 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:53548 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbZINJmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 05:42:31 -0400
Date: Mon, 14 Sep 2009 15:12:31 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix error handling in load_module()
Message-ID: <20090914094231.GA5061@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20090907141558.GA5456@linux.vnet.ibm.com> <20090910141430.a00dcc94.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090910141430.a00dcc94.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2009-09-10 14:14:30]:

> On Mon, 7 Sep 2009 19:45:58 +0530
> Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
> > Hi Rusty,
> > 
> > 	During our testing following call trace was seen. The testcase was
> > to compile the kernel based on the distro config and try to insert all the
> > modules compiled.
> > 
> > #!/bin/sh
> > 
> > for module in `modprobe -l | tr '\n' ' '`
> > do
> > 	insert_module=`basename $module .ko`
> > 	modprobe -v $insert_module
> > done
> > 
<snip>
> > 
> > Once the percpu_modalloc fails, percpu_modfree(mod->refptr) is called on a NULL pointer.
> > We try calling it on a NULL pointer. The following patch fixes the problem by introducing 
> > a check for mod->refptr before calling percpu_modfree.
> 
> Where did it crash and why did it crash?  That trace is pretty unclear.
> 

This was on the powerpc and used to crash after inserting around 790
modules, using the above script. My bad, sorry for unclear call trace.
The kernel was configured with

CONFIG_SMP=y
CONFIG_MODULE_UNLOAD=y
CONFIG_HAVE_DYNAMIC_PER_CPU_AREA=n

Sep  7 15:46:04 mjs22lp5 kernel: yealink: yld-20051230:Yealink phone driver
Sep  7 15:46:04 mjs22lp5 kernel: Could not allocate 8 bytes percpu data
Sep  7 15:46:04 mjs22lp5 kernel: ------------[ cut here ]------------
Sep  7 15:46:04 mjs22lp5 kernel: kernel BUG at kernel/module.c:495!
Sep  7 15:46:04 mjs22lp5 kernel: Oops: Exception in kernel mode, sig: 5 [#8]
Sep  7 15:46:04 mjs22lp5 kernel: SMP NR_CPUS=2048 NUMA pSeries
Sep  7 15:46:04 mjs22lp5 kernel: Modules linked in: <snipped the modules name>
.
.
Sep  7 15:46:04 mjs22lp5 kernel: mveth ibmvscsic scsi_transport_srp scsi_tgt
Sep  7 15:46:04 mjs22lp5 kernel: NIP: c0000000000ebba0 LR: c0000000000ee79c CTR: 0000000000000000
Sep  7 15:46:04 mjs22lp5 kernel: REGS: c00000002c90b8e0 TRAP: 0700 Tainted: P      D     (2.6.31-rc8)
Sep  7 15:46:04 mjs22lp5 kernel: MSR: 8000000000029032 <EE,ME,CE,IR,DR> CR: 24222488  XER: 00000008
Sep  7 15:46:04 mjs22lp5 kernel: TASK = c00000002ff40000[9062] 'modprobe' THREAD: c00000002c908000 CPU: 0
Sep  7 15:46:04 mjs22lp5 kernel: GPR00: 0000000000000010 c00000002c90bb60 c000000001421e68 0000000000000000
Sep  7 15:46:04 mjs22lp5 kernel: GPR04: c000000000691a5c c00000000009f5c4 0000000000000000 c0000000167f6630
Sep  7 15:46:04 mjs22lp5 kernel: GPR08: c0000000167f72a4 000000000000031f c000000000bb9580 000000000000031e
Sep  7 15:46:04 mjs22lp5 kernel: GPR12: 800000000631b800 c0000000015a2600 0000000000000000 0000000000000000
Sep  7 15:46:04 mjs22lp5 kernel: GPR16: 0000000000000033 d00000000fb1f6d0 d00000000fb1fe50 000000000000000e
Sep  7 15:46:04 mjs22lp5 kernel: GPR20: d00000000fb1efb8 d00000000fb62260 d00000000fb00000 8000000000000000
Sep  7 15:46:04 mjs22lp5 kernel: GPR24: 0000000000000004 d00000000fb1f190 0000000000000035 fffffffffffffff4
Sep  7 15:46:04 mjs22lp5 kernel: GPR28: 0000000000000000 000000000000031e c00000000137def8 c00000002c90bb60
Sep  7 15:46:04 mjs22lp5 kernel: NIP [c0000000000ebba0] .percpu_modfree+0xe8/0x210
Sep  7 15:46:04 mjs22lp5 kernel: LR [c0000000000ee79c] .load_module+0x14f8/0x1650
Sep  7 15:46:04 mjs22lp5 kernel: Call Trace:
Sep  7 15:46:04 mjs22lp5 kernel: [c00000002c90bb60] [c00000002c90bc00] 0xc00000002c90bc00 (unreliable)
Sep  7 15:46:04 mjs22lp5 kernel: [c00000002c90bc00] [c0000000000ee79c] .load_module+0x14f8/0x1650
Sep  7 15:46:04 mjs22lp5 kernel: [c00000002c90bd90] [c0000000000ee988] .SyS_init_module+0x94/0x2ac
Sep  7 15:46:04 mjs22lp5 kernel: [c00000002c90be30] [c0000000000084dc] syscall_exit+0x0/0x40
Sep  7 15:46:04 mjs22lp5 kernel: Instruction dump:
Sep  7 15:46:05 mjs22lp5 kernel: 48000038 e8080006 793d0020 39080004 78090020 2f800000 409c000c 7c0000d0
Sep  7 15:46:05 mjs22lp5 kernel: 78090020 7d4a4a14 393d0001 4200ffb0 <0fe00000> 48000000 38a30001 7f83e378
Sep  7 15:46:05 mjs22lp5 kernel: ---[ end trace 3c8bbdf1034c7f0d ]---

> > diff --git a/kernel/module.c b/kernel/module.c
> > index 2d53718..7f89258 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -2379,7 +2379,8 @@ static noinline struct module *load_module(void __user *umod,
> >  	module_unload_free(mod);
> >  #if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
> >   free_init:
> > -	percpu_modfree(mod->refptr);
> > +	if (mod->refptr)
> > +		percpu_modfree(mod->refptr);
> >  #endif
> >  	module_free(mod, mod->module_init);
> >   free_core:
> 
> My reverse engineering of the secret, undocumented percpu_modfree()
> indicates that its mad inventor intended that percpu_modfree(NULL) be a
> valid thing to do.
> 
> It calls free_percpu(), all implementations of which appear to secretly
> support free_percpu(NULL).
> 
> So why did your machine crash?
> 
> This:
> 
> void free_percpu(void *ptr)
> {
> 	void *addr = __pcpu_ptr_to_addr(ptr);
> 	struct pcpu_chunk *chunk;
> 	unsigned long flags;
> 	int off;
> 
> 	if (!ptr)
> 		return;
> 
> is dangerous.  The implementation of __pcpu_ptr_to_addr() can be
> overridden by asm/percpu.h and there's no reason why the compiler won't
> choose to pass a NULL into __pcpu_ptr_to_addr().
> 
> But there doesn't appear to be any overriding of __pcpu_ptr_to_addr()
> in 2.6.31 and the default __pcpu_ptr_to_addr() looks like it will
> handle a NULL pointer OK.
> 
> So again, why did your machine crash?
> 

with CONFIG_HAVE_DYNAMIC_PER_CPU_AREA disabled, the below code path
is called and the BUG() is hit,

static void percpu_modfree(void *freeme)
{
		unsigned int i;
		void *ptr = __per_cpu_start + block_size(pcpu_size[0]);
		int cpu; 

		/* First entry is core kernel percpu data. */
		for (i = 1; i < pcpu_num_used; ptr +=
						block_size(pcpu_size[i]), i++) {
				if (ptr == freeme) {
						pcpu_size[i] = -pcpu_size[i];
						goto free;
				}    
		}    
		BUG(); 

In the patch, the check was introduced before calling percpu_modfree.
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> __pcpu_ptr_to_addr() can be overridden by the architecture and might not
> behave well if passed a NULL pointer.  So avoid calling it until we have
> verified that its arg is not NULL.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/percpu.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff -puN mm/percpu.c~percpu-avoid-calling-__pcpu_ptr_to_addrnull mm/percpu.c
> --- a/mm/percpu.c~percpu-avoid-calling-__pcpu_ptr_to_addrnull
> +++ a/mm/percpu.c
> @@ -957,7 +957,7 @@ static void pcpu_reclaim(struct work_str
>   */
>  void free_percpu(void *ptr)
>  {
> -	void *addr = __pcpu_ptr_to_addr(ptr);
> +	void *addr;
>  	struct pcpu_chunk *chunk;
>  	unsigned long flags;
>  	int off;
> @@ -965,6 +965,8 @@ void free_percpu(void *ptr)
>  	if (!ptr)
>  		return;
> 
> +	addr = __pcpu_ptr_to_addr(ptr);
> +
>  	spin_lock_irqsave(&pcpu_lock, flags);
> 
>  	chunk = pcpu_chunk_addr_search(addr);
> _
> 
			
			Kamalesh
