Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412Ab0ASH6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab0ASH6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 02:58:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597Ab0ASH6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 02:58:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:35933 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932148Ab0ASH56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 02:57:58 -0500
Message-ID: <4B5565BE.4050406@kernel.org>
Date: Tue, 19 Jan 2010 16:56:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 32/40] async: introduce workqueue based alternative implementation
References: <1263776272-382-1-git-send-email-tj@kernel.org>	<1263776272-382-33-git-send-email-tj@kernel.org>	<20100117220130.214d56f1@linux.intel.com>	<4B5420A3.3080200@kernel.org> <20100118072523.2683cd59@linux.intel.com> <4B55038D.3070106@kernel.org> <4B550384.8030103@linux.intel.com>
In-Reply-To: <4B550384.8030103@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Jan 2010 07:56:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Arjan.

On 01/19/2010 09:57 AM, Arjan van de Ven wrote:
> there are two types:
> there's the domains, where you synchronize only within a domain,

Maps pretty nicely to a wq which is a queueing and flushing domain
after all.

> and then there's the "async string", think ACPI.  the ACPI init is a
> whole series of sort of dependent steps, where you synchronize about
> halfway, but the whole set runs async to all other inits in the
> system, and only near the very end when a full synchronization is
> done do you wait.  basically what you get (sorry, lame ascii graph)
> 
> ***************************************  (main init flow)
>    ***                driver 1
>    *  **            driver 2
>     *   **            driver 3
>     *     **            driver 4
>     *       **                  driver 5
> 
> where you get maximum concurrency during the pre-synchronization
> part, and a "chain" of synchronized execution *as part of the same
> function flow*, but possibly independent of other synchronization
> flows.

This too can be implemented using wq directly.  More below.

> the async infrastructure as you say took away the hassle of
> allocating, and more importantly, caring for the lifetime of the
> metadata object. But it also introduced a sychronization mechanism
> that is natural and simple for driver init and some other flows.

The tradeoff changes with the worker pool implementation can be shared
with workqueue which provides its own ways to control concurrency and
synchronize.  Before, the cookie based synchronization is something
inherent to the async mechanism.  The async worker pool was needed and
the synchronization mechanism came integrated with it.  Now that the
backend can be replaced with workqueue which supplies its own ways of
synchronization, the cookie based synchronization model needs stronger
justification as it no longer comes as a integral part of something
bigger which is needed anyway.

I'm sure the cookie based synchronization has its benefits but is the
benefit big enough, or is using workqueue synchronization constructs
difficult enough to justify a completely separate synchronization
model?

If so, we can leave the list based cookie synchronization alone and
simply use wq's to provide concurrency only without using its
synchronization mechanisms (flushes).

As for the current in-kernel users, the simplistic implementation
seems enough to me.  Do you think the stuff which is currently being
worked on would benefit a lot from cookie based synchronization
compared to using works and flushes directly?

Thanks.

-- 
tejun
