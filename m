Return-Path: <linux-kernel-owner+w=401wt.eu-S1762084AbYA1QyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762084AbYA1QyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 11:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbYA1QyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 11:54:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55843 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853AbYA1QyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 11:54:03 -0500
Date: Mon, 28 Jan 2008 18:28:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@tglx.de, hpa@zytor.com
Subject: Re: [patch 1/3] x86: a new API for drivers/etc to control cache and other page attributes
Message-ID: <20080128172810.GA24952@one.firstfloor.org>
References: <20080125144937.2709f9ae@laptopd505.fenrus.org> <p733asi80dm.fsf@bingen.suse.de> <20080128075534.361de0ca@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128075534.361de0ca@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The new API is a lot simpler, and it is INTENT driven.
> This means that PAT (for 2.6.26) no longer has to second guess various things
> and capabilities, it just gets a set_memory_uc() or set_memory_wc() call and 

AFAIK there is no valid use case where you would ever change PAT
bits on a page you don't own. And on pages you own you should really
know the full capability bits anyways.

> c_p_a() doesn't give you intent, it gives you a whole range of bits, and it's 
> not clear which ones the caller cares about.

It needs to care about all of them if it wants to do anything
useful with the page.


> 
> 
>  
> > So if you look closely at the various cases there is no legitimate
> > reason to ever use anything other than the standard PAGE_KERNEL_*
> > defines with change_page_attr()
> 
> I looked carefully at all the cases, and there are basically 2 classes
> 1) Drivers needed memory to be uncached (or in 2.6.26, wc) 

Only on their own memory they control. And it better no be funny
in any other way. e.g. toggling RW there is obviously not a good idea,
unless the driver is aware of that.


> 2) Core x86 code needing to change 1 attribute only for various reasons

The two cases here are NX (transparent) and setting RO (only on freed pages
nobody else should mess with and freed pages should not have any 
PAT etc. attributes either).  

I maintain my earlier point that there is no valid use case for
changing bits on pages without you're being aware of all bits
(modulo NX which is transparent and self test) 

>  
> > The only exception I know of is the cpa selftest which can change
> > attributes of arbitrary pages, but that one does a lookup_address on
> > its own anyways.
> 
> yeah the selftest was quite buggy; it would look at the first page of a range,
> and then mark the entire range with that attribute. This explodes nicely if the

Yes that was a bug I had fixed here, unfortunately that fix never made
it in because I was forced to drop all my changes with the great rewrite.

> Given the amount of issues in this area of code (now and in the future with PAT), including
> int the cpa-selftest that you wrote and was buggy in using cpa, I would have to disagree with you.

The original code I wrote was correct but then I later decided to add
in variable length changes too which was not quite correct on the first
try. 

Anyways using the selftest for arguing general API changes seems somewhat
bogus to me because it is really an extremly specialized special case
that I don't expect to apply anywhere else. What it actually does is 
quite bogus.

-Andi
