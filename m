Return-Path: <linux-kernel-owner+w=401wt.eu-S1761335AbZCPUHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761335AbZCPUHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 16:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756447AbZCPUHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 16:07:46 -0400
Received: from mail-bw0-f175.google.com ([209.85.218.175]:57350 "EHLO
	mail-bw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbZCPUHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 16:07:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PmRg7v9ddC0YgAXAOQhRtuwrfyomfDxonkppKljQ/6CTzwt2f+nJ/RPBQ2VBOdQsaP
         O56dE1JL6Wn+WLylv8omgPTbU44iH5PKPnDrTabQ6AfhQUQ58n5YqSq2TBDiVr6SFE4F
         9XyNtNeer6+/51rA6DtR+hivoPOVynw1w5CyQ=
Date: Mon, 16 Mar 2009 21:07:38 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Cc: Avi Kivity <avi@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
Message-ID: <20090316200736.GD8393@nowhere>
References: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera> <qm8_cedJGaP.A.-NH.CPCvJB@chimera> <1237107837.27699.27.camel@kulgan.wumi.org.au> <49BE20B2.9070804@redhat.com> <1237207595.4964.31.camel@kulgan.wumi.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237207595.4964.31.camel@kulgan.wumi.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 11:16:35PM +1030, Kevin Shanahan wrote:
> On Mon, 2009-03-16 at 11:49 +0200, Avi Kivity wrote:
> > Kevin Shanahan wrote:
> > > On Sat, 2009-03-14 at 20:20 +0100, Rafael J. Wysocki wrote:
> > >   
> > >> This message has been generated automatically as a part of a report
> > >> of regressions introduced between 2.6.27 and 2.6.28.
> > >>
> > >> The following bug entry is on the current list of known regressions
> > >> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> > >> be listed and let me know (either way).
> > >>
> > >> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12465
> > >> Subject		: KVM guests stalling on 2.6.28 (bisected)
> > >> Submitter	: Kevin Shanahan <kmshanah@ucwb.org.au>
> > >> Date		: 2009-01-17 03:37 (57 days old)
> > >> Handled-By	: Avi Kivity <avi@redhat.com>
> > >>     
> > >
> > > No further updates since the last reminder.
> > > The bug should still be listed.   
> > 
> > Does the bug reproduce if you use the acpi_pm clocksource in the guests?
> 
> In the guest being pinged? Yes, it still happens.


Hi Kevin,

I've looked a bit at your traces.
I think it's probably too wide to find something inside.
Latest -tip is provided with a new set of events tracing, meaning
that you will be able to produce function graph traces with various
sched events included.

Another thing, is it possible to reproduce it with only one ping?
Or testing perioding pings and keep only one that raised a relevant
threshold of latency? I think we could do a script that can do that.
It would make the trace much clearer.

Just wait a bit, I'm looking at which event could be relevant to enable
and I come back to you with a set of commands to test.

Frederic.
 
> hermes-old:~# cat /sys/devices/system/clocksource/clocksource0/available_clocksource 
> kvm-clock acpi_pm jiffies tsc 
> hermes-old:~# cat /sys/devices/system/clocksource/clocksource0/current_clocksource 
> acpi_pm
> 
> kmshanah@flexo:~$ ping -c 600 hermes-old
> 
> --- hermes-old.wumi.org.au ping statistics ---
> 600 packets transmitted, 600 received, 0% packet loss, time 599439ms
> rtt min/avg/max/mdev = 0.131/723.197/9941.884/1569.918 ms, pipe 10
> 
> I had to reconfigure the guest kernel to make that clocksource
> available. The way I had the guest kernel configured before, it only had
> tsc and jiffies clocksources available. Unstable TSC was detected, so it
> has been using jiffies until now.
> 
> Here's another test, using kvm-clock as the guest's clocksource:
> 
> hermes-old:~# cat /sys/devices/system/clocksource/clocksource0/current_clocksource 
> kvm-clock
> 
> kmshanah@flexo:~$ ping -c 600 hermes-old
> 
> --- hermes-old.wumi.org.au ping statistics ---
> 600 packets transmitted, 600 received, 0% packet loss, time 599295ms
> rtt min/avg/max/mdev = 0.131/1116.170/30840.411/4171.905 ms, pipe 31
> 
> Regards,
> Kevin.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

