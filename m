Return-Path: <linux-kernel-owner+w=401wt.eu-S932809AbXCPJ6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809AbXCPJ6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 05:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933275AbXCPJ6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 05:58:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33712 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932809AbXCPJ6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 05:58:08 -0400
Date: Fri, 16 Mar 2007 10:57:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: jeremy@goop.org, ak@muc.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, chrisw@sous-sol.org, zach@vmware.com,
       rusty@rustcorp.com.au, anthony@codemonkey.ws,
       torvalds@linux-foundation.org
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops callsites to make them patchable
Message-ID: <20070316095702.GA301@elte.hu>
References: <20070301232443.195603797@goop.org> <20070301232527.956565107@goop.org> <20070316092445.GM23174@elte.hu> <20070316.023331.59468179.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070316.023331.59468179.davem@davemloft.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri, 16 Mar 2007 10:24:45 +0100
> 
> > ugh. This is beyond ugly! Why dont we just compile two images, one 
> > for Xen and one for native, do two passes to get those two images 
> > and 'merge' them into a single vmlinuz (so that we still have a 
> > 'single' kernel unit to deal with on the distro side). This way we 
> > avoid all this crazy, limited, fragile patchery business...
> 
> Perhaps the problem can be dealt with using ELF relocations.
> 
> There is another case, discussed yesterday on netdev, where run-time 
> resolution of ELF relocations would be useful (for 
> very-very-very-read-only variables) so if it can solve this problem 
> too it would be nice to have a generic infrastructure for it.

yeah, and i really think this is very fundamental: we've already got a 
very nice tool that can do things like detect when we are paravirt and 
optimize and patch things in a machine-specific way. It can even reorder 
instructions and simulate the CPU's pipeline state and do very smart 
optimizations based on that. It's a really neat thing, they call it 
"GCC".

Limited, instruction-level patching like alternatives.h is fine because 
that makes it easier to support multiple, incompatible CPU 
architectures, without having to do a hugely intrusive split at the 
kernel RPM level.

but the level of 'binary patching' done by the paravirt and Xen goes way 
beyond that, and the changes here really underscore that we:

  _should not emulate the closed source world_

There the only solution is to binary-patch - because they have no source 
code. But here, we've got all the source code.

splitting the images and simply extending vmlinuz to have a 
'multi-image' format would not only eliminate a huge amount of hookery, 
it would also solve the problem of CONFIG_PARAVIRT bloating the native 
kernel's codepaths by ~7%.

nobody wants to boot a xen-paravirt kernel from a floppy, so image size 
is not an issue. In-RAM overhead would in fact be /reduced/, because 
currently all the paravirt overhead hits both the native and the 
paravirt kernel. Nor would /all/ of the vmlinuz have to be replicated in 
the images - it's enough to replicate only those functions that truly 
differ between the two build methods.

	Ingo
