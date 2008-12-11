Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbYLKST6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbYLKST6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 13:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755082AbYLKSTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 13:19:49 -0500
Received: from relay2.sgi.com ([192.48.179.30]:56168 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754467AbYLKSTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 13:19:49 -0500
Message-ID: <494159C2.5020401@sgi.com>
Date: Thu, 11 Dec 2008 10:19:46 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] cpumask: use maxcpus=NUM to extend the cpu limit
 as well as restrict the limit
References: <20081211112806.499831000@polaris-admin.engr.sgi.com> <20081211112807.004085000@polaris-admin.engr.sgi.com> <20081211134131.GB6264@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20081211134131.GB6264@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> On Thu, Dec 11, 2008 at 03:28:09AM -0800, Mike Travis wrote:
>> Impact: allow adding additional cpus.
>>
>> Use maxcpus=NUM kernel parameter to extend the number of possible cpus as well
>> as (currently) limit them.  Any cpus >= number of present cpus will disabled.
>>
>> The ability to HOTPLUG ON cpus that are "possible" but not "present" is
>> dealt with in a later patch.
> 
> Hm.. documentation/kernel-parameters.txt says:
> 
> 	maxcpus=	[SMP] Maximum number of processors that an SMP kernel
> 			should make use of.  maxcpus=n : n >= 0 limits the
> 			kernel to using 'n' processors.	 n=0 is a special case,
> 			it is equivalent to "nosmp", which also disables
> 			the IO APIC.
> 
> but documentation/cpu-hotplug.txt says:
> 
> maxcpus=n    Restrict boot time cpus to n. Say if you have 4 cpus, using
> 	     maxcpus=2 will only boot 2. You can choose to bring the
> 	     other cpus later online, read FAQ's for more info.
> 
> It used to be (implementation wise) that maxcpus doesn't influence the number
> of possible cpus but just indicated how many cpus were brought online at startup
> of the kernel. Which is what cpu-hotplug.txt describes.
> 
> Other present cpus would appear offline and could be brought online later.
> 
> For s390 I added the possible_cpus kernel parameter back then, since my
> understanding back then was that maxcpus doesn't and shouldn't influence the
> number of possible cpus:
> 
> possible_cpus=n		[s390 only] use this to set hotpluggable cpus.
> 			This option sets possible_cpus bits in
> 			cpu_possible_map. Thus keeping the numbers of bits set
> 			constant even if the machine gets rebooted.
> 
> Dunno... it all looks like a mess ;)

Hmm, I hadn't noticed that.  For a while the X86 devel kernel had an
"additional_cpus=n" parameter, which was also a bit confusing.  Say you
wanted, 64 total, you had to give the increment over how many you already
had [e.g., (want)64 - (have)16  = (additional_cpus=)48.]

I just figured that re-using the same kernel parameter was better than adding
another.  But I'm willing to go either way.

Btw, I did alter the Documentation/kernel-parameters.txt file:

        maxcpus=        [SMP] Maximum number of processors that an SMP kernel
                        should make use of.  maxcpus=n : n >= 0 limits the
                        kernel to using 'n' processors.  n=0 is a special case,
                        it is equivalent to "nosmp", which also disables
                        the IO APIC.  On [X86] maxcpus can also be used to
                        extend the number of possible cpus to overcome ACPI
                        tables that do not indicate disabled cpus, as well as
                        allow for additional cpus to be HOT PLUGGED in.
                        Format: <0-NR_CPUS>

In modifying the code, I could not find any arch-specific instances and the only
general case was in the 3 references in init/main.c, so I figured it was pretty
safe to use.

Thanks,
Mike
