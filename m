Return-Path: <linux-kernel-owner+w=401wt.eu-S1761009AbZEGUFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761009AbZEGUFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZEGUFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:05:30 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47921 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbZEGUFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:05:30 -0400
Message-ID: <4A033EAB.8010700@garzik.org>
Date: Thu, 07 May 2009 16:03:55 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, Christoph Lameter <cl@linux.com>,
       Alok Kataria <akataria@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Reduce the default HZ value
References: <1241462661.412.8.camel@alok-dev1>	<4A00ADDE.9000908@zytor.com>	<1241560625.8665.17.camel@alok-dev1>	<alpine.DEB.1.10.0905071010170.24528@qirst.com>	<20090507161440.5b9c067d@lxorguk.ukuu.org.uk>	<4A02FE91.8070006@zytor.com>	<4A031269.3000603@garzik.org>	<20090507180909.4b0a8672@lxorguk.ukuu.org.uk>	<4A03209E.4070603@garzik.org> <20090507205101.0091eb2a@lxorguk.ukuu.org.uk>
In-Reply-To: <20090507205101.0091eb2a@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> jiffies is *really* expensive...

Certainly.


> However you don't need HZ

Thus I said "libata would be happy to use milliseconds rather than 
jiffies; the unit does not matter."

All crucial constants and variables are already in useful units, and we 
are forced to convert them to jiffies, and test against 'jiffies' global 
var, because the API does not provide other reasonable alternatives.

Pretty much all users of time -- including users of timers -- are forced 
to convert from a useful unit of time to jiffies, because that's what 
the API requires.


> and you can do that really easily by making your timer switch a single
> value to the correct state for the time and in your loops just checking
> 
> 	while ( ap->reset_state == WIBBLING_RANDOMLY) {
> 		wobble = readl(ap->ioaddr.wibble);
> 		mdelay(1);
> 		if (wobble & WIBBLED) {
> 			...
> 		}
> 	}

And when the deadline changes, you need mod_timer rather than a simple 
non-global-variable increment.

And when you consider all the bits of state, spread across not only 
libata core __but drivers as well__, a timer-based solution gets even 
uglier.

But you're still missing the point.  jiffies are just a unit, a unit 
forced upon us by all the time-based kernel API functions that take 
jiffies rather than usec or msec.

I would rather fix the API, than investigate hacky solutions that 
complicate the code even more.

	Jeff



