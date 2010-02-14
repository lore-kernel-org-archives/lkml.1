Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359Ab0BNKMd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 05:12:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:60669 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758329Ab0BNKMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 05:12:25 -0500
Subject: Re: Why is PERF_FORMAT_GROUP incompatible with inherited events?
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       Dave Wootton <dwootton@us.ibm.com>
In-Reply-To: <20100212030205.GE13769@brick.ozlabs.ibm.com>
References: <20100212030205.GE13769@brick.ozlabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Feb 2010 11:12:17 +0100
Message-ID: <1266142337.5273.417.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-12 at 14:02 +1100, Paul Mackerras wrote:
> We currently have this code in perf_event_alloc() in kernel/perf_event.c:
> 
> 	/*
> 	 * we currently do not support PERF_FORMAT_GROUP on inherited events
> 	 */
> 	if (attr->inherit && (attr->read_format & PERF_FORMAT_GROUP))
> 		goto done;
> 
> plus there is a comment "XXX PERF_FORMAT_GROUP vs inherited events
> seems difficult" next to perf_output_read_group() (but there isn't a
> similar comment on perf_read_hw()).
> 
> First, what is the difficulty referred to here?

IIRC its the fact that we have to go collect the count delta from all
the child counters, which can be quite a lot of work depending on the
number of cpus and children around.

> Secondly, if the difficulty is just to do with the intersection of
> sampling counters, inheritance, and group readout (as seems to be the
> case), could we please allow group readout on ordinary counting
> (non-sampling) counters?  That is, change the test above to something
> like:
> 
> 	if (attr->inherit && attr->sample_period &&
> 	    (attr->read_format & PERF_FORMAT_GROUP))
> 		goto done;
> 
> Any objections to that change?  If it's OK, could we get it into .33
> and .32-stable?

Yeah, that's still broken, you can't do a read without collecting all
the child counts.


