Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbZDPAsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbZDPAsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 20:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZDPAsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 20:48:00 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56924 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbZDPAr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 20:47:59 -0400
Message-Id: <200904160046.n3G0ki9o028612@www262.sakura.ne.jp>
Subject: Re: [2.6.30-rc1] RCU detected CPU 1 stall
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: hugh@veritas.com
Cc: arjan@linux.intel.com, gregkh@suse.de, alan@lxorguk.ukuu.org.uk,
       viro@ZenIV.linux.org.uk, jmorris@namei.org, akpm@linux-foundation.org,
       paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 16 Apr 2009 09:46:44 +0900
References: <200904080057.n380vZAH051872@www262.sakura.ne.jp> <20090410142203.GA6719@linux.vnet.ibm.com> <20090410150353.GL26366@ZenIV.linux.org.uk> <20090410153229.GB6719@linux.vnet.ibm.com> <200904110608.IED21123.FQOVMtSOOHFFLJ@I-love.SAKURA.ne.jp> <20090410231245.GF6719@linux.vnet.ibm.com> <20090410233919.GS26366@ZenIV.linux.org.uk> <200904130048.n3D0mw1f077050@www262.sakura.ne.jp> <Pine.LNX.4.64.0904141801300.24679@blonde.anvils> <200904150328.n3F3S0F9083222@www262.sakura.ne.jp> <Pine.LNX.4.64.0904152036150.27354@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0904152036150.27354@blonde.anvils>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 15042009 #1852660, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Hugh Dickins wrote:
> --- 2.6.30-rc1/lib/kobject_uevent.c	2009-04-08 18:20:24.000000000 +0100
> +++ linux/lib/kobject_uevent.c	2009-04-15 19:59:33.000000000 +0100
> @@ -244,11 +244,9 @@ int kobject_uevent_env(struct kobject *k
>  
>  	/* call uevent_helper, usually only enabled during early boot */
>  	if (uevent_helper[0]) {
> -		char *argv [3];
> -
> -		argv [0] = uevent_helper;
> -		argv [1] = (char *)subsystem;
> -		argv [2] = NULL;
> +		env->argv[0] = uevent_helper;
> +		env->argv[1] = (char *)subsystem;
> +		env->argv[2] = NULL;
>  		retval = add_uevent_var(env, "HOME=/");
>  		if (retval)
>  			goto exit;
> @@ -257,7 +255,7 @@ int kobject_uevent_env(struct kobject *k
>  		if (retval)
>  			goto exit;
>  
> -		retval = call_usermodehelper(argv[0], argv,
> +		retval = call_usermodehelper(env->argv[0], env->argv,
>  					     env->envp, UMH_NO_WAIT);
>  	}
>  
Indeed, we can't use "argv" put on stack memory if we use "no wait" mode.
We need to ensure that memory region pointed by "argv" is valid until
do_execve() finishes. However,
| 
| exit:
| 	kfree(devpath);
| 	kfree(env);
| 	return retval;
| }
"env" can be overwritten as well as "argv".
We need to ensure that memory region pointed by "env" is valid until
do_execve() finishes, don't we?

I think we need to use UMH_WAIT_EXEC instead of UMH_NO_WAIT.

Regards.
