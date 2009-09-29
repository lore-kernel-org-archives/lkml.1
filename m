Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbZI2SPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbZI2SPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 14:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbZI2SPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 14:15:35 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:35399 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbZI2SPe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 14:15:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iJq/QuGfQg2JcJujlI56Ryzv68G24oWj4w78UCWQmocZCs5hlPEN6WzUgdOYJ/g+Ie
         PFkR7nrJl1Q5rNMN5JeMkzaNrpW0yvznpzcPfpS1A2TWptjc1unJmk8s518q5EBvn4YE
         YsbqJFDbvD5tGD6+FP9zV8ijA0xKuf/k+kaLc=
MIME-Version: 1.0
In-Reply-To: <1253712627.5631.478.camel@Palantir>
References: <1253615424.20345.76.camel@Palantir>
	 <63386a3d0909230533o7ab835ecubc8d074fea97642f@mail.gmail.com>
	 <1253712627.5631.478.camel@Palantir>
Date: Tue, 29 Sep 2009 20:15:37 +0200
Message-ID: <25e057c00909291115t63c36ddm657f9359d1ae34f4@mail.gmail.com>
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: roel kluin <roel.kluin@gmail.com>
To: Raistlin <raistlin@linux.it>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, claudio@evidence.eu.com,
       michael@evidence.eu.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static int __sched_setscheduler(struct task_struct *p, int policy,
> -                               struct sched_param *param, bool user)
> +                               struct sched_param *param,
> +                               struct sched_param_ex *param_ex,
> +                               bool user)
...

> @@ -6200,6 +6364,13 @@ recheck:
>            (p->mm && param->sched_priority > MAX_USER_RT_PRIO-1) ||
>            (!p->mm && param->sched_priority > MAX_RT_PRIO-1))
>                return -EINVAL;
> +       if (edf_policy(policy) && param_ex->sched_priority != 0)
> +               return -EINVAL;
> +       if (edf_policy(policy) && (param_ex == NULL ||
> +           timespec_to_ns(&param_ex->sched_period) == 0 ||
> +           timespec_to_ns(&param_ex->sched_period) <
> +           timespec_to_ns(&param_ex->sched_runtime)))
> +               return -EINVAL;

shouldn't the NULL test be moved upwards, to prevent a dereference of
a NULL pointer? Also I notice that `timespec_to_ns(&param_ex->sched_period)'
is called twice, maybe gcc does this but can't we do something like

        if (edf_policy(policy)) {
                if (param_ex == NULL || param_ex->sched_priority != 0)
                        return -EINVAL;
                s64 psp = timespec_to_ns(&param_ex->sched_period);
                if (psp == 0 || psp < timespec_to_ns(&param_ex->sched_runtime))
                        return -EINVAL;
        }

Roel
