Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbYFJP7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbYFJP7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 11:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbYFJP7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 11:59:08 -0400
Received: from smtp2.riverbed.com ([206.169.144.7]:19170 "EHLO
	smtp2.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbYFJP7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 11:59:07 -0400
Date: Tue, 10 Jun 2008 08:58:50 -0700
From: Arthur Jones <ajones@riverbed.com>
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, Doug Thompson <norsk5@yahoo.com>,
       bluesmoke-devel@lists.sourceforge.net
Subject: on static kobjects and double frees...
Message-ID: <20080610155848.GS26334@ajones-laptop.nbttech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,  The edac pci sysfs generic layer uses a static
kobject as a placeholder parent where edac pci drivers
are inserted.  An atomic count is used to know when
to kobject_init_add_add or kobject_put the static kobject.
The issue with this is that the name gets double freed
on the second module load as edac does not clear it, and
kobject_cleanup does not clear it.

The quick fix was to clear the static kobj name before
calling kobject_init, but that seems a bit fragile as it
involves knowing the internals of kobject_put.  Perhaps
the name should be cleared before calling the kobject
release method?  Something like this (not even compile
tested):

diff --git a/lib/kobject.c b/lib/kobject.c
index 718e510..7dfe906 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -552,6 +552,9 @@ static void kobject_cleanup(struct kobject *kobj)
 	if (t && t->release) {
 		pr_debug("kobject: '%s' (%p): calling ktype release\n",
 			 kobject_name(kobj), kobj);
+
+		/* avoid double free with static kobjects... */
+		kobj->name = NULL;
 		t->release(kobj);
 	}
 
What do you think?  I'm happy to implement and test whatever
you think is best...

The edac code in question is drivers/edac/edac_pci_sysfs.c,
the static kobject is called edac_pci_top_main_kobj...

Arthur
