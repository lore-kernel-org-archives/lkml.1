Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbZLBQY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbZLBQY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 11:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbZLBQY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 11:24:26 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:4310 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbZLBQYZ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;7:1>);
	Wed, 2 Dec 2009 11:24:25 -0500
Message-Id: <4B16A2CC020000780002313A@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 02 Dec 2009 16:24:28 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <tglx@linutronix.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>, <mingo@redhat.com>,
       <npiggin@suse.de>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [tip:core/locking] locking, x86: Slightly shorten
	 __ticket_spin_trylock()
References: <4B0FF9AC0200007800022713@vpn.id2.novell.com>
 <tip-133ec7a235160dd44cbd4d82fff65a9983331df9@git.kernel.org>
 <alpine.LFD.2.00.0912020714420.2872@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912020714420.2872@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Linus Torvalds <torvalds@linux-foundation.org> 02.12.09 16:26 >>>
>You have zero idea what type "bool" is, do you? It can well be "int", it 
>can be "char", it can be some compiler-internal type ("_Bool"). You have 
>no idea what size it is.
>
>And maybe it _is_ just a byte. But even if it is, using 'bool' here is 
>wrong. The fact is, bool has magic semantic properties outside of sizing. 
>You can't mix it with inline asm, because you simply don't know what the 
>compiler rules for 'bool' are.
>
>For example, maybe the rules are that it's always passed as an integer, 
>and is always guaranteed to have the values 0/1. So even if 'sizeof' 
>returns 1, that doesn't actually mean that you can necessarily pass it 
>around as a char - it only means that it will take one byte in a structure 
>(except that bool arrays might be packed, I think).
>
>In other words, the semantics of 'bool' are such that you have no clue 
>what the actual ABI for 'bool' is. You cannot mix this with asm.

This just can't be the case: In order for two compilers to be
interoperable, the processor specific ABI has to define the handling of
bool, just like it has to for any other data type.

>Secondly, the notion of using a union here is just totally broken. There's 
>no point to it, and it just makes the code look horrible.

There is a point: Avoiding to have the compiler allocate yet another
register for the asm().

>So if you want to do this, then just keep 'new' as an int, and make sure 
>that the function returns a 'char'. No games with 'bool' which is badly 
>defined, no games with unions.

I considered that, but since the code means to return a boolean value,
using a char here is as bogus as (mis-)using int-s for returning boolean
values.

>And please do make sure that it actually doesn't deprove code at the 
>callers too.

Not sure what you mean here (or whether it's a typo) - neither I nor
my dictionary know the word "deprove". I assume you mean that I ought
to check that this doesn't make worse the code at the call sites, which
I did.

Jan

