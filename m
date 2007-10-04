Return-Path: <linux-kernel-owner+w=401wt.eu-S1759129AbXJDHmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129AbXJDHmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 03:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbXJDHmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 03:42:03 -0400
Received: from aun.it.uu.se ([130.238.12.36]:36041 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756517AbXJDHmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 03:42:00 -0400
Date: Thu, 4 Oct 2007 09:41:38 +0200 (MEST)
Message-Id: <200710040741.l947fcVQ012708@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-kernel@vger.kernel.org, riku.voipio@iki.fi
Subject: Re: [PATCH][RFC] unbreak generic futex_atomic_cmpxchg_inatomic() on UP
Cc: buytenh@wantstofly.org, mikpe@it.uu.se
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2007 22:33:46 +0300, Riku Voipio wrote:
> What's the state of this patch? I can confirm tst-robust1
> from glibc testsuite locks a armv5 machine hard. With this patch
> applied, the test succeeds.

There were no comments from any Linux arch or futex maintainer.
Because of that I intend to submit an ARM-only patch when 2.6.23
has been released.

/Mikael

> > The higher-end archs (x86, sparc64, ppc64, etc) provide fully-functional
> > asm/futex.h implementations, but a number of archs (alpha, arm, arm26,
> > avr32, blackfin, cris, h8300, m32r, m68k, mk68knommu, sh64, sparc, um,
> > v850, and xtensa) use asm-generic/futex.h, which makes robust futexes
> > horribly broken on them. There have also been reports recently that PI
> > futexes are broken due to the generic futex_atomic_cmpxchg_inatomic()
> > just being an -ENOSYS stub.
> 
> This an effective local DOS bug on the affected architectures, too.. 
> 
> > The patch below implements the generic futex_atomic_cmpxchg_inatomic() in
> > terms of __copy_{from,to}_user_inatomic() and preempt_{disable,enable}().
> > It obviously doesn't support SMP, but UP-only support should go a long
> > way for users of the affected archs.
> > 
> > I'm using this patch now and it has allowed me to build and use glibc-2.4
> > with NPTL on ARM (glibc-2.4-11.src.rpm from FC5 + ARM fixes).
> > (Finally I can ditch LinuxThreads :->)
> > 
> > Comments?
> > 
> > /Mikael
> > 
> > --- linux-2.6.22/include/asm-generic/futex.h.~1~	2007-02-04 19:44:54.000000000 +0100
> > +++ linux-2.6.22/include/asm-generic/futex.h	2007-08-01 19:03:43.000000000 +0200
> > @@ -4,6 +4,7 @@
> >  #ifdef __KERNEL__
> >  
> >  #include <linux/futex.h>
> > +#include <linux/preempt.h>
> >  #include <asm/errno.h>
> >  #include <asm/uaccess.h>
> >  
> > @@ -52,7 +53,34 @@ futex_atomic_op_inuser (int encoded_op, 
> >  static inline int
> >  futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
> > {
> > +#ifdef CONFIG_SMP
> >  	return -ENOSYS;
> > +#else
> > +	int curval, ret;
> > +
> > +	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
> > +		return -EFAULT;
> > +
> > +	preempt_disable();
> > +
> > +	ret = -EFAULT;
> > +	if (__copy_from_user_inatomic(&curval, uaddr, sizeof(int)))
> > +		goto out;
> > +
> > +	ret = curval;
> > +	if (curval != oldval)
> > +		goto out;
> > +
> > +	ret = -EFAULT;
> > +	if (__copy_to_user_inatomic(uaddr, &newval, sizeof(int)))
> > +		goto out;
> > +
> > +	ret = newval;
> > +
> > + out:
> > +	preempt_enable();
> > +	return ret;
> > +#endif
> >  }
> >  
> >  #endif
> > -
> 
> - -- 
> "rm -rf" only sounds scary if you don't have backups
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.6 (GNU/Linux)
> 
> iD8DBQFHA+6aibPvMsrqrwMRAlMuAKCBf7qpD2dETgU+RgnDG4ArVvFp3gCgrewq
> 4KvOt40U1MAPM7g4F/Ps5jk=
> =68gr
> -----END PGP SIGNATURE-----
> 
