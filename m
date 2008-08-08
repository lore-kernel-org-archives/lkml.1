Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbYHHWbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbYHHWbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758390AbYHHWba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:31:30 -0400
Received: from tundra.namei.org ([65.99.196.166]:47520 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401AbYHHWb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:31:29 -0400
Date: Sat, 9 Aug 2008 08:31:06 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Eduardo Habkost <ehabkost@redhat.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Howells <dhowells@redhat.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: next-20080808 fs/nfsctl.c build error
In-Reply-To: <20080808172527.GB4742@blackpad>
Message-ID: <alpine.LRH.1.10.0808090825060.29741@tundra.namei.org>
References: <20080808171624.24ae1e10.sfr@canb.auug.org.au> <20080808172527.GB4742@blackpad>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008, Eduardo Habkost wrote:

> 
> I got the following build error on next-20080808:
> 
> fs/nfsctl.c: In function ?do_open?:
> fs/nfsctl.c:45: error: implicit declaration of function ?current_cred?
> fs/nfsctl.c:45: warning: passing argument 4 of ?dentry_open? makes pointer from integer without a cast
> make[1]: *** [fs/nfsctl.o] Error 1
> make: *** [fs/nfsctl.o] Error 2

Something I noticed in the configs posted with build breakages is 
CONFIG_SMP=n, although I'm not sure how/if that's related.

In any case, it seems that linux/cred.h should include linux/sched.h to 
provide a full definition of 'struct task_struct', so that 'current' can 
be dereferenced (e.g. in current_cred()).

Does this patch work for you and look correct ?

---- 

diff --git a/fs/nfsctl.c b/fs/nfsctl.c
index cc4ef26..f6967b6 100644
--- a/fs/nfsctl.c
+++ b/fs/nfsctl.c
@@ -14,6 +14,7 @@
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/syscalls.h>
+#include <linux/cred.h>
 #include <asm/uaccess.h>
 
 /*
diff --git a/include/linux/cred.h b/include/linux/cred.h
index b156ed4..431f1ab 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -14,9 +14,9 @@
 
 #include <linux/capability.h>
 #include <linux/key.h>
+#include <linux/sched.h>
 #include <asm/atomic.h>
 
-struct user_struct;
 struct cred;
 struct inode;
 

---

Signed-off-by: James Morris <jmorris@namei.org>



-- 
James Morris
<jmorris@namei.org>
