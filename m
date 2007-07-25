Return-Path: <linux-kernel-owner+w=401wt.eu-S935746AbXGYTZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935746AbXGYTZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 15:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763891AbXGYTY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 15:24:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33899 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762753AbXGYTYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 15:24:55 -0400
Date: Wed, 25 Jul 2007 21:24:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tong Li <tong.n.li@intel.com>
Cc: linux-kernel@vger.kernel.org, Chris Snook <csnook@redhat.com>
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
Message-ID: <20070725192442.GC4463@elte.hu>
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com> <20070725110159.GA15076@elte.hu> <20070725120358.GA30755@elte.hu> <Pine.LNX.4.64.0707251014520.14515@tongli.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707251014520.14515@tongli.jf.intel.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Tong Li <tong.n.li@intel.com> wrote:

> Thanks for the patch. It doesn't work well on my 8-way box. Here's the 
> output at two different times. It's also changing all the time.

you need to measure it over longer periods of time. Its not worth 
balancing for such a thing in any high-frequency manner. (we'd trash the 
cache constantly migrating tasks back and forth.)

> [time 2]
>  3721 tongli    20   0  7864  108   16 R   91  0.0   1:44.67 loop
>  3720 tongli    20   0  7864  108   16 R   89  0.0   1:40.55 loop
>  3722 tongli    20   0  7864  108   16 R   86  0.0   1:41.40 loop
>  3723 tongli    20   0  7864  108   16 R   82  0.0   1:38.94 loop
>  3715 tongli    20   0  7864  108   16 R   82  0.0   1:43.09 loop
>  3717 tongli    20   0  7864  108   16 R   79  0.0   1:46.38 loop
>  3718 tongli    20   0  7864  108   16 R   79  0.0   1:40.72 loop
>  3714 tongli    20   0  7864  108   16 R   77  0.0   1:40.17 loop
>  3719 tongli    20   0  7864  108   16 R   73  0.0   1:35.41 loop
>  3716 tongli    20   0  7864  108   16 R   61  0.0   1:38.66 loop

the runtime ranges from 1:38.66 to 1:46.38 - that's a +-3% spread which 
is pretty acceptable for ~90 seconds of runtime. Note that the 
percentages you see above were likely done over a shorter period that's 
why you see them range from 61% to 91%.

> I'm running 2.6.23-rc1 with your patch on a two-socket quad-core 
> system. Top refresh rate is the default 3s.

the 3s is the problem: change that to 60s! We no way want to 
over-migrate for SMP fairness, the change i did gives us reasonable 
long-term SMP fairness without the need for high-rate rebalancing.

	Ingo
