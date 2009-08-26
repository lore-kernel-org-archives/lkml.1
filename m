Return-Path: <linux-kernel-owner+w=401wt.eu-S1757210AbZHZMHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbZHZMHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 08:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756934AbZHZMHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 08:07:22 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53106 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756922AbZHZMHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 08:07:20 -0400
In-Reply-To: <20090826021005.GD19494@bombadil.infradead.org>
References: <20090826021005.GD19494@bombadil.infradead.org>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: eparis@redhat.com, Kyle McMartin <kyle@infradead.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       David Safford <David_Safford@watson.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH] allow disabling IMA at runtime
X-KeepSent: 49FE725E:CE343CE0-8525761E:0041C9AD;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5 December 05, 2008
Message-ID: <OF49FE725E.CE343CE0-ON8525761E.0041C9AD-8525761E.00429749@us.ibm.com>
From: Mimi Zohar <zohar@us.ibm.com>
Date: Wed, 26 Aug 2009 08:07:21 -0400
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Release 8.5|December 05, 2008) at
 08/26/2009 08:07:21,
	Serialize complete at 08/26/2009 08:07:21
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin <kyle@infradead.org> wrote on 08/25/2009 10:10:05 PM:

> From: Kyle McMartin <kyle@redhat.com>
> 
> Due to a memory leak in IMA that we're currently debugging in Fedora
> rawhide, it would be nice to be able to disable that support at runtime.
> Currently it's only able to be built in, and there's no toggle to avoid
> initializing it.
> 
> Provide one, in order to enhance debuggability. If a user can reboot a
> machine and edit its command line, one can do a far sight worse things
> than disabling a security precaution.
> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>

Have you tried using Eric's patch
"IMA: Minimal IMA policy and boot param for TCB IMA policy"
(commit 5789ba3bd0a3cd20df5980ebf03358f2eb44fd67), which introduced
the ima_tcb=1 command line option?  It wasn't backported to 2.6.30.

Mimi

> ---
> diff --git a/Documentation/kernel-parameters.txt 
b/Documentation/kernel-parameters.txt
> index 7936b80..0d1b1ed 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -926,6 +926,11 @@ and is between 256 and 4096 characters. It is 
defined in the file
>     ihash_entries=   [KNL]
>           Set number of hash buckets for inode cache.
> 
> +   ima=      [IMA]
> +         Format: { "0" | "1" }
> +         0 -- disable IMA.
> +         1 -- enable IMA. (default)
> +
>     ima_audit=   [IMA]
>           Format: { "0" | "1" }
>           0 -- integrity auditing messages. (Default)
> diff --git a/security/integrity/ima/ima_main.c 
b/security/integrity/ima/ima_main.c
> index 101c512..cc7603e 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -339,10 +339,27 @@ int ima_bprm_check(struct linux_binprm *bprm)
>     return 0;
>  }
> 
> +static int ima_disabled = 0;
> +static int __init ima_enabled(char *str)
> +{
> +   unsigned long enabled;
> +
> +   if (!strict_strtoul(str, 0, &enabled))
> +      ima_disabled = enabled ? 0 : 1;
> +
> +   return 1;
> +}
> +__setup("ima=", ima_enabled);
> +
>  static int __init init_ima(void)
>  {
>     int error;
> 
> +   if (ima_disabled) {
> +      pr_info("IMA disabled at user request.\n");
> +      return 0;
> +   }
> +
>     ima_iintcache_init();
>     error = ima_init();
>     ima_initialized = 1;

