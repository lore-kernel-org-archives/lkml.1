Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbZBHMgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbZBHMgt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 07:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbZBHMgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 07:36:38 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:50659 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbZBHMgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 07:36:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=ZCZYYmY0FNmzBZQHPqt68Nsy55JhDQDqwrzhzA5oTJZaKavuZDuC+g8CxC/PKWI0R8
         Hsx3qSyFO2rAAuR20M1s8kpp5EBgZvlxqKoYCv5fisCuzXjKVdytg6Tb+vqs1scl2mQo
         /1DcOBY86CBxh7tQ7l/eggX1XZSYChYmpVvlU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 09/15] ide: add "flagged" taskfile flags to struct ide_taskfile
Date: Sun, 8 Feb 2009 12:38:18 +0100
User-Agent: KMail/1.10.4 (Linux/2.6.29-rc3-next-20090206; KDE/4.1.4; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090201174909.19144.67767.sendpatchset@localhost.localdomain> <20090201175012.19144.87417.sendpatchset@localhost.localdomain> <20090206170425.201346e6.sfr@canb.auug.org.au>
In-Reply-To: <20090206170425.201346e6.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902081238.18970.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday 06 February 2009, Stephen Rothwell wrote:
> Hi Bart,
> 
> On Sun, 01 Feb 2009 18:50:12 +0100 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> >
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] ide: add "flagged" taskfile flags to struct ide_taskfile
> > 
> > * Add ->ftf_flags field to struct ide_taskfile
> >   and convert flags for TASKFILE ioctl to use it.
> > 
> > * Rename "flagged" taskfile flags:
> >   - IDE_TFLAG_FLAGGED -> IDE_FTFLAG_FLAGGED
> 
> There were several places where this transformation did not take place as
> shown by today's linux-next build.

Thanks, it is now fixed with v2 of the patch, interdiff below:

...
v2:
* Remember to fully update ide-h8300.c, scc_pata.c and tx493{8,9}ide.c
  (thanks to Stephen Rothwell for noticing).

There should be no functional changes caused by this patch.

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
...
diff -u b/drivers/ide/ide-h8300.c b/drivers/ide/ide-h8300.c
--- b/drivers/ide/ide-h8300.c
+++ b/drivers/ide/ide-h8300.c
@@ -51,7 +51,7 @@
 	struct ide_taskfile *tf = &task->tf;
 	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
 
-	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+	if (task->ftf_flags & IDE_FTFLAG_FLAGGED)
 		HIHI = 0xFF;
 
 	if (task->ftf_flags & IDE_FTFLAG_OUT_DATA)
diff -u b/drivers/ide/scc_pata.c b/drivers/ide/scc_pata.c
--- b/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -672,7 +672,7 @@
 	struct ide_taskfile *tf = &task->tf;
 	u8 HIHI = (task->tf_flags & IDE_TFLAG_LBA48) ? 0xE0 : 0xEF;
 
-	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+	if (task->ftf_flags & IDE_FTFLAG_FLAGGED)
 		HIHI = 0xFF;
 
 	if (task->ftf_flags & IDE_FTFLAG_OUT_DATA)
diff -u b/drivers/ide/tx4938ide.c b/drivers/ide/tx4938ide.c
--- b/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -89,7 +89,7 @@
 	struct ide_taskfile *tf = &task->tf;
 	u8 HIHI = task->tf_flags & IDE_TFLAG_LBA48 ? 0xE0 : 0xEF;
 
-	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+	if (task->ftf_flags & IDE_FTFLAG_FLAGGED)
 		HIHI = 0xFF;
 
 	if (task->ftf_flags & IDE_FTFLAG_OUT_DATA) {
diff -u b/drivers/ide/tx4939ide.c b/drivers/ide/tx4939ide.c
--- b/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -474,7 +474,7 @@
 	struct ide_taskfile *tf = &task->tf;
 	u8 HIHI = task->tf_flags & IDE_TFLAG_LBA48 ? 0xE0 : 0xEF;
 
-	if (task->tf_flags & IDE_TFLAG_FLAGGED)
+	if (task->ftf_flags & IDE_FTFLAG_FLAGGED)
 		HIHI = 0xFF;
 
 	if (task->ftf_flags & IDE_FTFLAG_OUT_DATA) {

