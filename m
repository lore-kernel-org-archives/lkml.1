Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbZGHPtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbZGHPtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 11:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673AbZGHPtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 11:49:11 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:56179 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457AbZGHPtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 11:49:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=QA87dA+emb4gHrTlHFqxqDOMSu1bzdFpEjxSEH17RoGN/CaDEtKoqfD8J+xu68w1oh
         fDZw91DK0cqxBYaVCbzoY7A6cjAfQaLZUOlm2vUW+fEnW45k1PvfqTrnwBMdyXnpsZVs
         mYYiSiYb2fRlbgsAkJAdDe3NfV8U3RiOqwmLI=
MIME-Version: 1.0
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Wed, 8 Jul 2009 17:48:49 +0200
Message-ID: <193b0f820907080848m5b72e2a9l52944ae3de785d90@mail.gmail.com>
Subject: possible migration bug with hotplug cpu
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was doing some analysis with the number of migrations in my application and
I think there's a bug in this accounting or even worse, in the migrations
mechanism when used together with cpu hotplug.

I turned off all CPUs except one using the hotplug mechanism, after what I
launghed my application that has 8 threads. Before they finish they print the
file /proc/<tid>/sched. I have only 1 online CPU and there are ~ 200
migrations per thread. The function set_task_cpu is responsible for updating
the migrations counter and is called by 9 other functions. With some tests I
discovered that 95% of these migrations come from try_to_wake_up and the other
5% from pull_task and __migrate_task.

Looking at try_to_wake_up:

...
	cpu = task_cpu(p);
	orig_cpu = cpu;
	this_cpu = smp_processor_id();

#ifdef CONFIG_SMP
	if (unlikely(task_running(rq, p)))
		goto out_activate;

	cpu = p->sched_class->select_task_rq(p, sync);  //<<<<===
	if (cpu != orig_cpu) {                          //<<<<===
		set_task_cpu(p, cpu);
...

p->sched_class->select_task_rq(p, sync)  is returning a different cpu of
task_cpu(p) even if I have only 1 online CPU. In my tests this behavior is
similar for rt and normal tasks. For RT, the only possible problem could be on
find_lowest_rq, but I'm still rying to find out why. Since you have more
experience with this code, if you could give it a look I'd appreciate.

Is there any obscure reason why this behavior could be right?

Lucas De Marchi
