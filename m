Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbZLPPco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbZLPPco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932673AbZLPPch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:32:37 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:45513 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283AbZLPPcc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:32:32 -0500
From: "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
CC: "davej@redhat.com" <davej@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "mjg@redhat.com" <mjg@redhat.com>, "trenn@suse.de" <trenn@suse.de>,
       "lenb@kernel.org" <lenb@kernel.org>
Date: Wed, 16 Dec 2009 15:31:48 +0000
Subject: RE: [PATCH] cpufreq: Processor Clocking Control interface driver
Thread-Topic: [PATCH] cpufreq: Processor Clocking Control interface driver
Thread-Index: Acp9tSH9dGXHhXujRbKA2pu2bwabHwABo3DA
Message-ID: <66D9D2F0CDB5C9428E6166B01EC85EE161DEEE4166@GVW0676EXC.americas.hpqcorp.net>
References: <20091128034424.6796.75673.sendpatchset@localhost.localdomain>
 <20091211231233.GA4291@isilmar.linta.de>
 <66D9D2F0CDB5C9428E6166B01EC85EE161DEEE3CB7@GVW0676EXC.americas.hpqcorp.net>
 <20091215183331.GA5560@comet.dominikbrodowski.net>
In-Reply-To: <20091215183331.GA5560@comet.dominikbrodowski.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> >> +	if (target_freq <= 
>> >(ioread32(&pcch_hdr->minimum_frequency) * 1000)) {
>> >> +		target_freq = 
>> >ioread32(&pcch_hdr->minimum_frequency) * 1000;
>> >> +		dprintk("target: target_freq for cpu %d was 
>> >below limit, "
>> >> +			"converted it to %d\n", cpu, target_freq);
>> >> +	}
>> >
>> >why not do this in the _verify() step? Does 
>pcch_hdr->minimum_frequency
>> >even change "on the fly"?
>> 
>> pcch_hdr->minimum_frequency does not change "on the fly". 
>Also, there is no
>> need for those IO accesses:
>
>target_freq cannot be below policy->min or above policy->max. 
>If it were,
>the whole cpufreq subsystem is broken. So there's no need for 
>these checks,
>AFAICS.
>

I think the "ondemand" governor can ask for a target frequency that is
below policy->min.

Let's say that at a given snapshot, the frequency of a CPU is policy->cur.
At the next sampling, if the "load" on the CPU drops to a level that 
satisifies the equation below, then freq_next requested by "ondemand" 
will be below policy->min:

	load < (threshold - differential) * policy->min / policy->cur

A patch such as below may be needed to sanitize the target frequency 
requested by "ondemand". The "conservative" governor already has this check: 

# diff -bur ./drivers/cpufreq/cpufreq_ondemand.c.orig ./drivers/cpufreq/cpufreq_ondemand.c
--- ./drivers/cpufreq/cpufreq_ondemand.c.orig   2009-12-11 15:06:02.000000000 -0600
+++ ./drivers/cpufreq/cpufreq_ondemand.c        2009-12-15 20:27:57.000000000 -0600
@@ -554,6 +554,9 @@
                                (dbs_tuners_ins.up_threshold -
                                 dbs_tuners_ins.down_differential);

+               if (freq_next < policy->min)
+                       freq_next = policy->min;
+
                if (!dbs_tuners_ins.powersave_bias) {
                        __cpufreq_driver_target(policy, freq_next,
                                        CPUFREQ_RELATION_L);

- naga -

