Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104Ab0ASA5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab0ASA5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 19:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508Ab0ASA5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 19:57:44 -0500
Received: from mga05.intel.com ([192.55.52.89]:59761 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753300Ab0ASA5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 19:57:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,299,1262592000"; 
   d="scan'208";a="765297287"
Message-ID: <4B550384.8030103@linux.intel.com>
Date: Mon, 18 Jan 2010 16:57:40 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 32/40] async: introduce workqueue based alternative implementation
References: <1263776272-382-1-git-send-email-tj@kernel.org>	<1263776272-382-33-git-send-email-tj@kernel.org>	<20100117220130.214d56f1@linux.intel.com>	<4B5420A3.3080200@kernel.org> <20100118072523.2683cd59@linux.intel.com> <4B55038D.3070106@kernel.org>
In-Reply-To: <4B55038D.3070106@kernel.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/18/2010 16:57, Tejun Heo wrote:
> Hello, Arjan.
>
> On 01/19/2010 12:25 AM, Arjan van de Ven wrote:
>> Your API/model change gets rid of this conceptually simple programming
>> model, which makes using it on other places more complex and messy. I
>> do not see what enormous benefit your patches would have that would
>> justify complicating the programming model. (And "sharing the thread
>> pool" is not that; I'm sure it's possible to share the thread pool
>> without changing the programming model... and it's not that the async
>> thread pools are that big or complex anyway)
>
> Oh yeah, if you want the cookies, it can be implemented on top of
> workqueue.  I'm just not sure whether that has justifiable benefit.
> About the same things can be achived using flushes and if some
> subsystem want low level control, it can simply use the workqueue
> directly implementing whatever level of concurrency as it sees fit and
> flushing as necessary.
>
> As cmwq can provide async contexts flexibly, the benefit of async is
> simplification of simple cases where the caller doesn't have to worry
> about allocating works or whatever.  I don't really see much point in
> introducing a different set of sync rules based on cookies when the
> same thing can be achieved using wq interfaces directly and I think
> that having two different models for async synchronization might hurt
> more than help.  What type of ordering rules are you currently working
> on using cookies?

there are two types:
there's the domains, where you synchronize only within a domain,
and then there's the "async string", think ACPI.
the ACPI init is a whole series of sort of dependent steps, where you synchronize
about halfway, but the whole set runs async to all other inits in the system, and only
near the very end when a full synchronization is done do you wait.
basically what you get (sorry, lame ascii graph)

***************************************  (main init flow)
    ***				driver 1
    *  **			driver 2
     *   **			driver 3
     *     **			driver 4
     *       **                  driver 5

where you get maximum concurrency during the pre-synchronization part,
and a "chain" of synchronized execution *as part of the same function flow*,
but possibly independent of other synchronization flows.


the async infrastructure as you say took away the hassle of allocating, and more
importantly, caring for the lifetime of the metadata object. But it also introduced
a sychronization mechanism that is natural and simple for driver init and some other flows.



>
> Thanks.
>

