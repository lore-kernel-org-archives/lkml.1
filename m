Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbZGIMYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbZGIMYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 08:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756647AbZGIMYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 08:24:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40606 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999AbZGIMYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 08:24:31 -0400
Subject: Re: possible migration bug with hotplug cpu
From: Peter Zijlstra <peterz@infradead.org>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <193b0f820907090457s7a3662f4gcdecdc22fcae857b@mail.gmail.com>
References: <193b0f820907080848m5b72e2a9l52944ae3de785d90@mail.gmail.com>
	 <1247068556.9777.58.camel@twins>
	 <193b0f820907080905u643e90ddi42a719e6163b0bc@mail.gmail.com>
	 <193b0f820907080939sf0bec93n16ee4b5aca6e1a7a@mail.gmail.com>
	 <193b0f820907090457s7a3662f4gcdecdc22fcae857b@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 09 Jul 2009 14:24:26 +0200
Message-Id: <1247142266.9777.371.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-09 at 13:57 +0200, Lucas De Marchi wrote:
> So, I found the problem.
> 
> These fields are currently not initialized upon fork. I noted that when I
> updated to 2.6.31-rc2; commit 6c594c21fcb02c662f11c97be4d7d2b73060a205 was
> merged into kernel by Ingo (not present yet in 2.6.30), but it only initializes
> nr_migrations. Why the other fields are not initialized to 0? Even when there
> are more processors, these fields may be wrong if not zeroed when a new task
> is started. Below the fast way to fix it. This fixed the counters for me.

Ah, awesome. I hadn't had time to look in detail yet. Thanks!

> What do you think of creating a struct sched_statistics embedded into
> sched_entity so we coudl memset it to zero all at once? All fields of
> SCHED_STATS piece should be initialized, right?

Sounds like a sane plan.

One of the things I have wanted to do for a long time is to rename
sched_entity to sched_fair_entity, and do something like:

struct sched_entity {
	struct sched_common_entity       common;

	union {
		struct sched_fair_entity fair;
		struct sched_rt_entity   rt;
	};
};

I imagine we can add struct sched_statistics to the end of this as well.

The reason I haven't come around to doing this is that it takes a bit of
time to refactor the code and find all the common bits. So its been on
my todo list like forever.

Can I persuade you to look at this? :-)

I'll queue the below, can I add:

Signed-off-by: Lucas De Marchi <lucas.de.marchi@gmail.com>

?

