Return-Path: <linux-kernel-owner+w=401wt.eu-S1757501AbYLEIag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbYLEIag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbYLEIa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:30:28 -0500
Received: from smtp-out.google.com ([216.239.45.13]:22949 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbYLEIa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:30:28 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=S0VrKuOOjs4CFzXgZCCL7+BFaj8QjmSxMVhigZnyD6ZqCCnUTo7HflxP1LHWbAyIi
	ndNEMqV5BEeXrBWXsCgZQ==
MIME-Version: 1.0
In-Reply-To: <4938DE1C.6070608@cn.fujitsu.com>
References: <b040c32a0812032048x4a11dc26k184a4b279b509050@mail.gmail.com>
	 <49376BE3.1040909@cn.fujitsu.com>
	 <6599ad830812041502m15f54f0ckd8baa0a1792fc31e@mail.gmail.com>
	 <b040c32a0812042344n75117b68x8de975d12dddf594@mail.gmail.com>
	 <4938DE1C.6070608@cn.fujitsu.com>
Date: Fri, 5 Dec 2008 00:30:23 -0800
Message-ID: <b040c32a0812050030uff5ae65o417c599a792c800c@mail.gmail.com>
Subject: Re: [patch] export percpu cpuacct cgroup stats
From: Ken Chen <kenchen@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2008 at 11:54 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> +             seq_printf(m, "%llu ", percpu);
>
> Should be:
> +               seq_printf(m, "%llu ", (unsigned long long)percpu);
>
> Otherwsise:
> kernel/sched.c: In function 'cpuacct_percpu_seq_read':
> kernel/sched.c:9359: warning: format '%llu' expects type 'long long unsigned int',
> but argument 3 has type 'u64'

huh, I was just wondering about the type case in cgroup_read_u64()
when I was looking at it earlier.  That explains it.  Diff patch
attached.

diff --git a/kernel/sched.c b/kernel/sched.c
index e32c094..055c54f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9356,7 +9356,7 @@ static int cpuacct_percpu_seq_read
 		spin_lock_irq(&cpu_rq(i)->lock);
 		percpu = *percpu_ptr(ca->cpuusage, i);
 		spin_unlock_irq(&cpu_rq(i)->lock);
-		seq_printf(m, "%llu ", percpu);
+		seq_printf(m, "%llu ", (unsigned long long) percpu);
 	}
 	seq_printf(m, "\n");
 	return 0;
