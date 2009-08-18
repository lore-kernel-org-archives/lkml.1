Return-Path: <linux-kernel-owner+w=401wt.eu-S1758843AbZHRNhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843AbZHRNhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 09:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbZHRNht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 09:37:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:53135 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbZHRNht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 09:37:49 -0400
Subject: RE: [PATCH] perf_counter: Fix a race on perf_counter_ctx
From: Peter Zijlstra <peterz@infradead.org>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EC1CB7775@irsmsx504.ger.corp.intel.com>
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
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 18 Aug 2009 15:37:44 +0200
Message-Id: <1250602664.7583.293.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-18 at 14:20 +0100, Metzger, Markus T wrote:
> >-----Original Message-----
> >From: Peter Zijlstra [mailto:peterz@infradead.org]
> >Sent: Tuesday, August 18, 2009 3:00 PM
> >To: Metzger, Markus T
> >Cc: Ingo Molnar; tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail..com; linux-
> >kernel@vger.kernel.org; Paul Mackerras
> >Subject: RE: [PATCH] perf_counter: Fix a race on perf_counter_ctx
> >
> >On Tue, 2009-08-18 at 14:59 +0200, Peter Zijlstra wrote:
> >> On Tue, 2009-08-18 at 13:49 +0100, Metzger, Markus T wrote:
> >> > Hi Ingo, Peter,
> >> >
> >> > Did you say that branch tracing is working for you?
> >> >
> >> > On my system, the kernel hangs.
> >> >
> >> > Could it be that it simply takes too long to copy the trace? When I set the number
> >> > of samples to 10, everything seems to work OK. When I increase that number to 1000,
> >> > the kernel is getting very slow and eventually hangs.
> >> >
> >> > I get a message "hrtimer: interrupt too slow", and I get a soft lockup bug. The rest
> >> > of the message log seems pretty garbled.
> >
> >How many NMI/s is this generating anyway?
> 
> One every 800 or so branches in the current configuration - which results in 800 plus
> a few perf_counter_output() calls per interrupt.

Right, that's terribly expensive. It might be worth it to specialize
that.

int perf_bts_entry_size(struct perf_counter *counter)
{
	u64 sample_type = counter->attr.sample_type;
	int size = sizeof(perf_event_header);

	if (sample_type & PERF_SAMPLE_IP)
		size += sizeof(u64);

	...
	
	/* maybe disallow PERF_SAMPLE_CALLCHAIN/RAW and grouping
           on BTS counters */

	return size;
}

void perf_bts_output(struct perf_counter *counter, ...)
{
	int size = perf_bts_entry_size(counter);
	struct perf_output_handle handle;
	u64 entry[size / sizeof(u64)];
	int ret;

	entry[0] = (struct perf_entry_header){
		.type = PERF_EVENT_SAMPLE,
		.misc = 0,
		.size = size,
	};
	
	... /* set all entry things */

	ret = perf_output_begin(&handle, counter, 
				size * nr_entries, 1, 1);
	if (ret)
		return;

	for (i = 0; i < nr_entries; i++) {
		/* over-write the two that differ per entry */
		entry[ip_entry] = bts_data[i].ip;
		entry[add_entry] = bts_data[i].the_other_one;

		perf_output_copy(&handle, entry, size);
	}

	perf_output_end(&handle);
}

or something like that.. would that work?
