Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbYKQQCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbYKQQCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 11:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbYKQQCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 11:02:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57239 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbYKQQCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 11:02:13 -0500
Date: Mon, 17 Nov 2008 11:02:11 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Paul Mackerras <paulus@samba.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 5/7] ftrace, PPC64: handle module trampolines for dyn
 ftrace
In-Reply-To: <18720.64083.306981.779763@drongo.ozlabs.ibm.com>
Message-ID: <alpine.DEB.1.10.0811171053070.2919@gandalf.stny.rr.com>
References: <20081116212428.938752312@goodmis.org> <20081116212516.000516128@goodmis.org> <18720.64083.306981.779763@drongo.ozlabs.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008, Paul Mackerras wrote:

> Steven Rostedt writes:
> 
> > +	if (!rec->arch.mod) {
> > +		if (!mod) {
> > +			printk(KERN_ERR "No module loaded addr=%lx\n",
> > +			       addr);
> > +			return -EFAULT;
> > +		}
> > +		rec->arch.mod = mod;
> > +	} else if (mod) {
> > +		printk(KERN_ERR
> > +		       "Record mod %p not equal to passed in mod %p\n",
> > +		       rec->arch.mod, mod);
> > +		return -EINVAL;
> 
> That looks wrong; surely you need an if (mod != rec->arch.mod)
> somewhere here?

??? How did that happen :-/  Maybe it was because I was working between
two boxes and I did not refresh quilt before submitting it into my git
tree? I'm positive I made that fix already.

Yes, I will fix that.

> 
> > +	/* Make sure that that this is still a 24bit jump */
> > +	if ((*op & 0xff000000) != 0x48000000) {
> > +		printk(KERN_ERR "Not expected bl: opcode is %x\n", *op);
> > +		return -EINVAL;
> > +	}
> 
> Needs to be
> 
> 	if ((*op & 0xfc000003) != 0x48000001)
> 
> since the major opcode is the top 6 bits, and the bottom 2 bits are
> the link bit and the absolute address bit.

Thanks! will fix.

> 
> > +	/* lets find where the pointer goes */
> > +	offset = (*op & 0x03fffffc);
> > +	/* make it signed */
> > +	if (offset & 0x02000000)
> > +		offset |= 0xfe000000;
> 
> but you got that right... :)

Heh, I'm not hopeless.

> 
> > +	/* get the address this jumps too */
> > +	tramp = mod->arch.toc + offset + 32;
> 
> Why + 32?

Good question. This is one of the things that was weird to me too. I got 
this from the module_64.c code.

static struct ppc64_stub_entry ppc64_stub =
{ .jump = {
	0x3d, 0x82, 0x00, 0x00, /* addis   r12,r2, <high> */
	0x39, 0x8c, 0x00, 0x00, /* addi    r12,r12, <low> */
	/* Save current r2 value in magic place on the stack. */
	0xf8, 0x41, 0x00, 0x28, /* std     r2,40(r1) */
	0xe9, 0x6c, 0x00, 0x20, /* ld      r11,32(r12) */

 ld r11,32(r12) is the call.

	0xe8, 0x4c, 0x00, 0x28, /* ld      r2,40(r12) */
	0x7d, 0x69, 0x03, 0xa6, /* mtctr   r11 */
	0x4e, 0x80, 0x04, 0x20  /* bctr */
} };


I'm making sure that I will actually jump to the correct spot before 
changing any code, but to find that correct spot, I need to calculate what 
is being done.

I see the above code from module_64.c adds r2 (the TOC?) to r12, and then 
adds the location of the 'bl' offset. Then it adds the contents of 32(r12) 
to r11. And then the jump is to r11.

I'll comment that better to state that I pulled this code from 
module_64.c.

Thanks,

-- Steve


