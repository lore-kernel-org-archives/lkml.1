Return-Path: <linux-kernel-owner+w=401wt.eu-S1762177AbXJSLbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762177AbXJSLbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 07:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbXJSLb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 07:31:28 -0400
Received: from hall.aurel32.net ([88.191.38.19]:60500 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbXJSLb1 (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 07:31:27 -0400
Message-ID: <47189585.5010901@aurel32.net>
Date: Fri, 19 Oct 2007 13:31:17 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: carsteno@de.ibm.com
CC: "kvm-devel@lists.sourceforge.net" <kvm-devel@lists.sourceforge.net>,
       Linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] severe bug in 2.6.23+ kvm.git
References: <47189371.7080104@de.ibm.com>
In-Reply-To: <47189371.7080104@de.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------040802010607020907040908"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040802010607020907040908
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Carsten Otte a écrit :
> Hi list,
> 
> we've experienced a severe bug in current kvm.git, that may have been 
> introduced to the git tree quite recently around last weekend. 2.6.23 
> is broken, 2.6.23-rc8 works for us. The symptom is, that our operon 
> kvm test machine shredders its hard disk content to a state that is 
> not correctably by the file system checker. We use raid1 md mirrored 
> ext3 file systems on 4 sata hard disks on it, and we've verified 
> correct operation of the hardware via badblocks and memtest86.
> The problem occurs even without kvm modules loaded, so the cause seems 
> to be something that Avi pulled elsewhere. Did anyone else experience 
> similar problems with the 2.6.23 based kvm tree? Does anyone have an 
> idea about a possible cause, which would help us debugging it?
> 

Could you please precise what is corrupted? The guest disk image?

If that's the case, I experienced the same problem since
kvm-userspace.git has been updated to the latest qemu CVS, and I can
reproduce it with plain QEMU. I am able to reproduce it easily by
booting FreeBSD.

The problem is actually in QEMU, it has been broken by this commit:
http://cvs.savannah.nongnu.org/viewvc/qemu/hw/ide.c?root=qemu&r1=1.64&r2=1.65

You can try to apply the attached patch, it reverts this commit and can
be applied to the latest QEMU CVS and to the latest KVM versions.

-- 
  .''`.  Aurelien Jarno	            | GPG: 1024D/F1BCDB73
 : :' :  Debian developer           | Electrical Engineer
 `. `'   aurel32@debian.org         | aurelien@aurel32.net
   `-    people.debian.org/~aurel32 | www.aurel32.net

--------------040802010607020907040908
Content-Type: text/x-patch;
 name="qemu-ide-corruption.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="qemu-ide-corruption.diff"

Index: hw/ide.c
===================================================================
RCS file: /sources/qemu/qemu/hw/ide.c,v
retrieving revision 1.69
diff -u -r1.69 ide.c
--- hw/ide.c	17 Sep 2007 08:09:47 -0000	1.69
+++ hw/ide.c	10 Oct 2007 17:55:33 -0000
@@ -865,44 +865,10 @@
     ide_set_irq(s);
 }
 
-static void ide_sector_write_aio_cb(void *opaque, int ret)
-{
-    BMDMAState *bm = opaque;
-    IDEState *s = bm->ide_if;
-
-#ifdef TARGET_I386
-    if (win2k_install_hack && ((++s->irq_count % 16) == 0)) {
-	/* It seems there is a bug in the Windows 2000 installer HDD
-	   IDE driver which fills the disk with empty logs when the
-	   IDE write IRQ comes too early. This hack tries to correct
-	   that at the expense of slower write performances. Use this
-	   option _only_ to install Windows 2000. You must disable it
-	   for normal use. */
-	qemu_mod_timer(s->sector_write_timer,
-		       qemu_get_clock(vm_clock) + (ticks_per_sec / 1000));
-    } else
-#endif
-    {
-	ide_set_irq(s);
-    }
-    bm->aiocb = NULL;
-}
-
 static void ide_sector_write(IDEState *s)
 {
-    BMDMAState *bm;
     int64_t sector_num;
-    int n, n1;
-
-    s->io_buffer_index = 0;
-    s->io_buffer_size = 0;
-    bm = s->bmdma;
-    if(bm == NULL) {
-	bm = qemu_mallocz(sizeof(BMDMAState));
-	s->bmdma = bm;
-    }
-    bm->ide_if = s;
-    bm->dma_cb = ide_sector_write_aio_cb;
+    int ret, n, n1;
 
     s->status = READY_STAT | SEEK_STAT;
     sector_num = ide_get_sector(s);
@@ -912,6 +878,7 @@
     n = s->nsector;
     if (n > s->req_nb_sectors)
         n = s->req_nb_sectors;
+    ret = bdrv_write(s->bs, sector_num, s->io_buffer, n);
     s->nsector -= n;
     if (s->nsector == 0) {
         /* no more sectors to write */
@@ -924,8 +891,21 @@
     }
     ide_set_sector(s, sector_num + n);
 
-    bm->aiocb = bdrv_aio_write(s->bs, sector_num, s->io_buffer, n,
-			       ide_sector_write_aio_cb, bm);
+#ifdef TARGET_I386
+    if (win2k_install_hack && ((++s->irq_count % 16) == 0)) {
+        /* It seems there is a bug in the Windows 2000 installer HDD
+           IDE driver which fills the disk with empty logs when the
+           IDE write IRQ comes too early. This hack tries to correct
+           that at the expense of slower write performances. Use this
+           option _only_ to install Windows 2000. You must disable it
+           for normal use. */
+        qemu_mod_timer(s->sector_write_timer, 
+                       qemu_get_clock(vm_clock) + (ticks_per_sec / 1000));
+    } else 
+#endif
+    {
+        ide_set_irq(s);
+    }
 }
 
 /* XXX: handle errors */

--------------040802010607020907040908--
