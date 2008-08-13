Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbYHMJ2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbYHMJ2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 05:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbYHMJ2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 05:28:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386AbYHMJ2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 05:28:13 -0400
Date: Wed, 13 Aug 2008 02:27:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH] kexec jump: fix compiling warning on xchg(&kexec_lock,
 0) in kernel_kexec()
Message-Id: <20080813022712.4bea5fea.akpm@linux-foundation.org>
In-Reply-To: <1218618760.24951.137.camel@caritas-dev.intel.com>
References: <1218618760.24951.137.camel@caritas-dev.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 17:12:40 +0800 Huang Ying <ying.huang@intel.com> wrote:

> Fix compiling warning on xchg(&kexec_lock, 0) in kernel_kexec().
>

Would prefer that thi code not use such a peculair idiom.  I don't
believe that it needs to.

I guess that's a separate activity.

> 
> ---
>  kernel/kexec.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1433,6 +1433,7 @@ module_init(crash_save_vmcoreinfo_init)
>  int kernel_kexec(void)
>  {
>  	int error = 0;
> +	int locked;
>  
>  	if (xchg(&kexec_lock, 1))
>  		return -EBUSY;
> @@ -1498,7 +1499,8 @@ int kernel_kexec(void)
>  #endif
>  
>   Unlock:
> -	xchg(&kexec_lock, 0);
> +	locked = xchg(&kexec_lock, 0);
> +	BUG_ON(!locked);
>  
>  	return error;
>  }
> 

Please always quote the compiler output in the changelog when fixing
warnings and build errors.

The patch is titled "kexec jump: ..." whereas this is just a plain old
kexec fix, which is applicable to mainline.

We don't need to create that local.  I queued this:



Subject: kexec: fix compilation warning on xchg(&kexec_lock, 0) in kernel_kexec()
From: Huang Ying <ying.huang@intel.com>

kernel/kexec.c: In function 'kernel_kexec':
kernel/kexec.c:1506: warning: value computed is not used

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/kexec.c~kexec-jump-fix-compiling-warning-on-xchgkexec_lock-0-in-kernel_kexec kernel/kexec.c
--- a/kernel/kexec.c~kexec-jump-fix-compiling-warning-on-xchgkexec_lock-0-in-kernel_kexec
+++ a/kernel/kexec.c
@@ -1503,7 +1503,8 @@ int kernel_kexec(void)
 	}
 
  Unlock:
-	xchg(&kexec_lock, 0);
+	if (!xchg(&kexec_lock, 0))
+		BUG();
 
 	return error;
 }
_

