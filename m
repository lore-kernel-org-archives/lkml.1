Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068AbYLKLJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbYLKLJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 06:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916AbYLKLI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 06:08:58 -0500
Received: from brick.kernel.dk ([93.163.65.50]:2641 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708AbYLKLI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 06:08:57 -0500
Date: Thu, 11 Dec 2008 12:08:39 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Fix LSF default inconsistency
Message-ID: <20081211110839.GH23742@kernel.dk>
References: <20081211111614.493d2a62@hyperion.delvare> <20081211104109.GF23742@kernel.dk> <20081211115844.1b1dbf49@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211115844.1b1dbf49@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11 2008, Jean Delvare wrote:
> On Thu, 11 Dec 2008 11:41:10 +0100, Jens Axboe wrote:
> > On Thu, Dec 11 2008, Jean Delvare wrote:
> > > Configuration option LSF has a default which contradicts its help
> > > text. The help text says "if unsure, say Y" but there is no explicit
> > > default, and the default default is N.
> > > 
> > > This inconsistency was introduced by commit
> > > 88b9adb073b7a69a54b1b14423103bc24587ebdc. According to the commit
> > > message, we want users to enable this option, so it should default to
> > > Y.
> > 
> > I wonder if we just shouldn't get rid of this option and just have the
> > single CONFIG_LBD option control both of these. If you set CONFIG_LBD,
> > you probably want large files as well. And CONFIG_LSF without CONFIG_LBD
> > doesn't make a lot of sense.
> > 
> > Would anyone object to such a change?
> 
> No objection from me, getting rid of configuration options almost
> always gets my vote :)

Yeah, mine too. One recent addition was CONFIG_UNEVICTABLE_LRU - why on
earth is that an option?!

Anyway, how about something like this? Totally untested...

diff --git a/block/Kconfig b/block/Kconfig
index 1ab7c15..ce566dd 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -24,21 +24,18 @@ menuconfig BLOCK
 if BLOCK
 
 config LBD
-	bool "Support for Large Block Devices"
+	bool "Support for Large Block Devices and files"
 	depends on !64BIT
+	select LSF
 	help
-	  Enable block devices of size 2TB and larger.
+	  Enable block devices or files of size 2TB and larger.
 
 	  This option is required to support the full capacity of large
 	  (2TB+) block devices, including RAID, disk, Network Block Device,
 	  Logical Volume Manager (LVM) and loopback.
-
-	  For example, RAID devices are frequently bigger than the capacity
-	  of the largest individual hard drive.
-
-	  This option is not required if you have individual disk drives
-	  which total 2TB+ and you are not aggregating the capacity into
-	  a large block device (e.g. using RAID or LVM).
+	
+	  This option also enables support for single files larger than
+	  2TB.
 
 	  If unsure, say N.
 
@@ -57,15 +54,6 @@ config BLK_DEV_IO_TRACE
 
 	  If unsure, say N.
 
-config LSF
-	bool "Support for Large Single Files"
-	depends on !64BIT
-	help
-	  Say Y here if you want to be able to handle very large files (2TB
-	  and larger), otherwise say N.
-
-	  If unsure, say Y.
-
 config BLK_DEV_BSG
 	bool "Block layer SG support v4 (EXPERIMENTAL)"
 	depends on EXPERIMENTAL

-- 
Jens Axboe

