Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab0BAMUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 07:20:38 -0500
Received: from smtp-out.google.com ([216.239.44.51]:35444 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab0BAMUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 07:20:37 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=qpd+kcjUqMnSH6BX42Nc1KkFK4PUkgVLunaHw0tQ3bxevCu/xzRoUg5nbPa9xRTuC
	PJlWnR03Huyv5cWkhCAPQ==
MIME-Version: 1.0
Date: Mon, 1 Feb 2010 13:20:34 +0100
Message-ID: <bd4cb8901002010420o2ea7dbafnba84f78b6a2f38f5@mail.gmail.com>
Subject: [BUG] perf_events: ctx_flexible_sched_in()
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I believe there is something wrong with ctx_flexible_sched_in().

The function does not allow maximizing PMU usage because of
the way can_add_hw is managed. Basically, as soon as a group
fail to be scheduled in, then no other group can. I believe this
is not optimum. You need to skip the group that fails and keep
scanning the list. There may be other groups which can be
scheduled.

Here is an example to illustrate the issue:
$ task -ebaclears,div,instructions_retired,fp_assist  noploop 5
noploop for 5 seconds
                908 baclears (scaled from 74.97% of time)
                   0 div (scaled from 50.01% of time)
  11328128990 instructions_retired (scaled from 74.99% of time)
                   0 fp_assist (scaled from 50.00% of time)

Here div, fp_assist can only go on counter 1. There is no explicit
grouping. On Intel Core, you have 2 generic, 3 fixed counters.
Instruction_retired can go on a fixed counter. Thus, I was
expecting baclears and instructions_retired to always be scheduled.
The other two would alternate at 50% each. While you get the latter
behavior, you are not getting full utilization for the other two.

Once I modify ctx_flexible_sched_in():
$ ./task -ebaclears,div,instructions_retired,fp_assist  noploop 5
noploop for 5 seconds
               658 baclears
                   0 div (scaled from 50.01% of time)
 11726844342 instructions_retired
                   0 fp_assist (scaled from 50.00% of time)

I get the right result. Thus, I think, we need to drop can_add_hw
from ctx_flexible_sched_in().

Am I missing something in the role of can_add_hw?

If not, then I I will provide a patch to get the optimum behavior.
