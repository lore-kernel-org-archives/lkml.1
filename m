Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab0BSBZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 20:25:20 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52864 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab0BSBZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 20:25:19 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] mm: Make copy_from_user() in migrate.c statically predictable
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@linux.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4B7DD89F.4050003@linux.intel.com>
References: <alpine.LFD.2.00.1002181447080.4141@localhost.localdomain> <4B7DD89F.4050003@linux.intel.com>
Message-Id: <20100219102247.B939.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 19 Feb 2010 10:25:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 02/18/2010 03:02 PM, Linus Torvalds wrote:
> > 
> > Hmm. When making simplifications like this, I would really suggest you 
> > also move the declaration of the variable itself into the block where it 
> > is now used, rather than leaving it be function-wide.
> > 
> > Yes, it's used in the final condition of the for-loop, but that whole loop 
> > is just screwy. The 'err' handling is insane. Sometimes 'err' is a return 
> > value form copy_to/from_user, and sometimes it's a errno. The two are 
> > _not_ the same thing, they don't even have the same type!
> > 
> > And 'i' is totally useless too.
> > 
> > So that whole loop should be rewritten.
> > 
> 
> OK, I was trying to make the minimal set of changes given the late -rc
> status.
> 
> > I don't even have page migration enabled, so I haven't even compile-tested 
> > this, but wouldn't something like this work? It's smaller, gets rid of two 
> > pointless variables, and looks simpler to me. Hmm?
> 
> The code definitely looks cleaner, and it's a much more standard
> "chunked data loop" form.  Weirdly enough, though, gcc 4.4.2 can't
> figure out the copy_from_user() that way... despite having the same
> min() structure as my code.
> 
> However, if I change it to:
> 
> 		chunk_nr = nr_pages;
> 		if (chunk_nr > DO_PAGES_STAT_CHUNK_NR)
> 			chunk_nr = DO_PAGES_STAT_CHUNK_NR;
> 
> ... then it works!
> 
> Overall, it looks like gcc is rather fragile with regards to its ability
> to constant-propagate.  It's probably no coincidence that chunked loops
> is the place where we really have problems with this kind of stuff.
> 
> Updated patch, which compile-tests for me, attached.

hehe, I'm ESPer. I think you hope I do runtime-test, plz wait 12 hour :-)



