Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbXL3Om1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbXL3Om1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 09:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbXL3OmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 09:42:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45737 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbXL3OmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 09:42:19 -0500
To: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: pharon@gmail.com, Rene Herman <rene.herman@keyaccess.nl>,
       "David P. Reed" <dpreed@reed.com>,
       Richard Harman <richard@richardharman.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
From: Andi Kleen <andi@firstfloor.org>
References: <47765D11.2040903@reed.com> <1198967334.5049.3.camel@iamer-laptop>
	<4776F6A0.9010801@keyaccess.nl>
	<1198979361.11150.2.camel@iamer-laptop>
	<20071230121725.11d05099@linux360.ro>
Date: Sun, 30 Dec 2007 15:42:17 +0100
In-Reply-To: <20071230121725.11d05099@linux360.ro> (Eduard-Gabriel Munteanu's message of "Sun\, 30 Dec 2007 12\:17\:25 +0200")
Message-ID: <p73ejd41bxy.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro> writes:
>
> Other kernel developers, as discussed previously in this thread, are
> working on a HPET-driven dynticks (as opposed to the current
> LAPIC-driven one), but the change isn't that easy to make.

No, actually HPET based dyntick has been implemented for a long time
(as long as APIC based dyntick). APIC based dyntick is preferred 
because it is a little cheaper, but both are there.

The problem is just that many BIOSes don't tell the kernel about the
HPET location (even when the chipset supports it) because that wasn't
needed for older Windows versions.  And without the BIOS telling the
kernel HPET it doesn't know where it is and can't use it when
the APIC timer is not usable.

The ongoing work is to implement hpet=force code that knows
about various chipsets and reads their hardware registers directly
and then uses the HPET timer without BIOS support.

The reason it is still an option is that there used to be at least one
old chipset where forcing the HPET could trigger hardware bugs.

On the other hand it is expected that BIOS versions support Vista
also supply HPET, so that problem will hopefully get better.

> This way,
> dynticks and C1E could be both enabled and thus save more power.

I would not expect too much over a HZ=100 kernel on current AMD. 

C1e doesn't have too much latency on its own. iirc at least on current
AMD platforms sleeping for longer didn't make too much
difference. With HZ=250 it might be borderline, but I would not expect
miracles. It's probably only clearly a good idea if you're on a
HZ=1000 kernel or have applications that need very precise hrtimers (but that
might cost more power again because it'll cause more wakeups) 

Of course this can always change in future systems -- these are
just rules of thumb currently.

-Andi
