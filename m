Return-Path: <linux-kernel-owner+w=401wt.eu-S1750991AbZDCHAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750991AbZDCHAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 03:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbZDCHAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 03:00:06 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:36409 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbZDCHAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 03:00:05 -0400
X-SourceIP: 213.93.53.227
Subject: Re: perf_counter: request for three more sample data options
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <49D56A7E.80908@linux.vnet.ibm.com>
References: <49D56A7E.80908@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 09:01:04 +0200
Message-Id: <1238742064.798.8.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 18:46 -0700, Corey Ashford wrote:
> Currently, perf_counter has the ability to record the following on event 
> counter overflow:
> 
> Instruction Pointer
> Call chain
> Group counter values
> Thread id
> 
> To give perf_counter similar capabilities to perfmon2's default sampling 
>   module, I'd like the following additional sample data to be added.
> 
> Time stamp
 
Rather hard actually, to provide a decent timestamp from NMI context.

> CPU number

Could do I guess.

> Thread Group Id

As in the process id? PERF_RECORD_TID already provides that.

> I'd suggest the following
> 
> enum perf_counter_record_format {
>          PERF_RECORD_IP          = 1U << 0,
>          PERF_RECORD_TID         = 1U << 1,
>          PERF_RECORD_TGID        = 1U << 2,
> -        PERF_RECORD_GROUP       = 1U << 2,
> +        PERF_RECORD_GROUP       = 1U << 3,
> -        PERF_RECORD_CALLCHAIN   = 1U << 3,
> +        PERF_RECORD_CALLCHAIN   = 1U << 4,
> +        PERF_RECORD_CPU_ID      = 1U << 5,
> +        PERF_RECORD_TIMESTAMP   = 1U << 6,
> };
> 
> And of course the obvious changes to perf_event_type.
> 
> I would expect that CPU ID would be 32 bits, and the timestamp to be the 
> 64-bit current time.  TGID is the same size as TID.

Right, so PREF_RECORD_TID provides:

 { u32 pid, tid; }

PERF_RECORD_TIMESTAMP would provide something like:

 { u64 time; }

and per our u64 alignment rule, PERF_RECORD_CPU would provide

 { u64 cpuid; }

unless you can think of anything else to stuff in there?

> I am guessing the only difficult thing here would be obtaining the 
> current time from an IRQ, especially NMI handler.  Is this difficult?

Yes, quite :-) I'll have to see what we can do there -- we could do a
best effort thing with little to no guarantees I think.

