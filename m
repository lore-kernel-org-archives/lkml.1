Return-Path: <linux-kernel-owner+w=401wt.eu-S1750788AbXB0Ed4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750788AbXB0Ed4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 23:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbXB0Ed4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 23:33:56 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:12896 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbXB0Edz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 23:33:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lp+WbhVKUSDJfk3MEj6/A9tZh54ELA//I7NYzXXPG3ZPlsvBDQU2QrlcD8s/aybAdTSxdwcoR60NmR4OXavvzCaKSZY9GdsnSApMViAXl6/7agpJaIhkU5UrwWfQWDHmqK8qww0HG1KsEiVPOklOCnGAIwu/jQpTUQ4yUVpFIDg=
Message-ID: <cc723f590702262033k4fa6cbe0n8e327b8339c7a0e4@mail.gmail.com>
Date: Tue, 27 Feb 2007 10:03:53 +0530
From: "Aneesh Kumar" <aneesh.kumar@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH 1/3] Freezer: Fix vfork problem
Cc: "Oleg Nesterov" <oleg@tv-sign.ru>, "Srivatsa Vaddagiri" <vatsa@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, "Andrew Morton" <akpm@osdl.org>,
       "Pavel Machek" <pavel@ucw.cz>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Gautham R Shenoy" <ego@in.ibm.com>
In-Reply-To: <200702270131.25656.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702261139.59130.rjw@sisk.pl> <200702261928.19274.rjw@sisk.pl>
	 <20070226212554.GA93@tv-sign.ru> <200702270131.25656.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>   * Only the _current_ task can read/write to tsk->flags, but other
> Index: linux-2.6.20-mm2/include/linux/freezer.h
> ===================================================================
> --- linux-2.6.20-mm2.orig/include/linux/freezer.h       2007-02-26 08:40:22.000000000 +0100
> +++ linux-2.6.20-mm2/include/linux/freezer.h    2007-02-27 00:51:44.000000000 +0100
> @@ -75,7 +75,32 @@ static inline int try_to_freeze(void)
>                 return 0;
>  }
>
> -extern void thaw_some_processes(int all);
> +/*
> + * Tell the freezer not to count current task as freezeable
> + */
> +static inline void freezer_do_not_count(void)
> +{
> +       current->flags |= PF_FREEZER_SKIP;
> +}
> +
> +/*
> + * Tell the freezer to count this task as freezeable again and if it's a user
> + * space one, try to freeze it
> + */
> +static inline void freezer_count(void)
> +{
> +       current->flags &= ~PF_FREEZER_SKIP;
> +       if (current->mm)
> +               try_to_freeze();
> +}
> +


This means that we are not going to wait for the kernel thread
(Parent) to freeze. I guess what vatsa suggested in previous mail is
better.

freeezer_do_not_count(void)
{
   if (current->mm) {

       current->flags |= PF_FREEZER_SKIP;
   }

}


freezer_count(void)
{
 if (current->mm) {
current->flags &= ~PF_FREEZER_SKIP;
try_to_freeze();
   }

}


Now if do_fork is called from kernel_thread with CLONE_VFORK we make
the freezer wait till that kernel thread is also frozen. I think this
is important.  with khelper thread it is okey because it is a single
threaded workqueue.

If do_fork is called via a user process we can skip the Parent if the
child got frozen before calling execve.

-aneesh
