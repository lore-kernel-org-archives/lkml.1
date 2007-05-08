Return-Path: <linux-kernel-owner+w=401wt.eu-S1032318AbXEHVUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032318AbXEHVUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032185AbXEHVUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:20:36 -0400
Received: from gw.goop.org ([64.81.55.164]:58988 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031833AbXEHVUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:20:35 -0400
Message-ID: <4640E98B.4030107@goop.org>
Date: Tue, 08 May 2007 14:20:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [RFC/PATCH] doc: volatile considered evil
References: <516386418.20070501080839@gmail.com> <20070430235642.e576e917.akpm@linux-foundation.org> <20070508121404.17bd97a6.randy.dunlap@oracle.com> <alpine.DEB.0.99.0705081217180.12908@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.0.99.0705081217180.12908@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> Since 'volatile' has two different semantics depending on the context in 
> which it is used, this warning should be appended to include the fact that 
> it is legitimate to use for inline assembly.
>   


It's probably worth noting that "asm volatile (...)" doesn't mean what
many people think it means: specifically, it *does not* prevent the asm
from being reordered with respect to the surrounding code.  It may not
even prevent it from being reordered with respect to other asm
volatiles.  *All* it means is that the asm code will be emitted even if
the compiler doesn't think its results will be used.  Note that an
"asm()" with no outputs is implicitly "asm volatile()" - on the grounds
that it would be otherwise useless as far as gcc can tell.

If you need to guarantee ordering of asm statements, you must do it
explicitly, with either a "memory" clobber, or some finer-grain
serialization variable (like the _proxy_pda stuff).  It would be useful
if you could tell gcc "I'm passing this variable to the asm for
serialization purposes, but there's no need to generate any explicit
references to it", but as far as I know there's no support for that.

    J
