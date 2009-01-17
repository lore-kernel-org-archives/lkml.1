Return-Path: <linux-kernel-owner+w=401wt.eu-S1762530AbZAQDIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762530AbZAQDIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 22:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbZAQDIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 22:08:00 -0500
Received: from relay2.sgi.com ([192.48.179.30]:53440 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753032AbZAQDIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 22:08:00 -0500
Date: Fri, 16 Jan 2009 21:07:53 -0600
From: Jack Steiner <steiner@sgi.com>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: put trigger in to detect mismatched apic versions.
Message-ID: <20090117030752.GB127262@sgi.com>
References: <49704DF6.8040205@sgi.com> <20090116092540.GC4305@elte.hu> <4970C984.30202@sgi.com> <20090116223011.GB3899@elte.hu> <497116A8.5080900@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497116A8.5080900@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 03:22:16PM -0800, Mike Travis wrote:
> Ingo Molnar wrote:
> > * Mike Travis <travis@sgi.com> wrote:
> > 
> >> Hi Ingo,
> >>
> >> I did notice that the versions all came up the same, and that the checks 
> >> were very specific.  I was trying to be as transparent and unintrusive 
> >> as possible.  Since there's so few calls, I though this was a good 
> >> approach but apparently I was wrong.
> >>
> >> I like the idea of collapsing the array down to one and checking to see 
> >> if all apic's have the same version, but is this really the case? Must 
> >> all apics be the same?
> > 
> > Could you please send a patch that doesnt change the code, only adds a 
> > 'boot APIC version' kind of variable as an apic_version __read_mostly 
> > variable and does a WARN_ONCE() if that mismatches? We can then stick that 
> > into -tip and see whether it triggers.
> > 
> > The max array size is ~128K, right? So if the WARN_ONCE() does not 
> > trigger, we can just drop the array and use the central apic_version 
> > variable ...
> > 
> > And even if it _does_ trigger, the version incompatibilities between APIC 
> > protocols are very rare. They only happen across wildly different CPU 
> > architectures like when going from very old external apics to integrated 
> > apics, or going from apics to x-apics. We wont see any mixing across those 
> > boundaries.
> > 
> > 	Ingo
> 
> Btw, I checked with our UV architect and the problem is that we need a
> 16 bit apic id which is what caused the MAX_APICS to be bumped to 32k.
> The lower 8 bits are the normal apic id, and the upper bit relate to
> the node.  This means cpu 0 on node 0 has the same apic id as cpu 0 on
> node 1, etc.  I also asked about whether we could rely on always having

Not strictly true. The apicids in the ACPI tables are always globally unique
across the entire system. Because of the size of UV systems, UV needs 16 bit
apicids. This fits in the ACPI apicid id/eid fields.

The actual processor apicid register is unfortunately only 11 bits and there are
some restrictions on the actual values loaded into the apicid register.

If we can put unique ids into the apicid register, we do. If we
can't, the function that reads the apicid will automatically supply the rest
of the bits.  Most of the kernel is unaware that the processor apicid
register may have only a subset of the bits that are in the ACPI tables.


--- jack
