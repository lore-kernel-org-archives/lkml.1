Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab0BSQpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 11:45:12 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:48414 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab0BSQpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 11:45:09 -0500
Date: Fri, 19 Feb 2010 17:45:12 +0100
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH] x86: Add optimized popcnt variants
Message-ID: <20100219164512.GA492@aftab>
References: <4B758FC0.1020600@zytor.com>
 <20100212174751.GD3114@aftab>
 <4B75A66A.70005@zytor.com>
 <4B7BF5D6.3030701@suse.cz>
 <20100217172040.GC13429@aftab>
 <4B7C27D8.9050408@suse.cz>
 <4B7C29C1.10906@suse.cz>
 <20100218061923.GA1594@liondog.tnic>
 <20100219142205.GA32533@aftab>
 <4B7EB6EF.9010405@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7EB6EF.9010405@zytor.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, Feb 19, 2010 at 08:06:07AM -0800

<snip>

> > +unsigned long __arch_hweight64(__u64 w)
> > +{
> > +	unsigned long res = 0;
> > +
> > +#ifdef CONFIG_X86_32
> > +	return  __arch_hweight32((u32)w) +
> > +		__arch_hweight32((u32)(w >> 32));
> > +#else
> > +	asm (ALTERNATIVE("call __sw_hweight64", POPCNT, X86_FEATURE_POPCNT)
> > +		     : "="REG_OUT (res)
> > +		     : REG_IN (w));
> > +#endif /* CONFIG_X86_32 */
> > +
> > +	return res;
> > +}
> 
> You're still not inlining these.  They should be: there is absolutely no
> reason for code size to not inline them anymore.

Isn't better to have only those 4 locations for apply_alternatives to
patch wrt to popcnt instead of sprinkling alternatives sections around
the kernel in every callsite of hweight and its users? Or is the aim to
optimize even that "call __arch_hweightXX" away?

> > +unsigned long __arch_hweight64(__u64 w)
> > +{
> > +	return __sw_hweight64(w);
> > +}
> >  #endif /* _ASM_GENERIC_BITOPS_HWEIGHT_H_ */
> 
> and these are in a header file and *definitely* should be inlines.

Yep, done.

-- 
Regards/Gruss,
Boris.

-
Advanced Micro Devices, Inc.
Operating Systems Research Center
