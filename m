Return-Path: <linux-kernel-owner+w=401wt.eu-S1758304AbYFSMUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304AbYFSMUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbYFSMUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:20:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:51411 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbYFSMUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:20:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pYjju8voR5zdWw7W2tZmrT3m2WYSnzEnU0xHNEYrFNp0P2Ch15T4YOSXgUjD/tpiid
         3AfPs58iT+VCxvirA50HsW6MfiiiKrbFwHefB8+HmxJTo+cc4SqVs9oDMhWPn0Jk7xxP
         0u0TkvgfVGLxiB73DwC8SdtwoHMtSevAzCj7Y=
Message-ID: <961aa3350806190520m28edf130x3bb40d1ced56a303@mail.gmail.com>
Date: Thu, 19 Jun 2008 21:20:47 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1 of 4] mm: add a ptep_modify_prot transaction abstraction
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>, benh@kernel.crashing.org,
       xen-devel <xen-devel@lists.xensource.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       kvm-devel <kvm-devel@lists.sourceforge.net>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "Virtualization Mailing List" <virtualization@lists.osdl.org>,
       "Hugh Dickins" <hugh@veritas.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20080619115832.GM15228@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b020e42384197b824320.1213615800@localhost>
	 <1213831403.8011.24.camel@pasglop> <4859A149.9090004@goop.org>
	 <4859A528.1010107@goop.org>
	 <alpine.LFD.1.10.0806181723400.2907@woody.linux-foundation.org>
	 <4859AA47.2020903@goop.org>
	 <alpine.LFD.1.10.0806181743390.2907@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0806182050470.2907@woody.linux-foundation.org>
	 <20080619115832.GM15228@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Below is the commit, it needed a small amount of massaging to apply the
> void * -> unsigned long * change in the x86/bitops topic.

So you need to change this line

> +#define CONST_MASK_ADDR BITOP_ADDR(addr + (nr>>3))

to be

#define CONST_MASK_ADDR BITOP_ADDR((void *)addr + (nr>>3))

or something like this. Otherwise it will get wrong address in set_bit

> -static inline void set_bit(int nr, volatile unsigned long *addr)
> +static inline void set_bit(unsigned int nr, volatile unsigned long *addr)
>  {
> -       asm volatile(LOCK_PREFIX "bts %1,%0" : ADDR : "Ir" (nr) : "memory");
> +       if (IS_IMMEDIATE(nr))
> +               asm volatile(LOCK_PREFIX "orb %1,%0" : CONST_MASK_ADDR : "i" (CONST_MASK) : "memory");
> +       else
> +               asm volatile(LOCK_PREFIX "bts %1,%0" : ADDR : "Ir" (nr) : "memory");
>  }
