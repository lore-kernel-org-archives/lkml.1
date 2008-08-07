Return-Path: <linux-kernel-owner+w=401wt.eu-S1757817AbYHGBJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817AbYHGBJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 21:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbYHGBIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 21:08:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46882 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061AbYHGBIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 21:08:50 -0400
Date: Thu, 7 Aug 2008 11:08:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, bwalle@suse.de,
       greg@kroah.com, hugh@veritas.com, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, haveblue@us.ibm.com
Subject: Re: linux-next: Tree for July 29
Message-Id: <20080807110844.a912483a.sfr@canb.auug.org.au>
In-Reply-To: <20080730234419.GA12070@suse.de>
References: <20080729172337.b3d74100.sfr@canb.auug.org.au>
	<20080730090650.79a5a749@kopernikus.site>
	<20080730021947.def99edc.akpm@linux-foundation.org>
	<200807302127.42148.bzolnier@gmail.com>
	<20080730130419.49986a25.akpm@linux-foundation.org>
	<20080731094105.f6bec082.sfr@canb.auug.org.au>
	<20080730234419.GA12070@suse.de>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Greg,

On Wed, 30 Jul 2008 16:44:19 -0700 Greg KH <gregkh@suse.de> wrote:
>
> On Thu, Jul 31, 2008 at 09:41:05AM +1000, Stephen Rothwell wrote:
> > Hi Andrew,
> > 
> > On Wed, 30 Jul 2008 13:04:19 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > The offending patch has just got itself turfed from linux-next so my
> > > fix now has nothing to fix.
> > > 
> > > We'll see what happens!
> > 
> > I will put Dave's patch back with yours on top of it (hoping that Greg
> > will take your patch).
> 
> Greg will, it's in my queue.

This is still not in your patch series ...  summary email with patch
repeated below.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

Date: Wed, 30 Jul 2008 02:19:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernhard Walle <bwalle@suse.de>
Cc: Greg KH <greg@kroah.com>, Hugh Dickins <hugh@veritas.com>,
        Greg KH <gregkh@suse.de>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Dave Hansen <haveblue@us.ibm.com>
Subject: driver-core: kobject verification fixup

On Wed, 30 Jul 2008 09:06:50 +0200 Bernhard Walle <bwalle@suse.de> wrote:

> * Greg KH <greg@kroah.com> [2008-07-29 21:48]:
> > > Isn't this the opposite end of the same problem for which Bernhard
> > > has been repeatedly trying to find a taker for his patch:
> > > 
> > > http://article.gmane.org/gmane.linux.kernel.kexec/1882
> > 
> > Yes.  It's not the kobject patch at fault here, it's the use of kobjects
> > so early in the boot process.  That needs to be fixed.

It was a bit optimistic to stick an unconditional GFP_KERNEL allocation
into the previously-atomic kobject_init().

It's only 128 bytes, so why can't we fix both problems thusly?

--- a/lib/kobject.c~a
+++ a/lib/kobject.c
@@ -38,12 +38,10 @@ static int ptr_in_range(void *ptr, void 
 
 static void verify_dynamic_kobject_allocation(struct kobject *kobj)
 {
-	char *namebuf;
+	char namebuf[KSYM_NAME_LEN];
 	const char *ret;
 
-	namebuf = kzalloc(KSYM_NAME_LEN, GFP_KERNEL);
-	ret = kallsyms_lookup((unsigned long)kobj, NULL, NULL, NULL,
-			namebuf);
+	ret = kallsyms_lookup((unsigned long)kobj, NULL, NULL, NULL, namebuf);
 	/*
 	 * This is the X86_32-only part of this function.
 	 * This is here because it is valid to have a kobject
@@ -63,7 +61,7 @@ static void verify_dynamic_kobject_alloc
 	/* dump_stack(); */
 	pr_debug("---- end silly warning ----\n");
 out:
-	kfree(namebuf);
+	return;
 }
 #else
 static void verify_dynamic_kobject_allocation(struct kobject *kobj) { }
_


> Yes, but if somebody could tell me why nobody takes the patch, I would
> be happy. Then I would be able to improve the patch. :)

Copy me on the patch.  Then I merge it and people know there will be no
hiding from it.

