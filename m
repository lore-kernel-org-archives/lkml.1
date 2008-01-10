Return-Path: <linux-kernel-owner+w=401wt.eu-S1758935AbYAJJxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935AbYAJJxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 04:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYAJJxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 04:53:40 -0500
Received: from cantor.suse.de ([195.135.220.2]:43892 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbYAJJxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 04:53:39 -0500
Date: Thu, 10 Jan 2008 10:53:37 +0100
From: Andi Kleen <ak@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       suresh.b.siddha@intel.com, Arjan van de Ven <arjan@infradead.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: CPA patchset
Message-ID: <20080110095337.GK25945@bingen.suse.de>
References: <20080103424.989432000@suse.de> <20080110093126.GA360@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110093126.GA360@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 10:31:26AM +0100, Ingo Molnar wrote:
> 
> Andi,
> 
> finally managed to get the time to review your CPA patchset, and i 
> fundamentally agree with most of the detail changes done in it. But here 
> are a few structural high-level observations:

I have a few changes and will post a updated version shortly.
There's also unfortunately still one outstanding bug (triggeredb y
some recent changes) on 32bit that makes the self test suite not pass
currently.

> - firstly, there's no rationale given. So we'll change ioremap()/etc.
>   from doing a cflush-range instruction instead of a WBINVD. But why?

- WBINVD is a very nasty operation. I was talking to some CPU people
and they really recommended to get rid of it as far as possible.
Stopping the CPU for msecs is just wrong and there are apparently
even some theoretical live lock situations.
- It is not interruptible in earlier VT versions and messes up
real time in the hypervisor. Some people were doing KVM on rt 
kernels and had latency spikes from that.

I'll add that to the changelog.

>   WBINVD isnt particular fast (takes a few msecs), but why is that a
>   problem? Drivers dont do high-frequency ioremap-ing. It's typically

Actually graphics drivers can do higher frequency allocation of WC
memory (with PAT) support.

>   only done at driver/device startup and that's it. Whether module load
>   time takes 1254 msecs instead of 1250 msecs is no big deal.
> 
> - secondly, obviously doing a 'flush some' instead of a 'flush all' 
>   operation is risky. There's not many ways we can get the 'flush all'

Yes, that is why it took so long. But it's eventually needed
to make PAT actually useful for once.

>   WBINVD instruction wrong (as long as we do it on all cpus, etc.). But 
>   with this specific range flush we've got all the risks of accidentally
>   not flushing _enough_. Especially if some boundary of a mapped area is 
>   imprecisely.

Not sure what you mean here? If someone doesn't pass in the correct
area then not everything will be uncached in the first place. 
Using something as cached that should be uncached is usually
noticed because it tends to be quite slow or corrupt data.

I don't think you have thought that concern through.

>   asking for trouble as it's very hard to debug and the operations here
>   (ioremap) are typically done only once per system bootup. So we'll add

change_page_attr() is used for more than just ioremap (e.g. a common
case is mapping memory into AGP apertures which still happens in
many graphics drivers). I also expect it will be used even more
in the future when PAT usage will become more wide spread.

> - the bugfixes and cleanups to pgattr.c i like very much - but shouldnt
>   they come first in the series, instead of being mixed into it?

It all depends on each other; I don't think any of the changes can
be easily reordered.

-Andi
