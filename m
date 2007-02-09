Return-Path: <linux-kernel-owner+w=401wt.eu-S1752558AbXBIXmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbXBIXmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 18:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbXBIXmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 18:42:42 -0500
Received: from ozlabs.org ([203.10.76.45]:53119 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbXBIXml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 18:42:41 -0500
Subject: Re: [PATCH 4 of 7]  lguest: Config and headers
From: Rusty Russell <rusty@rustcorp.com.au>
To: James Morris <jmorris@namei.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.osdl.org>
In-Reply-To: <Pine.LNX.4.64.0702091304090.9927@d.namei>
References: <1171033146.2718.157.camel@localhost.localdomain>
	 <1171033383.2718.163.camel@localhost.localdomain>
	 <1171033436.2718.165.camel@localhost.localdomain>
	 <1171033484.2718.167.camel@localhost.localdomain>
	 <1171033741.2718.172.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0702091304090.9927@d.namei>
Content-Type: text/plain
Date: Sat, 10 Feb 2007 10:41:55 +1100
Message-Id: <1171064515.15356.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-09 at 13:15 -0500, James Morris wrote:
> On Sat, 10 Feb 2007, Rusty Russell wrote:
> 
> > +/* 64k ought to be enough for anybody! */
> > +#define HYPERVISOR_MAP_ORDER 16
> > +#define HYPERVISOR_PAGES ((1 << HYPERVISOR_MAP_ORDER)/PAGE_SIZE)
> 
> I think it'd be better to go back to defining HYPERVISOR_SIZE then derive 
> the map order from that via get_order(), as it should be 4 instead of 16; 
> and this code is now both implying PAGE_SIZE while also using it for 
> calculations. 

Well it was the use of get_order() which triggered Andi's alarm bells,
so I went back to deriving it.  This code is correct, however.

get_order() is one of those classic functions only a kernel coder could
love.  Look how lovingly it has been optimized:

#define get_order(n)							\
(									\
	__builtin_constant_p(n) ?					\
	((n < (1UL << PAGE_SHIFT)) ? 0 : ilog2(n) - PAGE_SHIFT) :	\
	__get_order(n, PAGE_SHIFT)					\
 )

All that time spent, yet no consideration that it should be called
"get_page_order()" or some name which hints that the divide by page size
is happening.  It's even documented in the comment above, so someone
thought it needed explaining.  Too bad they chose to explain it instead
of actually clarifying it. 8(

Cheers,
Rusty.


