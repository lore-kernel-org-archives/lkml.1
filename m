Return-Path: <linux-kernel-owner+w=401wt.eu-S933151AbYGQXNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151AbYGQXNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760806AbYGQXMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:12:54 -0400
Received: from www.tglx.de ([62.245.132.106]:42536 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760721AbYGQXMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:12:52 -0400
Date: Fri, 18 Jul 2008 01:11:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andi Kleen <andi@firstfloor.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Revert duplicate "dock: bay: Don't call acpi_walk_namespace()
 when ACPI is disabled" commit (was: Please pull ACPI updates)
In-Reply-To: <alpine.LFD.1.10.0807170752190.2959@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807180013190.4316@apollo.tec.linutronix.de>
References: <20080716214516.GA10777@basil.nowhere.org> <200807170011.12184.rjw@sisk.pl> <200807161633.01375.jbarnes@virtuousgeek.org> <alpine.LFD.1.10.0807161639090.2835@woody.linux-foundation.org> <487EE940.1050007@firstfloor.org>
 <alpine.LFD.1.10.0807170752190.2959@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008, Linus Torvalds wrote:
> On Thu, 17 Jul 2008, Andi Kleen wrote:
> > 
> > My plan was to keep everything in quilt and just regenerate for the pull.
> > Please let me know if it's now not allowed anymore to use quilt.
> 
> End-point developers can use quilt all thei like.
> 
> But people cannot and *MUST NOT* destroy other peoples work with quilt, 
> nor make it harder for people to share commits.
> 
> Len had apparently left a nice topic tree for you. You took that work, and 
> then destroyed it. And yes, it is noticeable: Jesse had shared some of the 
> work from Len by pulling one of the branches (the 'suspend' branch), and 
> then you literally re-wrote _public_ history, so now tohose patches are 
> duplicated.

It's not only about destroying work and history, it can be worse than that.

For example look at commits:

816c2eda3ce8fa7eb62f22e01e2ec7a3f7d677c0 (merged between 2.6.26-rc8 and -rc9)
and
cc7e51666d82aedfd6b9a033ca1a10d71c21f1ca (merged now)

The export to quilt and the lazy default fuzz setting of quilt added
aside of Andi's Signed-off-by the following gem:

commit cc7e51666d82aedfd6b9a033ca1a10d71c21f1ca
Author: Len Brown <len.brown@intel.com>
Date:   Tue Jun 24 22:57:12 2008 -0400

    dock: bay: Don't call acpi_walk_namespace() when ACPI is disabled.
    
    Signed-off-by: Len Brown <len.brown@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/drivers/acpi/bay.c b/drivers/acpi/bay.c
index 61b6c5b..e6caf5d 100644
--- a/drivers/acpi/bay.c
+++ b/drivers/acpi/bay.c
@@ -380,6 +380,9 @@ static int __init bay_init(void)
 	if (acpi_disabled)
 		return -ENODEV;
 
+	if (acpi_disabled)
+		return -ENODEV;
+
 	/* look for dockable drive bays */
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
 		ACPI_UINT32_MAX, find_bay, &bays, NULL);
diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index bb7c51f..1e872e7 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -920,6 +920,9 @@ static int __init dock_init(void)
 	if (acpi_disabled)
 		return 0;
 
+	if (acpi_disabled)
+		return 0;
+
 	/* look for a dock station */
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
 			    ACPI_UINT32_MAX, find_dock, &num, NULL);

[ Note the code duplication in both files ]

I stumbled accross this incidentally while looking at the recent merge
commits.

While this one looks odd but harmless, probably a full audit of all
the affected commits should be done.

Please revert the one I happened to notice. Patch below.

Thanks,

	tglx

----------->
Subject: APCI: revert duplicated patch
From: Thomas Gleixner <tglx@linutronix.de>

commit 816c2eda3ce8fa7eb62f22e01e2ec7a3f7d677c0
    dock: bay: Don't call acpi_walk_namespace() when ACPI is disabled.  

was merged between 2.6.26-rc8 and -rc9)

Due to rebasing the ACPI tree via quilt the same patch got applied
again via 

commit cc7e51666d82aedfd6b9a033ca1a10d71c21f1ca
    dock: bay: Don't call acpi_walk_namespace() when ACPI is disabled.  

Revert it, as it is obviously bogus.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
diff --git a/drivers/acpi/bay.c b/drivers/acpi/bay.c
index e6caf5d..61b6c5b 100644
--- a/drivers/acpi/bay.c
+++ b/drivers/acpi/bay.c
@@ -380,9 +380,6 @@ static int __init bay_init(void)
 	if (acpi_disabled)
 		return -ENODEV;
 
-	if (acpi_disabled)
-		return -ENODEV;
-
 	/* look for dockable drive bays */
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
 		ACPI_UINT32_MAX, find_bay, &bays, NULL);
diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 1e872e7..bb7c51f 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -920,9 +920,6 @@ static int __init dock_init(void)
 	if (acpi_disabled)
 		return 0;
 
-	if (acpi_disabled)
-		return 0;
-
 	/* look for a dock station */
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
 			    ACPI_UINT32_MAX, find_dock, &num, NULL);
