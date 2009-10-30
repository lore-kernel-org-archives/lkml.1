Return-Path: <linux-kernel-owner+w=401wt.eu-S932650AbZJ3QvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650AbZJ3QvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 12:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932601AbZJ3QvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 12:51:16 -0400
Received: from aglcosbs02.cos.agilent.com ([192.25.218.39]:41155 "EHLO
	aglcosbs02.cos.agilent.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932578AbZJ3QvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 12:51:16 -0400
Message-ID: <4AEB1981.7040907@agilent.com>
Date: Fri, 30 Oct 2009 09:51:13 -0700
From: Earl Chew <earl_chew@agilent.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Tempering cascade rate when using higher frequency jiffy clocks
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Oct 2009 16:51:16.0530 (UTC) FILETIME=[326F7920:01CA5981]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been experimenting a higher frequency jiffy clock (10kHz)
in the spirit of:

http://courses.cs.vt.edu/~cs5204/fall05-gback/papers/p172-etsion.pdf

This is mostly motivated by a wish increase thread delay resolution
by increasing the frequency at which the scheduler gets a chance
to switch threads.

Ingo wrote a much cited description of the timer wheel:

http://lkml.org/lkml/2005/10/19/46

which provides a clear description of the operation of the wheel.

One thing that struck me was the number of wheel buckets (root
plus four more) is independent of the clock frequency.
The kernel allows several clock frequencies to be selected
ranging from 60Hz to 1kHz, but in all cases the same
five buckets are available.

Unless CONFIG_BASE_SMALL is selected, the bucket sizes are
1 x 256 entries, and 4 x 64 entries with 512 entries in total.

This means that at 60Hz, the timer wheel cascade operation must
be performed every 256 / 60 = 4266 ms, while at 1kHz the operation
must be performed every 256 / 1000 = 256 ms. A 10kHz clock
means the operation is performed 256 / 10000 = 25.6 ms.

Does it make sense to trade memory (ie bigger buckets) for
resolution?

In our case, its not that we have more timers, or that the timers
are any longer or shorter necessarily.

Given that, it seems to me that it doesn't make a lot of sense
to cascade buckets any more frequently than before.

So with a 10kHz jiffy clock, I'm think a 1 x 2048 + 4 x 32 = 2176
configuration might be quite attractive. In this configuration
the cascade operation is performed every 2048 / 10000 = 204.8 ms
which is quiet similar to the default configuration with a 1kHz clock.

Are there other considerations?

Earl


