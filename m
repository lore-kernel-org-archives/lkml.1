Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbZGCMY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbZGCMY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZGCMYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:24:48 -0400
Received: from mail.samba.org ([66.70.73.150]:45054 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbZGCMYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:24:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19021.63615.450348.192109@samba.org>
Date: Fri, 3 Jul 2009 22:24:31 +1000
To: Jan Engelhardt <jengelh@medozas.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Theodore Tso <tytso@mit.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <alpine.LSU.2.00.0907031121250.16093@fbirervta.pbzchgretzou.qr>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<200907012019.53932.rusty@rustcorp.com.au>
	<20090701122558.3a7c80d3@lxorguk.ukuu.org.uk>
	<20090701140503.GA21185@mit.edu>
	<alpine.LSU.2.00.0907030056210.17183@fbirervta.pbzchgretzou.qr>
	<alpine.LSU.2.00.0907030134291.17183@fbirervta.pbzchgretzou.qr>
	<19021.19842.663727.146474@samba.org>
	<87hbxu60qm.fsf@devron.myhome.or.jp>
	<19021.23231.213863.726785@samba.org>
	<alpine.LSU.2.00.0907030347210.24650@fbirervta.pbzchgretzou.qr>
	<19021.26102.80885.330380@samba.org>
	<alpine.LSU.2.00.0907030403330.26905@fbirervta.pbzchgretzou.qr>
	<19021.31291.642416.956966@samba.org>
	<alpine.LSU.2.00.0907031121250.16093@fbirervta.pbzchgretzou.qr>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

 > Right. That in itself is fine, but I'd still like to have readdir
 > return lowercase names here then.

you are in luck!

It just so happens that this is what happens when we use the patch
that Hirofumi and I just agreed on (ie. the case handling part of my
patch from May, combined with the current patch). 

I include it below. Can you please test it? It should be applied on
top of the previous patch. Note that you will not need to specify
shortname=winnt. In fact, if you don't specify any special options and
let the kernel default then you will get the behaviour you just
described.

Hirofumi-san, can you have a look at this too and see if it is how you
want to handle it? I built the patch against your fatfs-2.6 tree.

Cheers, Tridge

>From 244a8ebe72288a261e68b5aea04a86793a2f11f4 Mon Sep 17 00:00:00 2001
From: Andrew Tridgell <tridge@samba.org>
Date: Fri, 3 Jul 2009 22:15:02 +1000
Subject: [PATCH] Force case handling when dualnames are disabled for greater compatibility

When CONFIG_VFAT_FS_DUALNAMES is not set and a 8.3 name is created,
force the use of the shortname=winnt option to allow for lowercase or
uppercase prefix and extensions without using a long name.

Signed-off-by: Andrew Tridgell <tridge@samba.org>
---
 fs/fat/namei_vfat.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 894f44d..9555a46 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -317,6 +317,11 @@ static int vfat_create_shortname(struct inode *dir, struct nls_table *nls,
 	int sz = 0, extlen, baselen, i, numtail_baselen, numtail2_baselen;
 	int is_shortname;
 	struct shortname_info base_info, ext_info;
+	unsigned opts_shortname = opts->shortname;
+
+#ifndef CONFIG_VFAT_FS_DUALNAMES
+	opts_shortname = VFAT_SFN_CREATE_WINNT;
+#endif
 
 	is_shortname = 1;
 	INIT_SHORTNAME_INFO(&base_info);
@@ -429,9 +434,9 @@ static int vfat_create_shortname(struct inode *dir, struct nls_table *nls,
 		if (vfat_find_form(dir, name_res) == 0)
 			return -EEXIST;
 
-		if (opts->shortname & VFAT_SFN_CREATE_WIN95) {
+		if (opts_shortname & VFAT_SFN_CREATE_WIN95) {
 			return (base_info.upper && ext_info.upper);
-		} else if (opts->shortname & VFAT_SFN_CREATE_WINNT) {
+		} else if (opts_shortname & VFAT_SFN_CREATE_WINNT) {
 			if ((base_info.upper || base_info.lower) &&
 			    (ext_info.upper || ext_info.lower)) {
 				if (!base_info.upper && base_info.lower)
-- 
1.6.0.4

