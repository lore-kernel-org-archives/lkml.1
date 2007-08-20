Return-Path: <linux-kernel-owner+w=401wt.eu-S1761651AbXHTREF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761651AbXHTREF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 13:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759678AbXHTRDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 13:03:55 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:30051 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740AbXHTRDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 13:03:54 -0400
X-IronPort-AV: i="4.19,285,1183359600"; 
   d="scan'208"; a="393201902:sNHT49862886"
To: Arjan van de Ven <arjan@infradead.org>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, discuss@x86-64.org,
       linux-kernel@vger.kernel.org, jh@suse.cz
Subject: Re: [discuss] [PATCH] x86-64: memset optimization
X-Message-Flag: Warning: May contain useful information
References: <20070817163446.3e63f208@freepuppy.rosehill.hemminger.net>
	<200708182055.11277.ak@suse.de>
	<20070819010430.2c8c31fc@oldman.hemminger.net>
	<200708192024.24864.ak@suse.de>
	<20070820085253.5f589e58@freepuppy.rosehill.hemminger.net>
	<1187625068.2577.3.camel@laptopd505.fenrus.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 20 Aug 2007 10:03:46 -0700
In-Reply-To: <1187625068.2577.3.camel@laptopd505.fenrus.org> (Arjan van de Ven's message of "Mon, 20 Aug 2007 08:51:08 -0700")
Message-ID: <adamywmw32l.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Aug 2007 17:03:46.0548 (UTC) FILETIME=[122FA340:01C7E34C]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > The problem is with the optimization flags: passing -Os causes the compiler
 > > to be stupid and not inline any memset/memcpy functions.
 > 
 > you get what you ask for.. if you don't want that then don't ask for
 > it ;)

Well, the compiler is really being dumb about -Os and in fact it's
giving bigger code, so I'm not really getting what I ask for.  

With my gcc at least (x86_64, gcc (GCC) 4.1.3 20070812 (prerelease)
(Ubuntu 4.1.2-15ubuntu2)) and Andi's example:

#include <string.h>

f(char x[6]) {
        memset(x, 1, 6);
}

compiling with -O2 gives

0000000000000000 <f>:
   0:	c7 07 01 01 01 01    	movl   $0x1010101,(%rdi)
   6:	66 c7 47 04 01 01    	movw   $0x101,0x4(%rdi)
   c:	c3                   	retq   

and compiling with -Os gives

0000000000000000 <f>:
   0:	48 83 ec 08          	sub    $0x8,%rsp
   4:	ba 06 00 00 00       	mov    $0x6,%edx
   9:	be 01 00 00 00       	mov    $0x1,%esi
   e:	e8 00 00 00 00       	callq  13 <f+0x13>
  13:	5a                   	pop    %rdx
  14:	c3                   	retq   

so the code gets bigger and worse in every way.

 - R.
