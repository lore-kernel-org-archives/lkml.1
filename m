Return-Path: <linux-kernel-owner+w=401wt.eu-S1760799AbZCTTJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760799AbZCTTJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758533AbZCTTJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:09:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42477 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758320AbZCTTJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:09:25 -0400
Date: Fri, 20 Mar 2009 20:09:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>
Subject: Re: [RFC][PATCH 3/3] perf_counter: new output ABI - part 1
Message-ID: <20090320190912.GF6224@elte.hu>
References: <20090320151547.937040269@chello.nl> <20090320151735.008338484@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320151735.008338484@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Rework the output ABI
> 
> use sys_read() only for instant data and provide mmap() output for 
> all async overflow data.

i like this.

> The first mmap() determines the size of the output buffer. The 
> mmap() size must be a PAGE_SIZE multiple of 1+pages, where pages 
> must be a power of 2 or 0. Further mmap()s of the same fd must 
> have the same size. Once all maps are gone, you can again mmap() 
> with a new size.
> 
> In case of 0 extra pages there is no data output and the first 
> page only contains meta data.
> 
> When there are data pages, a poll() event will be generated for 
> each full page of data. Furthermore, the output is circular. This 
> means that although 1 page is a valid configuration, its useless, 
> since we'll start overwriting it the instant we report a full 
> page.

i think it would still be nice to allow plain old-fashioned 
poll()+read() loops ... but the logistics of that seem difficult. 
mmap() seems to fit this better - and it's probably faster as well. 
(as we have to construct the kernel-space pages anyway, so mapping 
them isnt that big of an issue)

per-CPU-ness will be handled naturally via per-cpu counters.

Paul, can you see any hole/quirkiness in this scheme?

	Ingo
