Return-Path: <linux-kernel-owner+w=401wt.eu-S1764078AbYDYQoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764078AbYDYQoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 12:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761053AbYDYQoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 12:44:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760851AbYDYQop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 12:44:45 -0400
Date: Fri, 25 Apr 2008 09:37:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Andi Kleen <andi@firstfloor.org>, Jiri Slaby <jirislaby@gmail.com>,
       David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
       rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
       penberg@cs.helsinki.fi, clameter@sgi.com, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, pageexec@freemail.hu,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
In-Reply-To: <20080425162215.GA16273@elte.hu>
Message-ID: <alpine.LFD.1.10.0804250925341.2779@woody.linux-foundation.org>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu>
 <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425154854.GC3265@one.firstfloor.org> <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org> <20080425162215.GA16273@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 Apr 2008, Ingo Molnar wrote:
> 
> hm, right now we've got a debug protection in set_fixmap() to make sure 
> it's only ever called once. So it's going to be a noisy bootup. (but 
> it's a warning only) The patch below removes that.

No, I think the warning is good, I should have done some kind of 
clear_fixmap() after doing the mmap. 


But there was actually a much worse problem with my patch: __set_fixmap() 
is __init. Which means that my patch was just totally broken.

What I really wanted to do was to just follow the page tables and mark it 
writable temporarily over the whole loop, and get rid of the whole mess.

(We'd need to make __set_fixmap() non-init, and probably return the pte_t 
pointer that it used, so that we could then just use "native_pte_clear()" 
on the thing after having done the memcpy()).

I suspect I should have just kept using vmap(), even if I do dislike just 
how insanely expensive that likely is.

			Linus
