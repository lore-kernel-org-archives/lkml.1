Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbZCaInA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbZCaInA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 04:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZCaImu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 04:42:50 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:19151 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbZCaIms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 04:42:48 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 13/15] perf_counter: provide generic callchain bits
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <49D1C544.7020403@linux.vnet.ibm.com>
References: <20090330170701.856843742@chello.nl>
	 <20090330171024.254266860@chello.nl>
	 <18897.46177.528910.51044@cargo.ozlabs.ibm.com>
	 <1238481552.28248.1384.camel@twins>  <49D1C544.7020403@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 31 Mar 2009 10:43:13 +0200
Message-Id: <1238488993.28248.1929.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-31 at 00:24 -0700, Corey Ashford wrote:
> Peter Zijlstra wrote:
> > On Tue, 2009-03-31 at 17:12 +1100, Paul Mackerras wrote:
> >> Peter Zijlstra writes:
> >>
> >>>  				include_tid    :  1, /* include the tid       */
> >>>  				mmap           :  1, /* include mmap data     */
> >>>  				munmap         :  1, /* include munmap data   */
> >>> +				callchain      :  1, /* add callchain data    */
> >> Interesting, I would have put callchain (and include_tid, also) in
> >> hw_event.record_type rather than as individual 1-bit fields.  The
> >> present arrangement where some selection of what goes into the ring
> >> buffer is in record_type and some is in individual bits seems a bit
> >> awkward.  Plus, with the current arrangement I can't get both the IP
> >> and the values of the other group members, which I might reasonable
> >> want.
> >>
> >> I think either we make record_type bit-significant, or we define
> >> individual bits in hw_event for recording the IP and other group
> >> members.
> >>
> >> There are a couple of other things I want to be able to record on an
> >> event - we have registers on powerpc that give information about the
> >> event that caused the interrupt, and it would be nice to be able to
> >> record them.  (These registers include instruction and data addresses
> >> associated with the event; the instruction address can be further on
> >> from where the interrupt was taken because of out-of-order instruction
> >> execution and because interrupts might be hard-disabled at the point
> >> where the interrupt becomes pending.)
> >>
> >> Those registers would need bits in record_type or in the hw_event to
> >> indicate that we want them recorded.
> > 
> > Sure, I'm fine with moving them to record_type and making that a bit
> > field. I've also considered merging the group and 'simple' output to
> > enable what you say.
> 
> Originally, the record_type field was used to determine what would be 
> read if you read from the fd.  However, now it seems to be what you get 
> from the mmap buffer (only), that there is no longer a way to read the 
> record stream from the fd anymore. Is this true?  

Yes, read() will return the current value of the counter.
mmap() is used for all async data streams.

> If so, I like this 
> idea because it simplifies the ABI: there is one way to read the current 
> value of counters and another way to read sample records (via mmap), 
> both of these operations use a single fd.

Correct, glad you like it ;-)

> If this is the case, what is the exact meaning of PERF_COUNTER_SIMPLE 
> now? and PERF_COUNTER_GROUP? 

Legacy mainly. I've been working towards unifying those. As Paul also
suggested, group can be yet another output option.

>  One simplification would be that reading 
> the fd of a group leader would always read up all of the counters in the 
> group (along with their enabled and running times if those bits are 
> set), and that reading a single counter's fd would yield only that 
> counter's values and times (if enabled).  In effect, these two values, 
> PERF_COUNTER_GROUP and PERF_COUNTER_SIMPLE would no longer be necessary 
> at all.  Other bits would be used to determine what's in the mmap'd samples.

Quite so, that sounds sensible, Paul?

Would you be overly bothered by the read() output also having that
{type,size} header we use for the mmap() data?

