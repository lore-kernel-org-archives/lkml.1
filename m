Return-Path: <linux-kernel-owner+w=401wt.eu-S932420AbYGQVGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420AbYGQVGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 17:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757832AbYGQVGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 17:06:15 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36584 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756791AbYGQVGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 17:06:14 -0400
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs
	(part1: use kprobe symbol_name/offset instead of address)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
In-Reply-To: <20080717202634.GI18295@redhat.com>
References: <1216146802.3312.95.camel@localhost.localdomain>
	 <487E78ED.30804@redhat.com>
	 <1216249383.3358.69.camel@localhost.localdomain>
	 <487E8CE4.70105@redhat.com>
	 <1216259391.3358.85.camel@localhost.localdomain>
	 <1216304290.5515.11.camel@localhost.localdomain>
	 <1216313914.5515.25.camel__21144.9282979176$1216314027$gmane$org@localhost.localdomain>
	 <y0m7ibkjrcj.fsf@ton.toronto.redhat.com>
	 <1216325546.5515.63.camel@localhost.localdomain>
	 <20080717202634.GI18295@redhat.com>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 16:06:09 -0500
Message-Id: <1216328769.5515.78.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-17 at 16:26 -0400, Frank Ch. Eigler wrote:
> Hi -
> 
> On Thu, Jul 17, 2008 at 03:12:26PM -0500, James Bottomley wrote:
> > [...]
> > > Can you explain in detail how you believe this is materially
> > > different from offsetting from _stext?
> > 
> > Basically because _stext is an incredibly dangerous symbol; being linker
> > generated it doesn't actually get put in the right place if you look:
> 
> Thank you for your response.
> 
> > jejb@sparkweed> nm vmlinux |egrep -w '_stext|_text'
> > ffffffff80209000 T _stext
> > ffffffff80200000 A _text
> > 
> > Since we can't do negative offsets
> 
> Actually, "we" as in systemtap could do it just fine if that were
> desired.  And really _stext is therefore an arbitrary choice - it
> could be any other reference.
> 
> My point is that the proposed effort to identify a nearby function
> symbol to use as a base for each probe's symbol+offset calculation is
> wasted.

It's not exactly wasted ... the calculations have to be done anyway for
modules.

> > you've lost access to the symbols in the sections that start before _stext.  
> 
> What's between _text and _stext appears to consist of kernel boot-time
> functions that are unmapped the time anything like systemtap could
> run.

Well, no, they're the head code.  It's actually used in CPU boot and
tear down, one of the things it's useful to probe, I think.

> > Assuming you meant _text (which is dangerous because it's a define
> > in the kernel linker script and could change).
> 
> By "dangerous" do you only mean that it may require a one-liner
> catch-up patch in systemtap if the kernel linker scripts change?

Dangerous as in it's not necessarily part of the kernel linker scripts.
Some arches have it defined as a symbol, some have it as a linker script
definition ... that's why it's location is strange.

The point, really, is to remove some of the fragile dependencies between
systemtap and the kernel.

> > Then you can't offset into other sections, like init sections or
> > modules.
> 
> Kernel init sections are unprobeable by definition, so that doesn't
> matter.  Modules are also irrelevant, since their addresses are
> relative to their relocation bases / sections, not to a kernel
> (vmlinux) symbol.

Then the definition needs altering.  I can see that the industrial
customers aren't interested but kernel developers are ... a lot of
problems occur in the init sections.

I think you'll find that systemtap will run quite happily from a shell
in an initramfs before the init sections are discarded.  Plus there's
always module init sections which can appear at any time.

James


