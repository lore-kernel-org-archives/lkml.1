Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbYKNTAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbYKNTAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 14:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbYKNTAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 14:00:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbYKNTAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 14:00:03 -0500
Date: Fri, 14 Nov 2008 13:59:55 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: linux-kernel@vger.kernel.org
cc: mingo@elte.hu, rml@tech9.net, Alasdair G Kergon <agk@redhat.com>,
       Milan Broz <mbroz@redhat.com>
Subject: Active waiting with yield()
Message-ID: <Pine.LNX.4.64.0811141327100.22830@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Every time I write yield() somewhere into my code, there comes a comment 
"real-time people don't like yield()". Without any explanation why yield() 
is not suitable at that specific point, just that "people don't like it".

We all know that waiting with yield() is bad for general code that 
processes requests, because repeated scheduling wastes extra CPU time and 
the process waiting for some event with yield() is woken up late. In these 
normal cases, wait queues should be used.

However, there is code where in my opinion using yield() for waiting is 
appropriate, for example:

* driver unload --- check the count of outstanding requests and call 
yield() repeatedly until it goes to zero, then unload.
* some rare race contition --- a workaround for a race that triggers once 
per hour for one user in several years doesn't really have to be fast.

A typical example where yield() can be used is a driver that counts a 
number of outstanding requests --- when the user tries to unload the 
driver, the driver will make sure that new requests won't come, repeatedly 
yield()s until the count of requests reaches zero and then destroys its 
data structures.

Here, yield() has some advantages over wait queues, because:

* reduced size of data structures (and reduced cache footprint for the hot 
path that actually processes requests)
* slightly reduced code size even on the hot path (no need to wake up an 
empty queue)
* less possibility for bugs coming from the fact that someone forgets to 
wake the queue up

The downside of yield is slower unloading of the driver by few tens of 
miliseconds, but the user doesn't really care about fractions of a second 
when unloading drivers.

--- but people complain even if I use yield() in these cases. None of 
those complains contains any valid technical argument --- just that 
"someone said that yield() is bad". Is there a real reason why yield() in 
these cases is bad? (for example that with some real-time patches, 
yield()ing high-priority thread would be spinning forever, killing the 
system?) Or should I use msleep(1) instead? Or should wait queues really 
be used even in those performance-insensitive cases?

Mikulas
