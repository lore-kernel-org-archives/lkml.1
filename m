Return-Path: <linux-kernel-owner+w=401wt.eu-S1763321AbXEPSEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763321AbXEPSEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758112AbXEPSEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:04:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34507 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756489AbXEPSEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:04:21 -0400
Date: Wed, 16 May 2007 11:00:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mel@skynet.ie (Mel Gorman)
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel@vger.kernel.org, Steve Fox <drfickle@us.ibm.com>
Subject: Re: 2.6.22-rc1-mm1
Message-Id: <20070516110001.786217db.akpm@linux-foundation.org>
In-Reply-To: <20070516174046.GE10225@skynet.ie>
References: <20070515201914.16944e04.akpm@linux-foundation.org>
	<464ADA5D.8050405@shadowen.org>
	<464B2048.7040103@zytor.com>
	<20070516174046.GE10225@skynet.ie>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 18:40:47 +0100
mel@skynet.ie (Mel Gorman) wrote:

> On (16/05/07 08:16), H. Peter Anvin didst pronounce:
> > Andy Whitcroft wrote:
> > > Getting this on both x86 and x86_64 boxes, they are the older boxen so
> > > likely older compilers:
> > 
> > Please give the gcc version number.
> > 
> > >   CC      arch/x86_64/boot/memory.o
> > > arch/i386/boot/memory.c: In function `detect_memory':
> > > arch/i386/boot/memory.c:32: error: can't find a register in class `DREG'
> > > while reloading `asm'
> > > 
> > > Seems to come from git-netsetup, but that tree isn't pulled into your
> > > git version of -mm so I can't be more specific.
> > 
> > Does the following patch work for you?
> > 
> 
> With the patch, elm3b6 from test.kernel.org builds and boots. It's
> x86_64. elm3b132 which is x86 fails with
> 
>   CC      arch/i386/boot/video-bios.o
>   HOSTCC  arch/i386/boot/tools/build
>   AS      arch/i386/boot/compressed/head.o
>   CC      arch/i386/boot/compressed/misc.o
>   OBJCOPY arch/i386/boot/compressed/vmlinux.bin
>   LD      arch/i386/boot/setup.elf
> ld:arch/i386/boot/setup.ld:47: syntax error

	ASSERT(_end <= 0x8000, "Setup too big!")

Which compiler/binutils are you running over there?

> make[1]: *** [arch/i386/boot/setup.elf] Error 1
> make[1]: *** Waiting for unfinished jobs....
>   GZIP    arch/i386/boot/compressed/vmlinux.bin.gz
> include/asm/processor.h: In function `native_get_debugreg':
> include/asm/processor.h:531: warning: asm operand 0 probably doesn't
> match constraints
> include/asm/processor.h: In function `native_set_debugreg':
> include/asm/processor.h:558: warning: asm operand 0 probably doesn't
> match constraints

	static inline unsigned long native_get_debugreg(int regno)
	{
		unsigned long val = 0; 	/* Damn you, gcc! */
	
		switch (regno) {
		case 0:
			asm("movl %%db0, %0" :"=r" (val)); break;
		case 1:
			asm("movl %%db1, %0" :"=r" (val)); break;
		case 2:
			asm("movl %%db2, %0" :"=r" (val)); break;
		case 3:
			asm("movl %%db3, %0" :"=r" (val)); break;
		case 6:
			asm("movl %%db6, %0" :"=r" (val)); break;
		case 7:
			asm("movl %%db7, %0" :"=r" (val)); break;
		default:
-->			BUG();
		}
		return val;
	}

weird.

There are no significant changes in processor.h relative to 2.6.22-rc1.

If the file-n-line aren't screwed up, it's disliking

#define BUG()								\
	do {								\
		asm volatile("1:\tud2\n"				\
			     ".pushsection __bug_table,\"a\"\n"		\
			     "2:\t.long 1b, %c0\n"			\
			     "\t.word %c1, 0\n"				\
			     "\t.org 2b+%c2\n"				\
			     ".popsection"				\
			     : : "i" (__FILE__), "i" (__LINE__),	\
			     "i" (sizeof(struct bug_entry)));		\
		for(;;) ;						\
	} while(0)

and we haven't changedanything in there recently either.
	
>   LD      arch/i386/boot/compressed/piggy.o
>   LD      arch/i386/boot/compressed/vmlinux
> make: *** [bzImage] Error 2
> 05/16/07-17:27:44 Build the kernel. Failed rc = 2
> 05/16/07-17:27:44 build: kernel build Failed rc = 1
> Failed and terminated the run
> 
> I haven't checked yet if that has anything to do with git-newsetup or
> not.

It built and ran 2.6.22-rc1-git4 happily.


