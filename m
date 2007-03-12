Return-Path: <linux-kernel-owner+w=401wt.eu-S1751037AbXCLAir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751037AbXCLAir (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 20:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbXCLAiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 20:38:46 -0400
Received: from smtp25.orange.fr ([193.252.22.23]:45011 "EHLO smtp25.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbXCLAiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 20:38:46 -0400
X-ME-UUID: 20070312003844100.187EA1C0009A@mwinf2506.orange.fr
Date: Mon, 12 Mar 2007 02:38:43 +0200
From: Samuel Ortiz <samuel@sortiz.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       mingo@redhat.com
Subject: Re: irda rmmod lockdep trace.
Message-ID: <20070312003843.GA3394@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
References: <20070308225436.GA25184@redhat.com> <20070310174326.GA3816@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070310174326.GA3816@sortiz.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Sat, Mar 10, 2007 at 07:43:26PM +0200, Samuel Ortiz wrote:
> Hi Dave,
> 
> On Thu, Mar 08, 2007 at 05:54:36PM -0500, Dave Jones wrote:
> > modprobe irda ; rmmod irda in 2.6.21rc3 gets me the spew below..
> Well it seems that we call __irias_delete_object() from hashbin_delete(). Then
> __irias_delete_object() calls itself hashbin_delete() again. We're trying to
> get the lock recursively.
Looking at the code more carefully, this seems to be a false positive:
iriap_cleanup and and __irias_delete_object are taking 2 different locks from
2 different hashbin instances. The locks belong to the same lock class but
they are hierarchically different. We need to tell the validator about it and
the following patch does that. Comments are welcomed as I'm planning to push
it to netdev soon:

 include/net/irda/irqueue.h |    4 +++-
 net/irda/irias_object.c    |    3 ++-
 net/irda/irqueue.c         |   13 +++++++++----
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/net/irda/irqueue.h b/include/net/irda/irqueue.h
index 335b0ac..ce9fa7c 100644
--- a/include/net/irda/irqueue.h
+++ b/include/net/irda/irqueue.h
@@ -77,7 +77,8 @@ typedef struct hashbin_t {
 } hashbin_t;
 
 hashbin_t *hashbin_new(int type);
-int      hashbin_delete(hashbin_t* hashbin, FREE_FUNC func);
+int      hashbin_delete_nested(hashbin_t* hashbin, FREE_FUNC func,
+			       u8 nested_depth);
 int      hashbin_clear(hashbin_t* hashbin, FREE_FUNC free_func);
 void     hashbin_insert(hashbin_t* hashbin, irda_queue_t* entry, long hashv, 
 			const char* name);
@@ -92,5 +93,6 @@ irda_queue_t *hashbin_get_first(hashbin_t *hashbin);
 irda_queue_t *hashbin_get_next(hashbin_t *hashbin);
 
 #define HASHBIN_GET_SIZE(hashbin) hashbin->hb_size
+#define hashbin_delete(hashbin, func) hashbin_delete_nested(hashbin, func, 0)
 
 #endif
diff --git a/net/irda/iriap.c b/net/irda/iriap.c
diff --git a/net/irda/irias_object.c b/net/irda/irias_object.c
index 4adaae2..4238d23 100644
--- a/net/irda/irias_object.c
+++ b/net/irda/irias_object.c
@@ -142,7 +142,8 @@ void __irias_delete_object(struct ias_object *obj)
 
 	kfree(obj->name);
 
-	hashbin_delete(obj->attribs, (FREE_FUNC) __irias_delete_attrib);
+	hashbin_delete_nested(obj->attribs, (FREE_FUNC) __irias_delete_attrib,
+			      SINGLE_DEPTH_NESTING);
 
 	obj->magic = ~IAS_OBJECT_MAGIC;
 
diff --git a/net/irda/irqueue.c b/net/irda/irqueue.c
index 9266233..c669a86 100644
--- a/net/irda/irqueue.c
+++ b/net/irda/irqueue.c
@@ -378,13 +378,14 @@ EXPORT_SYMBOL(hashbin_new);
 
 
 /*
- * Function hashbin_delete (hashbin, free_func)
+ * Function hashbin_delete_nested (hashbin, free_func, nested_lock)
  *
  *    Destroy hashbin, the free_func can be a user supplied special routine
  *    for deallocating this structure if it's complex. If not the user can
  *    just supply kfree, which should take care of the job.
  */
-int hashbin_delete( hashbin_t* hashbin, FREE_FUNC free_func)
+int hashbin_delete_nested( hashbin_t* hashbin, FREE_FUNC free_func,
+			   u8 nested_depth)
 {
 	irda_queue_t* queue;
 	unsigned long flags = 0;
@@ -395,7 +396,11 @@ int hashbin_delete( hashbin_t* hashbin, FREE_FUNC free_func)
 
 	/* Synchronize */
 	if ( hashbin->hb_type & HB_LOCK ) {
-		spin_lock_irqsave(&hashbin->hb_spinlock, flags);
+		if (nested_depth > 0)
+			spin_lock_irqsave_nested(&hashbin->hb_spinlock, flags,
+						 nested_depth);
+		else
+			spin_lock_irqsave(&hashbin->hb_spinlock, flags);
 	}
 
 	/*
@@ -428,7 +433,7 @@ int hashbin_delete( hashbin_t* hashbin, FREE_FUNC free_func)
 
 	return 0;
 }
-EXPORT_SYMBOL(hashbin_delete);
+EXPORT_SYMBOL(hashbin_delete_nested);
 
 /********************* HASHBIN LIST OPERATIONS *********************/
 



> I'll try to fix that soon, thanks for the report.
> 
> Cheers,
> Samuel.
> 
> 
> > 	Dave
> > 
> > NET: Registered protocol family 23
> > NET: Unregistered protocol family 23
> > 
> > =============================================
> > [ INFO: possible recursive locking detected ]
> > 2.6.20-1.2966.fc7 #1
> > ---------------------------------------------
> > rmmod/16712 is trying to acquire lock:
> >  (&hashbin->hb_spinlock){....}, at: [<ffffffff884bf476>] hashbin_delete+0x29/0x94 [irda]
> > 
> > but task is already holding lock:
> >  (&hashbin->hb_spinlock){....}, at: [<ffffffff884bf476>] hashbin_delete+0x29/0x94 [irda]
> > 
> > other info that might help us debug this:
> > 1 lock held by rmmod/16712:
> >  #0:  (&hashbin->hb_spinlock){....}, at: [<ffffffff884bf476>] hashbin_delete+0x29/0x94 [irda]
> > 
> > stack backtrace:
> > 
> > Call Trace:
> >  [<ffffffff802a303b>] __lock_acquire+0x151/0xbc4
> >  [<ffffffff884c1517>] :irda:__irias_delete_attrib+0x0/0x31
> >  [<ffffffff802a3ea4>] lock_acquire+0x4c/0x65
> >  [<ffffffff884bf476>] :irda:hashbin_delete+0x29/0x94
> >  [<ffffffff80264011>] _spin_lock_irqsave+0x2c/0x3c
> >  [<ffffffff884bf476>] :irda:hashbin_delete+0x29/0x94
> >  [<ffffffff884c1918>] :irda:__irias_delete_object+0x0/0x39
> >  [<ffffffff884c193d>] :irda:__irias_delete_object+0x25/0x39
> >  [<ffffffff884bf48d>] :irda:hashbin_delete+0x40/0x94
> >  [<ffffffff884c5e3a>] :irda:iriap_cleanup+0x36/0x38
> >  [<ffffffff884c5fd6>] :irda:irda_cleanup+0x29/0x3a
> >  [<ffffffff802aa1e1>] sys_delete_module+0x199/0x1ca
> >  [<ffffffff8026ce36>] syscall_trace_enter+0x9a/0x9f
> >  [<ffffffff8025c2b5>] tracesys+0xdc/0xe1
> > 
> > 
> > -- 
> > http://www.codemonkey.org.uk

