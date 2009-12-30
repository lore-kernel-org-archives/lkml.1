Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbZL3X5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbZL3X5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 18:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbZL3X5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 18:57:44 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:60184 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbZL3X5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 18:57:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jiri Slaby <jslaby@novell.com>
Subject: Re: [PATCH 15/16] COMPAT: add get/put_compat_rlimit
Date: Thu, 31 Dec 2009 00:55:37 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: jirislaby@gmail.com, mingo@elte.hu, nhorman@tuxdriver.com,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, torvalds@linux-foundation.org,
       James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
References: <4B040A03.2020508@gmail.com> <1258555922-2064-15-git-send-email-jslaby@novell.com>
In-Reply-To: <1258555922-2064-15-git-send-email-jslaby@novell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912310055.37707.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/dGp8jjiJKGnM/Pxz8FFiBjPexDIs9jOeGPYI
 Eym3fxXA7mxSBbgWjBHkzJ2H4Fe42rjFMtPUUPDWEALBD9STW7
 g1+2TF5Lqbj6BfXXcT9Gg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 November 2009, Jiri Slaby wrote:
> @@ -284,17 +317,12 @@ asmlinkage long compat_sys_setrlimit(unsigned int resource,
>         if (resource >= RLIM_NLIMITS)
>                 return -EINVAL;
>  
> -       if (!access_ok(VERIFY_READ, rlim, sizeof(*rlim)) ||
> -           __get_user(r.rlim_cur, &rlim->rlim_cur) ||
> -           __get_user(r.rlim_max, &rlim->rlim_max))
> -               return -EFAULT;
> +       ret = get_compat_rlimit(&r, rlim);
> +       if (ret)
> +               return ret;
>  
> -       if (r.rlim_cur == COMPAT_RLIM_INFINITY)
> -               r.rlim_cur = RLIM_INFINITY;
> -       if (r.rlim_max == COMPAT_RLIM_INFINITY)
> -               r.rlim_max = RLIM_INFINITY;
>         set_fs(KERNEL_DS);
> -       ret = sys_setrlimit(resource, (struct rlimit __user *) &r);
> +       ret = sys_setrlimit(resource, (struct rlimit __force __user *)&r);
>         set_fs(old_fs);
>         return ret;

Since you are already rewriting the whole function here, it would be
nice if you could just call do_setrlimit() with the kernel pointer
instead of the set_fs() and __force tricks. For getrlimit, it may
be easier to just open-code the whole function, and for your new
functions, you could pass the pid into do_setrlimit instead of the
task in order to reduce code duplication between compat_sys_setprlimit
and sys_setprlimit.
If you interpret a pid argument of zero as 'current', we can deprecate
the kernel implementation of setrlimit and getrlimit for future
architecture ports.

Yes, I realize my reply is late in this thread, but I assume your patch
is still current since it hasn't made it into 2.6.33.

	Arnd
