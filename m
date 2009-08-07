Return-Path: <linux-kernel-owner+w=401wt.eu-S932423AbZHGLvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423AbZHGLvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 07:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932336AbZHGLvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 07:51:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:7007 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223AbZHGLvH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 07:51:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,341,1246863600"; 
   d="scan'208";a="714757378"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "oleg@redhat.com" <oleg@redhat.com>
Date: Fri, 7 Aug 2009 12:51:04 +0100
Subject: RE: [patch] x86, perf_counter, bts: add bts to perf_counter
Thread-Topic: [patch] x86, perf_counter, bts: add bts to perf_counter
Thread-Index: AcoXVJoUJcVeFyrVS/2gd0sKdSKllwAADmLg
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EC1BFF07F@irsmsx504.ger.corp.intel.com>
References: <20090807092256.A6083@sedona.ch.intel.com>
 <1249645524.32113.688.camel@twins>
In-Reply-To: <1249645524.32113.688.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl]
>Sent: Friday, August 07, 2009 1:45 PM
>To: Metzger, Markus T
>Cc: linux-kernel@vger.kernel.org; mingo@elte.hu; tglx@linutronix.de; hpa@zytor.com;
>markus.t.metzger@gmail.com; oleg@redhat.com
>Subject: Re: [patch] x86, perf_counter, bts: add bts to perf_counter
>
>On Fri, 2009-08-07 at 09:22 +0200, Markus Metzger wrote:
>> @@ -721,9 +903,13 @@ static int __hw_perf_counter_init(struct
>>         err = 0;
>>         if (!atomic_inc_not_zero(&active_counters)) {
>>                 mutex_lock(&pmc_reserve_mutex);
>> -               if (atomic_read(&active_counters) == 0 && !reserve_pmc_hardware())
>> -                       err = -EBUSY;
>> -               else
>> +               if (atomic_read(&active_counters) == 0) {
>> +                       if (!reserve_pmc_hardware())
>> +                               err = -EBUSY;
>> +                       else
>> +                               reserve_bts_hardware();
>> +               }
>> +               if (!err)
>>                         atomic_inc(&active_counters);
>>                 mutex_unlock(&pmc_reserve_mutex);
>>         }
>
>You loose the reserve_bts_hardware() error case there.


That had been intentional since I consider BTS somewhat optional. In case it is not available or
fails to initialize, e.g. out of memory, we fall back to normal profiling.

Now that I think about it again, I guess that's not what a (debugger) user would expect.
An error might be more appropriate in that case.

I'll change it.

thanks and regards,
markus.

---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

