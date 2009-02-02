Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbZBBJC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbZBBJC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 04:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbZBBJCC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 04:02:02 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:56781 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbZBBJCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 04:02:01 -0500
Message-ID: <4986B684.5000506@s5r6.in-berlin.de>
Date: Mon, 02 Feb 2009 10:01:56 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
References: <20090127001708.GA4815@nowhere>	<20090126163015.7f879b18@infradead.org>	<20090131180347.GC5884@nowhere>	<20090131101502.7ce8e7af@infradead.org>	<20090131182843.GD5884@nowhere>	<1233524261.18767.60.camel@pasglop> <20090201211909.37c0780b@infradead.org>
In-Reply-To: <20090201211909.37c0780b@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Mon, 02 Feb 2009 08:37:41 +1100
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
>> That's were thread pools kick in ... tried using Dave Howells slow
>> work ?
> 
> async function calls are pretty much the same and actually in mainlinme.
> Dave Howells stuff in addition plays some extremely weird refcounting
> games that I cannot imagine anyone but him needing...

I haven't looked at this particular slow-work implementation.  Do you
refer to some internal refcounting or to some refcounting as a service
for the API user?

IME, scheduling work and executing work is often accompanied by
reference counting of this sort:

static int schedule_delayed_work_wrapper(struct foo *container,
					 unsigned long delay)
{
	int scheduled;

	foo_get(container);
	scheduled = schedule_delayed_work(&container->work, delay);
	if (!scheduled)
		foo_put(container);

	return scheduled;
}

static void foo_work(struct work_struct *work)
{
	struct foo *container =
			container_of(work, struct foo, work.work);

	do_the_work;

	foo_put(container);
}

But I think that whenever there are additional call sites of
foo_put(container), this refcounting of container_of(work, ...) cannot
be easily generalized.
-- 
Stefan Richter
-=====-==--= --=- ---=-
http://arcgraph.de/sr/
