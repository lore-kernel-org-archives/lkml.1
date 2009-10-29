Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbZJ2Pbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbZJ2Pbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 11:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbZJ2Pbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 11:31:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835AbZJ2Pbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 11:31:46 -0400
Date: Thu, 29 Oct 2009 08:31:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: akpm@linux-foundation.org, linux-cachefs@redhat.com,
       linux-kernel@vger.kernel.org, Roel Kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH] CacheFiles: Cleanup redundant tests on unsigned
In-Reply-To: <20091026155839.15099.72735.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LFD.2.01.0910290826350.31845@localhost.localdomain>
References: <20091026155839.15099.72735.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 26 Oct 2009, David Howells wrote:
>
> From: Roel Kluin <roel.kluin@gmail.com>
> 
> The variables are unsigned so the test `>= 0' is always true,
> the `< 0' test always fails. The other part of
> the test catches wrapped values.

This is an excellent example of why I think that some gcc warnings are 
pure and utter sh*t, and why just blindly trying to avoid them then leads 
to worse code.

> -	if (datalen < 0 || datalen > PAGE_SIZE - 1)
> +	if (datalen > PAGE_SIZE - 1)
> -	if (fstop < 0 || fstop >= cache->fcull_percent)
> +	if (fstop >= cache->fcull_percent)
> -	if (bstop < 0 || bstop >= cache->bcull_percent)
> +	if (bstop >= cache->bcull_percent)

You've now actively made the code more fragile, only to avoid a warning.

The old code was clearly correct. The new code subtle depends on the type 
of comparison. 

I _hate_ those idiotic warnings, and in this case the "warning-free" code 
is actively worse than the original.

A smart compiler would see that it's a range check, and one that could 
have been done as an unsigned comparison (well, for the constant compare 
case) regardless of the type of the variable being tested. So a _smart_ 
compiler wouldn't complain, but it might use the signedness information to 
silently simplify the comparison.

A _stupid_ compiler complains, and thus forces people to either ignore the 
warning, or make the code worse.

Which one would you prefer?

		Linus
