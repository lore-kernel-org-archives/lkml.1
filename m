Return-Path: <linux-kernel-owner+w=401wt.eu-S1758964AbYA1P4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964AbYA1P4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 10:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYA1P4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 10:56:03 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49185 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbYA1P4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 10:56:00 -0500
Date: Mon, 28 Jan 2008 07:55:34 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de, hpa@zytor.com
Subject: Re: [patch 1/3] x86: a new API for drivers/etc to control cache and
 other page attributes
Message-ID: <20080128075534.361de0ca@laptopd505.fenrus.org>
In-Reply-To: <p733asi80dm.fsf@bingen.suse.de>
References: <20080125144937.2709f9ae@laptopd505.fenrus.org>
	<p733asi80dm.fsf@bingen.suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 15:56:21 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> Arjan van de Ven <arjan@infradead.org> writes:
> 
> > Right now, if drivers or other code want to change, say, a cache
> > attribute of a page, the only API they have is change_page_attr().
> > c-p-a is a really bad API for this, because it forces the caller to
> > know *ALL* the attributes he wants for the page, not just the 1
> > thing he wants to change. So code that wants to set a page
> > uncachable, needs to be aware of the NX status as well etc etc etc.
> 
> Please think clearly through the various cases.
> 
> NX for areas which can be legitimately non NX (very few) is 100%
> transparently handled in c_p_a() no matter what the caller passes in.

1) that didn't used to be the case upto and including 2.6.24
2) even for the various arch/x86 pieces there were.. interesting issues there

The new API is a lot simpler, and it is INTENT driven.
This means that PAT (for 2.6.26) no longer has to second guess various things
and capabilities, it just gets a set_memory_uc() or set_memory_wc() call and 
it can do the right thing for the hw/sw combination at hand.

c_p_a() doesn't give you intent, it gives you a whole range of bits, and it's 
not clear which ones the caller cares about.


 
> So if you look closely at the various cases there is no legitimate
> reason to ever use anything other than the standard PAGE_KERNEL_*
> defines with change_page_attr()

I looked carefully at all the cases, and there are basically 2 classes
1) Drivers needed memory to be uncached (or in 2.6.26, wc) 
2) Core x86 code needing to change 1 attribute only for various reasons

The new API caters to both in a very natural way, while allowing the implementation
to deal with things like PAT etc in a much more natural way because the intent
is given, and only the intent is changed in behavior.
 
> The only exception I know of is the cpa selftest which can change
> attributes of arbitrary pages, but that one does a lookup_address on
> its own anyways.

yeah the selftest was quite buggy; it would look at the first page of a range,
and then mark the entire range with that attribute. This explodes nicely if the
first page is in the read only .rodata section, but the range extends well beyond that... 
it made the .data section and more read only. That works great... for about 100 nanoseconds.

 
> You basically solved a non-issue here.

Given the amount of issues in this area of code (now and in the future with PAT), including
int the cpa-selftest that you wrote and was buggy in using cpa, I would have to disagree with you.



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
