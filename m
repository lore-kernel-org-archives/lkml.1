Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598Ab0AHPgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab0AHPgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 10:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511Ab0AHPgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 10:36:40 -0500
Received: from verein.lst.de ([213.95.11.210]:58152 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488Ab0AHPgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 10:36:40 -0500
Date: Fri, 8 Jan 2010 16:34:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux@arm.linux.org.uk, starvik@axis.com, jesper.nilsson@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.jp, takata@linux-m32r.org,
       geert@linux-m68k.org, zippel@linux-m68k.org, gerg@uclinux.org,
       ralf@linux-mips.org, benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, lethal@linux-sh.org, davem@davemloft.net,
       jdike@addtoit.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH v3 3/3] generic sys_ipc wrapper
Message-ID: <20100108153443.GA14494@lst.de>
References: <20100106172152.GC17163@lst.de> <20100108095023.GA29560@lst.de> <20100108100347.GA30353@lst.de> <201001081157.17195.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001081157.17195.arnd@arndb.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 11:57:17AM +0100, Arnd Bergmann wrote:
> > Add a generic implementation of the ipc demultiplexer syscall.  Except for
> > s390 and sparc64 all implementations of the sys_ipc are nearly identical.
> 
> I think the s390 version is trivial to add as well, like
> 
> SYSCALL_DEFINE5(s390_ipc, uint, call, int, first, unsigned long, second,
>  		unsigned long, third, void __user *, ptr)
> {
> 	if (call == SEMTIMEDOP)
> 		return sys_semtimedop(first, (struct sembuf __user *)ptr,
> 				      (unsigned) second,
> 				      (const struct timespec __user *)third);
> 
> 	return sys_ipc(call & 0xffff, first, second, third, ptr, 0);
> }

Possiblly.  Not sure if it's worth it, though.  If the s390 maintainers
want it I'd say do it as a separate patch.

> But while going over the code again, I noticed that you broke sign extension
> at least on powerpc and s390, possibly on all 64 bit machines:

> > +			return -EINVAL;
> > +		if (get_user(fourth.__pad, (void __user * __user *) ptr))
> > +			return -EFAULT;
> > +		return sys_semctl(first, second, third, fourth);
> 
> 		return sys_semctl(first, (int)second, third, fourth);

What does the explicit case buy us in terms of sign-extension over
the implicit one given that the second argument to sys_semctl already is
types as int?

> This is needed to make sure the upper half of the register is filled with
> zero-extended or sign-extended correctly and does not contain random garbage
> in the native 64 bit case. IIRC, x86_64 does not have this problem and mips64
> may have the wrong code already. Alpha, parisc and ia64 don't have a native
> sys_ipc and the rest are 32 bit, so they don't care.

I can fix it up, but I don't quite understand the need.

