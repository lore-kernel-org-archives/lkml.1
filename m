Return-Path: <linux-kernel-owner+w=401wt.eu-S1751531AbZIWMdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbZIWMdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbZIWMdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:33:51 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:33014 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbZIWMdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:33:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=T5PkvNrsu7G+cO9+ChGLIB/5nwjSIAMQOdWnJtK79rYnWx2U7MH6SiUdOONf2ltBFA
         Tp5ADKUXR59ffrFvGD6tKtp4+v80pAoZCO2Iof/H2gUVaiTTzdSdy58N2kAblJAJOygf
         dHOiMkGJ4YQ2BD//uBVKqwtiWa0thkf6LpyMo=
MIME-Version: 1.0
In-Reply-To: <1253615424.20345.76.camel@Palantir>
References: <1253615424.20345.76.camel@Palantir>
Date: Wed, 23 Sep 2009 14:33:53 +0200
Message-ID: <63386a3d0909230533o7ab835ecubc8d074fea97642f@mail.gmail.com>
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Raistlin <raistlin@linux.it>
Cc: Peter Zijlstra <peterz@infradead.org>, claudio@evidence.eu.com,
       michael@evidence.eu.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Raistlin,

I have trouble compiling the (mainline) kernel for ARM u300_defconfig with the
sched-edf patches:

In file included from /home/linus/src/linux-trees/linux-2.6/kernel/sched.c:1856:
/home/linus/src/linux-trees/linux-2.6/kernel/sched_edf.c: In function
'pick_next_task_edf':
/home/linus/src/linux-trees/linux-2.6/kernel/sched_edf.c:435: error:
implicit declaration of function 'hrtick_enabled'

The hrtick_enabled() function is a static in sched.c, and should be visible
in sched_edf.c since it's #include:ed into sched.c so I'm pretty confused
about this one.

Could it be that I'm using a too bleeding edge compiler? This is a
arm-none-eabi-gcc (Sourcery G++ Lite 2008q3-66) 4.3.2
i.e. a CodeSourcery custom compiler, what are you using for ARM builds
in Pisa?

/home/linus/src/linux-trees/linux-2.6/kernel/sched.c: In function
'__setscheduler_ex':
/home/linus/src/linux-trees/linux-2.6/kernel/sched.c:6318: error:
'struct sched_edf_entity' has no member named 'bw'
/home/linus/src/linux-trees/linux-2.6/kernel/sched.c:6318: error:
implicit declaration of function 'to_ratio'

This is another thing: the code in struct sched_edf_entity only compiles
in the field bw if you have CONFIG_EDF_GROUP_SCHED, but the
code in sched.c __setscheduler_ex() use it no matter whether that's
configured or not.

This patch fixes it.

diff --git a/kernel/sched.c b/kernel/sched.c
index b41fc65..9ce89d4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6315,8 +6315,10 @@ __setscheduler_ex(struct rq *rq, struct
task_struct *p, int policy,

        edf_se->runtime_max = timespec_to_ns(&param_ex->sched_runtime);
        edf_se->period = timespec_to_ns(&param_ex->sched_period);
+#ifdef CONFIG_EDF_GROUP_SCHED
        edf_se->bw = to_ratio(timespec_to_ns(&param_ex->sched_period),
                              timespec_to_ns(&param_ex->sched_runtime));
+#endif

        edf_se->runtime = edf_se->runtime_max;

Yours,
Linus Walleij
