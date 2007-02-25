Return-Path: <linux-kernel-owner+w=401wt.eu-S964915AbXBYOdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964915AbXBYOdL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 09:33:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964917AbXBYOdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 09:33:10 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:16775 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964915AbXBYOdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 09:33:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=k/0oF9OWMAAsOLq6RVWd1/ZcskMtdSNC0pLP1UbvfANssczlvkqFPYvKW3gczkt0UXPVbNuJFdN/RcAJWvqgG+xyJBVXMoGieS7iytJI5/HsjlKXs8h8k9PQz93te1sdyg7UmHbUWsreVs/ckJxfIqthsRQ3VXoRpOHmOiTSlmM=
Message-ID: <cc723f590702250633i27a79a9tedd5fe670cd9e4ed@mail.gmail.com>
Date: Sun, 25 Feb 2007 20:03:07 +0530
From: "Aneesh Kumar" <aneesh.kumar@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH 4/7] Freezer: Fix vfork problem
Cc: "Pavel Machek" <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com, ego@in.ibm.com, akpm@osdl.org,
       mingo@elte.hu, vatsa@in.ibm.com, dipankar@in.ibm.com,
       venkatesh.pallipadi@intel.com
In-Reply-To: <200702251359.53411.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702231116.23607.rjw@sisk.pl> <20070225104612.GM2045@elf.ucw.cz>
	 <200702251145.39595.rjw@sisk.pl> <200702251359.53411.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/25/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, 25 February 2007 11:45, Rafael J. Wysocki wrote:
> > Hi,
> >
> > =========
> --- linux-2.6.20-mm2.orig/kernel/power/process.c        2007-02-22 23:44:04.000000000 +0100
> +++ linux-2.6.20-mm2/kernel/power/process.c     2007-02-23 22:33:11.000000000 +0100
> @@ -127,22 +127,12 @@ static unsigned int try_to_freeze_tasks(
>                                 cancel_freezing(p);
>                                 continue;
>                         }
> -                       if (is_user_space(p)) {
> -                               if (!freeze_user_space)
> -                                       continue;
> -
> -                               /* Freeze the task unless there is a vfork
> -                                * completion pending
> -                                */
> -                               if (!p->vfork_done)
> -                                       freeze_process(p);
> -                       } else {
> -                               if (freeze_user_space)
> -                                       continue;
> +                       if (is_user_space(p) == !freeze_user_space)
> +                               continue;
>

How about ?
if ( ! (is_user_space(p) == freeze_user_space) )
     continue;


BTW one of the concern that vatsa had was; is it ok to allow some of
the tasks to be left running  ( the parent from vfork ) while
freezing.  I guess we can solve this in a nice way.

in fork.c

if (clone_flags & CLONE_VFORK) {
                        p->vfork_done = &vfork;
                        p->flags |= PF_PARENT_WAKEUP_ON_FREEZE;
                        init_completion(&vfork);
}


and in freeze_process(struct task_struct *p)

if ( p->flags & PF_PARENT_WAKEUP_ON_FREEZE ) {
  wake_up_parent();
}

now parent should be wating for these completion via

wait_for_completion_freezable(); // pavel's implementation.

-aneesh
