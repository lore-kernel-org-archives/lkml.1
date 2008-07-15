Return-Path: <linux-kernel-owner+w=401wt.eu-S1763175AbYGOTwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763175AbYGOTwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbYGOTwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:52:13 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42392 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761522AbYGOTwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:52:11 -0400
Subject: Re: [RFC] systemtap: begin the process of using proper kernel APIs
	(part1: use kprobe symbol_name/offset instead of address)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
In-Reply-To: <y0mr69vj5p0.fsf@ton.toronto.redhat.com>
References: <1216146802.3312.95.camel__45052.4692344063$1216146917$gmane$org@localhost.localdomain>
	 <y0mr69vj5p0.fsf@ton.toronto.redhat.com>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 14:52:06 -0500
Message-Id: <1216151526.3312.102.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 15:41 -0400, Frank Ch. Eigler wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> > One of the big nasties of systemtap is the way it tries to embed
> > virtually the entirety of the kernel symbol table in the probe
> > modules it constructs.
> 
> It is a compromise of conflicting requirements. 

Well ... in order to make forward progress, since the systemtap people
expressed a desire to be better integrated with the kernel, the first
order of business is to use the correct APIs ... that has to happen even
before an evaluation can be made of which pieces of the systemtap
runtime should move into the kernel.

> > This is highly undesirable because it represents a subversion of the
> > kernel API to gain access to unexported symbols.
> 
> Please elaborate.  Does the translator or its runtime use unexported
> symbols?  (That would arouse the question about why.)
> 
> Or are you talking about being able to *probe* unexported functions or
> access unexported data?  That would be a deliberate feature.

No ... I'm talking about _stp_module_relocate() at this point.  It's an
unnecessary function, since the kprobes API provides a way to attach to
a symbol and an offset.  The API allows access to unexported functions.

> > At least for kprobes, the correct way to do this is to specify the
> > probe point by symbol and offset.
> 
> But there won't be just kprobes.  Much of this code was built with
> anticipation of user-space probing, and there the kernel won't have a
> similar mechanism.  Similarly, the code is written to work with old
> kernels too - ones that predate the symbol+offset kprobe API.

OK ... you've got me there ... why would user space probing necessitate
resolution of kernel space symbols?  Surely you plan to use an exported
module API of utrace or whatever the agreed framework is?

> Unless someone is about to rip out pure address-based kprobes, I see
> no reason to complicate the code.

If you actually look, you'll see that pure addressed based kprobes still
work.

Also, I think you'll find it simplifies the code, since tons of the
runtime junk that duplicate the in-kernel symbol resolution can be
thrown out, plus the corresponding pieces of systemtap that have to
worry about this.

There's also the architectural worry:  this scheme you currently use is
very fragile.  For instance, I don't see it surviving a move to
-ffunction-sections (which patches are already going over linux-arch).

James


