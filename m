Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbZLBPei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbZLBPei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbZLBPeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:34:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791AbZLBPeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:34:36 -0500
Date: Wed, 2 Dec 2009 07:33:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jan Beulich <JBeulich@novell.com>
cc: Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl,
       Jeremy Fitzhardinge <jeremy@goop.org>, tglx@linutronix.de,
       mingo@redhat.com, npiggin@suse.de, linux-kernel@vger.kernel.org,
       linux-tip-commits@vger.kernel.org, hpa@zytor.com
Subject: Re: [tip:core/locking] locking, x86: Slightly shorten 
 __ticket_spin_trylock()
In-Reply-To: <4B168E7702000078000230C5@vpn.id2.novell.com>
Message-ID: <alpine.LFD.2.00.0912020727410.2872@localhost.localdomain>
References: <4B0FF9AC0200007800022713@vpn.id2.novell.com> <tip-133ec7a235160dd44cbd4d82fff65a9983331df9@git.kernel.org> <20091202132937.GA1564@elte.hu> <4B168293020000780002308E@vpn.id2.novell.com> <20091202142108.GA5815@elte.hu>
 <4B168E7702000078000230C5@vpn.id2.novell.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Dec 2009, Jan Beulich wrote:

> >>> Ingo Molnar <mingo@elte.hu> 02.12.09 15:21 >>>
> 792a99a9 <_raw_spin_lock>:
> ...
> >792a99f3:	89 d8                	mov    %ebx,%eax
> >792a99f5:	ff 15 d0 6c f2 79    	call   *0x79f26cd0
> >792a99fb:	85 c0                	test   %eax,%eax
> ...
> >792a9a2e:	89 f8                	mov    %edi,%eax
> >792a9a30:	ff 15 d0 6c f2 79    	call   *0x79f26cd0
> >792a9a36:	85 c0                	test   %eax,%eax
> 
> Assuming that these are the calls to __raw_spin_trylock, it is clear that
> the generated code isn't what we want: It should be test %al, %al in
> both cases.

See my previous email.  Using 'bool' was a mistake. It's _always_ a 
mistake. 

'bool' basically says that the compiler can assume magic things, and 
compile the thing to be anything it wants that is convenient for it. 
Put another way, 'bool' has a magic API. For all you know, the rule might 
even be that a 'bool' return value is always returned in a flag register 
(ok, on x86 that would be _very_ inconvenient, but it's _possible_). 

So the calling convention could have been

	call <bool-returning-function>
	jne ..	// jump if it returned non-zero

because the rule about bool is that it is just one bit of information, 
but exactly _how_ that bit is done is totally up to the compiler ABI.

In this case, the rule gcc implements on x86 is probably just "we pass it 
around as an 'int' that contains 0 or 1". So the code would work if you 
had left in the 'movzbl'.

End result: don't use bool.

			Linus
