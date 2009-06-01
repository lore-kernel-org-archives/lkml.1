Return-Path: <linux-kernel-owner+w=401wt.eu-S1759905AbZFAV7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905AbZFAV7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759003AbZFAV4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:56:01 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:61789 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759151AbZFAVz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:55:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=fvoamF0Z36np/nAHPlNLpXDbq5VR6sYrwKu19wfzmr8JYKe4HJyXk53cWtGSzmrrVx
         VSOZAZQq9vZni8EQmqxfezyo2bUjjswLru/7lASjwUVFl1bzAQJU9IrZTcMlrp/Rn8zo
         Jk8orNFcSHTN/t1bAAqsl6Sot223svJStktYQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: Re: [PATCH 4/4] ide: preserve Host Protected Area by default
Date: Mon, 1 Jun 2009 23:33:23 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc7-next-20090601-06903-gd651475-dirty; KDE/4.2.3; i686; ; )
Cc: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Frans Pop <elendil@planet.nl>
References: <20090531143911.7164.26834.sendpatchset@localhost.localdomain> <20090531143939.7164.82399.sendpatchset@localhost.localdomain>
In-Reply-To: <20090531143939.7164.82399.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906012333.29159.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 May 2009 16:39:39 Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: preserve Host Protected Area by default
> 
> From the perspective of most users of recent systems, disabling Host
> Protected Area (HPA) can break vendor RAID formats, GPT partitions and
> risks corrupting firmware or overwriting vendor system recovery tools.
> 
> Unfortunately the original (kernels < 2.6.30) behavior (unconditionally
> disabling HPA and using full disk capacity) was introduced at the time
> when the main use of HPA was to make the drive look small enough for the
> BIOS to allow the system to boot with large capacity drives.
> 
> Thus to allow the maximum compatibility with the existing setups (using
> HPA and partitioned with HPA disabled) we automatically disable HPA if
> any partitions overlapping HPA are detected.  Additionally HPA can also
> be disabled using the "nohpa" module parameter (i.e. "ide_core.nohpa=0.0"
> to disable HPA on /dev/hda).
> 
> While at it:
> - remove stale "idebus=" entry from Documentation/kernel-parameters.txt
> 
> Cc: Robert Hancock <hancockrwd@gmail.com>
> Cc: Frans Pop <elendil@planet.nl>
> Cc: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> [patch description was based on input from Alan Cox and Frans Pop]
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

v2 interdiff

v2:
Fix ->resume HPA support.
---
 ide-disk.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -u b/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
--- b/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -433,8 +433,11 @@
 		goto out;
 
 	set = ide_disk_hpa_set_capacity(drive, set, lba48);
-	if (set)
+	if (set) {
+		/* needed for ->resume to disable HPA */
+		drive->dev_flags |= IDE_DFLAG_NOHPA;
 		return set;
+	}
 out:
 	return drive->capacity64;
 }
