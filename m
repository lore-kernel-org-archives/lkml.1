Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbZLBP12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbZLBP12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbZLBP12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:27:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750815AbZLBP11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:27:27 -0500
Date: Wed, 2 Dec 2009 07:26:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: npiggin@suse.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, jbeulich@novell.com,
       a.p.zijlstra@chello.nl, JBeulich@novell.com, tglx@linutronix.de,
       mingo@elte.hu
Subject: Re: [tip:core/locking] locking, x86: Slightly shorten
 __ticket_spin_trylock()
In-Reply-To: <tip-133ec7a235160dd44cbd4d82fff65a9983331df9@git.kernel.org>
Message-ID: <alpine.LFD.2.00.0912020714420.2872@localhost.localdomain>
References: <4B0FF9AC0200007800022713@vpn.id2.novell.com> <tip-133ec7a235160dd44cbd4d82fff65a9983331df9@git.kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Dec 2009, tip-bot for Jan Beulich wrote:
> 
> locking, x86: Slightly shorten __ticket_spin_trylock()

NAK. This is horrible crap. Don't ever send me this kind of broken patch 
again.

> -	int new;
> +	union { int i; bool b; } new;

No thank you. This is total bogosity.

You have zero idea what type "bool" is, do you? It can well be "int", it 
can be "char", it can be some compiler-internal type ("_Bool"). You have 
no idea what size it is.

And maybe it _is_ just a byte. But even if it is, using 'bool' here is 
wrong. The fact is, bool has magic semantic properties outside of sizing. 
You can't mix it with inline asm, because you simply don't know what the 
compiler rules for 'bool' are.

For example, maybe the rules are that it's always passed as an integer, 
and is always guaranteed to have the values 0/1. So even if 'sizeof' 
returns 1, that doesn't actually mean that you can necessarily pass it 
around as a char - it only means that it will take one byte in a structure 
(except that bool arrays might be packed, I think).

In other words, the semantics of 'bool' are such that you have no clue 
what the actual ABI for 'bool' is. You cannot mix this with asm.

Secondly, the notion of using a union here is just totally broken. There's 
no point to it, and it just makes the code look horrible.

So if you want to do this, then just keep 'new' as an int, and make sure 
that the function returns a 'char'. No games with 'bool' which is badly 
defined, no games with unions.

And please do make sure that it actually doesn't deprove code at the 
callers too.

				Linus
