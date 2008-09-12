Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbYILVw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbYILVw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 17:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbYILVwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 17:52:18 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:51008 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbYILVwR (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 17:52:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=aKiCkUpFMWp0ioBAu/o8BV68dyfCihFtenuUsNRXMs30sOeD46A1yeZ7KwiOM8tHQF
         FQdzk/Q7sVt+4CgXWPbIR6gandARduQvItYtud5lwYpLvyIa4M2yyE761HQqvWZQ21Pt
         yjd0uZL69napeUG+K/LDlb/g+99JbwYViYrNU=
Message-ID: <6934efce0809121452kd20deb6m268715f6ed83a71e@mail.gmail.com>
Date: Fri, 12 Sep 2008 14:52:17 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Jamie Lokier" <jamie@shareable.org>
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Cc: "Greg Ungerer" <gerg@snapgear.com>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <20080822184326.GE24179@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00C4.6060302@gmail.com> <20080821110749.GA1926@shareable.org>
	 <6934efce0808210711t686a88eci6eb294dbb54d68fe@mail.gmail.com>
	 <48AE0476.80109@snapgear.com> <20080822181314.GB24179@shareable.org>
	 <6934efce0808221116w76a662b0t954b0922b69d3232@mail.gmail.com>
	 <20080822183713.GC24179@shareable.org>
	 <20080822184326.GE24179@shareable.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 11:43 AM, Jamie Lokier <jamie@shareable.org> wrote:
> Jamie Lokier wrote:
>> Jared Hulbert wrote:
>> > What kind of NOR you using?  That is not what I measure with fast
>> > synchronous burst NOR's.
>>
>> I think the "fast" in "fast synchronous" gives it away :-)
>>
>> I'm using Spansion MirrorBit S29GL128N, which reads at about 0.6 MByte/s.
>
> By the way, what speeds do you get on fast synchronous burst NORs - and
> which chips are those?

I am only familiar with the Numonyx product line up.

If you are using a GL, you'll probably find our P33 a good fit and at
competitive prices to GL as I understand it.  That's I think 50Mhz.

M18 is 100Mhz maybe a little higher.  And we just announced our LPDDR
266 part, Velocity LP.

A good way of making a rough estimate of read performance is to
measure a cache miss latency and convert that to bandwidth.  It's
usually fairly close.

32Byte cache size / 16 bit bus = 16 word transfers

memory controller latency (time from Load instruction to bus activity)
= ~300ns (upto 450ns for some processors)
initial latency (time to read first word) = ~100ns (60ns - 120ns)
clock frequency (time between words) = 50Mhz = 20ns per word
bus clean up = ~50ns

32Bytes = 300ns + 100ns + (16 - 1) * 20ns + 50ns = 750ns

= 32B/750ns

= 40MB/s


This is a very simple model and reality is much more nuanced.  You
also need to check my assume numbers with the reality of your system.
Also this doesn't take copying the data to RAM into account which is
usually what you are really measuring.  That's easy to model though.
A rule of thumb is to say that copying to RAM will reduce this value
less than 50% because RAM should be at least a little faster than NOR.

Nevertheless, If you can't use a simple calculation like this to
explain the numbers then you have a poorly configured bus timings or
have your cache off.  Cache is important because it would make the
equation look like this, or worse.

4Bytes = 300ns + 100ns + 1 * 20ns + 50ns = 470ns

=4B/470ns

=8MB/s

For a PXA270 if you go with the defaults it can look like this.

2Bytes = 300ns + 250ns + 250ns = 800ns

= 2MB/s

So, If you are only getting 0.6MB/s out of your NOR..... You're using it wrong.
