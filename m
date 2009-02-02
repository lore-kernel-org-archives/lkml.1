Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbZBBUds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbZBBUds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbZBBUdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:33:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:39093 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbZBBUdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:33:39 -0500
Subject: Re: Performance counter API review was [patch] Performance
 Counters for Linux, v3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Maynard Johnson <mpjohn@us.ibm.com>, carll@us.ibm.com
In-Reply-To: <49875199.3010609@linux.vnet.ibm.com>
References: <20081211155230.GA4230@elte.hu>
	 <87r64ag68n.fsf@basil.nowhere.org>  <49875199.3010609@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 21:33:01 +0100
Message-Id: <1233606782.10184.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 12:03 -0800, Corey Ashford wrote:
> Andi Kleen wrote:
> [snip]
> > - Global tracing. Right now there seem to be two modi: per task and
> > per CPU. But a common variant is global tracing of all CPUs. While this
> > could be in theory done right now by attaching to each CPU
> > this has the problem that it doesn't interact very well with CPU
> > hot plug. The application would need to poll for additional/lost
> > CPUs somehow and then re-attach to them (or detach). This would
> > likely be quite clumsy and slow. It would be better if the kernel supported 
> > that better.
> > 
> > Or alternative here is to do nothing and keep oprofile for that job
> > (which it doesn't do that badly)
> > 
> 
> This issue is of particular interest to us, from the IBM Power toolchain 
> perspective.
> 
> Ingo, do you think it would be feasible to add an ability to open a 
> single file descriptor that could give global counting (and sampling) on 
> all CPU's?  I realize this would entail creating a context per cpu in 
> the kernel.
> 
> How to present the count data back to user space is another issue.  For 
> example, do you sum the counts of a particular event type across all 
> CPUs or do you keep them separate, and have the user space app read them 
> up per-cpu  (perhaps not knowing exactly which cpu they come from)?
> 
> I realize that perfmon doesn't have this ability either, it's currently 
> per-cpu as well for global counting.
> 
> But it seems as long as you are going so far as providing a thread 
> inheritance feature (which I assume uses a summing approach for 
> providing counts back to user space), that this "pan-cpu" counting 
> feature might not be too difficult to implement.  It sure would simplify 
> the life of user space apps, as Andi said.

Doing a single fd for all cpus is going to suck chunks because its going
to be a global serialization point.

Also, why would you be profiling while doing a hotplug? Both cpu
profiling, and hotplug, are administrator operations, just don't do
that.

The inheritance thing will also suffer this issue, if you're going to do
reads of your fds at any other point than at the end -- it will have to
walk the whole inheritance tree and sum all the values (or propagate
interrupts up the tree). Which sounds rather expensive.



