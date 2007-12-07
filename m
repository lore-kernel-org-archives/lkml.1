Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbXLHDIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbXLHDIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 22:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbXLHDIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 22:08:12 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:7815 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753263AbXLHDIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 22:08:11 -0500
Message-Id: <20071208025623.008165580@mvista.com>
References: <20071208025620.470633411@mvista.com>
User-Agent: quilt/0.46-1
Date: Fri, 07 Dec 2007 00:00:02 -0800
Subject: [PATCH 2/4] docs: kernel-locking: Convert semaphore references
References: <20071208025608.631609481@mvista.com>
User-Agent: quilt/0.46-1
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com
Content-Disposition: inline; filename=doc-kernel-locking-convert-semaphore-reference.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I converted some of the document to reflect mutex usage instead of
semaphore usage. Since we shouldin't be promoting semaphore usage when
it's on it's way out..

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 Documentation/DocBook/kernel-locking.tmpl |   32 +++++++++++++++---------------
 1 file changed, 16 insertions(+), 16 deletions(-)

Index: linux-2.6.23/Documentation/DocBook/kernel-locking.tmpl
===================================================================
--- linux-2.6.23.orig/Documentation/DocBook/kernel-locking.tmpl
+++ linux-2.6.23/Documentation/DocBook/kernel-locking.tmpl
@@ -717,7 +717,7 @@ used, and when it gets full, throws out 
     <para>
 For our first example, we assume that all operations are in user
 context (ie. from system calls), so we can sleep.  This means we can
-use a semaphore to protect the cache and all the objects within
+use a mutex to protect the cache and all the objects within
 it.  Here's the code:
     </para>
 
@@ -725,7 +725,7 @@ it.  Here's the code:
 #include &lt;linux/list.h&gt;
 #include &lt;linux/slab.h&gt;
 #include &lt;linux/string.h&gt;
-#include &lt;asm/semaphore.h&gt;
+#include &lt;linux/mutex.h&gt;
 #include &lt;asm/errno.h&gt;
 
 struct object
@@ -737,7 +737,7 @@ struct object
 };
 
 /* Protects the cache, cache_num, and the objects within it */
-static DECLARE_MUTEX(cache_lock);
+static DEFINE_MUTEX(cache_lock);
 static LIST_HEAD(cache);
 static unsigned int cache_num = 0;
 #define MAX_CACHE_SIZE 10
@@ -789,17 +789,17 @@ int cache_add(int id, const char *name)
         obj-&gt;id = id;
         obj-&gt;popularity = 0;
 
-        down(&amp;cache_lock);
+        mutex_lock(&amp;cache_lock);
         __cache_add(obj);
-        up(&amp;cache_lock);
+        mutex_unlock(&amp;cache_lock);
         return 0;
 }
 
 void cache_delete(int id)
 {
-        down(&amp;cache_lock);
+        mutex_lock(&amp;cache_lock);
         __cache_delete(__cache_find(id));
-        up(&amp;cache_lock);
+        mutex_unlock(&amp;cache_lock);
 }
 
 int cache_find(int id, char *name)
@@ -807,13 +807,13 @@ int cache_find(int id, char *name)
         struct object *obj;
         int ret = -ENOENT;
 
-        down(&amp;cache_lock);
+        mutex_lock(&amp;cache_lock);
         obj = __cache_find(id);
         if (obj) {
                 ret = 0;
                 strcpy(name, obj-&gt;name);
         }
-        up(&amp;cache_lock);
+        mutex_unlock(&amp;cache_lock);
         return ret;
 }
 </programlisting>
@@ -853,7 +853,7 @@ The change is shown below, in standard p
          int popularity;
  };
 
--static DECLARE_MUTEX(cache_lock);
+-static DEFINE_MUTEX(cache_lock);
 +static spinlock_t cache_lock = SPIN_LOCK_UNLOCKED;
  static LIST_HEAD(cache);
  static unsigned int cache_num = 0;
@@ -870,22 +870,22 @@ The change is shown below, in standard p
          obj-&gt;id = id;
          obj-&gt;popularity = 0;
 
--        down(&amp;cache_lock);
+-        mutex_lock(&amp;cache_lock);
 +        spin_lock_irqsave(&amp;cache_lock, flags);
          __cache_add(obj);
--        up(&amp;cache_lock);
+-        mutex_unlock(&amp;cache_lock);
 +        spin_unlock_irqrestore(&amp;cache_lock, flags);
          return 0;
  }
 
  void cache_delete(int id)
  {
--        down(&amp;cache_lock);
+-        mutex_lock(&amp;cache_lock);
 +        unsigned long flags;
 +
 +        spin_lock_irqsave(&amp;cache_lock, flags);
          __cache_delete(__cache_find(id));
--        up(&amp;cache_lock);
+-        mutex_unlock(&amp;cache_lock);
 +        spin_unlock_irqrestore(&amp;cache_lock, flags);
  }
 
@@ -895,14 +895,14 @@ The change is shown below, in standard p
          int ret = -ENOENT;
 +        unsigned long flags;
 
--        down(&amp;cache_lock);
+-        mutex_lock(&amp;cache_lock);
 +        spin_lock_irqsave(&amp;cache_lock, flags);
          obj = __cache_find(id);
          if (obj) {
                  ret = 0;
                  strcpy(name, obj-&gt;name);
          }
--        up(&amp;cache_lock);
+-        mutex_unlock(&amp;cache_lock);
 +        spin_unlock_irqrestore(&amp;cache_lock, flags);
          return ret;
  }

-- 
