Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbZJFFr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbZJFFr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 01:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbZJFFrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 01:47:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38790 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209AbZJFFrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 01:47:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4ACAD9A9.5000208@jp.fujitsu.com>
Date: Tue, 06 Oct 2009 14:46:17 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
CC: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX -v7] x86, MCE: Fix bugs and issues of MCE log ring buffer
References: <1253269241.15717.525.camel@yhuang-dev.sh.intel.com>	 <4AC990E1.7030708@jp.fujitsu.com> <c62985530910050151u78b46fa4l6ec0184f4f75be27@mail.gmail.com>
In-Reply-To: <c62985530910050151u78b46fa4l6ec0184f4f75be27@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frédéric Weisbecker wrote:
> Looks like the conversion of MCE log into a TRACE_EVENT is still in
> discussion whereas the current issues are urgent.
> 
> So the need is to have a more stable ring buffer. But this one is an ad-hoc one.
> We already have a general purpose per-cpu/lockless ring buffer implementation in
> kernel/trace/ring_buffer.c
> And it's not only used by tracing, it's generally available.

Thank you for this comment.

First of all, we have to make it clear that what is the urgent issue.
IMHO there are 2 issues, one is "small buffer" and the other is "non
ring buffer."

I think that the "small buffer" is definitely a scalability issue and
that this problem should be fixed asap to support large servers with
modern processors.
But I think that the "non ring buffer" is kind of a performance issue,
which is relatively minor problem on the MCE codes.

So frankly I approve of the per-CPU buffering, but be skeptical about
the ring buffering here.

In other words I don't mind dropping 9/10 of my patch set to postpone
converting the buffer to ring buffer, because even though the rests of
my patch set can convert the buffer to per-CPU style, which will solve
the urgent issue I have now.  That is why I divided original patch into
these pieces and made separate steps in the buffer conversion.

How about converting the MCE buffer to per-CPU as the 1st step, to solve
an urgent scalability issue, x86 maintainers? > Ingo, Peter?


> I think it would be nicer to use it to avoid a proliferation of
> unstable ring buffers inside the kernel.

I tend to agree with Andi.
I think the generic ring buffer implementation is too rich for current
use in MCE codes.

Maybe I could invent an alternative patch of my patch 9/10 to use generic
ring buffer from MCE codes.  But as I mentioned above I think that the
patch will solve the minor issue only.  Also I think that it might bring
unexpected impacts on traditional interfaces.
Therefore if there are still "use generic one if you want to use ring buffer"
comments then I'd like to drop 9/10 simply rather than reinvent it.

Any other suggestions?


BTW, I'd like to make it clear that what is the main complaint here.

Is it kind of "don't duplicate codes"?
The requirement in MCE codes is quite simple, so use of relatively complex
generic ring buffer doesn't fit for it.  I'm not sure but as Andi proposed
the next version of kernel/kfifo will be better choice here.  I can wait
the release of new kfifo either without making MCE log buffer to ring,
or with the temporary ad-hoc one.

Is it kind of "provide generic interface"?
I think it makes a lot of sense.  I can't say the /dev/mcelog is the best
interface for MCE logging.  Moreover there are many other hardware error
sources in a system such as PCIe and power unit etc., so it would be nice
for monitoring applications if kernel can provide a single channel (other
than /var/log/messages) to gather all kind of hardware errors.
The TRACE_EVENT would be one of possible options (or parts) to implement
such feature.

Oh, don't forget "please keep traditional interfaces."
To be honest I think the current interfaces look quite ugly.  But I know
that there are few real users such as mcelog (and mced?), and that at this
time we have no choice but use these tools.  So we cannot cast away current
interfaces immediately, until new interfaces are invented and new user land
application can provide enough functionalities.  Or we need to improve
current interface gradually and synchronously with improvements on tools ...
but I suppose in this way there will never be drastic changes.


Well, then I think what we have to do is invent a competitive new interface
for MCE logging, which can live together with current interface for a while,
isn't it?


Thanks,
H.Seto

