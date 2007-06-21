Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbXFULSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbXFULSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 07:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbXFULSC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 07:18:02 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:25465 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbXFULSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 07:18:00 -0400
Message-ID: <467A5E36.9030904@de.ibm.com>
Date: Thu, 21 Jun 2007 13:17:10 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Yan Zheng <yanzheng@21cn.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG?]Set XIP mount option on ext2 bypass check.
References: <4679A58C.2080008@21cn.com> <3d0408630706201840o5b1c2454n75d1ebbd26d660d6@mail.gmail.com>
In-Reply-To: <3d0408630706201840o5b1c2454n75d1ebbd26d660d6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yan Zheng wrote:
> I mount an ext2 fs , then remount it with xip option set.
> I get message below when do write operation in the fs.
Ouch. Like on mount, we should refuse -o xip on remount. The patch 
below fixes this issue.

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
---
Index: linux-2.6.22-rc4-mm/fs/ext2/super.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/fs/ext2/super.c
+++ linux-2.6.22-rc4-mm/fs/ext2/super.c
@@ -1071,6 +1071,9 @@ static int ext2_remount (struct super_bl
  	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
  		((sbi->s_mount_opt & EXT2_MOUNT_POSIX_ACL) ? MS_POSIXACL : 0);

+	ext2_xip_verify_sb(sb); /* see if bdev supports xip, unset
+				    EXT2_MOUNT_XIP if not */
+
  	es = sbi->s_es;
  	if (((sbi->s_mount_opt & EXT2_MOUNT_XIP) !=
  	    (old_mount_opt & EXT2_MOUNT_XIP)) &&
