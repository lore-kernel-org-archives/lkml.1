Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266Ab0BYLMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 06:12:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57376 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758955Ab0BYLMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 06:12:03 -0500
Date: Thu, 25 Feb 2010 12:11:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, linux-kernel@vger.kernel.org,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>
Subject: Re: perf per-symbol histogram causes memory corruption
Message-ID: <20100225111148.GA5754@elte.hu>
References: <20100225.022618.256301798.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100225.022618.256301798.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Added Arnaldo to the Cc: - he's maintaining the symbol lookup bits of perf.)

* David Miller <davem@davemloft.net> wrote:

> When builtin-annotate.c processes sample events via
> process_sample_event() it uses 'sample_filter'
> 
> sample_filter() sizes the histogram object for a symbol based upon the
> size, calculated as "sym->end - sym->start", to determine the number
> of IP sample slots to allocate.
> 
> The problem is, the sym->end value is not stable at this point.
> 
> For example, dso__load_sym() first loads all of the symbols, then it
> makes another pass over the symbols by calling symbols__fixup_end()
> which will adjust the sym->end values of various symbols.
> 
> At this point, the histogram IP sample array allocated by
> sample_filter() can become too small, and hits recorded can thus
> access past the end of the array corrupting memory.
> 
> I get this very reliably on sparc64, and it took me a few days to root
> cause this. :-)
> 
> I don't see an immediate way to fix this, any ideas?
