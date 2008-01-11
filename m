Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbYAKHeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbYAKHeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 02:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbYAKHeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 02:34:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39648 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbYAKHeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 02:34:17 -0500
Date: Fri, 11 Jan 2008 08:33:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       suresh.b.siddha@intel.com, Arjan van de Ven <arjan@infradead.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: CPA patchset
Message-ID: <20080111073314.GA24021@elte.hu>
References: <20080103424.989432000@suse.de> <20080110093126.GA360@elte.hu> <20080110095337.GK25945@bingen.suse.de> <20080110100443.GB28209@elte.hu> <20080110100712.GO25945@bingen.suse.de> <20080110105726.GD28209@elte.hu> <20080110111248.GR25945@bingen.suse.de> <20080111071936.GA16175@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111071936.GA16175@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > > I think you have it fundamentally backwards: the best for 
> > > performance is WB + cflush. What would WC offer for performance 
> > > that cflush cannot do?
> > 
> > Cached requires the cache line to be read first before you can write 
> > it.
> 
> nonsense, and you should know it. It is perfectly possible to 
> construct fully written cachelines, without reading the cacheline 
> first. MOVDQ is SSE1 so on basically in every CPU today - and it is 16 
> byte aligned and can generate full cacheline writes, _without_ filling 
> in the cacheline first. Bulk ops (string ops, etc.) will do full 
> cacheline writes too, without filling in the cacheline. Especially 
> with high performance 3D ops we do _NOT_ need any funky reads from 
> anywhere because 3D software can stream a lot of writes out: we 
> construct a full frame or a portion of a frame, or upload vertices or 
> shader scripts, textures, etc.
> 
> ( also, _even_ when there is a cache fill pending on for a partially
>   written cacheline, that might go on in parallel and it is not 
>   necessarily holding up the CPU unless it has an actual data dependency 
>   on that. )

btw., that's not to suggest that WC does not have its place - but it's 
not where you think it is.

Write-Combining can be very useful for devices that are behind a slow or 
a high-latency transport, such as PCI, and which are mapped UnCached 
today. Such as a networking card (or storage card) descriptor rings. New 
entries in the TX ring are typically constructed on the CPU side without 
knowing anything about their contents (and hence no need to read them, 
the drivers typically shadow the ring on the host side already, it is 
required for good UC performance today), so the new descriptors can be 
streamed out efficiently with WC, instead of generating lots of small UC 
accesses. But these descriptor rings have constant size, they have a 
fixed place in the aperture and are ioremap()ed once during device init 
and that's it. No high-frequency change_page_attributes() usage is done 
or desired here.

	Ingo
