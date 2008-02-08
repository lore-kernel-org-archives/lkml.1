Return-Path: <linux-kernel-owner+w=401wt.eu-S934278AbYBHQk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934278AbYBHQk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 11:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933454AbYBHQjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 11:39:19 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:35116 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933996AbYBHQjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 11:39:16 -0500
Subject: Re: [-mm PATCH] sysdev_unregister() should call kobject_del()
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Greg KH <greg@kroah.com>, haveblue@us.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080208054158.GA12742@kroah.com>
References: <1202428618.26309.45.camel@dyn9047017100.beaverton.ibm.com>
	 <20080208003825.GB27317@kroah.com>
	 <1202433946.26309.47.camel@dyn9047017100.beaverton.ibm.com>
	 <20080208045533.GA10988@kroah.com>
	 <1202447322.13910.3.camel@badari-laptop.beaverton.ibm.com>
	 <20080208054158.GA12742@kroah.com>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 08:42:05 -0800
Message-Id: <1202488925.26309.60.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-07 at 21:41 -0800, Greg KH wrote:
> On Thu, Feb 07, 2008 at 09:08:42PM -0800, Badari Pulavarty wrote:
> > 
> > On Thu, 2008-02-07 at 20:55 -0800, Greg KH wrote:
> > > On Thu, Feb 07, 2008 at 05:25:46PM -0800, Badari Pulavarty wrote:
> > > > On Thu, 2008-02-07 at 16:38 -0800, Greg KH wrote:
> > > > > On Thu, Feb 07, 2008 at 03:56:58PM -0800, Badari Pulavarty wrote:
> > > > > > Hi Greg,
> > > > > > 
> > > > > > While playing with hotplug memory remove on 2.6.24-mm1, I 
> > > > > > noticed that /sysfs directory entries are not getting removed.
> > > > > > 
> > > > > > sysdev_unregister() used to call kobject_unregister().
> > > > > > But in 2.6.24-mm1, its only dropping the ref. It should
> > > > > > call kobject_del() to remove the object. Correct ?
> > > > > > 
> > > > > > With this change, the directories are getting removed
> > > > > > correctly. Comments ?
> > > > > 
> > > > > Ick, no, this shouldn't be needed, someone else must be holding a
> > > > > reference to the kobject device somewhere.  See the kobject documenation
> > > > > for more info.
> > > > > 
> > > > > I'll try to see where we grab 2 references...
> > > > 
> > > > I will take a closer look then. I was taking easy way out :(
> > > 
> > > Hm, I don't see anything obvious in the sys.c core.  What code is
> > > controlling these objects that you are creating and removing from the
> > > system?
> > 
> > add_memory_block()/register_memory() is creating sysfs entries
> > for the memory blocks.
> > 
> > I am trying to make use of remove_memory_block() to clean up
> > sysfs entries. BTW, remove_memory_block() is never tested
> > before, since we don't support memory remove yet.
> 
> So how are you testing the sysdev removal logic then if you can't remove
> memory?

I am now adding code to remove memory, I am making use of the
existing unregister_memory() code and ran into this.
> 
> Oh, one thing, remove the link in unregister_memory, before you call
> sysdev_unregister().  You are trying to get the name of a kobject, and
> the whole object, that has just been blown away, not nice...

I can add remove link before unregister() as you suggested.

Regarding accessing kobject after freeing up, no one calls with "root".
Why not clean it up first, like this ? 

Dave, are you okay with this ?

Thanks,
Badari

register_memory()/unregister_memory() never gets called with
"root". unregister_memory() is accessing kobject_name of
the object just freed up. Since no one uses the code,
lets take the code out. And also, make register_memory()
static (since unregister_memory() is already static).  

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
---
 drivers/base/memory.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

Index: linux-2.6.24/drivers/base/memory.c
===================================================================
--- linux-2.6.24.orig/drivers/base/memory.c	2008-02-07 16:59:52.000000000 -0800
+++ linux-2.6.24/drivers/base/memory.c	2008-02-08 08:26:33.000000000 -0800
@@ -62,8 +62,8 @@ void unregister_memory_notifier(struct n
 /*
  * register_memory - Setup a sysfs device for a memory block
  */
-int register_memory(struct memory_block *memory, struct mem_section *section,
-		struct node *root)
+static
+int register_memory(struct memory_block *memory, struct mem_section *section)
 {
 	int error;
 
@@ -71,26 +71,16 @@ int register_memory(struct memory_block 
 	memory->sysdev.id = __section_nr(section);
 
 	error = sysdev_register(&memory->sysdev);
-
-	if (root && !error)
-		error = sysfs_create_link(&root->sysdev.kobj,
-					  &memory->sysdev.kobj,
-					  kobject_name(&memory->sysdev.kobj));
-
 	return error;
 }
 
 static void
-unregister_memory(struct memory_block *memory, struct mem_section *section,
-		struct node *root)
+unregister_memory(struct memory_block *memory, struct mem_section *section)
 {
 	BUG_ON(memory->sysdev.cls != &memory_sysdev_class);
 	BUG_ON(memory->sysdev.id != __section_nr(section));
 
 	sysdev_unregister(&memory->sysdev);
-	if (root)
-		sysfs_remove_link(&root->sysdev.kobj,
-				  kobject_name(&memory->sysdev.kobj));
 }
 
 /*
@@ -361,7 +351,7 @@ static int add_memory_block(unsigned lon
 	mutex_init(&mem->state_mutex);
 	mem->phys_device = phys_device;
 
-	ret = register_memory(mem, section, NULL);
+	ret = register_memory(mem, section);
 	if (!ret)
 		ret = mem_create_simple_file(mem, phys_index);
 	if (!ret)
@@ -415,7 +405,7 @@ int remove_memory_block(unsigned long no
 	mem_remove_simple_file(mem, state);
 	mem_remove_simple_file(mem, phys_device);
 	mem_remove_simple_file(mem, removable);
-	unregister_memory(mem, section, NULL);
+	unregister_memory(mem, section);
 
 	return 0;
 }


