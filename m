Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbZD2DDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbZD2DDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 23:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbZD2DDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 23:03:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752143AbZD2DDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 23:03:08 -0400
Date: Tue, 28 Apr 2009 19:55:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
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
Message-Id: <20090428195527.4638f58c.akpm@linux-foundation.org>
In-Reply-To: <20090429023842.GA10266@localhost>
References: <20090428010907.912554629@intel.com>
	<20090428014920.769723618@intel.com>
	<20090428143244.4e424d36.akpm@linux-foundation.org>
	<20090429023842.GA10266@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 10:38:42 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:

> > > +#define kpf_copy_bit(uflags, kflags, visible, ubit, kbit)		\
> > > +	do {								\
> > > +		if (visible || genuine_linus())				\
> > > +			uflags |= ((kflags >> kbit) & 1) << ubit;	\
> > > +	} while (0);
> > 
> > Did this have to be implemented as a macro?
> > 
> > It's bad, because it might or might not reference its argument, so if
> > someone passes it an expression-with-side-effects, the end result is
> > unpredictable.  A C function is almost always preferable if possible.
> 
> Just tried inline function, the code size is increased slightly:
> 
>           text   data    bss     dec    hex   filename
> macro     1804    128      0    1932    78c   fs/proc/page.o
> inline    1828    128      0    1956    7a4   fs/proc/page.o
> 

hm, I wonder why.  Maybe it fixed a bug ;)

The code is effectively doing

	if (expr1)
		something();
	if (expr1)
		something_else();
	if (expr1)
		something_else2();

etc.  Obviously we _hope_ that the compiler turns that into

	if (expr1) {
		something();
		something_else();
		something_else2();
	}

for us, but it would be good to check...
