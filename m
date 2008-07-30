Return-Path: <linux-kernel-owner+w=401wt.eu-S1759181AbYG3JU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181AbYG3JU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbYG3JUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:20:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751502AbYG3JUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:20:11 -0400
Date: Wed, 30 Jul 2008 02:19:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernhard Walle <bwalle@suse.de>
Cc: Greg KH <greg@kroah.com>, Hugh Dickins <hugh@veritas.com>,
       Greg KH <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: linux-next: Tree for July 29
Message-Id: <20080730021947.def99edc.akpm@linux-foundation.org>
In-Reply-To: <20080730090650.79a5a749@kopernikus.site>
References: <20080729172337.b3d74100.sfr@canb.auug.org.au>
	<200807291825.14281.bzolnier@gmail.com>
	<20080729181639.GA21311@suse.de>
	<Pine.LNX.4.64.0807292145220.28604@blonde.site>
	<20080730044834.GB2954@kroah.com>
	<20080730090650.79a5a749@kopernikus.site>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
