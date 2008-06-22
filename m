Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbYFVQ3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbYFVQ3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 12:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbYFVQ3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 12:29:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:54113 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbYFVQ3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 12:29:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=d+JZWZFUjeUZWOh0OQbnlogsO8BRcM59HV1DZePbp/iL71cV3Muto5o8P33p2hAHkC
         fKlkULe2gtCsxeQgtnN4xjR/LJH4hZj2E7Kf4gIhrd4yNy/e5EeeOeYfqoBE0X45B76Y
         8N3LAipHcquyyj6JmcOnxg6+9ezlbUQzca96E=
Message-ID: <19f34abd0806220929y1ca9d0c4nbf480473b7ce018a@mail.gmail.com>
Date: Sun, 22 Jun 2008 18:29:07 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: v2.6.26-rc7: BUG: unable to handle kernel NULL pointer dereference
Cc: "Rusty Russell" <rusty@rustcorp.com.au>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>, "Mike Travis" <travis@sgi.com>,
       linux-kernel@vger.kernel.org, "Gautham R Shenoy" <ego@in.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>
In-Reply-To: <20080622155627.GA20122@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080622125633.GA8166@damson.getinternet.no>
	 <19f34abd0806220747q5ac41afcg53979f0d98a95d3c@mail.gmail.com>
	 <19f34abd0806220754l230a09d7xd59835cc3e091b94@mail.gmail.com>
	 <20080622155627.GA20122@cs181140183.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 5:56 PM, Adrian Bunk <bunk@kernel.org> wrote:
>> commit e37d05dad7ff9744efd8ea95a70d389e9a65a6fc
>> Author: Mike Travis <travis@sgi.com>
>> Date:   Thu May 1 04:35:16 2008 -0700
>>
>>     cpu: change cpu_sys_devices from array to per_cpu variable
>>
>>     Change cpu_sys_devices from array to per_cpu variable in drivers/base/cpu.c.
>>...
>
> Can you confirm whether this is definitely the cause or not?
>
> E.g. if it is and 2.6.25 works fine it might qualify as a 2.6.26-rc
> regression.

Hm, no. Each time I run this test, I get a different error (has been
NULL pointer, stuck CPU, circular locking dependency, ...) :-D

But if you look at the patch, I KNOW that this function is the one
that returns NULL, and it does so because the check is now stricter
than before. The hunk was:

-       if (cpu < NR_CPUS)
-               return cpu_sys_devices[cpu];
+       if (cpu < nr_cpu_ids && cpu_possible(cpu))
+               return per_cpu(cpu_sys_devices, cpu);
        else
                return NULL;

And the (cpu < nr_cpu_ids) fails because the CPU has just been
offlined (or failed to initialize, but it's the same thing), while
NR_CPUS is the value that was compiled in as CONFIG_NR_CPUS (so the
former check will always be true).

I don't think it is valid to ask for a per_cpu() variable on a CPU
which does not exist, though, so I don't know what the right fix would
be. A straight revert would be possible, but probably not desirable.
I'm so definitely not an expert in this area, but this "fix" _looks_
correct to me:

diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index fdf4044..3bd95fd 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -143,14 +143,10 @@ static int __cpuinit topology_cpu_callback(struct notifier
        int rc = 0;

        switch (action) {
-       case CPU_UP_PREPARE:
-       case CPU_UP_PREPARE_FROZEN:
+       case CPU_ONLINE:
                rc = topology_add_dev(cpu);
                break;
-       case CPU_UP_CANCELED:
-       case CPU_UP_CANCELED_FROZEN:
-       case CPU_DEAD:
-       case CPU_DEAD_FROZEN:
+       case CPU_DOWN_PREPARE:
                topology_remove_dev(cpu);
                break;
        }

I'm sorry, I can't really say whether it's a regression or not. But
I'd bet it is.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
