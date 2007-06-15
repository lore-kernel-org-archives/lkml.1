Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbXFOVXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbXFOVXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbXFOVXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:23:06 -0400
Received: from mail.suse.de ([195.135.220.2]:50205 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbXFOVXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:23:04 -0400
From: Andi Kleen <ak@suse.de>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
Date: Fri, 15 Jun 2007 23:22:06 +0200
User-Agent: KMail/1.9.1
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "David Howells" <dhowells@redhat.com>, "Arnd Bergmann" <arnd@arndb.de>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Dave Airlie" <airlied@linux.ie>, linux-arch@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       Bernd Schmidt <bernds_cb1@t-online.de>
References: <200706151355.57464.ak@suse.de> <200706151454.28854.ak@suse.de> <200706151650.53481.rgetz@blackfin.uclinux.org>
In-Reply-To: <200706151650.53481.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706152322.07739.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> For the architecture we use (Blackfin), it does not support unaligned
> accesses, and we purposely never put in the trap/fixup code - we trap, and
> printk("fix your source");

For the kernel you should fix up too in addition to the printk. Otherwise
you risk a ping of death in the field with some more obscure protocol.
Also the printk should be load limited.

> > > people have done
> > > that work so using the types without unaligned.
> >
> > Very brave; we're talking about around half a million lines
> > of non trivial source code here.
>
> Is there something specific that you can think of that we should be
> testing?

A lot of protocols have variable length headers.  Normally everything
is aligned, but an attacker could purposefully misalign some headers
using variable length padding, causing fields in later headers to be 
misaligned.

e.g. the original reason this was forbidden was because the TCP
option parser could be tricked into reading time stamps unaligned.
That code is now using get_unaligned(), but there are probably
other culprits too (there is a lot of code in the network stack) 

Unfortunately it is hard to test all combinations, so the only safe 
alternative would be to audit source code. Another possibility would be to
use a tainted data scheme similar sparse's __user/__iomem annotations with
a static code checker (or extending sparse), but that would also require a lot 
of work to do properly and add the necessarily annotations.

Also watch out for netfilter modules -- they make all this much more 
complex. And drivers possibly too.

> We have done alot of testing, and people have shipped alot of systems
> connected to a varity of networks, and have run all kinds of protocols on
> them.

Well behaved peers normally don't generate unaligned headers. But
that doesn't mean it couldn't be exploited by someone malicious.

-Andi
