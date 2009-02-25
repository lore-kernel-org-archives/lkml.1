Return-Path: <linux-kernel-owner+w=401wt.eu-S1761607AbZBYJwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761607AbZBYJwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756499AbZBYJwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:52:41 -0500
Received: from mga14.intel.com ([143.182.124.37]:62186 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbZBYJwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:52:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,264,1233561600"; 
   d="scan'208";a="114192594"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
       "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Date: Wed, 25 Feb 2009 09:51:25 +0000
Subject: RE: [tip:tracing/hw-branch-tracing] tracing/hw-branch-tracing:
 convert bts-tracer mutex to a spinlock
Thread-Topic: [tip:tracing/hw-branch-tracing] tracing/hw-branch-tracing:
 convert bts-tracer mutex to a spinlock
Thread-Index: AcmXIhzEHIfpAEUoR2O5suSGqGrFFAACmY1A
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E4A4C1EF6@irsmsx504.ger.corp.intel.com>
References: <tip-2d542cf34264ac92e9e7ac55c0b096b066d569d2@kernel.org>
In-Reply-To: <tip-2d542cf34264ac92e9e7ac55c0b096b066d569d2@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n1P9qrwM009949

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu]
>Sent: Wednesday, February 25, 2009 9:21 AM


>bts_hotcpu_handler() is called with irqs disabled, so using mutex_lock()
>is a no-no.
>
>All the BTS codepaths here are atomic (they do not schedule), so using
>a spinlock is the right solution.

I introduced the lock to protect against a race between bts_trace_start/stop()
and bts_hotcpu_handler().

Assuming that the hw-branch-tracer is removed and at the same time a cpu
comes online, we might be left with a disabled tracer but still trace
that new cpu.

I wonder whether a simple get/put_online_cpus() would suffice, i.e.

static void bts_trace_start(struct trace_array *tr)
{
	get_online_cpus();

 	on_each_cpu(bts_trace_start_cpu, NULL, 1);
 	trace_hw_branches_enabled = 1;

	put_online_cpus();
}



> static void trace_bts_prepare(struct trace_iterator *iter)
> {
>-	mutex_lock(&bts_tracer_mutex);
>+	spin_lock(&bts_tracer_lock);
>
> 	on_each_cpu(trace_bts_cpu, iter->tr, 1);
>
>-	mutex_unlock(&bts_tracer_mutex);
>+	spin_unlock(&bts_tracer_lock);
> }

Whereas start/stop are relatively fast, the above operation is rather
expensive. Would it make sense to use schedule_on_each_cpu() instead
of on_each_cpu()?

regards,
markus.

---------------------------------------------------------------------Intel GmbHDornacher Strasse 185622 Feldkirchen/Muenchen GermanySitz der Gesellschaft: Feldkirchen bei MuenchenGeschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes SchwadererRegistergericht: Muenchen HRB 47456 Ust.-IdNr.VAT Registration No.: DE129385895Citibank Frankfurt (BLZ 502 109 00) 600119052
This e-mail and any attachments may contain confidential material forthe sole use of the intended recipient(s). Any review or distributionby others is strictly prohibited. If you are not the intendedrecipient, please contact the sender and delete all copies.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
