Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbZGYDiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbZGYDiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 23:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbZGYDiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 23:38:08 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:1767 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZGYDiH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 23:38:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rltPtnGR8feQH3KP8ilK6vuYzT5V7cKvWA3iHlPZJ1c60ZLRa9bgIWbmnnh2w2qBn/
         09cPAzigYKnCTxSkfB98FPVdq3VtDfFZScM6lI0w1CYiq889TM1aV9Km8LXAr+e75vJs
         54hQlANnYuo1RQ9spTJCH2+rEzc4pYBEEaBKA=
MIME-Version: 1.0
In-Reply-To: <1248419547-30261-1-git-send-email-dfeng@redhat.com>
References: <1248419547-30261-1-git-send-email-dfeng@redhat.com>
Date: Sat, 25 Jul 2009 11:38:07 +0800
Message-ID: <d82e647a0907242038l460c01b0ud51a7265f70d6c2e@mail.gmail.com>
Subject: Re: [PATCH] lib/kobject: put kobject if kobject_add_internal fails
From: Ming Lei <tom.leiming@gmail.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/24 Xiaotian Feng <dfeng@redhat.com>:
> The proper way to use kobject_init_and_add should be:
>
>        retval = kobject_init_and_add(&foo->kobj, &foo_ktype, NULL, "%s", name);
>        if (retval) {
>                kobject_put(&foo->kobj); (*)
>                return NULL;
>        }
>

Yes, you are correct.

> kobject_init_and_add calls kobject_add_vargs finally, kobject_add_vargs is divided
> into two parts: kobject_set_name_vargs and kobject_add_internal. Both the two parts
> may return an error. If the error is came from kobject_add_internal, this means
> kobject_set_name_vargs already alloc memory for kobj->name.
>
> So if caller forgets to use kobject_put when this kind of error occurs, the memory
> for kobj->name leaks. Unfortunately, most of the callers is forgotten to use
> kobject_put in this rare situation, grep kobject_init_and_add in kernel source code,
> there are 20+ files forgotten this. So I'd prefer to fix this in lib/kobject, not
> the whole 20+ files.

No, you should fix the 20+ files instead of lib/kobject. One rule should be:

             One who allocated kobject should free the kobject,
instead of others.

Image you have allocated a object, and call some .init function to
initialize it,
but .init frees the object due to some exception, it is very ugly and very prone
to access of the freed object.

Your patch may lead to much oops if the drivers use the proper way of
kobject_init_and_add:

        retval = kobject_init_and_add(&foo->kobj, &foo_ktype, NULL, "%s", name);
        if (retval) {
                kobject_put(&foo->kobj);      /*foo->kobj has been freed, oops*/
                return NULL;
        }

Right?

>
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> ---
>  lib/kobject.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/lib/kobject.c b/lib/kobject.c
> index b512b74..e6e6e03 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -200,6 +200,7 @@ static int kobject_add_internal(struct kobject *kobj)
>                        printk(KERN_ERR "%s failed for %s (%d)\n",
>                               __func__, kobject_name(kobj), error);
>                dump_stack();
> +               kobject_put(kobj);
>        } else
>                kobj->state_in_sysfs = 1;
>
> @@ -657,7 +658,6 @@ struct kobject *kobject_create_and_add(const char *name, struct kobject *parent)
>        if (retval) {
>                printk(KERN_WARNING "%s: kobject_add error: %d\n",
>                       __func__, retval);
> -               kobject_put(kobj);
>                kobj = NULL;
>        }
>        return kobj;

NAK.

-- 
Lei Ming
