Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbXKEK22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbXKEK22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 05:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbXKEK2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 05:28:20 -0500
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:41576 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbXKEK2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 05:28:19 -0500
Date: Mon, 5 Nov 2007 11:27:31 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Michael Holzheu <holzheu@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Volker Sameske <sameske@de.ibm.com>
Subject: Re: [PATCH 46/54] kset: convert s390 ipl.c to use kset_create
Message-ID: <20071105112731.288a8334@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1194047972-9850-46-git-send-email-gregkh@suse.de>
References: <20071102235758.GA9803@kroah.com>
	<1194047972-9850-46-git-send-email-gregkh@suse.de>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Nov 2007 16:59:24 -0700,
Greg Kroah-Hartman <gregkh@suse.de> wrote:

> Dynamically create the kset instead of declaring it statically.
> This makes the kobject attributes now work properly that I broke in the
> previous patch.
> 
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Michael Holzheu <holzheu@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Volker Sameske <sameske@de.ibm.com>
> Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  arch/s390/kernel/ipl.c |   75 +++++++++++++++++++++++++-----------------------
>  1 files changed, 39 insertions(+), 36 deletions(-)

It seems you also need this (not yet booted):

Fix the following warnings:

arch/s390/kernel/ipl.c: In function 'reipl_init':
arch/s390/kernel/ipl.c:981: warning: passing argument 2 of 'sysfs_create_file' from incompatible pointer type
arch/s390/kernel/ipl.c: In function 'dump_init':
arch/s390/kernel/ipl.c:1070: warning: passing argument 2 of 'sysfs_create_file' from incompatible pointer type
arch/s390/kernel/ipl.c: In function 'shutdown_actions_init':
arch/s390/kernel/ipl.c:1094: warning: passing argument 2 of 'sysfs_create_file' from incompatible pointer type

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 arch/s390/kernel/ipl.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/s390/kernel/ipl.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/ipl.c	2007-11-05 11:12:49.000000000 +0100
+++ linux-2.6/arch/s390/kernel/ipl.c	2007-11-05 11:22:04.000000000 +0100
@@ -978,7 +978,7 @@ static int __init reipl_init(void)
 	reipl_kset = kset_create_and_register("reipl", NULL, NULL, firmware_kset);
 	if (IS_ERR(reipl_kset))
 		return PTR_ERR(reipl_kset);
-	rc = sysfs_create_file(&reipl_kset->kobj, &reipl_type_attr);
+	rc = sysfs_create_file(&reipl_kset->kobj, &reipl_type_attr.attr);
 	if (rc) {
 		kset_unregister(reipl_kset);
 		return rc;
@@ -1067,7 +1067,7 @@ static int __init dump_init(void)
 	dump_kset = kset_create_and_register("dump", NULL, NULL, firmware_kset);
 	if (IS_ERR(dump_kset))
 		return PTR_ERR(dump_kset);
-	rc = sysfs_create_file(&dump_kset->kobj, &dump_type_attr);
+	rc = sysfs_create_file(&dump_kset->kobj, &dump_type_attr.attr);
 	if (rc) {
 		kset_unregister(dump_kset);
 		return rc;
@@ -1091,7 +1091,8 @@ static int __init shutdown_actions_init(
 							 firmware_kset);
 	if (IS_ERR(shutdown_actions_kset))
 		return PTR_ERR(shutdown_actions_kset);
-	rc = sysfs_create_file(&shutdown_actions_kset->kobj, &on_panic_attr);
+	rc = sysfs_create_file(&shutdown_actions_kset->kobj,
+			       &on_panic_attr.attr);
 	if (rc) {
 		kset_unregister(shutdown_actions_kset);
 		return rc;
