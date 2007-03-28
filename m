Return-Path: <linux-kernel-owner+w=401wt.eu-S1751862AbXC1OBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbXC1OBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 10:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbXC1OBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 10:01:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbXC1OBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 10:01:18 -0400
Message-ID: <460A74EF.6000700@redhat.com>
Date: Wed, 28 Mar 2007 10:00:15 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: virtualization@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       John Hawkes <hawkes@sgi.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 3/4] Locally disable the softlockup watchdog rather than
 touching it
References: <20070327214919.800272641@goop.org> <20070327215828.085422178@goop.org> <460A6EC0.4020701@redhat.com> <200703281550.04224.ak@suse.de>
In-Reply-To: <200703281550.04224.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>> touch_nmi_watchdog is attempting to tickle _all_ CPUs softlockup watchdogs.
>>     
>
> It is supposed to only touch the current CPU, just like it only touches
> the NMI watchdog on the current CPU.
>
>   

Andi,

(sorry for the cut-and-paste). 

touch_nmi_watchdogs sets EACH CPUs alert_counter to 0.

void touch_nmi_watchdog (void)
{
        if (nmi_watchdog > 0) {
                unsigned cpu;

                /*
                 * Just reset the alert counters, (other CPUs might be
                 * spinning on locks we hold):
                 */
                for_each_present_cpu (cpu)
                        alert_counter[cpu] = 0;
        }

        /*
         * Tickle the softlockup detector too:
         */
        touch_softlockup_watchdog();
}

The call to touch_softlockup_watchdog here is incorrect -- it is only 
touching the current CPU's softlockup.

P.
