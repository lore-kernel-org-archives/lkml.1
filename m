Return-Path: <linux-kernel-owner+w=401wt.eu-S1762164AbYEGGQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762164AbYEGGQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 02:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755056AbYEGGQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 02:16:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:46352 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754689AbYEGGQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 02:16:25 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18scFkgwk8sWDtZZo4WC8vWvtSVpwy9SkQn9NHYzR
	ItKAT9XujE4kb7
Subject: Re: WARNING: at drivers/base/sys.c:183 sysdev_driver_register+0x7a
From: Mike Galbraith <efault@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200805070039.20120.rjw@sisk.pl>
References: <20080422075357.GA15651@elte.hu>
	 <1208855066.4695.17.camel@marge.simson.net>
	 <200805070039.20120.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 07 May 2008 08:16:23 +0200
Message-Id: <1210140983.5376.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-07 at 00:39 +0200, Rafael J. Wysocki wrote:
> On Tuesday, 22 of April 2008, Mike Galbraith wrote:
> > 
> > On Tue, 2008-04-22 at 09:53 +0200, Ingo Molnar wrote:
> > > hi Len,
> > > 
> > > randconfig boot testing found this new debug warning message in the 
> > > syslog:
> > 
> > Ditto with Q6600 and v2.6.25-3410-g8075014.
> 
> Does it still happen with the current -git?

No, it was fixed by:

commit db176c6ed8974fae94328ad5ac9e70b094ff22fd
Author: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date:   Wed May 7 04:02:53 2008 +0900

    Fix bogus warning in sysdev_driver_register()
    
            if ((drv->entry.next != drv->entry.prev) ||
                (drv->entry.next != NULL)) {
    
    warns list_empty(&drv->entry).
    
    Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    Cc: Greg KH <gregkh@suse.de>
    Cc: Len Brown <lenb@kernel.org>
    [ Version 2 totally redone based on suggestions from Linus & Greg ]
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 4fbb56b..358bb0b 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -175,8 +175,7 @@ int sysdev_driver_register(struct sysdev_class *cls, struct sysdev_driver *drv)
 	}
 
 	/* Check whether this driver has already been added to a class. */
-	if ((drv->entry.next != drv->entry.prev) ||
-	    (drv->entry.next != NULL)) {
+	if (drv->entry.next && !list_empty(&drv->entry)) {
 		printk(KERN_WARNING "sysdev: class %s: driver (%p) has already"
 			" been registered to a class, something is wrong, but "
 			"will forge on!\n", cls->name, drv);




