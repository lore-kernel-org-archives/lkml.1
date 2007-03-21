Return-Path: <linux-kernel-owner+w=401wt.eu-S964798AbXCUUNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964798AbXCUUNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 16:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964821AbXCUUNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 16:13:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:15325 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964798AbXCUUM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 16:12:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=s1d8Eq6XBhWptuuiZ7auxYyoqJTCDf0xdfMCAFJRhNPSC3dpk/5cOyfwXoY5cLveC6GwuG9E5VdfTA+ACYq4q2wg/BKqj5GSbUsUebbDgbjFyKGpaOJmzN5q5F8Q79WSeUOuv/RsaqCLdlq+NpGtfZK1kXDcjvUASoQB7G9eWIY=
Date: Wed, 21 Mar 2007 21:12:56 +0100
From: Luca Tettamanti <kronos.it@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andreas Mohr <andi@rhlx01.fht-esslingen.de>, vojtech@suse.cz,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: strange keyboard lag after suspend testing
Message-ID: <20070321201256.GA11560@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070320163826.GA7092@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Thomas Gleixner to CC

Pavel Machek <pavel@ucw.cz> ha scritto:
> Hi!
> 
>> > >> > I was testing suspend in 2.6.21-rc4 a lot, and now... machine feels
>> > >> > like someone added 50..100msec delay somewhere in keyboard
>> > >> > handling. Mouse does not seem affected. /proc/interrupts seem to
>> > >> > increase as they should, for both keyboard and mouse. Can someone
>> > >> > reproduce it? Any ideas how to debug it?
>> > >>
>> > >> Probably just asking the obvious:
>> > >> it's not a trivial "failed to re-configure repeat rate upon resume"
>> > >> (which one could rule out by running "kbdrate" again)
>> > >> but a lag in some interrupt handler or somewhere else deeper, right?
>> > >
>> > >No, it is not keyboard rate. Keyboard lags during normal typing,
>> > >sometimes letters come in groups of two or so...
>> > 
>> > I might start looking at embedded controller changes and switches. If
>> > ACPI misbehaves that could starve keyboard controller... But you
>> > said
>> 
>> Mouse _seems_ okay, but I'm not sure if I'd notice lag there.
>> 
>> > that mouse is OK... Hmm, what happens if you load evbug and type while
>> > watching syslog. Do you observe the same delays?
>> 
>> Hmm, seems that it only happens in X... so maybe it is some strange
>> scheduling artefact?
>> 
>> Hmm, something is wrong here:
>> 
>> On console, I get expected 4-5 ticks a second. In x in gnome-terminal,
>> I get this:
> 
> It gets weirder: I killed some tasks and now: (on unloaded system
> running X, notice that top latency was ~1sec at 33:09).
> 
> root@amd:~# while true ; do echo -n . ; sleep .2; date; done
> .Tue Mar 20 17:33:07 CET 2007
> .Tue Mar 20 17:33:07 CET 2007
> .Tue Mar 20 17:33:08 CET 2007
> .Tue Mar 20 17:33:08 CET 2007
> .Tue Mar 20 17:33:08 CET 2007
> .Tue Mar 20 17:33:08 CET 2007
> .Tue Mar 20 17:33:09 CET 2007
> .Tue Mar 20 17:33:10 CET 2007
> .Tue Mar 20 17:33:10 CET 2007
> .Tue Mar 20 17:33:10 CET 2007
> .Tue Mar 20 17:33:10 CET 2007
> .Tue Mar 20 17:33:10 CET 2007
> .Tue Mar 20 17:33:11 CET 2007
> .Tue Mar 20 17:33:11 CET 2007
> .Tue Mar 20 17:33:11 CET 2007
> .Tue Mar 20 17:33:12 CET 2007
> .Tue Mar 20 17:33:12 CET 2007
> 
> As soon as I load the cpu up with while1, machine starts to behave.
> 
> When I turn on bluetooth (USB), ACPI can no longer use C3, and machine
> starts to behave. Hmm?

When the CPU is in C3 the TSC and LAPIC (IIRC) are stopped, sounds like
the problem is here. Maybe after resume kernel fails to fall back to a
"safe" clocksource.

Luca
-- 
Inquietudine sintetica
Solo, davanti all'ignoto
Tienimi stretto a te
