Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbZBEPAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbZBEPAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 10:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbZBEPAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 10:00:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58632 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbZBEPAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 10:00:42 -0500
Date: Thu, 5 Feb 2009 16:00:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Brian Gerst <brgerst@gmail.com>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 2/3] xen: make direct versions of
	irq_enable/disable/save/restore to common code
Message-ID: <20090205150028.GD23903@elte.hu>
References: <4983AC87.5000304@goop.org> <498A87B5.3020808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498A87B5.3020808@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <htejun@gmail.com> wrote:

> Hello,
> 
> Jeremy Fitzhardinge wrote:
> > Now that x86-64 has directly accessible percpu variables, it can also
> > implement the direct versions of these operations, which operate on a
> > vcpu_info structure directly embedded in the percpu area.
> > 
> > In fact, the 64-bit versions are more or less identical, and so can be
> > shared.  The only two differences are:
> > 1. xen_restore_fl_direct takes its argument in eax on 32-bit, and rdi on
> > 64-bit.
> >    Unfortunately it isn't possible to directly refer to the 2nd lsb of
> > rdi directly
> >    (as you can with %ah), so the code isn't quite as dense.
> > 2. check_events needs to variants to save different registers.
> > 
> > Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > ---
> > arch/x86/xen/Makefile     |    3 arch/x86/xen/xen-asm.S    |  140
> > +++++++++++++++++++++++++++++++++++++++++++++
> > arch/x86/xen/xen-asm.h    |   12 +++
> > arch/x86/xen/xen-asm_32.S |  113 ++++--------------------------------
> > arch/x86/xen/xen-asm_64.S |  136
> > +------------------------------------------
> > 5 files changed, 171 insertions(+), 233 deletions(-)
> ...
> > ===================================================================
> > --- a/arch/x86/xen/xen-asm_32.S
> > +++ b/arch/x86/xen/xen-asm_32.S
> > @@ -11,101 +11,28 @@
> >     generally too large to inline anyway.
> >  */
> > 
> > -#include <linux/linkage.h>
> > -
> > -#include <asm/asm-offsets.h>
> > +//#include <asm/asm-offsets.h>
> 
> Applied without the above addition of //

btw., that's still worth fixing, plus the comments styles could be 
standardized. And this should grow an extra space after the comma:

        lea 4(%edi),%esp                /* point esp to new frame */

(there's 5-6 similar instructions in that file with this problem - the rest 
is fine.)

	Ingo
