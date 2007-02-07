Return-Path: <linux-kernel-owner+w=401wt.eu-S1161447AbXBGWsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161447AbXBGWsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 17:48:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161470AbXBGWsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 17:48:50 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42945 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161447AbXBGWst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 17:48:49 -0500
Date: Wed, 7 Feb 2007 14:48:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] lockdep: forward declare struct trask_struct
Message-Id: <20070207144825.ebfcff46.akpm@linux-foundation.org>
In-Reply-To: <20070207112301.GA9212@osiris.boeblingen.de.ibm.com>
References: <20070207112301.GA9212@osiris.boeblingen.de.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007 12:23:01 +0100
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> 3117df0453828bd045c16244e6f50e5714667a8a causes this:
> 
> In file included from arch/s390/kernel/early.c:13:
> include/linux/lockdep.h:300: warning:
> 		"struct task_struct" declared inside parameter list
> include/linux/lockdep.h:300:
> 		warning: its scope is only this definition or
> 		declaration, which is probably not what you want
> 
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  include/linux/lockdep.h |    2 ++
>  1 files changed, 2 insertions(+)
> 
> Index: linux-2.6/include/linux/lockdep.h
> ===================================================================
> --- linux-2.6.orig/include/linux/lockdep.h
> +++ linux-2.6/include/linux/lockdep.h
> @@ -286,6 +286,8 @@ static inline void early_init_irq_lock_c
>  }
>  #endif
>  
> +struct task_struct;

Minor nit: please put such forward declarations right at the top of the
header file.

Otherwise someone might come along later and require task_struct at line
100.  They'll then add another forward-declaration at line 95 and so on. 
This has happened in the past.

I updated the patch to do this.

diff -puN include/linux/lockdep.h~lockdep-forward-declare-struct-trask_struct include/linux/lockdep.h
--- a/include/linux/lockdep.h~lockdep-forward-declare-struct-trask_struct
+++ a/include/linux/lockdep.h
@@ -8,6 +8,8 @@
 #ifndef __LINUX_LOCKDEP_H
 #define __LINUX_LOCKDEP_H
 
+struct task_struct;
+
 #ifdef CONFIG_LOCKDEP
 
 #include <linux/linkage.h>
_

Note that it's outside CONFIG_LOCKDEP, to avoid possible
hey-my-build-broke-when-i-turned-off-lockdep problems.

