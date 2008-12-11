Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbYLKMus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbYLKMus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 07:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbYLKMuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 07:50:20 -0500
Received: from brick.kernel.dk ([93.163.65.50]:6079 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216AbYLKMuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 07:50:19 -0500
Date: Thu, 11 Dec 2008 13:50:01 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Fix LSF default inconsistency
Message-ID: <20081211125000.GL23742@kernel.dk>
References: <20081211111614.493d2a62@hyperion.delvare> <20081211104109.GF23742@kernel.dk> <20081211115844.1b1dbf49@hyperion.delvare> <20081211110839.GH23742@kernel.dk> <20081211134438.6d871834@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211134438.6d871834@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11 2008, Jean Delvare wrote:
> Hi Jens,
> 
> On Thu, 11 Dec 2008 12:08:39 +0100, Jens Axboe wrote:
> > Anyway, how about something like this? Totally untested...
> > 
> > diff --git a/block/Kconfig b/block/Kconfig
> > index 1ab7c15..ce566dd 100644
> > --- a/block/Kconfig
> > +++ b/block/Kconfig
> > @@ -24,21 +24,18 @@ menuconfig BLOCK
> >  if BLOCK
> >  
> >  config LBD
> > -	bool "Support for Large Block Devices"
> > +	bool "Support for Large Block Devices and files"
> >  	depends on !64BIT
> > +	select LSF
> 
> You can't select something...
> 
> >  	help
> > -	  Enable block devices of size 2TB and larger.
> > +	  Enable block devices or files of size 2TB and larger.
> >  
> >  	  This option is required to support the full capacity of large
> >  	  (2TB+) block devices, including RAID, disk, Network Block Device,
> >  	  Logical Volume Manager (LVM) and loopback.
> > -
> > -	  For example, RAID devices are frequently bigger than the capacity
> > -	  of the largest individual hard drive.
> > -
> > -	  This option is not required if you have individual disk drives
> > -	  which total 2TB+ and you are not aggregating the capacity into
> > -	  a large block device (e.g. using RAID or LVM).
> > +	
> > +	  This option also enables support for single files larger than
> > +	  2TB.
> >  
> >  	  If unsure, say N.
> >  
> > @@ -57,15 +54,6 @@ config BLK_DEV_IO_TRACE
> >  
> >  	  If unsure, say N.
> >  
> > -config LSF
> 
> ... that no longer exists. You must either leave the config LSF as a
> bool with no label and no help file, or drop it altogether and replace
> all occurrences of CONFIG_LSF in the kernel source with CONFIG_LBD.

Oh right, that's pretty dumb. Lets just do the former, then a later
patch can replace it completely if wanted.

diff --git a/block/Kconfig b/block/Kconfig
index 1ab7c15..a785e65 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -23,22 +23,22 @@ menuconfig BLOCK
 
 if BLOCK
 
+config LSF
+	bool
+
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
 
@@ -57,15 +57,6 @@ config BLK_DEV_IO_TRACE
 
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

