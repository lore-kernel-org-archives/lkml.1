Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbZEEV5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbZEEV5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 17:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZEEV5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 17:57:07 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:43136 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752918AbZEEV5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 17:57:06 -0400
Subject: Re: [PATCH] x86: Reduce the default HZ value
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <4A00ADDE.9000908@zytor.com>
References: <1241462661.412.8.camel@alok-dev1>  <4A00ADDE.9000908@zytor.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 05 May 2009 14:57:05 -0700
Message-Id: <1241560625.8665.17.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2009-05-05 at 14:21 -0700, H. Peter Anvin wrote:
> Alok Kataria wrote:
> > Hi,
> > 
> > Given that there were no major objections that came up regarding
> > reducing the HZ value in http://lkml.org/lkml/2009/4/27/499. 
> > 
> > Below is the patch which actually reduces it, please consider for tip.
> > 
> 
> What is the benefit of this?

I did some experiments on linux 2.6.29 guests running on VMware and
noticed that the number of timer interrupts could have some slowdown on
the total throughput on the system. 
A simple tight loop experiment showed that with HZ=1000 we took about
264sec to complete the loop and that same loop took about 255sec with
HZ=100.
You can find more information here http://lkml.org/lkml/2009/4/28/401

And with HRT i don't see any downsides in terms of increased latencies
for device timer's or anything of that sought.

> 
> I can see at least one immediate downside: some timeout values in the 
> kernel are still maintained in units of HZ (like poll, I believe), and 
> so with a lower HZ value we'll have higher roundoff errors.

If that at all is such a big problem shouldn't we think about moving to
using schedule_hrtimeout for such cases rather than relying on jiffy
based timeouts. 
The hrtimer explanation over here http://www.tglx.de/hrtimers.html
also talks about where these HZ (timer wheel) based timeouts be used and
shouldn't really be dependent on accurate timing.

Also the default HZ value was 250 before this commit

commit 5cb04df8d3f03e37a19f2502591a84156be71772 
  x86: defconfig updates 

And it was 250 for a very long time before that too. The commit log
doesn't explain why the value was bumped up either.

Thanks,
Alok

