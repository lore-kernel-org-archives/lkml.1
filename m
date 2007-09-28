Return-Path: <linux-kernel-owner+w=401wt.eu-S1760217AbXI1Gz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217AbXI1Gz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 02:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757045AbXI1GzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 02:55:20 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:18198 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728AbXI1GzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 02:55:19 -0400
Date: Fri, 28 Sep 2007 08:54:38 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Pierre-Yves Paulus <py@idlum.be>
Cc: linux-kernel@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>,
       BlueZ development <bluez-devel@lists.sourceforge.net>
Subject: Re: Warnings and Oops on 2.6.23-rc6 while activily using rfcomm
 links (mm/slab.c)
Message-ID: <20070928085438.4eb5a38f@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <46FBF17A.6030009@idlum.be>
References: <46F92364.3080603@idlum.be>
	<46F952BD.4010009@redhat.com>
	<46FA5E2E.3010300@idlum.be>
	<20070927085658.1c66f1c8@gondolin.boeblingen.de.ibm.com>
	<46FBC1AE.4020404@idlum.be>
	<46FBF17A.6030009@idlum.be>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 20:07:54 +0200,
Pierre-Yves Paulus <py@idlum.be> wrote:

> Another one below, complete log from power-up to reboot, with some bugs 
> and one Oops. I only trimmed the numerous "l2cap_recv_acldata" and "ACL 
> packet for unknown connection handle" lines which always fill up the log.

Hmm, looked at it, but currently I can't see what's wrong from a driver
core perspective...


> =============================================================================
> BUG kmalloc-128: Poison overwritten
> -----------------------------------------------------------------------------
> 
> INFO: 0xc5734f28-0xc5734f40. First byte 0x6a instead of 0x6b
> INFO: Allocated in rfcomm_dev_ioctl+0xbd/0x4e6 [rfcomm] age=6110 cpu=0 
> pid=3677
> INFO: Freed in rfcomm_dev_destruct+0x59/0x65 [rfcomm] age=3157 cpu=0 
> pid=3927
> INFO: Slab 0xc10ae680 used=21 fp=0xc5734f20 flags=0x400000c2
> INFO: Object 0xc5734f20 @offset=3872 fp=0xc57342c0
> 
> Bytes b4 0xc5734f10:  05 00 00 00 f8 23 0f 00 5a 5a 5a 5a 5a 5a 5a 5a 
> ....ø#..ZZZZZZZZ
>    Object 0xc5734f20:  6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b 
                                                 ^^

This looks suspiciously like someone tried to decrease a refcount on a
freed kobject. Unfortunately, we only see this after the fact with slub
debugging turned on :( So could you please turn it off again (but leave
kobject debugging on) and try with the following silly debug patch:

---
 lib/kobject.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- linux-2.6.orig/lib/kobject.c
+++ linux-2.6/lib/kobject.c
@@ -502,8 +502,12 @@ static void kobject_release(struct kref 
  */
 void kobject_put(struct kobject * kobj)
 {
-	if (kobj)
+	if (kobj) {
+		if (!atomic_read(&kobj->kref.refcount))
+			pr_debug("%s: kobject %s@%p already has zero refcount!\n",
+				 __FUNCTION__, kobj->name, kobj);
 		kref_put(&kobj->kref, kobject_release);
+	}
 }
 
 
