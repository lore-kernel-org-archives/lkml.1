Return-Path: <linux-kernel-owner+w=401wt.eu-S1759215AbZAOAyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215AbZAOAyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 19:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754733AbZAOAy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 19:54:27 -0500
Received: from ozlabs.org ([203.10.76.45]:52809 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575AbZAOAy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 19:54:27 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.29-rc1 does not boot
Date: Thu, 15 Jan 2009 11:24:21 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Mike Travis <travis@sgi.com>, Dieter Ries <clip2@gmx.de>,
       linux-kernel@vger.kernel.org
References: <496A085E.8020604@gmx.de> <496A4228.5090807@sgi.com> <20090112100053.GA7905@elte.hu>
In-Reply-To: <20090112100053.GA7905@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901151124.22442.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 January 2009 20:30:53 Ingo Molnar wrote:
> work_on_cpu() seems 
> completely unsuited for any sort of set_cpus_allowed() replacement ...

That's harsh.  set_cpus_allowed is *always* questionable in these cases.  Sometimes it's harmless, and sometimes there was a risk that we could run on the wrong cpu.

The mistake was that work_on_cpu() should rely on the caller to ensure the CPU doesn't go away.  It's a worse interface, but this reduces the number of *new* bugs, at least.

Subject: cpumask: don't try to get_online_cpus() in work_on_cpu.

This has caused more problems than it solved, with a pile of cpu
hotplug locking issues.

Followup patches will get_online_cpus() in callers that need it, but
if they don't do it they're no worse than before when they were using
set_cpus_allowed without locking.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -991,8 +991,7 @@ static void do_work_for_cpu(struct work_
  * @fn: the function to run
  * @arg: the function arg
  *
- * This will return -EINVAL in the cpu is not online, or the return value
- * of @fn otherwise.
+ * It is up to the caller to ensure that the cpu doesn't go offline.
  */
 long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 {
@@ -1001,14 +1000,12 @@ long work_on_cpu(unsigned int cpu, long 
 	INIT_WORK(&wfc.work, do_work_for_cpu);
 	wfc.fn = fn;
 	wfc.arg = arg;
-	get_online_cpus();
 	if (unlikely(!cpu_online(cpu)))
 		wfc.ret = -EINVAL;
 	else {
 		schedule_work_on(cpu, &wfc.work);
 		flush_work(&wfc.work);
 	}
-	put_online_cpus();
 
 	return wfc.ret;
 }
