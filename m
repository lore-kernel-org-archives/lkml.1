Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbYHLLnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbYHLLnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 07:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbYHLLn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 07:43:28 -0400
Received: from mailin.studentenwerk.mhn.de ([141.84.225.229]:50339 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751433AbYHLLnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 07:43:25 -0400
From: Wolfgang Walter <wolfgang.walter@stwm.de>
Organization: Studentenwerk =?utf-8?q?M=C3=BCnchen?=
To: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Date: Tue, 12 Aug 2008 13:43:22 +0200
User-Agent: KMail/1.9.9
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "viro@ZenIV.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "vegard.nossum@gmail.com" <vegard.nossum@gmail.com>
References: <200807171653.59177.wolfgang.walter@stwm.de> <20080810030521.GA2332@gondor.apana.org.au> <20080811190131.GL13158@linux-os.sc.intel.com>
In-Reply-To: <20080811190131.GL13158@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200808121343.22892.wolfgang.walter@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 August 2008, Suresh Siddha wrote:
> On Sat, Aug 09, 2008 at 08:05:21PM -0700, Herbert Xu wrote:
> > > void irq_ts_restore(int TS_state)
> > > {
> > >       if (!in_interrupt())
> > >               return 0;
> > 
> > This check isn't necessary.
> > 
> > >
> > >       if (TS_state)
> > >               stts();
> > > }
> > 
> > But yes this scheme looks good to me.
> 
> Appended the complete patch. Wolf, can you please help test this again
> and check the perf aswell.
> 
> > > kernel_fpu_begin:
> > >       ...
> > >
> > >       local_irq_disable();
> > >
> > >         if (me->status & TS_USEDFPU)
> > >                 __save_init_fpu(me->task);
> > >         else
> > >                 clts();
> > >
> > >       local_irq_enable();
> > >       ...
> > 
> > Couldn't we just move clts before the USEDFPU check? That huld
> > close the window.
> 
> you are correct. as pre-emption is already disabled, we should be ok. But
> given that we are taking another(clean) route to fix this issue, can leave the
> current code as it is(and not do an unconditional clts()).
> ---
> 
> [patch] fix via padlock instruction usage with irq_ts_save/restore()
> 
> Wolfgang Walter reported this oops on his via C3 using padlock for
> AES-encryption:
> 
> ##################################################################
> 
> BUG: unable to handle kernel NULL pointer dereference at 000001f0
> IP: [<c01028c5>] __switch_to+0x30/0x117
> *pde = 00000000
> Oops: 0002 [#1] PREEMPT
> Modules linked in:
> 
> Pid: 2071, comm: sleep Not tainted (2.6.26 #11)
> EIP: 0060:[<c01028c5>] EFLAGS: 00010002 CPU: 0
> EIP is at __switch_to+0x30/0x117
> EAX: 00000000 EBX: c0493300 ECX: dc48dd00 EDX: c0493300
> ESI: dc48dd00 EDI: c0493530 EBP: c04cff8c ESP: c04cff7c
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process sleep (pid: 2071, ti=c04ce000 task=dc48dd00 task.ti=d2fe6000)
> Stack: dc48df30 c0493300 00000000 00000000 d2fe7f44 c03b5b43 c04cffc8 00000046
>        c0131856 0000005a dc472d3c c0493300 c0493470 d983ae00 00002696 00000000
>        c0239f54 00000000 c04c4000 c04cffd8 c01025fe c04f3740 00049800 c04cffe0
> Call Trace:
>  [<c03b5b43>] ? schedule+0x285/0x2ff
>  [<c0131856>] ? pm_qos_requirement+0x3c/0x53
>  [<c0239f54>] ? acpi_processor_idle+0x0/0x434
>  [<c01025fe>] ? cpu_idle+0x73/0x7f
>  [<c03a4dcd>] ? rest_init+0x61/0x63
>  =======================
> 
> Wolfgang also found out that adding kernel_fpu_begin() and kernel_fpu_end()
> around the padlock instructions fix the oops.
> 
> Suresh wrote:
> 
> These padlock instructions though don't use/touch SSE registers, but it behaves
> similar to other SSE instructions. For example, it might cause DNA faults
> when cr0.ts is set. While this is a spurious DNA trap, it might cause
> oops with the recent fpu code changes.
> 
> This is the code sequence  that is probably causing this problem:
> 
> a) new app is getting exec'd and it is somewhere in between
>    start_thread() and flush_old_exec() in the load_xyz_binary()
> 
> b) At pont "a", task's fpu state (like TS_USEDFPU, used_math() etc) is
>    cleared.
> 
> c) Now we get an interrupt/softirq which starts using these encrypt/decrypt
>    routines in the network stack. This generates a math fault (as
>    cr0.ts is '1') which sets TS_USEDFPU and restores the math that is
>    in the task's xstate.
> 
> d) Return to exec code path, which does start_thread() which does
>    free_thread_xstate() and sets xstate pointer to NULL while
>    the TS_USEDFPU is still set.
> 
> e) At the next context switch from the new exec'd task to another task,
>    we have a scenarios where TS_USEDFPU is set but xstate pointer is null.
>    This can cause an oops during unlazy_fpu() in __switch_to()
> 
> Now:
> 
> 1) This should happen with or with out pre-emption. Viro also encountered
>    similar problem with out CONFIG_PREEMPT.
> 
> 2) kernel_fpu_begin() and kernel_fpu_end() will fix this problem, because
>    kernel_fpu_begin() will manually do a clts() and won't run in to the
>    situation of setting TS_USEDFPU in step "c" above.
> 
> 3) This was working before the fpu changes, because its a spurious
>    math fault  which doesn't corrupt any fpu/sse registers and the task's
>    math state was always in an allocated state.
> 
> With out the recent lazy fpu allocation changes, while we don't see oops,
> there is a possible race still present in older kernels(for example,
> while kernel is using kernel_fpu_begin() in some optimized clear/copy
> page and an interrupt/softirq happens which uses these padlock
> instructions generating DNA fault).
> 
> This is the failing scenario that existed even before the lazy fpu allocation
> changes:
> 
> 0. CPU's TS flag is set
> 
> 1. kernel using FPU in some optimized copy  routine and while doing
> kernel_fpu_begin() takes an interrupt just before doing clts()
> 
> 2. Takes an interrupt and ipsec uses padlock instruction. And we
> take a DNA fault as TS flag is still set.
> 
> 3. We handle the DNA fault and set TS_USEDFPU and clear cr0.ts
> 
> 4. We complete the padlock routine
> 
> 5. Go back to step-1, which resumes clts() in kernel_fpu_begin(), finishes
> the optimized copy routine and does kernel_fpu_end(). At this point,
> we have cr0.ts again set to '1' but the task's TS_USEFPU is stilll
> set and not cleared.
> 
> 6. Now kernel resumes its user operation. And at the next context
> switch, kernel sees it has do a FP save as TS_USEDFPU is still set
> and then will do a unlazy_fpu() in __switch_to(). unlazy_fpu()
> will take a DNA fault, as cr0.ts is '1' and now, because we are
> in __switch_to(), math_state_restore() will get confused and will
> restore the next task's FP state and will save it in prev tasks's FP state.
> Remember, in __switch_to() we are already on the stack of the next task
> but take a DNA fault for the prev task.
> 
> This causes the fpu leakage.
> 
> Fix the padlock instruction usage by calling them inside the
> context of new routines irq_ts_save/restore(), which clear/restore cr0.ts
> manually in the interrupt context. This will not generate spurious DNA
> in the  context of the interrupt which will fix the oops encountered and
> the possible FPU leakage issue.
> 
> Reported-and-bisected-by: Wolfgang Walter <wolfgang.walter@stwm.de>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
> 
> diff --git a/drivers/char/hw_random/via-rng.c b/drivers/char/hw_random/via-rng.c
> index f7feae4..128202e 100644
> --- a/drivers/char/hw_random/via-rng.c
> +++ b/drivers/char/hw_random/via-rng.c
> @@ -31,6 +31,7 @@
>  #include <asm/io.h>
>  #include <asm/msr.h>
>  #include <asm/cpufeature.h>
> +#include <asm/i387.h>
>  
>  
>  #define PFX	KBUILD_MODNAME ": "
> @@ -67,16 +68,23 @@ enum {
>   * Another possible performance boost may come from simply buffering
>   * until we have 4 bytes, thus returning a u32 at a time,
>   * instead of the current u8-at-a-time.
> + *
> + * Padlock instructions can generate a spurious DNA fault, so
> + * we have to call them in the context of irq_ts_save/restore()
>   */
>  
>  static inline u32 xstore(u32 *addr, u32 edx_in)
>  {
>  	u32 eax_out;
> +	int ts_state;
> +
> +	ts_state = irq_ts_save();
>  
>  	asm(".byte 0x0F,0xA7,0xC0 /* xstore %%edi (addr=%0) */"
>  		:"=m"(*addr), "=a"(eax_out)
>  		:"D"(addr), "d"(edx_in));
>  
> +	irq_ts_restore(ts_state);
>  	return eax_out;
>  }
>  
> diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
> index 54a2a16..bf2917d 100644
> --- a/drivers/crypto/padlock-aes.c
> +++ b/drivers/crypto/padlock-aes.c
> @@ -16,6 +16,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/kernel.h>
>  #include <asm/byteorder.h>
> +#include <asm/i387.h>
>  #include "padlock.h"
>  
>  /* Control word. */
> @@ -141,6 +142,12 @@ static inline void padlock_reset_key(void)
>  	asm volatile ("pushfl; popfl");
>  }
>  
> +/*
> + * While the padlock instructions don't use FP/SSE registers, they
> + * generate a spurious DNA fault when cr0.ts is '1'. These instructions
> + * should be used only inside the irq_ts_save/restore() context
> + */
> +
>  static inline void padlock_xcrypt(const u8 *input, u8 *output, void *key,
>  				  void *control_word)
>  {
> @@ -205,15 +212,23 @@ static inline u8 *padlock_xcrypt_cbc(const u8 *input, u8 *output, void *key,
>  static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
>  	struct aes_ctx *ctx = aes_ctx(tfm);
> +	int ts_state;
>  	padlock_reset_key();
> +
> +	ts_state = irq_ts_save();
>  	aes_crypt(in, out, ctx->E, &ctx->cword.encrypt);
> +	irq_ts_restore(ts_state);
>  }
>  
>  static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
>  	struct aes_ctx *ctx = aes_ctx(tfm);
> +	int ts_state;
>  	padlock_reset_key();
> +
> +	ts_state = irq_ts_save();
>  	aes_crypt(in, out, ctx->D, &ctx->cword.decrypt);
> +	irq_ts_restore(ts_state);
>  }
>  
>  static struct crypto_alg aes_alg = {
> @@ -244,12 +259,14 @@ static int ecb_aes_encrypt(struct blkcipher_desc *desc,
>  	struct aes_ctx *ctx = blk_aes_ctx(desc->tfm);
>  	struct blkcipher_walk walk;
>  	int err;
> +	int ts_state;
>  
>  	padlock_reset_key();
>  
>  	blkcipher_walk_init(&walk, dst, src, nbytes);
>  	err = blkcipher_walk_virt(desc, &walk);
>  
> +	ts_state = irq_ts_save();
>  	while ((nbytes = walk.nbytes)) {
>  		padlock_xcrypt_ecb(walk.src.virt.addr, walk.dst.virt.addr,
>  				   ctx->E, &ctx->cword.encrypt,
> @@ -257,6 +274,7 @@ static int ecb_aes_encrypt(struct blkcipher_desc *desc,
>  		nbytes &= AES_BLOCK_SIZE - 1;
>  		err = blkcipher_walk_done(desc, &walk, nbytes);
>  	}
> +	irq_ts_restore(ts_state);
>  
>  	return err;
>  }
> @@ -268,12 +286,14 @@ static int ecb_aes_decrypt(struct blkcipher_desc *desc,
>  	struct aes_ctx *ctx = blk_aes_ctx(desc->tfm);
>  	struct blkcipher_walk walk;
>  	int err;
> +	int ts_state;
>  
>  	padlock_reset_key();
>  
>  	blkcipher_walk_init(&walk, dst, src, nbytes);
>  	err = blkcipher_walk_virt(desc, &walk);
>  
> +	ts_state = irq_ts_save();
>  	while ((nbytes = walk.nbytes)) {
>  		padlock_xcrypt_ecb(walk.src.virt.addr, walk.dst.virt.addr,
>  				   ctx->D, &ctx->cword.decrypt,
> @@ -281,7 +301,7 @@ static int ecb_aes_decrypt(struct blkcipher_desc *desc,
>  		nbytes &= AES_BLOCK_SIZE - 1;
>  		err = blkcipher_walk_done(desc, &walk, nbytes);
>  	}
> -
> +	irq_ts_restore(ts_state);
>  	return err;
>  }
>  
> @@ -314,12 +334,14 @@ static int cbc_aes_encrypt(struct blkcipher_desc *desc,
>  	struct aes_ctx *ctx = blk_aes_ctx(desc->tfm);
>  	struct blkcipher_walk walk;
>  	int err;
> +	int ts_state;
>  
>  	padlock_reset_key();
>  
>  	blkcipher_walk_init(&walk, dst, src, nbytes);
>  	err = blkcipher_walk_virt(desc, &walk);
>  
> +	ts_state = irq_ts_save();
>  	while ((nbytes = walk.nbytes)) {
>  		u8 *iv = padlock_xcrypt_cbc(walk.src.virt.addr,
>  					    walk.dst.virt.addr, ctx->E,
> @@ -329,6 +351,7 @@ static int cbc_aes_encrypt(struct blkcipher_desc *desc,
>  		nbytes &= AES_BLOCK_SIZE - 1;
>  		err = blkcipher_walk_done(desc, &walk, nbytes);
>  	}
> +	irq_ts_restore(ts_state);
>  
>  	return err;
>  }
> @@ -340,12 +363,14 @@ static int cbc_aes_decrypt(struct blkcipher_desc *desc,
>  	struct aes_ctx *ctx = blk_aes_ctx(desc->tfm);
>  	struct blkcipher_walk walk;
>  	int err;
> +	int ts_state;
>  
>  	padlock_reset_key();
>  
>  	blkcipher_walk_init(&walk, dst, src, nbytes);
>  	err = blkcipher_walk_virt(desc, &walk);
>  
> +	ts_state = irq_ts_save();
>  	while ((nbytes = walk.nbytes)) {
>  		padlock_xcrypt_cbc(walk.src.virt.addr, walk.dst.virt.addr,
>  				   ctx->D, walk.iv, &ctx->cword.decrypt,
> @@ -354,6 +379,7 @@ static int cbc_aes_decrypt(struct blkcipher_desc *desc,
>  		err = blkcipher_walk_done(desc, &walk, nbytes);
>  	}
>  
> +	irq_ts_restore(ts_state);
>  	return err;
>  }
>  
> diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
> index 40d5680..a7fbade 100644
> --- a/drivers/crypto/padlock-sha.c
> +++ b/drivers/crypto/padlock-sha.c
> @@ -22,6 +22,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/kernel.h>
>  #include <linux/scatterlist.h>
> +#include <asm/i387.h>
>  #include "padlock.h"
>  
>  #define SHA1_DEFAULT_FALLBACK	"sha1-generic"
> @@ -102,6 +103,7 @@ static void padlock_do_sha1(const char *in, char *out, int count)
>  	 *     PadLock microcode needs it that big. */
>  	char buf[128+16];
>  	char *result = NEAREST_ALIGNED(buf);
> +	int ts_state;
>  
>  	((uint32_t *)result)[0] = SHA1_H0;
>  	((uint32_t *)result)[1] = SHA1_H1;
> @@ -109,9 +111,12 @@ static void padlock_do_sha1(const char *in, char *out, int count)
>  	((uint32_t *)result)[3] = SHA1_H3;
>  	((uint32_t *)result)[4] = SHA1_H4;
>   
> +	/* prevent taking the spurious DNA fault with padlock. */
> +	ts_state = irq_ts_save();
>  	asm volatile (".byte 0xf3,0x0f,0xa6,0xc8" /* rep xsha1 */
>  		      : "+S"(in), "+D"(result)
>  		      : "c"(count), "a"(0));
> +	irq_ts_restore(ts_state);
>  
>  	padlock_output_block((uint32_t *)result, (uint32_t *)out, 5);
>  }
> @@ -123,6 +128,7 @@ static void padlock_do_sha256(const char *in, char *out, int count)
>  	 *     PadLock microcode needs it that big. */
>  	char buf[128+16];
>  	char *result = NEAREST_ALIGNED(buf);
> +	int ts_state;
>  
>  	((uint32_t *)result)[0] = SHA256_H0;
>  	((uint32_t *)result)[1] = SHA256_H1;
> @@ -133,9 +139,12 @@ static void padlock_do_sha256(const char *in, char *out, int count)
>  	((uint32_t *)result)[6] = SHA256_H6;
>  	((uint32_t *)result)[7] = SHA256_H7;
>  
> +	/* prevent taking the spurious DNA fault with padlock. */
> +	ts_state = irq_ts_save();
>  	asm volatile (".byte 0xf3,0x0f,0xa6,0xd0" /* rep xsha256 */
>  		      : "+S"(in), "+D"(result)
>  		      : "c"(count), "a"(0));
> +	irq_ts_restore(ts_state);
>  
>  	padlock_output_block((uint32_t *)result, (uint32_t *)out, 8);
>  }
> diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
> index 96fa844..6d3b210 100644
> --- a/include/asm-x86/i387.h
> +++ b/include/asm-x86/i387.h
> @@ -13,6 +13,7 @@
>  #include <linux/sched.h>
>  #include <linux/kernel_stat.h>
>  #include <linux/regset.h>
> +#include <linux/hardirq.h>
>  #include <asm/asm.h>
>  #include <asm/processor.h>
>  #include <asm/sigcontext.h>
> @@ -236,6 +237,37 @@ static inline void kernel_fpu_end(void)
>  	preempt_enable();
>  }
>  
> +/*
> + * Some instructions like VIA's padlock instructions generate a spurious
> + * DNA fault but don't modify SSE registers. And these instructions
> + * get used from interrupt context aswell. To prevent these kernel instructions
> + * in interrupt context interact wrongly with other user/kernel fpu usage, we
> + * should use them only in the context of irq_ts_save/restore()
> + */
> +static inline int irq_ts_save(void)
> +{
> +	/*
> +	 * If we are in process context, we are ok to take a spurious DNA fault.
> +	 * Otherwise, doing clts() in process context require pre-emption to
> +	 * be disabled or some heavy lifting like kernel_fpu_begin()
> +	 */
> +	if (!in_interrupt())
> +		return 0;
> +
> +	if (read_cr0() & X86_CR0_TS) {
> +		clts();
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static inline void irq_ts_restore(int TS_state)
> +{
> +	if (TS_state)
> +		stts();
> +}
> +
>  #ifdef CONFIG_X86_64
>  
>  static inline void save_init_fpu(struct task_struct *tsk)
> 
> 

* Works fine, machine is up since 61 minutes.

* Performance:

Routing performance over esp-tunnels seems unchanged here compared to 2.6.25
(this was also the case with the "kernel_fpu_begin" patch).

tcrypt mode=200 shows exactly the same performance penalty compared to 2.6.25
as the "kernel_fpu_begin" patch.

But I think this the right way to go with 2.6.26 und probably 2.6.27. And I'm
not sure if tcyrpt really shows the whole story for 2.6.25:

a) does it measure the costs of the unecessary FXSAVE and FXRSTOR ?
b) does it measure the clts() and stts() which will happen any way though not
in padlock-*.c itself but in __switch_to() and math_state_restore() ?

So shouldn'tthis patch make  - in the whole - performance better compared to
2.6.25 (because its avoids FXSAVE and FXRSTOR for tasks which do not use
FPU/SSE/... in userspace)?


Here the results for tcrypt mode=200:

===============================
testing speed of ecb(aes) encryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 763 cycles (16 bytes)
test 1 (128 bit key, 64 byte blocks): 1 operation in 740 cycles (64 bytes)
test 2 (128 bit key, 256 byte blocks): 1 operation in 860 cycles (256 bytes)
test 3 (128 bit key, 1024 byte blocks): 1 operation in 1340 cycles (1024 bytes)
test 4 (128 bit key, 8192 byte blocks): 1 operation in 6583 cycles (8192 bytes)
test 5 (192 bit key, 16 byte blocks): 1 operation in 1542 cycles (16 bytes)
test 6 (192 bit key, 64 byte blocks): 1 operation in 1614 cycles (64 bytes)
test 7 (192 bit key, 256 byte blocks): 1 operation in 1950 cycles (256 bytes)
test 8 (192 bit key, 1024 byte blocks): 1 operation in 3294 cycles (1024 bytes)
test 9 (192 bit key, 8192 byte blocks): 1 operation in 18214 cycles (8192 bytes)
test 10 (256 bit key, 16 byte blocks): 1 operation in 753 cycles (16 bytes)
test 11 (256 bit key, 64 byte blocks): 1 operation in 781 cycles (64 bytes)
test 12 (256 bit key, 256 byte blocks): 1 operation in 949 cycles (256 bytes)
test 13 (256 bit key, 1024 byte blocks): 1 operation in 1621 cycles (1024 bytes)
test 14 (256 bit key, 8192 byte blocks): 1 operation in 8658 cycles (8192 bytes)

testing speed of ecb(aes) decryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 727 cycles (16 bytes)
test 1 (128 bit key, 64 byte blocks): 1 operation in 742 cycles (64 bytes)
test 2 (128 bit key, 256 byte blocks): 1 operation in 862 cycles (256 bytes)
test 3 (128 bit key, 1024 byte blocks): 1 operation in 1342 cycles (1024 bytes)
test 4 (128 bit key, 8192 byte blocks): 1 operation in 6621 cycles (8192 bytes)
test 5 (192 bit key, 16 byte blocks): 1 operation in 1548 cycles (16 bytes)
test 6 (192 bit key, 64 byte blocks): 1 operation in 1614 cycles (64 bytes)
test 7 (192 bit key, 256 byte blocks): 1 operation in 1950 cycles (256 bytes)
test 8 (192 bit key, 1024 byte blocks): 1 operation in 3294 cycles (1024 bytes)
test 9 (192 bit key, 8192 byte blocks): 1 operation in 18251 cycles (8192 bytes)
test 10 (256 bit key, 16 byte blocks): 1 operation in 759 cycles (16 bytes)
test 11 (256 bit key, 64 byte blocks): 1 operation in 783 cycles (64 bytes)
test 12 (256 bit key, 256 byte blocks): 1 operation in 951 cycles (256 bytes)
test 13 (256 bit key, 1024 byte blocks): 1 operation in 1623 cycles (1024 bytes)
test 14 (256 bit key, 8192 byte blocks): 1 operation in 8665 cycles (8192 bytes)

testing speed of cbc(aes) encryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 759 cycles (16 bytes)
test 1 (128 bit key, 64 byte blocks): 1 operation in 816 cycles (64 bytes)
test 2 (128 bit key, 256 byte blocks): 1 operation in 1088 cycles (256 bytes)
test 3 (128 bit key, 1024 byte blocks): 1 operation in 2144 cycles (1024 bytes)
test 4 (128 bit key, 8192 byte blocks): 1 operation in 12796 cycles (8192 bytes)
test 5 (192 bit key, 16 byte blocks): 1 operation in 1571 cycles (16 bytes)
test 6 (192 bit key, 64 byte blocks): 1 operation in 1694 cycles (64 bytes)
test 7 (192 bit key, 256 byte blocks): 1 operation in 2198 cycles (256 bytes)
test 8 (192 bit key, 1024 byte blocks): 1 operation in 4214 cycles (1024 bytes)
test 9 (192 bit key, 8192 byte blocks): 1 operation in 25420 cycles (8192 bytes)
test 10 (256 bit key, 16 byte blocks): 1 operation in 791 cycles (16 bytes)
test 11 (256 bit key, 64 byte blocks): 1 operation in 877 cycles (64 bytes)
test 12 (256 bit key, 256 byte blocks): 1 operation in 1235 cycles (256 bytes)
test 13 (256 bit key, 1024 byte blocks): 1 operation in 2675 cycles (1024 bytes)
test 14 (256 bit key, 8192 byte blocks): 1 operation in 16912 cycles (8192 bytes)

testing speed of cbc(aes) decryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 740 cycles (16 bytes)
test 1 (128 bit key, 64 byte blocks): 1 operation in 795 cycles (64 bytes)
test 2 (128 bit key, 256 byte blocks): 1 operation in 1058 cycles (256 bytes)
test 3 (128 bit key, 1024 byte blocks): 1 operation in 2114 cycles (1024 bytes)
test 4 (128 bit key, 8192 byte blocks): 1 operation in 12726 cycles (8192 bytes)
test 5 (192 bit key, 16 byte blocks): 1 operation in 1548 cycles (16 bytes)
test 6 (192 bit key, 64 byte blocks): 1 operation in 1670 cycles (64 bytes)
test 7 (192 bit key, 256 byte blocks): 1 operation in 2174 cycles (256 bytes)
test 8 (192 bit key, 1024 byte blocks): 1 operation in 4190 cycles (1024 bytes)
test 9 (192 bit key, 8192 byte blocks): 1 operation in 25349 cycles (8192 bytes)
test 10 (256 bit key, 16 byte blocks): 1 operation in 763 cycles (16 bytes)
test 11 (256 bit key, 64 byte blocks): 1 operation in 856 cycles (64 bytes)
test 12 (256 bit key, 256 byte blocks): 1 operation in 1214 cycles (256 bytes)
test 13 (256 bit key, 1024 byte blocks): 1 operation in 2654 cycles (1024 bytes)
test 14 (256 bit key, 8192 byte blocks): 1 operation in 16846 cycles (8192 bytes)

testing speed of lrw(aes) encryption
test 0 (256 bit key, 16 byte blocks): 1 operation in 1402 cycles (16 bytes)
test 1 (256 bit key, 64 byte blocks): 1 operation in 2653 cycles (64 bytes)
test 2 (256 bit key, 256 byte blocks): 1 operation in 7576 cycles (256 bytes)
test 3 (256 bit key, 1024 byte blocks): 1 operation in 26990 cycles (1024 bytes)
test 4 (256 bit key, 8192 byte blocks): 1 operation in 209207 cycles (8192 bytes)
test 5 (320 bit key, 16 byte blocks): 1 operation in 2229 cycles (16 bytes)
test 6 (320 bit key, 64 byte blocks): 1 operation in 3730 cycles (64 bytes)
test 7 (320 bit key, 256 byte blocks): 1 operation in 9179 cycles (256 bytes)
test 8 (320 bit key, 1024 byte blocks): 1 operation in 31493 cycles (1024 bytes)
test 9 (320 bit key, 8192 byte blocks): 1 operation in 239349 cycles (8192 bytes)
test 10 (384 bit key, 16 byte blocks): 1 operation in 1435 cycles (16 bytes)
test 11 (384 bit key, 64 byte blocks): 1 operation in 2809 cycles (64 bytes)
test 12 (384 bit key, 256 byte blocks): 1 operation in 8211 cycles (256 bytes)
test 13 (384 bit key, 1024 byte blocks): 1 operation in 29425 cycles (1024 bytes)
test 14 (384 bit key, 8192 byte blocks): 1 operation in 228659 cycles (8192 bytes)

testing speed of lrw(aes) decryption
test 0 (256 bit key, 16 byte blocks): 1 operation in 1396 cycles (16 bytes)
test 1 (256 bit key, 64 byte blocks): 1 operation in 2654 cycles (64 bytes)
test 2 (256 bit key, 256 byte blocks): 1 operation in 7577 cycles (256 bytes)
test 3 (256 bit key, 1024 byte blocks): 1 operation in 27001 cycles (1024 bytes)
test 4 (256 bit key, 8192 byte blocks): 1 operation in 209225 cycles (8192 bytes)
test 5 (320 bit key, 16 byte blocks): 1 operation in 2232 cycles (16 bytes)
test 6 (320 bit key, 64 byte blocks): 1 operation in 3722 cycles (64 bytes)
test 7 (320 bit key, 256 byte blocks): 1 operation in 9279 cycles (256 bytes)
test 8 (320 bit key, 1024 byte blocks): 1 operation in 31360 cycles (1024 bytes)
test 9 (320 bit key, 8192 byte blocks): 1 operation in 239270 cycles (8192 bytes)
test 10 (384 bit key, 16 byte blocks): 1 operation in 1459 cycles (16 bytes)
test 11 (384 bit key, 64 byte blocks): 1 operation in 2862 cycles (64 bytes)
test 12 (384 bit key, 256 byte blocks): 1 operation in 8162 cycles (256 bytes)
test 13 (384 bit key, 1024 byte blocks): 1 operation in 29382 cycles (1024 bytes)
test 14 (384 bit key, 8192 byte blocks): 1 operation in 228704 cycles (8192 bytes)

testing speed of xts(aes) encryption
test 0 (256 bit key, 16 byte blocks): 1 operation in 1079 cycles (16 bytes)
test 1 (256 bit key, 64 byte blocks): 1 operation in 2075 cycles (64 bytes)
test 2 (256 bit key, 256 byte blocks): 1 operation in 5939 cycles (256 bytes)
test 3 (256 bit key, 1024 byte blocks): 1 operation in 21395 cycles (1024 bytes)
test 4 (256 bit key, 8192 byte blocks): 1 operation in 166475 cycles (8192 bytes)
test 5 (384 bit key, 16 byte blocks): 1 operation in 1155 cycles (16 bytes)
test 6 (384 bit key, 64 byte blocks): 1 operation in 2265 cycles (64 bytes)
test 7 (384 bit key, 256 byte blocks): 1 operation in 6585 cycles (256 bytes)
test 8 (384 bit key, 1024 byte blocks): 1 operation in 23865 cycles (1024 bytes)
test 9 (384 bit key, 8192 byte blocks): 1 operation in 185980 cycles (8192 bytes)
test 10 (512 bit key, 16 byte blocks): 1 operation in 1155 cycles (16 bytes)
test 11 (512 bit key, 64 byte blocks): 1 operation in 2265 cycles (64 bytes)
test 12 (512 bit key, 256 byte blocks): 1 operation in 6585 cycles (256 bytes)
test 13 (512 bit key, 1024 byte blocks): 1 operation in 23865 cycles (1024 bytes)
test 14 (512 bit key, 8192 byte blocks): 1 operation in 185969 cycles (8192 bytes)

testing speed of xts(aes) decryption
test 0 (256 bit key, 16 byte blocks): 1 operation in 1065 cycles (16 bytes)
test 1 (256 bit key, 64 byte blocks): 1 operation in 2063 cycles (64 bytes)
test 2 (256 bit key, 256 byte blocks): 1 operation in 5927 cycles (256 bytes)
test 3 (256 bit key, 1024 byte blocks): 1 operation in 21383 cycles (1024 bytes)
test 4 (256 bit key, 8192 byte blocks): 1 operation in 166463 cycles (8192 bytes)
test 5 (384 bit key, 16 byte blocks): 1 operation in 1141 cycles (16 bytes)
test 6 (384 bit key, 64 byte blocks): 1 operation in 2253 cycles (64 bytes)
test 7 (384 bit key, 256 byte blocks): 1 operation in 6573 cycles (256 bytes)
test 8 (384 bit key, 1024 byte blocks): 1 operation in 23853 cycles (1024 bytes)
test 9 (384 bit key, 8192 byte blocks): 1 operation in 185957 cycles (8192 bytes)
test 10 (512 bit key, 16 byte blocks): 1 operation in 1141 cycles (16 bytes)
test 11 (512 bit key, 64 byte blocks): 1 operation in 2253 cycles (64 bytes)
test 12 (512 bit key, 256 byte blocks): 1 operation in 6573 cycles (256 bytes)
test 13 (512 bit key, 1024 byte blocks): 1 operation in 23853 cycles (1024 bytes)
test 14 (512 bit key, 8192 byte blocks): 1 operation in 185957 cycles (8192 bytes)
===============================


Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
