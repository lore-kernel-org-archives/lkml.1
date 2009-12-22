Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbZLVBKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbZLVBKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 20:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbZLVBK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 20:10:27 -0500
Received: from ozlabs.org ([203.10.76.45]:34978 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900AbZLVBKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 20:10:24 -0500
Date: Tue, 22 Dec 2009 12:02:38 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       perfmon2-devel@lists.sf.net, "David S. Miller" <davem@davemloft.net>,
       eranian@google.com
Subject: Re: [PATCH] perf_events: improve Intel event scheduling
Message-ID: <20091222010238.GB31264@drongo>
References: <1255964630-5878-1-git-send-email-eranian@gmail.com>
 <1258561957.3918.661.camel@laptop>
 <7c86c4470912110300n44650d98ke52ec56cf4d925c1@mail.gmail.com>
 <7c86c4470912110359i5a4416c2t9075eaa47d25865a@mail.gmail.com>
 <1261410040.4314.178.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261410040.4314.178.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 04:40:40PM +0100, Peter Zijlstra wrote:

> I'm not really seeing the problem here...
> 
> 
>  perf_disable() <-- shut down the full pmu
> 
>  pmu->disable() <-- hey someone got removed (easy free the reg)
>  pmu->enable()  <-- hey someone got added (harder, check constraints)
> 
>  hw_perf_group_sched_in() <-- hey a full group got added 
>                               (better than multiple ->enable)
> 
>  perf_enable() <-- re-enable pmu
> 
> 
> So ->disable() is used to track freeing, ->enable is used to add
> individual counters, check constraints etc..
> 
> hw_perf_group_sched_in() is used to optimize the full group enable.
> 
> Afaict that is what power does (Paul?) and that should I think be
> sufficient to track x86 as well.

That sounds right to me.

> Since sched_in() is balanced with sched_out(), the ->disable() calls
> should provide the required information as to the occupation of the pmu.
> I don't see the need for more hooks.
> 
> Paul, could you comment, since you did all this for power?

On powerpc we maintain a list of currently enabled events in the arch
code.  Does x86 do that as well?

If you have the list (or array) of events easily accessible, it's
relatively easy to check whether the whole set is feasible at any
point, without worrying about which events were recently added.  The
perf_event structure has a spot where the arch code can store which
PMU register is used for that event, so you can easily optimize the
case where the event doesn't move.

Like you, I'm not seeing where the difficulty lies.  Perhaps Stephane
could give us a detailed example if he still thinks there's a
difficulty.

Paul.
