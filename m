Return-Path: <linux-kernel-owner+w=401wt.eu-S1759178AbZHROTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759178AbZHROTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 10:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758900AbZHROTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 10:19:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:29427 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758958AbZHROTK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 10:19:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,402,1246863600"; 
   d="scan'208";a="440067351"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Date: Tue, 18 Aug 2009 15:19:07 +0100
Subject: RE: [PATCH] perf_counter: Fix a race on perf_counter_ctx
Thread-Topic: [PATCH] perf_counter: Fix a race on perf_counter_ctx
Thread-Index: AcogDHI09XwR6x4+Qb2UJHXdD+vq6wAAd4GA
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EC1CB7807@irsmsx504.ger.corp.intel.com>
References: <928CFBE8E7CB0040959E56B4EA41A77EC1BFEFEB@irsmsx504.ger.corp.intel.com>
	 <20090807103127.GA23139@elte.hu> <20090807103610.GA23728@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF02D@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF048@irsmsx504.ger.corp.intel.com>
	 <20090807112421.GB30014@elte.hu> <20090807113349.GA31673@elte.hu>
	 <1249667341.17467.5.camel@twins> <20090808120315.GA14086@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF464@irsmsx504.ger.corp.intel.com>
	 <20090810134608.GA8295@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF78D@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB7725@irsmsx504.ger.corp.intel.com>
	 <1250600348.7583.280.camel@twins> <1250600385.7583.281.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB7775@irsmsx504.ger.corp.intel.com>
	 <1250602664.7583.293.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB77C8@irsmsx504.ger.corp.intel.com>
 <1250604091.7583.296.camel@twins>
In-Reply-To: <1250604091.7583.296.camel@twins>
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
>From: Peter Zijlstra [mailto:peterz@infradead.org]
>Sent: Tuesday, August 18, 2009 4:02 PM
>To: Metzger, Markus T
>Cc: Ingo Molnar; tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; linux-
>kernel@vger.kernel.org; Paul Mackerras
>Subject: RE: [PATCH] perf_counter: Fix a race on perf_counter_ctx
>
>On Tue, 2009-08-18 at 14:54 +0100, Metzger, Markus T wrote:
>
>> Well, that would push out the limit a bit, but it would still be quite fragile.
>>
>> Currently, I'm not sure that this (i.e. that the interrupt handling takes too long)
>> is the underlying problem of the hangs that I'm seeing.
>>
>> If it truly is, then I would go with the two-buffer approach. This would make the
>> ISR itself predictably and reliably fast - at the expense of additional locked memory.
>
>comment out that perf_counter_output() call and see what happens ;-)

That's what I did more or less.
When I ignore the buffer size and sample 10 records, it seems to work.
When I sample 1000 records, the kernel hangs.

But this does not automatically mean that the increased time in the ISR is
directly causing the hang, does it?


>> Do you think that this truly is the problem?
>> How would the kernel react if interrupts were disabled for too long? I would definitely
>> expect bad responsiveness, but can the kernel kill itself?
>
>If we're branch tracing while processing the interrupt (not sure here),
>then we might well generate enough output to generate a new interrupt,
>causing back-to-back interrupts, basically DoSing the machine.

We call perf_disable() when entering the ISR and perf_enable() when exiting.

regards,
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

