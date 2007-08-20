Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbXHTBux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbXHTBux (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 21:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbXHTBup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 21:50:45 -0400
Received: from ozlabs.org ([203.10.76.45]:45111 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590AbXHTBuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 21:50:44 -0400
Subject: Re: [PATCH] [5/12] x86_64: Make patching more robust, fix paravirt
	issue
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, patches@x86-64.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <46C637B7.30200@goop.org>
References: <20070809241.425881000@suse.de>
	 <20070809124132.C794A14F3B@wotan.suse.de>  <46C637B7.30200@goop.org>
Content-Type: text/plain
Date: Mon, 20 Aug 2007 11:50:28 +1000
Message-Id: <1187574628.19435.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-17 at 17:05 -0700, Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> > Commit 19d36ccdc34f5ed444f8a6af0cbfdb6790eb1177 "x86: Fix alternatives
> > and kprobes to remap write-protected kernel text" uses code which is
> > being patched for patching.
> >
> > In particular, paravirt_ops does patching in two stages: first it
> > calls paravirt_ops.patch, then it fills any remaining instructions
> > with nop_out().  nop_out calls text_poke() which calls
> > lookup_address() which calls pgd_val() (aka paravirt_ops.pgd_val):
> > that call site is one of the places we patch.
> >
> > If we always do patching as one single call to text_poke(), we only
> > need make sure we're not patching the memcpy in text_poke itself.
> > This means the prototype to paravirt_ops.patch needs to change, to
> > marshal the new code into a buffer rather than patching in place as it
> > does now.  It also means all patching goes through text_poke(), which
> > is known to be safe (apply_alternatives is also changed to make a
> > single patch).
> >   
> 
> Hi Andi,
> 
> This patch breaks Xen booting.  I get infinite recursive faults during
> patching when this patch is present.  If I boot with
> "noreplace-paravirt" it works OK, and it works as expected if I back
> this patch out.  I haven't tracked down the exact failure mode; its a
> little hard to debug because it overwrites all kernel memory with
> recursive fault stackframes and then finally traps out to Xen when it
> hits the bottom of memory.
> 
> I think we should back this one out before .23.

Then back out 19d36ccdc34f5ed444f8a6af0cbfdb6790eb1177 too, which broke
lguest booting, and this tried to fix.

Rusty.

