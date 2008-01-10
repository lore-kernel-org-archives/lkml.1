Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbYAJLM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbYAJLM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 06:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYAJLMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 06:12:51 -0500
Received: from ns1.suse.de ([195.135.220.2]:58510 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbYAJLMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 06:12:50 -0500
Date: Thu, 10 Jan 2008 12:12:48 +0100
From: Andi Kleen <ak@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       suresh.b.siddha@intel.com, Arjan van de Ven <arjan@infradead.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: CPA patchset
Message-ID: <20080110111248.GR25945@bingen.suse.de>
References: <20080103424.989432000@suse.de> <20080110093126.GA360@elte.hu> <20080110095337.GK25945@bingen.suse.de> <20080110100443.GB28209@elte.hu> <20080110100712.GO25945@bingen.suse.de> <20080110105726.GD28209@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110105726.GD28209@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 11:57:26AM +0100, Ingo Molnar wrote:
> 
> > > > >   WBINVD isnt particular fast (takes a few msecs), but why is 
> > > > >   that a problem? Drivers dont do high-frequency ioremap-ing. 
> > > > >   It's typically only done at driver/device startup and that's 
> > > > >   it.
> > > > 
> > > > Actually graphics drivers can do higher frequency allocation of WC 
> > > > memory (with PAT) support.
> > > 
> > > but that's not too smart: why dont they use WB plus cflush instead?
> > 
> > Because they need to access it WC for performance.
> 
> I think you have it fundamentally backwards: the best for performance is 
> WB + cflush. What would WC offer for performance that cflush cannot do?

Cached requires the cache line to be read first before you can write it.

WC on the other hand does not allocate a cache line and just dumps
the data into a special write combining buffer.  It was invented originally 
because reads from AGP were incredibly slow.

And it's race less regarding the caching protocol (assuming you flush
the caches and TLBs correctly). 

Another typical problem is that if something
is uncached then you can't have it in any other caches because if that
cache eventually flushes it will corrupt the data.
That can happen with remapping apertures for example which remap data
behind the CPUs back.

CLFLUSH is really only a hint but it cannot be used if UC is needed
for correctness.

> also, it's irrelevant to change_page_attr() call frequency. Just map in 
> everything from the card and use it. In graphics, if you remap anything 
> on the fly and it's not a slowpath you've lost the performance game even 
> before you began it.

The typical case would be lots of user space DRI clients supplying
their own buffers on the fly. There's not really a fixed pool 
in this case, but it all varies dynamically. In some scenarios
that could happen quite often.

-Andi

