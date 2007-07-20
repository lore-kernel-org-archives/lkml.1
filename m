Return-Path: <linux-kernel-owner+w=401wt.eu-S932088AbXGTB1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088AbXGTB1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 21:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760856AbXGTB1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 21:27:07 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:45644 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761012AbXGTB1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 21:27:04 -0400
Message-ID: <46A00CC2.6010407@vmware.com>
Date: Thu, 19 Jul 2007 18:15:46 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>, jbeulich@novell.com,
       "S. P. Prasanna" <prasanna@in.ibm.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: new text patching for review
References: <200707191105.44056.ak@suse.de> <20070719133852.GA5490@Krystal> <200707191546.08919.ak@suse.de> <20070719173502.GB12955@Krystal> <p73d4yow0ys.fsf@bingen.suse.de> <20070719234912.GB30383@Krystal>
In-Reply-To: <20070719234912.GB30383@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Yes, kprobes is case 1: atomic update. And we don't even have to bother
> about Intel's erratum. This one is ok. That's mainly the
> alternatives/paravirt code I worry about.
>   

Paravirt and alternatives should all be ok because they are done before 
SMP bringup and with NMIs disabled.  NMI watchdog is not setup until 
smp_prepare_cpus/check_nmi_watchdog, which happens way later, not during 
parse_args/setup_nmi_watchdog, which just decides which type of watchdog 
to setup.

I originally considered the NMI problem for paravirt-ops patching done 
during module load, and found that I would need to modify 
stop_machine_run to have an architecture specific callout to mask and 
unmask NMIs.  I didn't imagine that would be very popular, and VMI was 
the only paravirt-ops that were considering module load time patching, 
so I flushed it.

You get some other nasty issues as well with run-time switching, like 
missing early init calls (in particular, we would have to go to some 
heroics to retake the land surrounding the APIC local timer interrupt).

Zach
