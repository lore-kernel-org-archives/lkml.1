Return-Path: <linux-kernel-owner+w=401wt.eu-S1760232AbYG1Qv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232AbYG1Qv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759716AbYG1Qst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:48:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759708AbYG1Qss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:48:48 -0400
Date: Mon, 28 Jul 2008 09:45:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Andrea Righi <righi.andrea@gmail.com>, akpm@linux-foundation.org,
       linux-mm@kvack.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm: unify pmd_free() implementation
In-Reply-To: <1217261852.3503.89.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.10.0807280937150.3486@nehalem.linux-foundation.org>
References: <> <1217260287-13115-1-git-send-email-righi.andrea@gmail.com>  <alpine.LFD.1.10.0807280851130.3486@nehalem.linux-foundation.org> <1217261852.3503.89.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Jul 2008, James Bottomley wrote:
> 
> Are you sure about this (the barrier)?

I'm sure. Try it. It perturbs the code quite a bit to have a function call 
in the thing, because it

 - clobbers all callee-clobbered registers.

   This means that all functions that _used_ to be leaf functions and 
   needed no stack frame at all (because they were simple enough to use 
   only the callee-clobbered registers) are suddenly now going to be 
   significantly more costly.

   Ergo: you get more stack movement with save/restore crud.

 - it is a barrier wrt any variables that may be visible externally 
   (perhaps because they had their address taken), so it forces a flush to 
   memory for those.

 - if it has arguments and return values, it also ends up forcing a 
   totally unnecessary argument setup (and all the fixed register crap 
   that involves, which means that you lost almost all your register 
   allocation freedom - not that you likely care, since most of your 
   registers are dead _anyway_ around the function call)

So empty functions calls are _deadly_ especially if the code was a leaf 
function before, and suddenly isn't any more.

On the other hand, there are also many cases where function calls won't 
matter much at all. If you had other function calls around that same area, 
all the above issues essentially go away, since your registers are dead 
anyway, and the function obviously wasn't a leaf function before the new 
call.

So it does depend quite a bit on the pattern of use. And yes, function 
argument setup can be a big part of it too.

				Linus
