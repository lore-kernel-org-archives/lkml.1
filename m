Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704Ab0A2Oi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab0A2Oi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 09:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030Ab0A2Oi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 09:38:56 -0500
Received: from MAIL.IHTFP.ORG ([204.107.200.6]:58530 "EHLO mail.ihtfp.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab0A2Oix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 09:38:53 -0500
X-Greylist: delayed 1407 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jan 2010 09:38:53 EST
From: Derek Atkins <warlord@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: warlord@mit.edu
Subject: Re-enabling non-GPL driver access to disk partition information
Date: Fri, 29 Jan 2010 09:15:09 -0500
Message-ID: <sjmd40t3slu.fsf@pgpdev.ihtfp.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Hi Linuxers,

I've been working on a proprietary disk driver which has been working
for the past couple years on Linux as old as 2.6.18.  Unfortunately,
as of 2.6.28 it appears that some of the gendisk interfaces (read:
structure members) I was using were moved behind an RCU and other
GPL-ONLY accessor interfaces.  I appologize for coming at this so
late, but I don't monitor LKML and I only noticed this when we tried
to port our driver to Ubuntu 9.04 and Fedora 11, and then had delays
in getting this email out.

In particular, there is now no way for a proprietary driver to access
the gendisk partition array, to enumerate the existing partitions, or to
get information about existing partitions.  All those interfaces are now
GPL-Only, (whereas access to the structure members before were perfectly
legal for non-GPL modules).  But now the partition structure is sitting
behind the GPL-Only RCU abstraction.

While I can hack around this to some extent, I'd rather have real
interfaces I can use and play nicely with the Linux disk driver APIs.
Therefore, I propose to convert a few of these interfaces to non-GPL
export for general driver use.  The list of functions I propose to
change:

disk_get_part()
put_device() (needed for the inline disk_put_part() function)

disk_part_iter_init()
disk_part_iter_next()
disk_part_iter_exit()

I hope this patch is acceptable to the Linux community and makes it
quickly into a published Linux release.

Thanks,

-derek

** drivers/base/core.c
** block/genhd.c
Re-enable non-GPL access to disk partition information

Approved By:  Derek Atkins <warlord@MIT.EDU>


--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment; filename=linux-disk.diff
Content-Description: Diff for re-enabling access to partition information

--- drivers/base/core.c~	2009-03-23 19:12:14.000000000 -0400
+++ drivers/base/core.c	2009-10-16 12:15:57.000000000 -0400
@@ -1200,7 +1200,7 @@
 EXPORT_SYMBOL_GPL(device_del);
 EXPORT_SYMBOL_GPL(device_unregister);
 EXPORT_SYMBOL_GPL(get_device);
-EXPORT_SYMBOL_GPL(put_device);
+EXPORT_SYMBOL(put_device);
 
 EXPORT_SYMBOL_GPL(device_create_file);
 EXPORT_SYMBOL_GPL(device_remove_file);
--- block/genhd.c~	2009-03-23 19:12:14.000000000 -0400
+++ block/genhd.c	2009-10-16 12:18:16.000000000 -0400
@@ -72,7 +72,7 @@
 
 	return part;
 }
-EXPORT_SYMBOL_GPL(disk_get_part);
+EXPORT_SYMBOL(disk_get_part);
 
 /**
  * disk_part_iter_init - initialize partition iterator
@@ -107,7 +107,7 @@
 
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL_GPL(disk_part_iter_init);
+EXPORT_SYMBOL(disk_part_iter_init);
 
 /**
  * disk_part_iter_next - proceed iterator to the next partition and return it
@@ -163,7 +163,7 @@
 
 	return piter->part;
 }
-EXPORT_SYMBOL_GPL(disk_part_iter_next);
+EXPORT_SYMBOL(disk_part_iter_next);
 
 /**
  * disk_part_iter_exit - finish up partition iteration
@@ -179,7 +179,7 @@
 	disk_put_part(piter->part);
 	piter->part = NULL;
 }
-EXPORT_SYMBOL_GPL(disk_part_iter_exit);
+EXPORT_SYMBOL(disk_part_iter_exit);
 
 static inline int sector_in_part(struct hd_struct *part, sector_t sector)
 {

--=-=-=


-- 
       Derek Atkins, SB '93 MIT EE, SM '95 MIT Media Laboratory
       Member, MIT Student Information Processing Board  (SIPB)
       URL: http://web.mit.edu/warlord/    PP-ASEL-IA     N1NWH
       warlord@MIT.EDU                        PGP key available

--=-=-=--
