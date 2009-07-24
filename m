Return-Path: <linux-kernel-owner+w=401wt.eu-S1752729AbZGXK5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbZGXK5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 06:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbZGXK5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 06:57:37 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:56191 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbZGXK5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 06:57:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=iWYWWASBtPfsHR8yT/Qm6spAltpiJduW6zbRk1nXne/tlUb42SlEs3D4NufF9l+Wnm
         IccSFG7v01pC7YlThM9PWnupRFGHeNbK/je6B9PNwJrILPi8osWO3b4gWk8WHCOCFXvR
         jNhU8hJ0ZDj/LkUqUUydedRd+FnJbNz4FkrEU=
MIME-Version: 1.0
Date: Fri, 24 Jul 2009 18:57:35 +0800
Message-ID: <454c71700907240357l61f5c4fajaca73db0fba7db8@mail.gmail.com>
Subject: report a bug about sched_rt
From: sen wang <wangsen.linux@gmail.com>
To: mingo@elte.hu, akpm@linux-foundation.org, kernel@kolivas.org,
       npiggin@suse.de, arjan@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I find something is wrong about sched_rt.

 when I am debugging my system with rt_bandwidth_enabled, there is a
running realtime FIFO task in the sched_rt running queue and
 the fair running queue is empty.  I found the idle task will be
scheduled up when the running task still lie in the  sched_rt running
queue!

this will happen when rt runqueue passed it's rt_bandwidth_enabled
runtime,then the scheduler choose the idle task instead of realtime
FIFO task.

the reason lie in: when scheduler try to pick up a realtime FIFO task,
it will check if rt_throttled is enabled,
if so, it'll return and try fair queue but it is empty, then it come
to the sched_idle class.

I don't think it reasonable, we should give the realtime FIFO task the
chance, even when rt runqueue passed it's runtime.
because it is cpu's free time.

To fix it ,and keep rt_bandwidth works as before, I think
pick_next_task_rt() is the best space,

the pick_next_task_rt should check another condiction: rq->cfs.nr_running.

So,I modify pick_next_task_rt() like this and debug it on my omap3430
zoom2 board, it works!


static struct task_struct *pick_next_task_rt(struct rq *rq)
{
	struct sched_rt_entity *rt_se;
	struct task_struct *p;
	struct rt_rq *rt_rq;

  ...

	if (rt_rq_throttled(rt_rq)&& rq->cfs.nr_running)
		return NULL;

  ...
}
