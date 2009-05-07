Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbZEGAlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbZEGAlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 20:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbZEGAl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 20:41:29 -0400
Received: from 130.120.124.202.static.snap.net.nz ([202.124.120.130]:43413
	"EHLO hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753813AbZEGAl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 20:41:28 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 May 2009 20:41:28 EDT
Message-ID: <4A022CAA.9000302@bluewatersys.com>
Date: Thu, 07 May 2009 12:34:50 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tim Bird <tim.bird@am.sony.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: How to use a different sched_clock() for ftrace on omap?
References: <4A022333.8030200@am.sony.com>
In-Reply-To: <4A022333.8030200@am.sony.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Bird wrote:
> Hi all,
> 
> I've worked up a replacement sched_clock for ftrace on my omap platform.
> The current sched_clock, based on the 32K timer, has low resolution and
> doesn't provide very useful results.
> 
> Unfortunately, I'm not sure the best way to use my special one, in place
> of a common one in arch/arm/plat-omap/common.c
> 
> I thought the __attribute__ ((weak)) would be enough to have the
> sched_clock() in common.c get out of the way, and allow my board-specific
> sched_clock() to be used.  But that didn't work. 

Not sure that will work correctly since sched_clock in kernel/sched.c is
already defined as weak. If you have two weak versions of a function I
think the one which gets used is based on link order (if your board's
sched_clock is not being used).

> What is the recommended
> way to specify a board-specific function at compile time?

You could look at arch/x86/kernel/tsc_32.c, I think it does what you
want by using the function called native_sched_clock for the default
sched_clock implementation and using the alias attribute if no board
specific implementation is given, ie:

#ifdef CONFIG_SOME_BOARD
unsigned long long sched_clock(void)
{
	some_board_sched_clock();
}
#else
unsigned long long sched_clock(void)
	__attribute__((alias("native_sched_clock")));
#endif

You could make it more generic by have some_board_sched_clock be a
#define (__board_sched_clock or something), so if a board defines it
(will need to be in a platform wide header) then you use that, otherwise
you use native_sched_clock.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

       Ryan Mallon                              Unit 5, Amuri Park
       Phone: +64 3 3779127                     404 Barbadoes St
       Fax:   +64 3 3779135                     PO Box 13 889
       Email: ryan@bluewatersys.com             Christchurch, 8013
       Web:   http://www.bluewatersys.com       New Zealand
       Freecall Australia  1800 148 751         USA 1800 261 2934
