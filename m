Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbZAZPhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbZAZPhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 10:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbZAZPhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 10:37:40 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59371 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbZAZPhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 10:37:40 -0500
Subject: Re: [RFC][PATCH 2/2] add a counter for writers spinning on a rwlock
From: Peter Zijlstra <peterz@infradead.org>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Mandeep Singh Baines <msb@google.com>
In-Reply-To: <c62985530901260725s2f36c6d8u1572775d790e7888@mail.gmail.com>
References: <497cd08f.0c11660a.33a7.ffffdf39@mx.google.com>
	 <1232977715.4863.81.camel@laptop>
	 <c62985530901260725s2f36c6d8u1572775d790e7888@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Jan 2009 16:37:28 +0100
Message-Id: <1232984248.4863.106.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-26 at 16:25 +0100, Frédéric Weisbecker wrote:
> 2009/1/26 Peter Zijlstra <peterz@infradead.org>:
> > On Sun, 2009-01-25 at 12:50 -0800, Frederic Weisbecker wrote:
> >> This patch adds a counter for writers that enter a rwlock slow path.
> >> For example it can be useful for slow background tasks which perform some jobs
> >> on the tasklist, such as the hung_task detector (kernel/hung_task.c).
> >>
> >> It adds a inc/dec pair on the slow path and 4 bytes for each rwlocks, so the overhead
> >> is not null.
> >>
> >> Only x86 is supported for now, writers_spinning_lock() will return 0 on other archs (which
> >> is perhaps not a good idea).
> >>
> >> Comments?
> >
> > _why_ ?
> 
> The hung task detector runs a periodic loop through the task_list, and
> currently it doesn't run
> over an arbitrary threshold of tasks to not hold the task_list lock
> for too long.
> 
> So we thought about a way to detect if there are some writers waiting
> for the lock, anf if so, release
> the lock, schedule and retry.

Ah, if it can do that, then it can also use RCU, no? Only users who
really have to hold off new tasks need the read-task_lock. The rest can
use RCU.

