Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbYAIKmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbYAIKmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 05:42:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYAIKmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 05:42:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50866 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbYAIKmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 05:42:42 -0500
Date: Wed, 9 Jan 2008 11:41:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: hch@lst.de, airlied@linux.ie, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, ak@suse.de, pq@iki.fi,
       jbeulich@novell.com, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] Revert "x86: optimize page faults like all other
	achitectures and kill notifier cruft"
Message-ID: <20080109104149.GB8041@elte.hu>
References: <20080108192951.a4dc394f.akpm@linux-foundation.org> <alpine.DEB.0.82.0801090346370.9570@skynet.skynet.ie> <20080109071945.GB10695@lst.de> <20080108.232311.79648776.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108.232311.79648776.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(kprobes folks Cc:-ed)

* David Miller <davem@davemloft.net> wrote:

> From: Christoph Hellwig <hch@lst.de>
> Date: Wed, 9 Jan 2008 08:19:45 +0100
> 
> > On Wed, Jan 09, 2008 at 03:55:20AM +0000, Dave Airlie wrote:
> > > now because Linus said send him a patch to revert regressions rather than 
> > > just complain,
> > 
> > this is not a regression by any definition.  You were abusing 
> > exported symbols for out of tree junk, so you'll lose.
> 
> And furthermore, they don't even need it, use a kprobe.

i agree. There a few practical complication on x86: the do_page_fault() 
function is currently excluded from kprobe probing, for recursion 
reasons. handle_mm_fault() can be probed OTOH - but that does not catch 
vmalloc()-ed faults. The middle of do_page_fault() [line 348] should 
work better [the point after notify_page_fault()] - but it's usually 
more fragile to insert probes to such middle-of-the-function places.

So probing pagefaults is not as easy as it should/could be. We should 
put a practical NOP marker to around line 348, to make it easier (and 
faster) for systemtap to probe there.

(__kprobes is a highly confusing newspeak name btw - it should be 
__noprobe instead.)

	Ingo
