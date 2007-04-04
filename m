Return-Path: <linux-kernel-owner+w=401wt.eu-S1751149AbXDDVvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751149AbXDDVvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbXDDVvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:51:05 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:38733 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbXDDVvD (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:51:03 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Maxim Uvarov <muvarov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Performance Stats: Kernel patch
In-Reply-To: Your message of "Wed, 04 Apr 2007 17:15:43 +0400."
             <4613A4FF.9030202@ru.mvista.com>
From: Valdis.Kletnieks@vt.edu
References: <46124E93.2000408@ru.mvista.com> <16797.1175641303@turing-police.cc.vt.edu>
            <4613A4FF.9030202@ru.mvista.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1175723450_4061P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Apr 2007 17:50:50 -0400
Message-ID: <6099.1175723450@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1175723450_4061P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <6093.1175723450.1@turing-police.cc.vt.edu>

On Wed, 04 Apr 2007 17:15:43 +0400, Maxim Uvarov said:

> New version of this patch. Please flay it.
> 
> 
> Signed-off-by: Max Uvarov <muvarov@ru.mvista.com>

> Index: linux-2.6.18/fs/proc/array.c
> ===================================================================
> --- linux-2.6.18.orig/fs/proc/array.c
> +++ linux-2.6.18/fs/proc/array.c
> @@ -295,6 +295,20 @@ static inline char *task_cap(struct task
>                             cap_t(p->cap_effective));
>  }
> 
> +#ifdef CONFIG_THREAD_PERF_STAT
> +static inline char *task_perf(struct task_struct *p, char *buffer)
> +{
> +#ifdef THREAD_PERF_STAT_SYSC

Missed the CONFIG_ here.

> +       return buffer + sprintf(buffer, "Nvcsw:\t%lu\n"
> +                           "Nivcsw:\t%lu\n",
> +                           cap_t(p->nvcsw),
> +                           cap_t(p->nivcsw));

cap_t()??!?  That's from include/linux/capability.h, and looks something like:

#ifdef STRICT_CAP_T_TYPECHECKS
#define cap_t(x) (x).cap
#else
#define cap_t(x) (x)
#endif

and you're probably picking up the second part, making it a no-op.  And if you
ever hit the first part of that ifdef, you'll throw a compile error.

Somebody else can comment on the use of #ifdef - we tend to frown on it inside
open C code, but I'm not seeing a really brilliant way to avoid them entirely
(the 'static inline task_perf' can probably move to a .h, but it's hard to
find a clean way to avoid the ifdefs given that we have Kconfig variables
to select it. array.c already has a CONFIG_S390 in it, anyhow. :)

There's a mostly-hypothetical race between inc_syscall() and the places that
increment the context switch counters, and where we read the values - but at
worst, we'll output a stale off-by-one-ish value.  Certainly not worth
grabbing a lock on the task struct for *this* usage, but the sort of thing you
want to keep in mind as you write other code.

Other random comments:

1) You probably want to rebase against something more recent (2.6.21-rc<mumble>
or the final .21 when it's released).

2) It arrived here with some line-wrapping damage, most likely to the fact
that you posted it with Thunderbird.  There's a mystic Thunderbird incantation
to make it not do that, but I have no idea what it is - it's in the list
archives someplace.

--==_Exmh_1175723450_4061P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGFB26cC3lWbTT17ARApq2AKCIFVxygpQBkRF5dzBA9q56u1wArwCglOUs
Zn6OWAd4vM6fEcZwJ+2Uorw=
=yTX6
-----END PGP SIGNATURE-----

--==_Exmh_1175723450_4061P--
