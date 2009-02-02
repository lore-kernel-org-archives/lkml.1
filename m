Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451AbZBBInA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbZBBInA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 03:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZBBImw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 03:42:52 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:56713 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbZBBImv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 03:42:51 -0500
Message-ID: <4986B205.2040807@s5r6.in-berlin.de>
Date: Mon, 02 Feb 2009 09:42:45 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
References: <20090127001708.GA4815@nowhere>	 <20090126163015.7f879b18@infradead.org> <20090131180347.GC5884@nowhere>	 <20090131101502.7ce8e7af@infradead.org> <20090131182843.GD5884@nowhere>	 <1233524261.18767.60.camel@pasglop>  <20090202022414.GA5006@nowhere> <1233554443.18767.71.camel@pasglop>
In-Reply-To: <1233554443.18767.71.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Mon, 2009-02-02 at 03:24 +0100, Frederic Weisbecker wrote:
>> On Mon, Feb 02, 2009 at 08:37:41AM +1100, Benjamin Herrenschmidt wrote:
>> > 
>> > > I don't know, most of those I've looked on are not documented about the reason
>> > > for a private workqueue. I guess most of them can use the usual kevent.

I rather suspect that the majority of private workqueues are there for
good reasons.

>> > The main problem with kevent is that it gets clogged up.
>> 
>> I don't think so. Here is a snapshot of the workqueue tracer in my
>> box currently:
> 
> That's not quite what I meant ... 
> 
> The main problem with keventd I'd say is that it's used in all sort of
> exeptional code path (ie, driver reset path, error handling, etc...) for
> things that will msleep happily for tenth milliseconds, that sort of
> thing.
> 
> IE. It will be pretty responsive -in general- but can suffer form
> horrible latencies every now and then.

Actually it /should/ be the other way around:

The shared workqueue should only be used for work that sleeps only
briefly (perhaps with the exception of very unlikely longer sleeps e.g.
for allocations that cause paging).

Work which /may/ sleep longer, for example performs SCSI transactions,
needs to go into a private workqueue or other kind of context.

OTOH you are right too; work which must not be deferred too long by work
from another uncooperative/ unfair subsystem is probably also better off
in an own workqueue...
-- 
Stefan Richter
-=====-==--= --=- ---=-
http://arcgraph.de/sr/
