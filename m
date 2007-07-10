Return-Path: <linux-kernel-owner+w=401wt.eu-S1761385AbXGJApK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385AbXGJApK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 20:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756608AbXGJAo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 20:44:59 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:54870 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbXGJAo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 20:44:58 -0400
Date: Mon, 9 Jul 2007 17:47:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Herbert van den Bergh <Herbert.van.den.Bergh@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, Dave McCracken <dave.mccracken@oracle.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] do not limit locked memory when RLIMIT_MEMLOCK is
 RLIM_INFINITY
Message-Id: <20070709174745.34668a90.randy.dunlap@oracle.com>
In-Reply-To: <4692D230.3050403@oracle.com>
References: <4692D230.3050403@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jul 2007 17:26:24 -0700 Herbert van den Bergh wrote:

> 
> This patch fixes a bug in mm/mlock.c on 32-bit architectures that prevents
> a user from locking more than 4GB of shared memory, or allocating more
> than 4GB of shared memory in hugepages, when rlim[RLIMIT_MEMLOCK] is
> set to RLIM_INFINITY.

Something has converted tabs to spaces in your patch.
Ah, thunderbird.  Did you use an external editor plugin?

If not, did you use preformat and other instructions from
http://mbligh.org/linuxdocs/Email/Clients/Thunderbird ?

Please send a patch to yourself and make sure that you can apply
the received patch cleanly.

> Signed-off-by: Herbert van den Bergh <herbert.van.den.bergh@oracle.com>
> Acked-by: Chris Mason <chris.mason@oracle.com>
> 
> --- linux-2.6.22/mm/mlock.c.orig    2007-07-09 10:19:31.000000000 -0700
> +++ linux-2.6.22/mm/mlock.c    2007-07-09 10:19:19.000000000 -0700
> @@ -244,9 +244,12 @@ int user_shm_lock(size_t size, struct us
>  
>      locked = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
>      lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
> +    if (lock_limit == RLIM_INFINITY)
> +        allowed = 1;
>      lock_limit >>= PAGE_SHIFT;
>      spin_lock(&shmlock_user_lock);
> -    if (locked + user->locked_shm > lock_limit && !capable(CAP_IPC_LOCK))
> +    if (!allowed &&
> +        locked + user->locked_shm > lock_limit && !capable(CAP_IPC_LOCK))
>          goto out;
>      get_uid(user);
>      user->locked_shm += locked;

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
