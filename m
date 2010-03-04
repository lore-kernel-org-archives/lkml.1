Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab0CDSj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 13:39:29 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:53285 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab0CDSj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 13:39:27 -0500
Message-ID: <4B8FFE55.5070008@linux.vnet.ibm.com>
Date: Thu, 04 Mar 2010 10:39:17 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] [PATCH 1/1] perf: add support for arch-dependent symbolic
 event names to "perf stat"
References: <4B8F1B58.5000702@linux.vnet.ibm.com>
In-Reply-To: <4B8F1B58.5000702@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/3/2010 6:30 PM, Corey Ashford wrote:
> For your review, this patch adds support for arch-dependent symbolic
> event names to the "perf stat" tool, and could be expanded to other
> "perf *" commands fairly easily, I suspect.
>
> To support arch-dependent event names without adding arch-dependent code
> to perf, I added a callout mechanism whereby perf will look for the
> environment variable: PERF_ARCH_DEP_LIB, and if it exists, it will try
> to open it as a shared object. If that succeeds, it looks for the symbol
> "parse_arch_dep_event". If that exists, that function will be called by
> parse_events() before all of the other event parsing functions in
> parse-events.c. It is passed the same arguments as the other
> parse_*_event functions, namely the event string and a pointer to an
> event attribute structure.
>
> As the code existed, "perf stat" would print out the count results, but
> for raw events (which is how arch-dependent events are supported in
> perf_events), it would just print out a raw code. This is not
> acceptable, especially when a symbolic name was placed on the command
> line. So I changed the code to save away the event name that was passed
> on the command line, rather than doing a reverse translation to an event
> string based on the event type and config fields of the attr structure.
> In this way, there's no need for a reverse translation function in the
> arch-dependent library; only a event string->attr struct function is
> needed.
>
> I could well be missing something, but I don't understand why reverse
> translation is ever needed in perf, as long as the tool keeps track of
> the original event strings.

A couple of follow-up comments on this patch:

This functionality was designed to provide a generalized interface to an 
external event name -> attr struct library, such as libpfm4.  libpfm4 has an 
interface that nearly exactly matches parse_*_event() profiles, so it's quite 
easy to write a small wrapper function to call libpfm4's function.

Ingo Molnar discussed adding some visibility to the arch-dependent event names 
through some other interface, such as through /sys/devices/pmus perhaps, but 
that discussion is a long way (as far as I know) from having something usable 
today.  So you could think of this external library approach to be a stop-gap 
until something better is developed.  When/if that new event naming mechanism 
becomes available, we can easily remove this external library support from perf.

-- 
Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com


