Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbYANUMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbYANUMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 15:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbYANUMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 15:12:23 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:58634 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbYANUMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 15:12:20 -0500
Date: Mon, 14 Jan 2008 21:12:14 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without HOTPLUG_CPU
Message-ID: <20080114201214.GC9257@uranus.ravnborg.org>
References: <20080110112607.GE28740@does.not.exist> <200801101242.53504.ak@suse.de> <20080110124702.GF28740@does.not.exist> <p73fxx5omck.fsf@bingen.suse.de> <20080110150911.GG28740@does.not.exist> <20080114135240.GA15357@elte.hu> <20080114140910.GA8507@uranus.ravnborg.org> <20080114145854.GA31695@elte.hu> <20080114150553.GA3524@elte.hu> <20080114152440.GA9174@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114152440.GA9174@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 04:24:40PM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > also, in theory we've got a pretty reliable set of the following 
> > information:
> > 
> >   function X references symbol Y
> > 
> > and we know what type of sections they are in, right?
> > 
> > could -ffunction-sections be used to delay the categorization of 
> > functions to the link stage, and in essence remove the need to mark 
> > functions via any of the __init markers?
> 
> find below the current set of warnings on -git. There are 62.

The correct figure is 112.

You need to do a:
make KCFLAGS=-fno-unit-at-a-time
build to see them all.

> 
> for example, instead of the rather cryptic:
> 
>   WARNING: vmlinux.o(.text+0x1815e): Section mismatch: reference to 
>   .init.text:calibrate_delay (between 'smp_callin' and '__cpu_up')
> 
> the following output would be more informative:
> 
> --------------------------------->
> | function:
> |
> |  ./init/calibrate.c:void __devinit calibrate_delay(void)
> |
> | calls:
> |
> |  ./arch/x86/kernel/smpboot_32.c:static void __cpuinit smp_callin(void)
> |
> | but calibrate_delay() is __devinit while smp_callin() is __cpuinit. 
> | Change smp_callin() to __devinit to resolve this warning.
> |-------------------------------->
> 
> would result in a lot faster cycles of fixing this.
> 
> do we have all the info to print this?

Not yet. The patch I posted on lkml bring us one step further.
At modpost time today we only see .init.text and .text but
with the suggested patch we will be able to see what section
a function belong to and we are several steps closer to better
error messages.

So let me get that into shape and I will revisit the messages.

In this case I would not know if calibrate_delay() should be
__cpuinit or smp_callin() should be __devinit looking at the
information modpost has available without additional digging.
But a quick grep tells me that the right fix is to annotate
calibrate_delay() with __cpuinit because is is used from
either __cpuinit annotated or __init annotated functions.

	Sam

