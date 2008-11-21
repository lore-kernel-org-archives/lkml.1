Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbYKUNjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbYKUNjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 08:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbYKUNjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 08:39:12 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51527 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbYKUNjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 08:39:10 -0500
Date: Fri, 21 Nov 2008 19:08:00 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, mhiramat@redhat.com,
       contact@ksplice.com, jbarnold@ksplice.com, tabbott@ksplice.com,
       wdaher@ksplice.com, andersk@ksplice.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC] kreplace: Rebootless kernel updates
Message-ID: <20081121133800.GA5244@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <200811211720.26394.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811211720.26394.knikanth@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 05:20:25PM +0530, Nikanth Karthikesan wrote:
> This RFC patch adds support for limited form of rebootless kernel patching 
> even without building the entire kernel.
>
> When looking for a shortcut to avoid the rebuild/reboot cycle when hacking the  
> kernel - the ksplice[1] was posted. This patch extends kprobes to do something 
> similar, which would require even lesser time to _experiment_ with the running 
> kernel. 

There have been other implementations of this feature, I am sure quite a
few people would have objections to having this as part of the kernel :-)

> This small patch extends jprobes so that the jprobe's handler is executed but 
> skips executing the actual function. But this has its own limitations such as 
> Cannot access symbols not exported for modules (ofcourse hacks like 
> pointers[2] can be used.), problems related to return values[3], etc... This 
> is currently a x86_64 only _hack_.

There are many other issues too... How do you enforce correct usage of this
infrastrucutre? What prevents people from overriding core-kernel
functions with their own?

Kprobes themselves provide enough ammunition to users to shoot themselves
in the foot, but this is way more dangerous than that.
...

> The kernel patch for kreplace, an extension to kprobes to do hot patching.  
> Only on x86_64. Do not try this on any other platforms without modifying.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> 
> ---
>  arch/x86/kernel/kprobes.c |   18 ++++++++++++++----
>  include/linux/kprobes.h   |    5 ++++-
>  kernel/kprobes.c          |   37 ++++++++++++++++++++++++++++++++-----
>  3 files changed, 50 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index 6c27679..9e2ea2b 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -340,9 +340,13 @@ static void __kprobes fix_riprel(struct kprobe *p)
>  #endif
>  }
> 
> -static void __kprobes arch_copy_kprobe(struct kprobe *p)
> +static void __kprobes arch_copy_kprobe(struct kprobe *p, int replace)
>  {
> -	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
> +	if (replace)
> +		memcpy(p->ainsn.insn, ((unsigned char []){0xc3}), 1);
> +	else
> +		memcpy(p->ainsn.insn, p->addr,
> +				MAX_INSN_SIZE * sizeof(kprobe_opcode_t));

This is limiting - especially since we allow multiple probes at the same
address. You modify the instruction underneath to always be a ret.

It also breaks existing functionality -- especially aggregate probes and
return probes.

...

> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
> index 497b1d1..91e83fb 100644
> --- a/include/linux/kprobes.h
> +++ b/include/linux/kprobes.h
> @@ -202,7 +202,7 @@ static inline int init_test_probes(void)
>  #endif /* CONFIG_KPROBES_SANITY_TEST */
> 
>  extern struct mutex kprobe_mutex;
> -extern int arch_prepare_kprobe(struct kprobe *p);
> +extern int arch_prepare_kprobe(struct kprobe *p, int replace);
>  extern void arch_arm_kprobe(struct kprobe *p);
>  extern void arch_disarm_kprobe(struct kprobe *p);
>  extern int arch_init_kprobes(void);
> @@ -240,11 +240,14 @@ int register_kprobes(struct kprobe **kps, int num);
>  void unregister_kprobes(struct kprobe **kps, int num);
>  int setjmp_pre_handler(struct kprobe *, struct pt_regs *);
>  int longjmp_break_handler(struct kprobe *, struct pt_regs *);
> +int register_kreplace(struct jprobe *p);
> +void unregister_kreplace(struct jprobe *p);
>  int register_jprobe(struct jprobe *p);
>  void unregister_jprobe(struct jprobe *p);
>  int register_jprobes(struct jprobe **jps, int num);
>  void unregister_jprobes(struct jprobe **jps, int num);
>  void jprobe_return(void);
> +void set_ax(unsigned long);

Please choose a better arch agnostic naming scheme -- set_ret()?

Ananth
