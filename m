Return-Path: <linux-kernel-owner+w=401wt.eu-S1759439AbXIROtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439AbXIROtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 10:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758806AbXIROts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 10:49:48 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59771 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbXIROtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 10:49:47 -0400
Message-ID: <46EFE6D7.3070105@bull.net>
Date: Tue, 18 Sep 2007 16:55:19 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: IPC: sleeping function called ...
References: <20070918091728.GA6766@localhost.sw.ru> <20070918032727.c07aa521.akpm@linux-foundation.org>
In-Reply-To: <20070918032727.c07aa521.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 18/09/2007 16:55:33,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 18/09/2007 16:55:35,
	Serialize complete at 18/09/2007 16:55:35
Content-Type: multipart/mixed;
 boundary="------------020104090001010406080904"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020104090001010406080904
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed

Andrew Morton wrote:
> On Tue, 18 Sep 2007 13:17:28 +0400 Alexey Dobriyan <adobriyan@sw.ru> wrote:
> 
> 
>>I'm getting tons of this, and X fails to start
>>
>>CONFIG_SYSVIPC=y
>>CONFIG_SYSVIPC_SYSCTL=y
>># CONFIG_PREEMPT_NONE is not set
>># CONFIG_PREEMPT_VOLUNTARY is not set
>>CONFIG_PREEMPT=y
>>CONFIG_PREEMPT_BKL=y
>>CONFIG_DEBUG_PREEMPT=y
>>
>>BUG: sleeping function called from invalid context at kernel/rwsem.c:47
>>in_atomic():1, irqs_disabled():0
> 
> 
> OK, this fixes the locking here:
> 
> --- a/ipc/util.c~ipc-integrate-ipc_checkid-into-ipc_lock-fix-2
> +++ a/ipc/util.c
> @@ -295,7 +295,6 @@ int ipc_addid(struct ipc_ids* ids, struc
>  
>  	spin_lock_init(&new->lock);
>  	new->deleted = 0;
> -	rcu_read_lock();
>  	spin_lock(&new->lock);
>  	return id;
>  }
> @@ -691,7 +690,7 @@ struct kern_ipc_perm *ipc_lock(struct ip
>  		rcu_read_unlock();
>  		return ERR_PTR(-EINVAL);
>  	}
> -
> +	rcu_read_unlock();
>  	return out;
>  }
>  


Well, reviewing the code I found another place where the 
rcu_read_unlock() was missing.
I'm so sorry for the inconvenience. It's true that I should have tested 
with CONFIG_PREEMPT=y :-(
Now, the ltp tests pass even with this option set...

In attachment you'll find a patch thhat
1) adds the missing rcu_read_unlock()
2) replaces Andrew's fix with a new one: the rcu_read_lock() is now 
taken in ipc_lock() / ipc_lock_by_ptr() and released in ipc_unlock(), 
exactly as it was done in the ref code.

Regards,
Nadia

--------------020104090001010406080904
Content-Transfer-Encoding: 7bit
Content-Type: text/x-patch;
 name="ipc_missing_rcu_locks.patch"
Content-Disposition: inline;
 filename="ipc_missing_rcu_locks.patch"

This patch fixes the missing rcu_read_(un)lock in the ipc code

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 ipc/util.c |    3 ++-
 ipc/util.h |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6.23-rc6-mm1/ipc/util.c
===================================================================
--- linux-2.6.23-rc6-mm1.orig/ipc/util.c	2007-09-18 16:39:43.000000000 +0200
+++ linux-2.6.23-rc6-mm1/ipc/util.c	2007-09-18 16:40:53.000000000 +0200
@@ -295,6 +295,7 @@ int ipc_addid(struct ipc_ids* ids, struc
 
 	spin_lock_init(&new->lock);
 	new->deleted = 0;
+	rcu_read_lock();
 	spin_lock(&new->lock);
 	return id;
 }
@@ -690,7 +691,7 @@ struct kern_ipc_perm *ipc_lock(struct ip
 		rcu_read_unlock();
 		return ERR_PTR(-EINVAL);
 	}
-	rcu_read_unlock();
+
 	return out;
 }
 
Index: linux-2.6.23-rc6-mm1/ipc/util.h
===================================================================
--- linux-2.6.23-rc6-mm1.orig/ipc/util.h	2007-09-18 14:55:31.000000000 +0200
+++ linux-2.6.23-rc6-mm1/ipc/util.h	2007-09-18 16:41:37.000000000 +0200
@@ -141,12 +141,14 @@ static inline int ipc_checkid(struct ipc
 
 static inline void ipc_lock_by_ptr(struct kern_ipc_perm *perm)
 {
+	rcu_read_lock();
 	spin_lock(&perm->lock);
 }
 
 static inline void ipc_unlock(struct kern_ipc_perm *perm)
 {
 	spin_unlock(&perm->lock);
+	rcu_read_unlock();
 }
 
 static inline struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids,
@@ -159,7 +161,7 @@ static inline struct kern_ipc_perm *ipc_
 		return out;
 
 	if (ipc_checkid(ids, out, id)) {
-		spin_unlock(&out->lock);
+		ipc_unlock(out);
 		return ERR_PTR(-EIDRM);
 	}
 

--------------020104090001010406080904--
