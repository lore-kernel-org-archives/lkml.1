Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbYJ0Kc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbYJ0Kc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 06:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbYJ0Kcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 06:32:51 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:21032 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbYJ0Kcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 06:32:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wofcHNLlMqtHvG8DGc+synR0cadUf1ZJ2eYxtPdNRB91X3evrkcc8wxoq1NpclsCah
         9l6hbANSqRGzvg/EI4KS68lxBHsyQ3wJIkaZY2aaXKUmmmAyna1KQcyduBdmufSLuz5u
         7mFREfaCRGA0J0Hj0gvOewFjpWrOjac/KnwcY=
Message-ID: <4f3ee3290810270332p56e1f99q24a5eea818e626ee@mail.gmail.com>
Date: Mon, 27 Oct 2008 11:32:46 +0100
From: cboulte@gmail.com
To: Nadia.Derbey@bull.net
Subject: Re: [PATCH 1/1] (v3) SYSVIPC - Fix the ipc structures initialization
Cc: akpm@linux-foundation.org, manfred@colorfullife.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081027072836.438113395@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081027072826.266777838@bull.net>
	 <20081027072836.438113395@bull.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 8:28 AM,  <Nadia.Derbey@bull.net> wrote:
>
> This patch is a fix for Bugzilla bug
> http://bugzilla.kernel.org/show_bug.cgi?id=11796.
>
> To summarize, a simple testcase is concurrently running an infinite loop on
> msgctl(IPC_STAT) and a call to msgget():
>
> while (1)
>   msgctl(id, IPC_STAT)    1
>                           |
>                           |
>                           |
>                           2 id = msgget(key, IPC_CREAT)
>                           |
>                           |
>                           |
>
> In the interval [1-2], the id doesn't exist yet.
>
> In that test, the problem is the following:
> When we are calling ipc_addid() from msgget() the msq structure is not
> completely initialized. So idr_get_new() is inserting a pointer into the
> idr tree, and the structure which is pointed to has, among other fields,
> its lock uninitialized.
>
> Since msgctl(IPC_STAT) is looping while (1), idr_find() returns the
> pointer as soon as it is inserted into the IDR tree. And ipc_lock()
> calls spin_lock(&mqs->lock), while we have not initialized that lock
> yet.
>
> This patch moves the spin_lock_init() before the call to ipc_addid().
> It also sets the "deleted" flag to 1 in the window between msg structure
> allocation and msg structure locking in ipc_addid().
>
>
> Regards,
> Nadia
>
>
> Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
>
> ---
>  ipc/util.c |   16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> Index: linux-2.6.27/ipc/util.c
> ===================================================================
> --- linux-2.6.27.orig/ipc/util.c        2008-10-23 15:20:46.000000000 +0200
> +++ linux-2.6.27/ipc/util.c     2008-10-24 17:48:33.000000000 +0200
> @@ -266,6 +266,17 @@ int ipc_addid(struct ipc_ids* ids, struc
>        if (ids->in_use >= size)
>                return -ENOSPC;
>
> +       spin_lock_init(&new->lock);
> +
> +       /*
> +        * We have a window between the time new is inserted into the idr
> +        * tree and the time it is actually locked.
> +        * In order to be safe during that window set the new ipc structure
> +        * as deleted: a concurrent ipc_lock() will see it as not present
> +        * until the initialization phase is complete.
> +        */
> +       new->deleted = 1;
> +
>        err = idr_get_new(&ids->ipcs_idr, new, &id);
>        if (err)
>                return err;
> @@ -280,10 +291,11 @@ int ipc_addid(struct ipc_ids* ids, struc
>                ids->seq = 0;
>
>        new->id = ipc_buildid(id, new->seq);
> -       spin_lock_init(&new->lock);
> -       new->deleted = 0;
>        rcu_read_lock();
>        spin_lock(&new->lock);
> +
> +       new->deleted = 0;
> +
>        return id;
>  }
>
>
> --
>

Still got the lock... I'm using a 4 cpus node: Intel Xeon @ 2.8GHz...
don't know if it has an impact.
The only way I found to have no lock, it's to spin_lock the ipc
_before_ inserting it into the idr.

Best regards, c.
