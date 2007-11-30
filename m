Return-Path: <linux-kernel-owner+w=401wt.eu-S1764267AbXK3Smj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764267AbXK3Smj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 13:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762691AbXK3SmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 13:42:12 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:58861 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764077AbXK3SmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 13:42:10 -0500
Subject: Re: [RFC PATCH] LTTng instrumentation mm (updated)
From: Dave Hansen <haveblue@us.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, mbligh@google.com
In-Reply-To: <20071130170516.GA31586@Krystal>
References: <20071115215142.GA7825@Krystal>
	 <1195164977.27759.10.camel@localhost> <20071116143019.GA16082@Krystal>
	 <1195495485.27759.115.camel@localhost> <20071128140953.GA8018@Krystal>
	 <1196268856.18851.20.camel@localhost> <20071129023421.GA711@Krystal>
	 <1196317552.18851.47.camel@localhost> <20071130161155.GA29634@Krystal>
	 <1196444801.18851.127.camel@localhost>  <20071130170516.GA31586@Krystal>
Content-Type: text/plain
Date: Fri, 30 Nov 2007 10:42:02 -0800
Message-Id: <1196448122.19681.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-30 at 12:05 -0500, Mathieu Desnoyers wrote:
> 
> 
> Given a trace including :
> - Swapfiles initially used
> - multiple swapon/swapoff
> - swap in/out events
> 
> We would like to be able to tell which swap file the information has
> been written to/read from at any given time during the trace.

Oh, tracing is expected to be on at all times?  I figured someone would
encounter a problem, then turn it on to dig down a little deeper, then
turn it off.

As for why I care what is in /proc/swaps.  Take a look at this:

struct swap_info_struct *
get_swap_info_struct(unsigned type)
{
        return &swap_info[type];
}

Then, look at the proc functions: 

static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
{
        struct swap_info_struct *ptr;
        struct swap_info_struct *endptr = swap_info + nr_swapfiles;

        if (v == SEQ_START_TOKEN)
                ptr = swap_info;
...

I guess if that swap_info[] has any holes, we can't relate indexes in
there right back to /proc/swaps, but maybe we should add some
information so that we _can_.

-- Dave

