Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbYBPNFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbYBPNFu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 08:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755641AbYBPNFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 08:05:39 -0500
Received: from www.tglx.de ([62.245.132.106]:34930 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbYBPNFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 08:05:38 -0500
Date: Sat, 16 Feb 2008 14:05:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       buytenh@wantstofly.org, mingo@elte.hu, riku.voipio@movial.fi,
       stable@kernel.org, schwidefsky@de.ibm.com
Subject: Re: + futex-runtime-enable-pi-and-robust-functionality.patch added
 to -mm tree
In-Reply-To: <20080216124248.GA4900@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.LFD.1.00.0802161346350.7583@apollo.tec.linutronix.de>
References: <200802150149.m1F1n8Gx013909@imap1.linux-foundation.org> <20080216124248.GA4900@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008, Heiko Carstens wrote:
> > +	/*
> > +	 * This will fail and we want it. Some arch implementations do
> > +	 * runtime detection of the futex_atomic_cmpxchg_inatomic()
> > +	 * functionality. We want to know that before we call in any
> > +	 * of the complex code paths. Also we want to prevent
> > +	 * registration of robust lists in that case. NULL is
> > +	 * guaranteed to fault and we get -EFAULT on functional
> > +	 * implementation, the non functional ones will return
> > +	 * -ENOSYS.
> > +	 */
> > +	curval = cmpxchg_futex_value_locked(NULL, 0, 0);
> > +	if (curval == -EFAULT)
> > +		futex_cmpxchg_enabled = 1;
> > +
> 
> Why should that fail? You're accessing a kernel space address here and no
> user space address.

Well, NULL pointer dereferencing is supposed to fail, isn't it ?

> Indeed it does fail with an Oops on s390 since we enable low address
> protection in the kernel so we get an exception if something within the
> kernel writes to the first 512 bytes of the kernel address space.
> Otherwise it would have silently passed the test...

NULL pointer dereferencing faults on all architectures, at least it
should, but we explicitely disable pagefaults and recover via the
extable fixup, which is in S390 as well. That returns -EFAULT and
signals that there is a working implementation, while those which have
no support return -ENOSYS, which keeps the robust/pi stuff disabled.

Thanks,

	tglx
