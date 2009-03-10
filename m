Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbZCJM21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbZCJM21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 08:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZCJM2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 08:28:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44416 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592AbZCJM2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 08:28:18 -0400
Date: Tue, 10 Mar 2009 13:28:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip V2] x86: cpu architecture debug code
Message-ID: <20090310122806.GE5794@elte.hu>
References: <1236684201.3301.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236684201.3301.11.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Added more features, now it supports:
> 1. TSS (GPR, Segment, Eflags)
> 2. Control Regs
> 3. DT (IDT, GDT, LDT, TR)
> 4. Debug regs
> 5. LAPIC
> 6. MSRs

looks pretty good!

A few small details:

> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/smp.h>
> +#include <linux/regset.h>
> +#include <linux/sched.h>
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>
> +#include <asm/desc.h>
> +#include <asm/cpu_debug.h>

Please use the include files style as can be seen in 
arch/x86/mm/fault.c. The reason why we do it is to reduce 
conflicts when files are modified by multiple topic branches at 
once.

> +	vendor = per_cpu(cpu_model, cpu) >> 16;
> +	modelflag = per_cpu(cpu_modelflag, cpu);
> +	index = get_cpu_range_count(cpu);
> +	for (i = 0; i < index; i++) {

please put a newline before loops in such cases, to make it 
stand out some more.

> +/* This function can also be called with seq = NULL for printk */
> +static void print_msr(struct seq_file *seq, unsigned cpu, unsigned flag)
> +{
> +	int i, range;
> +	u32 low, high;
> +	unsigned msr, msr_min, msr_max;
> +	struct cpu_private *priv;

please try to order local variables like this:

> +	unsigned msr, msr_min, msr_max;
> +	struct cpu_private *priv;
> +	u32 low, high;
> +	int i, range;

(this is done for similar reasons as the include files section 
ordering)

this affects other functions in the file too.

> +static const struct seq_operations cpu_seq_ops = {
> +	.start = cpu_seq_start,
> +	.next  = cpu_seq_next,
> +	.stop  = cpu_seq_stop,
> +	.show  = cpu_seq_show,
> +};

Please use consistent vertical alignment wherever possible 
thoughout the file, i.e.:

> +	.start			= cpu_seq_start,
> +	.next			= cpu_seq_next,
> +	.stop			= cpu_seq_stop,
> +	.show			= cpu_seq_show,

(note this applies to other places too in this same file.)


> +static int cpu_seq_open(struct inode *inode, struct file *file)
> +{
> +	int err;
> +	struct seq_file *seq;
> +	struct cpu_private *priv = inode->i_private;
> +
> +	err = seq_open(file, &cpu_seq_ops);
> +	mutex_lock(&cpu_debug_lock);
> +	if (!err) {
> +		seq = file->private_data;
> +		seq->private = priv;
> +	}
> +	mutex_unlock(&cpu_debug_lock);

what is the purpose of the locking here? What other codepath 
can race with this?

> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (priv == NULL)
> +		return -ENOMEM;
> +
> +	mutex_lock(&cpu_debug_lock);
> +	priv->cpu = cpu;
> +	priv->type = type;
> +	priv->reg = reg;
> +	priv->file = file;
> +	per_cpu(priv_arr[type], cpu) = priv;
> +	per_cpu(cpu_priv_count, cpu)++;
> +	mutex_unlock(&cpu_debug_lock);

what's the purpose of the locking here and why does it cover 
more than just the per_cpu() related critical section?

	Ingo
