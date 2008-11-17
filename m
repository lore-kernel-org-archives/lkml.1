Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbYKQFGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbYKQFGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 00:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbYKQFGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 00:06:21 -0500
Received: from ozlabs.org ([203.10.76.45]:46158 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbYKQFGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 00:06:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18720.64083.306981.779763@drongo.ozlabs.ibm.com>
Date: Mon, 17 Nov 2008 16:00:03 +1100
From: Paul Mackerras <paulus@samba.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 5/7] ftrace, PPC64: handle module trampolines for dyn ftrace
In-Reply-To: <20081116212516.000516128@goodmis.org>
References: <20081116212428.938752312@goodmis.org>
	<20081116212516.000516128@goodmis.org>
X-Mailer: VM 8.0.11 under Emacs 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt writes:

> +	if (!rec->arch.mod) {
> +		if (!mod) {
> +			printk(KERN_ERR "No module loaded addr=%lx\n",
> +			       addr);
> +			return -EFAULT;
> +		}
> +		rec->arch.mod = mod;
> +	} else if (mod) {
> +		printk(KERN_ERR
> +		       "Record mod %p not equal to passed in mod %p\n",
> +		       rec->arch.mod, mod);
> +		return -EINVAL;

That looks wrong; surely you need an if (mod != rec->arch.mod)
somewhere here?

> +	/* Make sure that that this is still a 24bit jump */
> +	if ((*op & 0xff000000) != 0x48000000) {
> +		printk(KERN_ERR "Not expected bl: opcode is %x\n", *op);
> +		return -EINVAL;
> +	}

Needs to be

	if ((*op & 0xfc000003) != 0x48000001)

since the major opcode is the top 6 bits, and the bottom 2 bits are
the link bit and the absolute address bit.

> +	/* lets find where the pointer goes */
> +	offset = (*op & 0x03fffffc);
> +	/* make it signed */
> +	if (offset & 0x02000000)
> +		offset |= 0xfe000000;

but you got that right... :)

> +	/* get the address this jumps too */
> +	tramp = mod->arch.toc + offset + 32;

Why + 32?

Paul.
