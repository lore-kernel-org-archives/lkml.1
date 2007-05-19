Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbXESBpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbXESBpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 21:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbXESBpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 21:45:43 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:8148 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbXESBpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 21:45:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AYa+3HGqN32Ugsxo/gse2cGBcvheGmTeIHI+q4+d5urjikGzwOEkdrza8S7qpqPvv7b9Ta29m5kcnJgNCrnr8Jb2p2R2ivNgEQ2ROkR99MAoQt7BEvoZ/kE8+5yDw2GjNTg3S8iWBzNfywPCFc6a7Wkthf/b2GKsCB+eFqEY45w=
Message-ID: <787b0d920705181845h355eed4fk2bf93323332a9d90@mail.gmail.com>
Date: Fri, 18 May 2007 21:45:37 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
Cc: galak@kernel.crashing.org, tglx@linutronix.de, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <464DBDBA.3060801@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920705172024g723412b4n8f82d3cd78e0f702@mail.gmail.com>
	 <464DBDBA.3060801@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/18/07, Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:
> Albert Cahalan wrote:

> >>> Sure, but is there any utility in registering more than the
> >>> decrementer on PPC?
>
> >> Not yet. I'm not sure I know any other PPC CPU facility fitting
> >> for clockevents. In theory, FIT could be used -- but its period
> >> is measured in powers of 2, IIRC.
>
> > I'd really like to have that as an option. It would allow oprofile
> > to safely use hardware events on the MPC74xx "G4" processors.
> > Alternately it would allow thermal events. It is safe to use at
> > most one of the three (decrementer,profiling,thermal) interrupts.
> > If two were to hit at the same time, badness happens.
>
> Unfortunately, FIT exists only on Book E CPUs and MPC74xx aren't Book E, IIUC.

By the name "FIT" perhaps, but MPC74xx has essentially
the same thing.

> > It's possible to wrapper the interrupt in something that divides
> > down, calling the normal code only some of the time. I think one
> > of the FIT choices is about 4 kHz on my system, which would be OK.
>
>     Erm, are you sure you have FIT (or is your system not MPC74xx based)?

Set MMCR0[TBEE], set MMCR0[PMXE], and choose a TBL bit via MMCR0[TBSEL].
TBSEL is a 2-bit field which selects a timebase bit to use. The timebase
bits that can be chosen are numbered 15, 19, 23, and 31. In the notation
used by every other CPU vendor those would be bits 0, 8, 12, and 16.

Example: My system uses a TBL frequency of 24907667. This gives choices
of 12453833, 48648, 3040, and 190 Hz. The lowest three of those could
be useful, with 48648 only for profiling and extreme real-time.

It's also possible to trigger on the CPU cycle counter, but this would
cost one of the performance counters. MPC7400 has 4, later CPUs have 6
or more, and I think xPC7x0 had only 2. This method is a bit nicer,
since then one could trigger interrupts on arbitrary clock cycles
without needing to write the timebase register.
