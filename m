Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbYIWGNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbYIWGNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 02:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYIWGNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 02:13:24 -0400
Received: from gw.goop.org ([64.81.55.164]:51950 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbYIWGNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 02:13:23 -0400
Message-ID: <48D88904.4030909@goop.org>
Date: Mon, 22 Sep 2008 23:13:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: PTE access rules & abstraction
References: <1221846139.8077.25.camel@pasglop> <48D739B2.1050202@goop.org>	 <1222117551.12085.39.camel@pasglop>  <20080923031037.GA11907@wotan.suse.de> <1222147886.12085.93.camel@pasglop>
In-Reply-To: <1222147886.12085.93.camel@pasglop>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Tue, 2008-09-23 at 05:10 +0200, Nick Piggin wrote:
>   
>> We are getting better slowly I think (eg. you note that set_pte_at is
>> no longer used as a generic "do anything"), but I won't dispute that
>> this whole area could use an overhaul; a document for all the rules,
>> a single person or point of responsibility for those rules...
>>     
>
> Can we nowadays -rely- on set_pte_at() never being called to overwrite
> an already valid PTE ? I mean, it looks like the generic code doesn't do
> it anymore but I wonder if it's reasonable to forbid that from coming
> back ? That would allow me to remove some hacks in ppc64 and simplify
> some upcoming ppc32 code.
>   

A good first step might be to define some conventions.  For example,
define that set_pte*() *always* means setting a non-valid pte to either
a new non-valid state (like a swap reference) or to a valid state. 
modify_pte() would modify the flags of a valid
pte, giving a new valid pte.  etc...

It may be that a given architecture collapses some or all of these down
to the same underlying functionality, but it would allow the core intent
to be clearly expressed.

What is the complete set of primitives we need?  I also noticed that a
number of the existing pagetable operations are used only once or twice
in the core code; I wonder if we really need such special cases, or
whether we can make each arch pte operation carry a bit more weight?

Also, rather than leaving all the rule enforcing to documentation and a
maintainer, we should also consider having a debug mode which adds
enough paranoid checks to each operation so that any rule breakage will
fail obviously on all architectures.

    J
