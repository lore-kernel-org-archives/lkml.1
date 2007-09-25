Return-Path: <linux-kernel-owner+w=401wt.eu-S1751939AbXIYI5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbXIYI5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbXIYI5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:57:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45794 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbXIYI5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:57:31 -0400
Date: Tue, 25 Sep 2007 09:57:11 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, hch@infradead.org,
       mathieu.desnoyers@polymtl.ca, akpm <akpm@linux-foundation.org>,
       sam@ravnborg.org, davem@davemloft.net
Subject: Re: [PATCH/RFC] samples/: move kprobes sources to samples
Message-ID: <20070925085711.GA11285@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	lkml <linux-kernel@vger.kernel.org>, prasanna@in.ibm.com,
	anil.s.keshavamurthy@intel.com, mathieu.desnoyers@polymtl.ca,
	akpm <akpm@linux-foundation.org>, sam@ravnborg.org,
	davem@davemloft.net
References: <20070924145828.d279abac.randy.dunlap@oracle.com> <20070925084333.GA16077@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925084333.GA16077@in.ibm.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 02:13:33PM +0530, Ananth N Mavinakayanahalli wrote:
> +++ linux-2.6.23-rc7/samples/kprobes/jprobe_example.c
> @@ -0,0 +1,69 @@
> +/*jprobe-example.c */

I don't think we should have this type of comment in any of the files.

> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/fs.h>
> +#include <linux/uio.h>

I don't think you'll need uio,h here.

> + * Jumper probe for do_fork.
> + * Mirror principle enables access to arguments of the probed routine
> + * from the probe handler.
> + */
> +static const char *probed_func = "do_fork";
> +

> +	/* Always end with a call to jprobe_return(). */
> +	jprobe_return();
> +
> +	/*NOTREACHED*/
> +	return 0;

I'd rather write this as:

	/* Always end with a call to jprobe_return(). */
	jprobe_return();
	return 0;
}

Also a a note not to these example but general kprobes code I've
bee wondering whether jprobe_return() should just include the return.
Yes, macros including a return are ugly, but in this case jprobe_return
actually handles the return anyway through deep magic.

> +static struct jprobe my_jprobe = {
> +	.entry = jdo_fork
> +};
> +
> +static int __init jprobe_init(void)
> +{
> +	int ret;
> +	my_jprobe.kp.symbol_name = (char *)probed_func;

Shouldn't this be simply done in the static initialization, ala:

static struct jprobe my_jprobe = {
	.entry			= jdo_fork,
	.kp = {
		.symbol_name	= "do_fork",
	},
};

(same for the other examples)

> +static int handler_pre(struct kprobe *p, struct pt_regs *regs)
> +{
> +#ifdef CONFIG_X86_32
> +	printk("pre_handler: p->addr = 0x%p, eip = %lx, eflags = 0x%lx\n",
> +		p->addr, regs->eip, regs->eflags);
> +#endif
> +#ifdef CONFIG_X86_64
> +	printk("pre_handler: p->addr = 0x%p, rip = %lx, eflags = 0x%lx\n",
> +		p->addr, regs->rip, regs->eflags);
> +#endif
> +#ifdef CONFIG_PPC
> +	printk("pre_handler: p->addr = 0x%p, nip = 0x%lx, msr = 0x%lx\n",
> +		p->addr, regs->nip, regs->msr);
> +#endif

Now this is really ugly.  We should really have macros for the interesting
registers (instruction pointer, frame pointer, stack pointer) in kdebug.h.
systemtap runtime already has them for supported architectures, any care
to port them over?

(note that this is not an objection to the patch as-is, but rather a
 suggestion for later improvement of the whole thing)



Thanks a lot for moving this in the right place!
