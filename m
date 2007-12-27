Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbXL0XWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbXL0XWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 18:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbXL0XWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 18:22:32 -0500
Received: from relay2.sgi.com ([192.48.171.30]:36938 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752685AbXL0XWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 18:22:31 -0500
Date: Thu, 27 Dec 2007 15:22:28 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       Willy Tarreau <w@1wt.eu>, Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: SLUB sysfs support
In-Reply-To: <20071227225947.GH27894@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0712271508080.917@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.58.0712221954530.19187@gandalf.stny.rr.com>
 <20071223051241.GA4449@1wt.eu> <20071223141500.GB6430@one.firstfloor.org>
 <20071224034530.GB16658@thunk.org> <Pine.LNX.4.64.0712241120230.8849@schroedinger.engr.sgi.com>
 <20071224233701.GB9784@kernel.org> <Pine.LNX.4.64.0712261330030.16904@schroedinger.engr.sgi.com>
 <20071226221631.GD27894@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.0712262149000.19009@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0712271222190.31582@schroedinger.engr.sgi.com>
 <20071227225947.GH27894@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Dec 2007, Al Viro wrote:

> On Thu, Dec 27, 2007 at 12:28:14PM -0800, Christoph Lameter wrote:
> > Hmmm.. If I separately allocate the kobject then I can no longer get to 
> > the kmem_cache structure from the kobject. 
> > 
> > I need to add a second kobject_del to sysfs_slab_remove() to make sysfs 
> > completely forget about the object?
> > 
> > Probably should track down any remaining symlinks at that point and nuke 
> > them too. Isnt there some way to convince sysfs to remove the symlinks 
> > if the target vanishes?
> 
> Don't bother with separate allocation.
> 
> a) remove symlink when slab goes away

Ok. Need to think about how to code that.

> b) instead of kfree() in slab removal do kobject_put() if you have sysfs stuff

Hmmmm.... Okay. Patch follows but its strange to do a kobject_put after a 
kobject_del().

> c) have ->release() of these kobjects do kfree()

In slab_ktype?

---
 mm/slub.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-12-27 15:09:38.000000000 -0800
+++ linux-2.6/mm/slub.c	2007-12-27 15:21:12.000000000 -0800
@@ -247,7 +247,10 @@ static void sysfs_slab_remove(struct kme
 static inline int sysfs_slab_add(struct kmem_cache *s) { return 0; }
 static inline int sysfs_slab_alias(struct kmem_cache *s, const char *p)
 							{ return 0; }
-static inline void sysfs_slab_remove(struct kmem_cache *s) {}
+static inline void sysfs_slab_remove(struct kmem_cache *s)
+{
+	kfree(s);
+}
 #endif
 
 /********************************************************************
@@ -2322,7 +2325,6 @@ void kmem_cache_destroy(struct kmem_cach
 		if (kmem_cache_close(s))
 			WARN_ON(1);
 		sysfs_slab_remove(s);
-		kfree(s);
 	} else
 		up_write(&slub_lock);
 }
@@ -3940,6 +3942,13 @@ static ssize_t slab_attr_store(struct ko
 	return err;
 }
 
+static void slab_release(struct kobject *kobj)
+{
+	struct kmem_cache *s = to_slab(kobj);
+
+	kfree(s);
+}
+
 static struct sysfs_ops slab_sysfs_ops = {
 	.show = slab_attr_show,
 	.store = slab_attr_store,
@@ -3947,6 +3956,7 @@ static struct sysfs_ops slab_sysfs_ops =
 
 static struct kobj_type slab_ktype = {
 	.sysfs_ops = &slab_sysfs_ops,
+	.release = slab_release
 };
 
 static int uevent_filter(struct kset *kset, struct kobject *kobj)
@@ -4048,6 +4058,7 @@ static void sysfs_slab_remove(struct kme
 {
 	kobject_uevent(&s->kobj, KOBJ_REMOVE);
 	kobject_del(&s->kobj);
+	kobject_put(&s->kobj);
 }
 
 /*

