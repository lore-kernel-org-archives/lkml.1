Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbXCRAre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbXCRAre (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 20:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbXCRArd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 20:47:33 -0400
Received: from ozlabs.org ([203.10.76.45]:32922 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbXCRArc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 20:47:32 -0400
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
	callsites to make them patchable
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu, ak@muc.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       chrisw@sous-sol.org, zach@vmware.com, anthony@codemonkey.ws,
       torvalds@linux-foundation.org, NetDev <netdev@vger.kernel.org>
In-Reply-To: <45FB005D.9060809@goop.org>
References: <20070301232443.195603797@goop.org>
	 <20070301232527.956565107@goop.org>	<20070316092445.GM23174@elte.hu>
	 <20070316.023331.59468179.davem@davemloft.net>  <45FB005D.9060809@goop.org>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 21:33:58 +1100
Message-Id: <1174127638.8897.75.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 13:38 -0700, Jeremy Fitzhardinge wrote:
> David Miller wrote:
> > Perhaps the problem can be dealt with using ELF relocations.
> >
> > There is another case, discussed yesterday on netdev, where run-time
> > resolution of ELF relocations would be useful (for
> > very-very-very-read-only variables) so if it can solve this problem
> > too it would be nice to have a generic infrastructure for it.
> 
> That's an interesting idea.  Have you or anyone else looked at what it
> would take to code up?
> 
> For this case, I guess you'd walk the relocs looking for references into
> the paravirt_ops structure.  You'd need to check that was a reference
> from an indirect jump or call instruction, which would identify a
> patchable callsite.  The offset into the pv_ops structure would identify
> which operation is involved.

I wrote a whole email on ways to do this, BUT...

Perhaps our patching code can already be vastly simplified to something
like:

#define pv_patch(call, args...) \
	asm volatile("8888:"); 
	call(args);
	asm volatile("8889:"
	 [ stuff to put 8889, 8888 and call in fixup section ]

The patching code doesn't even need to decode between those two: it
simply looks for an indirect call insn (0xff 0xd?).  If it finds more
than one, it doesn't patch.  If it only finds one, it patches.  We'll
probably hit them all just doing that.

> What are the netdev requirements?

Reading Ben LaHaise's (very cool!) patch, it's not clear that using
reloc postprocessing is going to be clearer than open-coding it as he
has done.

Rusty.


