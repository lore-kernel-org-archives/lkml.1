Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbXLIRRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbXLIRRP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 12:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbXLIRQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 12:16:59 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:3142 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbXLIRQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 12:16:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jbKs84QS7znMI7BGKAFVkIJ2e3n6RJoERPnOznsEOJTNUTbKQ7n18UfMLl2wswa/tLEdm6H1eGgGZLfLAfO9tRwRX8gPSqesv3WBW3qECbIc1YpGlXsFKuNyQLRyg95Df4nLzz54DVexjSnqxSJmJJw9Ki1xyqX9AkjcWnakbJc=
Message-ID: <b647ffbd0712090916l4eb9a944r4726680a5fdcae46@mail.gmail.com>
Date: Sun, 9 Dec 2007 18:16:52 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Steven Rostedt" <srostedt@redhat.com>
Subject: RT Load balance changes in sched-devel
Cc: "Gregory Haskins" <ghaskins@novell.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Balbir Singh" <balbir@in.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, vatsa@linux.vnet.ibm.com,
       "LKML Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <4756D709.1020901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071130145939.GN5681@linux.vnet.ibm.com>
	 <b647ffbd0712011156p252ae29dnfa75494e4d2c845c@mail.gmail.com>
	 <20071203182223.GA4133@linux.vnet.ibm.com>
	 <47556B23.2060909@redhat.com>
	 <20071204153542.GC3388@linux.vnet.ibm.com>
	 <b647ffbd0712040828l51a26a82jc0f38d3f4aa2291e@mail.gmail.com>
	 <20071205134036.GA21933@linux.vnet.ibm.com>
	 <4756B8E9.3080709@redhat.com>
	 <20071205164800.GA24767@linux.vnet.ibm.com>
	 <4756D709.1020901@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ cc'ed lkml ]

I guess, one possible load-balancing point is out of consideration --
sched_setscheduler()
(also rt_mutex_setprio()).

(1)  NORMAL --> RT, when p->se.on_rq == 1 && ! task_running(rq, p)

(2) RT --> NORMAL, when task_running(rq, p) == 1

e.g. for (2) we may even get a completely idle rq (schedule() -->
schedule_balance_rt() will not help due to schedule_balance_rt()
having a rt_task(prev) check in place... and 'prev' is of NORMAL type
when it's scheduled out).


btw., both cases would be addressed by placing load-balance points
into sched_class_rt->{enqueue,dequeue}_task_rt()... push_rt_tasks()
and pull_rt_tasks() respectively. As a side effect (I think,
technically, it would be possible), 3 out of 4 *_balance_rt() calls
(the exception: schedule_tail_balance_rt()) in schedule() would become
unnecessary.

_BUT_

the enqueue/dequeue() interface would become less straightforward,
logically-wise.
Something like:

rq = activate_task(rq, ...) ; /* may unlock rq and lock/return another one */

would complicate the existing use cases.


-- 
Best regards,
Dmitry Adamushko
