Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbXKGPWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbXKGPWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 10:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbXKGPWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 10:22:17 -0500
Received: from frankvm.xs4all.nl ([80.126.170.174]:44445 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751641AbXKGPWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 10:22:16 -0500
Date: Wed, 7 Nov 2007 16:22:15 +0100
From: Frank van Maarseveen <frankvm@frankvm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: VM/networking crash cause #1: page allocation failure (order:1, GFP_ATOMIC)
Message-ID: <20071107152215.GC14000@janus>
References: <fa.lT2PJ6g8pT/00cmv4KeoEpWD3rU@ifi.uio.no> <4730F52E.2070807@shaw.ca> <20071107135645.GB14000@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071107135645.GB14000@janus>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 02:56:45PM +0100, Frank van Maarseveen wrote:
> On Tue, Nov 06, 2007 at 05:13:50PM -0600, Robert Hancock wrote:
> > Frank van Maarseveen wrote:
> > >For quite some time I'm seeing occasional lockups spread over 50 different
> > >machines I'm maintaining. Symptom: a page allocation failure with order:1,
> > >GFP_ATOMIC, while there is plenty of memory, as it seems (lots of free
> > >pages, almost no swap used) followed by a lockup (everything dead). I've
> > >collected all (12) crash cases which occurred the last 10 weeks on 50
> > >machines total (i.e. 1 crash every 41 weeks on average). The kernel
> > >messages are summarized to show the interesting part (IMO) they have
> > >in common. Over the years this has become the crash cause #1 for stable
> > >kernels for me (fglrx doesn't count ;).
> > >
> > >One note: I suspect that reporting a GFP_ATOMIC allocation failure in an
> > >network driver via that same driver (netconsole) may not be the smartest
> > >thing to do and this could be responsible for the lockup itself. However,
> > >the initial page allocation failure remains and I'm not sure how to
> > >address that problem.
> > >
> > >I still think the issue is memory fragmentation but if so, it looks
> > >a bit extreme to me: One system with 2GB of ram crashed after a day,
> > >merely running a couple of TCP server programs. All systems have either
> > >1 or 2GB ram and at least 1G of (merely unused) swap.
> > 
> > These are all order-1 allocations for received network packets that need 
> > to be allocated out of low memory (assuming you're using a 32-bit 
> > kernel), so it's quite possible for them to fail on occasion. (Are you 
> > using jumbo frames?)
> 
> I don't use jumbo frames.
> 
> 
> > 
> > That should not be causing a lockup though.. the received packet should 
> > just get dropped.
> 
> Ok, packet loss is recoverable to some extend. When a system crashes
> I often see a couple of page allocation failures in the same second,
> all reported via netconsole.

[snip]

I've grepped for 'Normal free:' assuming it is the low memory you mention to see
how it correlates. Of the 12 cases 7 did crash, 5 recovered:

Nov  5 12:58:27 lokka Normal free:6444kB min:3736kB low:4668kB high:5604kB active:235196kB inactive:104336kB present:889680kB pages_scanned:44 all_unreclaimable? no 
Nov  5 12:58:27 lokka Normal free:6444kB min:3736kB low:4668kB high:5604kB active:235196kB inactive:104336kB present:889680kB pages_scanned:44 all_unreclaimable? no 
Nov  5 12:58:27 lokka Normal free:6444kB min:3736kB low:4668kB high:5604kB active:235196kB inactive:104336kB present:889680kB pages_scanned:44 all_unreclaimable? no 
crash

Oct 29 11:48:07 somero Normal free:5412kB min:3736kB low:4668kB high:5604kB active:288068kB inactive:105708kB present:889680kB pages_scanned:0 all_unreclaimable? no 
Oct 29 11:48:07 somero Normal free:6704kB min:3736kB low:4668kB high:5604kB active:287940kB inactive:105084kB present:889680kB pages_scanned:0 all_unreclaimable? no 
Oct 29 11:48:08 somero Normal free:8332kB min:3736kB low:4668kB high:5604kB active:287760kB inactive:104240kB present:889680kB pages_scanned:54 all_unreclaimable? no 
ok (more cases with increasing free memory not received via netconsole)

Oct 26 11:27:01 naantali Normal free:3976kB min:3736kB low:4668kB high:5604kB active:318568kB inactive:152928kB present:889680kB pages_scanned:0 all_unreclaimable? no 
Oct 26 11:27:01 naantali Normal free:4408kB min:3736kB low:4668kB high:5604kB active:318256kB inactive:152856kB present:889680kB pages_scanned:0 all_unreclaimable? no 
Oct 26 11:27:01 naantali Normal free:4408kB min:3736kB low:4668kB high:5604kB active:318256kB inactive:152856kB present:889680kB pages_scanned:0 all_unreclaimable? no 
crash

Oct 12 14:56:44 koli Normal free:11628kB min:3736kB low:4668kB high:5604kB active:238112kB inactive:157232kB present:889680kB pages_scanned:0 all_unreclaimable? no 
ok

Oct  1 08:51:58 salla Normal free:5496kB min:3736kB low:4668kB high:5604kB active:409500kB inactive:46388kB present:889680kB pages_scanned:137 all_unreclaimable? no 
Oct  1 08:51:59 salla Normal free:7396kB min:3736kB low:4668kB high:5604kB active:408292kB inactive:46740kB present:889680kB pages_scanned:0 all_unreclaimable? no 
crash

Sep 17 10:34:49 lokka Normal free:39756kB min:3736kB low:4668kB high:5604kB active:236916kB inactive:175624kB present:889680kB pages_scanned:0 all_unreclaimable? no 
ok

Sep 17 10:48:48 karvio Normal free:11648kB min:3736kB low:4668kB high:5604kB active:424420kB inactive:45380kB present:889680kB pages_scanned:144 all_unreclaimable? no 
Sep 17 10:48:48 karvio Normal free:11648kB min:3736kB low:4668kB high:5604kB active:424420kB inactive:45380kB present:889680kB pages_scanned:144 all_unreclaimable? no 
crash

Sep 20 10:32:50 nivala Normal free:27276kB min:3736kB low:4668kB high:5604kB active:354084kB inactive:104152kB present:889680kB pages_scanned:260 all_unreclaimable? no 
crash

Sep  3 09:46:11 lahti Normal free:26200kB min:3736kB low:4668kB high:5604kB active:242088kB inactive:94900kB present:889680kB pages_scanned:0 all_unreclaimable? no 
Sep  3 09:46:11 lahti Normal free:28096kB min:3736kB low:4668kB high:5604kB active:238756kB inactive:96184kB present:889680kB pages_scanned:0 all_unreclaimable? no 
ok (one additional case with "Normal free:31888kB" not received via netconsole)

Aug 30 10:40:46 ropi Normal free:14372kB min:3736kB low:4668kB high:5604kB active:393508kB inactive:93644kB present:889680kB pages_scanned:0 all_unreclaimable? no 
ok

Aug 30 10:46:58 ivalo Normal free:9808kB min:3736kB low:4668kB high:5604kB active:392388kB inactive:106044kB present:889680kB pages_scanned:96 all_unreclaimable? no 
Aug 30 10:46:58 ivalo Normal free:12324kB min:3736kB low:4668kB high:5604kB active:390276kB inactive:105852kB present:889680kB pages_scanned:32 all_unreclaimable? no 
crash

Aug 31 16:30:02 lokka Normal free:11840kB min:3736kB low:4668kB high:5604kB active:206760kB inactive:172036kB present:889680kB pages_scanned:7 all_unreclaimable? no 
Aug 31 16:30:02 lokka Normal free:13268kB min:3736kB low:4668kB high:5604kB active:205824kB inactive:171976kB present:889680kB pages_scanned:0 all_unreclaimable? no 
crash

I'll try "echo 40000 >/proc/sys/vm/min_free_kbytes" but I'm not sure
if it applies to all memory or only low memory and if it would make a
difference in practice.

-- 
Frank
