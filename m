Return-Path: <linux-kernel-owner+w=401wt.eu-S1765836AbXJSMGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765836AbXJSMGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 08:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbXJSMGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 08:06:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43151 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781AbXJSMGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 08:06:03 -0400
Date: Fri, 19 Oct 2007 14:05:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] x86: fix global_flush_tlb() bug
Message-ID: <20071019120559.GA8708@one.firstfloor.org>
References: <20071019104855.GA6621@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071019104855.GA6621@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for catching. 

> why this bug never become prominent is a mystery - it can probably be
> explained with the (still) relative obscurity of the x86_64 architecture.

global_flush_tlb() is not very common in the big scheme of things. In a normal
system it only happens single threaded during X server startup and when
the system starts.

So while it's nasty it's unlikely to really hit people in practice.

BTW while looking I noticed this code in the vermilion driver is also
surely not correct:

        /*
         * Change caching policy of the linear kernel map to avoid
         * mapping type conflicts with user-space mappings.
         * The first global_flush_tlb() is really only there to do a global
         * wbinvd().
         */

        global_flush_tlb();

That is not what gft is guaranteed to do.

It would be probably best to just do away with g_f_t() and fold it directly into
c_p_a(). I've seen little evidence the delayed flush optimization ever made 
much difference and it seems to be misused and a source of bugs. And near all
legitimate users seem to always call it directly after c_p_a() anyways.

Besides it is grossly misnamed -- it does much more than flushing TLBs.

-Andi
