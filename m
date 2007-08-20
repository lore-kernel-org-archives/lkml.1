Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbXHTCoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbXHTCoG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 22:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755058AbXHTCnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 22:43:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59227 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbXHTCnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 22:43:53 -0400
Subject: Re: [PATCH] Should GFP_ATOMIC fail when we're below low watermark?
From: Peter Zijlstra <peterz@infradead.org>
To: nigel@suspend2.net
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200708201138.50508.nigel@nigel.suspend2.net>
References: <200708201138.50508.nigel@nigel.suspend2.net>
Content-Type: text/plain
Date: Mon, 20 Aug 2007 04:43:50 +0200
Message-Id: <1187577830.6114.140.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-20 at 11:38 +1000, Nigel Cunningham wrote:
> Hi all.
> 
> In current git (and for a while now), an attempt to allocate memory with 
> GFP_ATOMIC will fail if we're below the low watermark level. The only way to 
> access that memory that I can see (not that I've looked that hard) is to have 
> PF_MEMALLOC set (ie from kswapd). I'm wondering if this behaviour is correct. 
> Shouldn't GFP_ATOMIC allocations ignore watermarks too? How about GFP_KERNEL?
> 
> The following patch is a potential fix for GFP_ATOMIC.

Sorry, no.

GFP_ATOMIC must fail when below the watermark. GFP_KERNEL has __GFP_WAIT
and hence can sleep and wait for reclaim so that should not be a problem
(usually).

GFP_ATOMIC may not access the reserves because the reserves are needed
to get out of OOM deadlocks within the VM. Consider the fact that
freeing memory needs memory - if there is no memory free, you cannot
free memory and you're pretty much stuck.

