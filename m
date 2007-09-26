Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbXIZCqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbXIZCqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 22:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbXIZCqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 22:46:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54870 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723AbXIZCqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 22:46:32 -0400
Date: Tue, 25 Sep 2007 19:41:21 -0700
From: Greg KH <greg@kroah.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: subsystem_unregister() breakage in -mm
Message-ID: <20070926024121.GA28124@kroah.com>
References: <E1IaIs6-00051t-00@dorka.pomaz.szeredi.hu> <20070925225330.GA26235@kroah.com> <E1IaJQL-00053O-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IaJQL-00053O-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 01:02:37AM +0200, Miklos Szeredi wrote:
> > On Wed, Sep 26, 2007 at 12:27:14AM +0200, Miklos Szeredi wrote:
> > > I get "BUG: failure at mm/slab.c:591/page_get_cache()!" in latest -mm
> > > when removing the fuse module.
> > > 
> > > This patch titled "kobject: remove the static array for the name"
> > > looks like it's responsible.  Reverting it cures the problem.
> > > 
> > > The root of the problem seems to be, that decl_subsys() initializes
> > > k_name with a string constant.  Then subsystem_unregister() will put
> > > the kobject, which will free the k_name.
> > > 
> > > So, what's the right way to deal with this?
> > 
> > How is the static kobject created by decl_subsys() getting it's release
> > function called when it is never really "released" as it is a static
> > kobject?
> 
> Don't know.
> 
> This is the stack trace I get:
> 
> BUG: failure at mm/slab.c:591/page_get_cache()!
> Kernel panic - not syncing: BUG!

Ok, here's a patch that fixes this for me.  It should go on top of the
-mm tree.  Let me know of this works or not.

In the end, we need to dynamically allocate these subsystems to properly
fix this.  In looking through the tree, there really isn't that many of
them, so I'll try to knock that out later this week.


thanks,

greg k-h

---
 lib/kobject.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -487,11 +487,11 @@ void kobject_cleanup(struct kobject * ko
 	struct kobject * parent = kobj->parent;
 
 	pr_debug("kobject %s: cleaning up\n",kobject_name(kobj));
-	kfree(kobj->k_name);
-	kobj->k_name = NULL;
-	if (t && t->release)
+	if (t && t->release) {
 		t->release(kobj);
-	else
+		kfree(kobj->k_name);
+		kobj->k_name = NULL;
+	} else
 		pr_debug("kobject '%s' does not have a release() function, "
 			"if this is not a directory kobject, it is broken "
 			"and must be fixed.\n",
