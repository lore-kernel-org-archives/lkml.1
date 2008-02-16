Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbYBPNmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbYBPNmN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 08:42:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYBPNl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 08:41:58 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:33830 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbYBPNl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 08:41:57 -0500
Date: Sat, 16 Feb 2008 14:41:55 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       buytenh@wantstofly.org, mingo@elte.hu, riku.voipio@movial.fi,
       stable@kernel.org, schwidefsky@de.ibm.com
Subject: Re: + futex-runtime-enable-pi-and-robust-functionality.patch added
	to -mm tree
Message-ID: <20080216134155.GB4900@osiris.boeblingen.de.ibm.com>
References: <200802150149.m1F1n8Gx013909@imap1.linux-foundation.org> <20080216124248.GA4900@osiris.boeblingen.de.ibm.com> <alpine.LFD.1.00.0802161346350.7583@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802161346350.7583@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 02:05:13PM +0100, Thomas Gleixner wrote:
> On Sat, 16 Feb 2008, Heiko Carstens wrote:
> > > +	/*
> > > +	 * This will fail and we want it. Some arch implementations do
> > > +	 * runtime detection of the futex_atomic_cmpxchg_inatomic()
> > > +	 * functionality. We want to know that before we call in any
> > > +	 * of the complex code paths. Also we want to prevent
> > > +	 * registration of robust lists in that case. NULL is
> > > +	 * guaranteed to fault and we get -EFAULT on functional
> > > +	 * implementation, the non functional ones will return
> > > +	 * -ENOSYS.
> > > +	 */
> > > +	curval = cmpxchg_futex_value_locked(NULL, 0, 0);
> > > +	if (curval == -EFAULT)
> > > +		futex_cmpxchg_enabled = 1;
> > > +
> > 
> > Why should that fail? You're accessing a kernel space address here and no
> > user space address.
> 
> Well, NULL pointer dereferencing is supposed to fail, isn't it ?

I wasn't sure that this is true for all architectures, but...

> > Indeed it does fail with an Oops on s390 since we enable low address
> > protection in the kernel so we get an exception if something within the
> > kernel writes to the first 512 bytes of the kernel address space.
> > Otherwise it would have silently passed the test...
> 
> NULL pointer dereferencing faults on all architectures, at least it
> should, but we explicitely disable pagefaults and recover via the
> extable fixup, which is in S390 as well. That returns -EFAULT and
> signals that there is a working implementation, while those which have
> no support return -ENOSYS, which keeps the robust/pi stuff disabled.

...one of our exception table entries has an off-by-one bug.
Never mind, I'll go and fix our own stuff instead ;)
