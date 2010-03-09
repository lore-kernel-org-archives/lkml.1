Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab0CIQXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 11:23:30 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56080 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab0CIQX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:23:28 -0500
Date: Tue, 9 Mar 2010 17:23:52 +0100
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH] x86: Add optimized popcnt variants
Message-ID: <20100309162352.GB2371@aftab>
References: <20100223175457.GA2401@aftab>
 <4B841BC3.1000908@zytor.com>
 <20100223190614.GB2401@aftab>
 <4B875BBD.4060104@zytor.com>
 <20100226074714.GA15310@aftab>
 <4B88097E.7010608@zytor.com>
 <20100227082807.GA21706@aftab>
 <4B8979DA.9000201@zytor.com>
 <20100309153628.GA2371@aftab>
 <1268149840.5037.3.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268149840.5037.3.camel@laptop>
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

From: Peter Zijlstra <peterz@infradead.org>
Date: Tue, Mar 09, 2010 at 04:50:40PM +0100

> Should all be fine as it is, that patch
> ( http://lkml.org/lkml/2010/2/4/119 ) is against a kernel with fce877e3
> in, I've just checked and it still applies to tip/master as of this
> writing (although it grew a single 2 line offset for 1 hunk).

Well, this way, I'm getting

...
In file included from include/linux/kernel.h:15,
                 from /home/linux-2.6/arch/x86/include/asm/percpu.h:45,
                 from /home/linux-2.6/arch/x86/include/asm/current.h:5,
                 from /home/linux-2.6/arch/x86/include/asm/processor.h:15,
                 from /home/linux-2.6/arch/x86/include/asm/atomic.h:6,
                 from include/linux/crypto.h:20,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/bitops.h:52:1: warning: "HWEIGHT8" redefined
...

due to the fact that we have multiple definitions of HWEIGHT*:

The one batch is in <include/linux/bitops.h> introduced by fce877e3.

The other is in <include/asm-generic/bitops/const_hweight.h> which
is pulled in into <include/linux/bitops.h> through "#include
<asm/bitops.h>", which, in turn, <includes asm/arch_hweight.h> and
<include/asm-generic/bitops/const_hweight.h>.

The obvious resolution is to remove the HWEIGHT* batch from
<include/asm-generic/bitops/const_hweight.h> since they're functionally
identical with the ones in <include/linux/bitops.h>, no?

-- 
Regards/Gruss,
Boris.

-
Advanced Micro Devices, Inc.
Operating Systems Research Center
