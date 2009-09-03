Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbZICO03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbZICO03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 10:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbZICO02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 10:26:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:12890 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbZICO01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 10:26:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,325,1249282800"; 
   d="scan'208";a="490197830"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Date: Thu, 3 Sep 2009 15:25:42 +0100
Subject: RE: [discuss] BTS overflow handling, was: [PATCH] perf_counter: Fix
 a race on perf_counter_ctx
Thread-Topic: [discuss] BTS overflow handling, was: [PATCH] perf_counter:
 Fix a race on perf_counter_ctx
Thread-Index: AcorC5XR7AsKI602Q0yo8rrw7ow4DQBkbp1g
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EC46CFE42@irsmsx504.ger.corp.intel.com>
References: <20090808120315.GA14086@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF464@irsmsx504.ger.corp.intel.com>
	 <20090810134608.GA8295@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF78D@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB7725@irsmsx504.ger.corp.intel.com>
	 <1250600348.7583.280.camel@twins> <1250600385.7583.281.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB7775@irsmsx504.ger.corp.intel.com>
	 <1250602664.7583.293.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB77C8@irsmsx504.ger.corp.intel.com>
	 <20090818140022.GB13013@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB77FF@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC465EFC5@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC465F989@irsmsx504.ger.corp.intel.com>
	 <1251810046.7547.13.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC46CF212@irsmsx504.ger.corp.intel.com>
 <1251813197.7547.27.camel@twins>
In-Reply-To: <1251813197.7547.27.camel@twins>
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
>Sent: Tuesday, September 01, 2009 3:53 PM
>To: Metzger, Markus T
>Cc: Ingo Molnar; tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; linux-
>kernel@vger.kernel.org; Paul Mackerras
>Subject: RE: [discuss] BTS overflow handling, was: [PATCH] perf_counter: Fix a race on
>perf_counter_ctx
>
>On Tue, 2009-09-01 at 14:32 +0100, Metzger, Markus T wrote:


>> >This makes me wonder how much time it takes to drain these buffers, it
>> >is at all possible to optimize that code path into oblivion, or will
>> >nothing be fast enough?
>>
>>
>> Are you saying that we should rather speed up that code path than try to
>> defer all the work? There definitely is a lot of redundant work done on
>> the generic path.
>>
>> I did a few experiments where I would drain only parts of the buffer.
>> I could not drain too much before the system would hang.
>> Besides, that does not sound too robust to me. Would it sill work on
>> a slower system? Or on a faster one? Or on a fully loaded one?
>
>Base cpu speed is what counts, load is not interesting.
>
>Also it seems a normalizing property, the slower the cpu the less
>branches it can process per time unit, so less data to process.
>
>But yes, I was suggesting to optimize this, since the current way of
>calling perf_counter_output() multiple times is massively bloated.


This seems to do the trick - at least on my box.

I prepare the header, then do a single perf_output_begin()/perf_output_end()
pair, and between those two, I drain the entire 2048 records BTS buffer -
pretty much the same way as perf_counter_output() does.

We could optimize this further by providing specialized draining functions,
one for each combination of PERF_SAMPLE_ bits, but it seems to be fast
enough the way it is.

Holding the output lock that long does not seem to be a problem.
I can do perf record -a -o /dev/null -e branches -c 1 and I don't get a
hrtimer warning in dmesg.

When I do a perf record -e branches -c 1 true in parallel, I do not get
any trace, though. And perf does not report an error, either.


I copied some of the generic sampling code; I'll try to restructure it
a bit so I can call a generic function to do the actual sampling - provided
this is still fast enough.

How would we make sure it works on other boxes, as well?
Is there a way for me to detect that I'm not handling the interrupt fast enough?


I found another "kernel hangs" bug that is reproducible with 'normal' profiling:

when I do sudo perf record -e instructions -c 1000000 -a -o /dev/null
then unplug and replug one cpu
then kill the perf record job
the kernel hangs


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

