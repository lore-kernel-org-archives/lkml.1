Return-Path: <linux-kernel-owner+w=401wt.eu-S1761910AbZEGTw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761910AbZEGTw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 15:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbZEGTwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 15:52:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37791 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750938AbZEGTwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 15:52:46 -0400
Date: Thu, 7 May 2009 20:51:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Christoph Lameter <cl@linux.com>,
       Alok Kataria <akataria@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Reduce the default HZ value
Message-ID: <20090507205101.0091eb2a@lxorguk.ukuu.org.uk>
In-Reply-To: <4A03209E.4070603@garzik.org>
References: <1241462661.412.8.camel@alok-dev1>
	<4A00ADDE.9000908@zytor.com>
	<1241560625.8665.17.camel@alok-dev1>
	<alpine.DEB.1.10.0905071010170.24528@qirst.com>
	<20090507161440.5b9c067d@lxorguk.ukuu.org.uk>
	<4A02FE91.8070006@zytor.com>
	<4A031269.3000603@garzik.org>
	<20090507180909.4b0a8672@lxorguk.ukuu.org.uk>
	<4A03209E.4070603@garzik.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> We care only about a decreasing time interval.  This interval is passed 
> to register polling functions (bitbang no longer than <this> amount of 
> time), as well as _cumulatively_ affecting the entire EH [sub-]process.

Yes so its a simple timer.

> A timer-based solution, in addition to being an ugly hack, would imply 
> replacing a simple variable with _at least_ two spinlocks, plus a timer 
> callback function that simply says "I expired".  With loops such as

That simple variable is incredibly incredibly expensive in power, in CPU
use, in cache poisoning and more - its very misleading to think of it as
"free".

> The current code is a -lot- more simple than checking "is timer 
> expired?" all over the code, given that any sort of timer-based function 
> implies dealing with additional concurrency issues -- a complication the 
> libata EH does not need.

I disagree - your implementation seems very very ugly. But even then its
a case of swapping jiffies for jiffies() for unconverted code and using
that function read the timer value from somewhere. The important thing is
that asking the time is active and we don't burn processor time and
wakeups and power going "lets wake up, lets turn the cache on, lets load
some cache lines, lets increment a variable, and poke some lines on the
bus waking up bits of other logic, now lets write the cache back out, and
go back to sleep for a tiny amount of time"

jiffies is *really* expensive...

Even a 

	jiffies = time_count_begin();

	blah blah with jiffies;

	time_count_end();

would help. But that seems a good way to add bugs.

However you don't need HZ - you are using it to implement state changes
and you can do that really easily by making your timer switch a single
value to the correct state for the time and in your loops just checking

	while ( ap->reset_state == WIBBLING_RANDOMLY) {
		wobble = readl(ap->ioaddr.wibble);
		mdelay(1);
		if (wobble & WIBBLED) {
			...
		}
	}




Alan
