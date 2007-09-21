Return-Path: <linux-kernel-owner+w=401wt.eu-S1759840AbXIUNbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759840AbXIUNbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759459AbXIUNbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:31:10 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:61439 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759375AbXIUNbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:31:09 -0400
Date: Fri, 21 Sep 2007 09:31:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 4/7] Immediate Values - i386 Optimization
Message-ID: <20070921133107.GB13129@Krystal>
References: <20070918210747.828804366@polymtl.ca> <20070918210853.588573678@polymtl.ca> <200709201124.13097.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200709201124.13097.vda.linux@googlemail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:02:25 up 53 days, 13:21,  4 users,  load average: 0.28, 0.82, 0.84
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Denys Vlasenko (vda.linux@googlemail.com) wrote:
> On Tuesday 18 September 2007 22:07, Mathieu Desnoyers wrote:
> > i386 optimization of the immediate values which uses a movl with code patching
> > to set/unset the value used to populate the register used as variable source.
> > 
> > Changelog:
> > - Use text_poke_early with cr0 WP save/restore to patch the bypass. We are doing
> >   non atomic writes to a code region only touched by us (nobody can execute it
> >   since we are protected by the immediate_mutex).
> > - Put immediate_set and _immediate_set in the architecture independent header.
> 
> > +struct __immediate {
> > +	long var;		/* Pointer to the identifier variable of the
> > +				 * immediate value
> > +				 */
> > +	long immediate;		/*
> > +				 * Pointer to the memory location of the
> > +				 * immediate value within the instruction.
> > +				 */
> > +	long size;		/* Type size. */
> > +};
> 
> 
> > +		case 2:							\
> > +			asm (	".section __immediate, \"a\", @progbits;\n\t" \
> > +					".long %1, (0f)+2, 2;\n\t"	\
> > +					".previous;\n\t"		\
> > +					"1:\n\t"			\
> > +					".align 2;\n\t"			\
> > +					"0:\n\t"			\
> > +					"mov %2,%0;\n\t"		\
> > +				: "=r" (value)				\
> > +				: "m" (name##__immediate),		\
> > +				  "i" (0));				\
> 
> Instead of letting gcc use whatever instruction it sees fit best
> for accessing the variable (like add/cmp/test...)
> now we force it to use mov imm,reg first. Maybe with preceding nop
> due to "align 2".
> 

Yes, this is true. So, the following branch:

char x;

void testb(void)
{
        if (x > 5)
                testa();
}

Would turn into:
  56:   b0 00                   mov    $0x0,%al
  58:   3c 05                   cmp    $0x5,%al
  5a:   7e 05                   jle    61 <testb+0x11>


Rather than:

  56:   80 3d 00 00 00 00 05    cmpb   $0x5,0x0
  5d:   7e 05                   jle    64 <testb+0x14>

> And then we use 12 more bytes in __immediate section
> *for each* place where you read the variable.
> 

Yes. You must consider the this section is only used when updating the
variable. It is never used by the read-side and therefore does not
consume data cache on hot paths.

> Do you plan to use the same approach on x86_64?
> I mean, longs there are twice as long.
> 

Yup. It's a memory footprint vs active cacheline footprints tradeoff.
When GCC optimizes for size and we see kernel speedups, it is not so
because it "consumes" less memory, but rather that there is less junk
polluting the cachelines. So unless you worry about a few K of data and
are an embedded system developer, I really don't see why you worry about
this. Oh, and by the way, I provide the ability to disable immediate
values in the EMBEDDED menu.

> Can this be made conditional, on CONFIG_CC_OPTIMIZE_FOR_SIZE perhaps?

No. As I just stated, only embedded developers would have an interest in
disabling this features because they would have so few memory available
on their architecture. The memory consumed by the immediate values table
is out of the hot path cachelines and therefore does not impact overall
performance.

> --
> vda

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
