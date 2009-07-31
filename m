Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbZGaVQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbZGaVQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 17:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbZGaVQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 17:16:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753208AbZGaVQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 17:16:19 -0400
Date: Fri, 31 Jul 2009 14:15:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ulrich Drepper <drepper@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] information leak in sigaltstack
In-Reply-To: <200907311948.n6VJm5Gf010118@hs20-bc2-1.build.redhat.com>
Message-ID: <alpine.LFD.2.01.0907311407040.24841@localhost.localdomain>
References: <200907311948.n6VJm5Gf010118@hs20-bc2-1.build.redhat.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 31 Jul 2009, Ulrich Drepper wrote:
> 
> The following patch should fix the issue.

Hmm. Is there any reason not to do an unconditional memset(), and then 
expect gcc to avoid the unnecessary stores? I realize gcc may not do that, 
but we could always _hope_.

Also, is there really any reason to believe that the only hole can be 
after ss_flags, and that it's only the case when ss_flags is in the 
middle? Quite frankly, as far as I can tell, you could have an "int 
ss_flags" at the _end_ of the structure too, and have the same issue 
(padding out to the alignment of the struct).

For an example of that "'int ss_flags' at the end" look at MIPS.

Now, you'd end up with a memset() in that case (since it certainly won't 
match the offsetof), but my point is, the conditional really looks very 
arbitrary and rather strange. I'd rather see it unconditional, even if it 
costs three unnecessary writes or whatever.

		Linus
