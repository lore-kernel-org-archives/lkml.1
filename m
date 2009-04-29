Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832AbZD2DtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbZD2DtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 23:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbZD2DtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 23:49:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:38017 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbZD2DtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 23:49:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,264,1239001200"; 
   d="scan'208";a="137083322"
Date: Wed, 29 Apr 2009 11:48:29 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "mpm@selenic.com" <mpm@selenic.com>,
       "adobriyan@gmail.com" <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Chandra Seetharaman <sekharan@us.ibm.com>, Nathan Lynch <ntl@pobox.com>,
       Olof Johansson <olof@lixom.net>, Helge Deller <deller@parisc-linux.org>
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
Message-ID: <20090429034829.GA10832@localhost>
References: <20090428010907.912554629@intel.com> <20090428014920.769723618@intel.com> <20090428143244.4e424d36.akpm@linux-foundation.org> <20090429023842.GA10266@localhost> <20090428195527.4638f58c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428195527.4638f58c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 10:55:27AM +0800, Andrew Morton wrote:
> On Wed, 29 Apr 2009 10:38:42 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > > > +#define kpf_copy_bit(uflags, kflags, visible, ubit, kbit)		\
> > > > +	do {								\
> > > > +		if (visible || genuine_linus())				\
> > > > +			uflags |= ((kflags >> kbit) & 1) << ubit;	\
> > > > +	} while (0);
> > > 
> > > Did this have to be implemented as a macro?
> > > 
> > > It's bad, because it might or might not reference its argument, so if
> > > someone passes it an expression-with-side-effects, the end result is
> > > unpredictable.  A C function is almost always preferable if possible.
> > 
> > Just tried inline function, the code size is increased slightly:
> > 
> >           text   data    bss     dec    hex   filename
> > macro     1804    128      0    1932    78c   fs/proc/page.o
> > inline    1828    128      0    1956    7a4   fs/proc/page.o
> > 
> 
> hm, I wonder why.  Maybe it fixed a bug ;)
> 
> The code is effectively doing
> 
> 	if (expr1)
> 		something();
> 	if (expr1)
> 		something_else();
> 	if (expr1)
> 		something_else2();
> 
> etc.  Obviously we _hope_ that the compiler turns that into
> 
> 	if (expr1) {
> 		something();
> 		something_else();
> 		something_else2();
> 	}
> 
> for us, but it would be good to check...

By 'expr1', you mean (visible || genuine_linus())?

No, I can confirm the inefficiency does not lie here.

I simplified the kpf_copy_bit() to

        #define kpf_copy_bit(uflags, kflags, ubit, kbit)                     \
                        uflags |= (((kflags) >> (kbit)) & 1) << (ubit);

or

        static inline u64 kpf_copy_bit(u64 kflags, int ubit, int kbit)
        {       
                return (((kflags) >> (kbit)) & 1) << (ubit);
        }

and double checked the differences: the gap grows unexpectedly!

              text               data                bss                dec            hex filename
macro         1829                168                  0               1997            7cd fs/proc/page.o
inline        1893                168                  0               2061            80d fs/proc/page.o
              +3.5%

(note: the larger absolute text size is due to some experimental code elsewhere.)

Thanks,
Fengguang
