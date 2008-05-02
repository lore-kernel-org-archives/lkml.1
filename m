Return-Path: <linux-kernel-owner+w=401wt.eu-S1760531AbYEBJOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760531AbYEBJOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 05:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760699AbYEBJO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 05:14:27 -0400
Received: from web52001.mail.re2.yahoo.com ([206.190.49.248]:47473 "HELO
	web52001.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759724AbYEBJO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 05:14:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=Wx8Jz6NvONiNSW9HLMaJjrpjpoSgizYXNMD45qbUmjJmKpb347960Gwya5skKEjiX5kcfAVBlISKVAy9MwWC/nNqlgHMVYzoP66Puk5JTatlpOTZBVkySdxaZ9Wizg2LGo99EM/bdlOzerkx8Ic8H5jUoKFYFqbSEdRw/8BOmI8=;
X-YMail-OSG: Tt2rpVgVM1naqPzoePiI25nRT_dfxtM5hc2gDQVvBSFTfzD_H_jQre.OfxObh9InNyF3vP2RM0BGF2e3o9xIRy7sZfr2wVfv2S78giMsZs6i_z8.ma5U8rrmkQ--
X-Mailer: YahooMailRC/975.23 YahooMailWebService/0.7.185
Date: Fri, 2 May 2008 02:14:25 -0700 (PDT)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: [patch] fs: remove local variable copy of f_pos to enable thread-safe updates
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <91456.70679.qm@web52001.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

Remove local variable copy of f_pos to enable thread-safe updates in
implementation functions of system calls read, readv, write and writev.

Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

---

--- linux-next/fs/fs-read_write.c    2008-05-02 11:54:04.715996700 +0300
+++ linux-2.6/fs/fs-read_write.c    2008-05-02 11:57:17.011641000 +0300
@@ -348,16 +348,6 @@ ssize_t vfs_write(struct file *file, con
 
 EXPORT_SYMBOL(vfs_write);
 
-static inline loff_t file_pos_read(struct file *file)
-{
-    return file->f_pos;
-}
-
-static inline void file_pos_write(struct file *file, loff_t pos)
-{
-    file->f_pos = pos;
-}
-
 asmlinkage ssize_t sys_read(unsigned int fd, char __user * buf, size_t count)
 {
     struct file *file;
@@ -366,10 +356,8 @@ asmlinkage ssize_t sys_read(unsigned int
 
     file = fget_light(fd, &fput_needed);
     if (file) {
-        loff_t pos = file_pos_read(file);
         trace_mark(fs_read, "fd %u count %zu", fd, count);
-        ret = vfs_read(file, buf, count, &pos);
-        file_pos_write(file, pos);
+        ret = vfs_read(file, buf, count, &file->f_pos);
         fput_light(file, fput_needed);
     }
 
@@ -384,10 +372,8 @@ asmlinkage ssize_t sys_write(unsigned in
 
     file = fget_light(fd, &fput_needed);
     if (file) {
-        loff_t pos = file_pos_read(file);
         trace_mark(fs_write, "fd %u count %zu", fd, count);
-        ret = vfs_write(file, buf, count, &pos);
-        file_pos_write(file, pos);
+        ret = vfs_write(file, buf, count, &file->f_pos);
         fput_light(file, fput_needed);
     }
 
@@ -679,10 +665,8 @@ sys_readv(unsigned long fd, const struct
 
     file = fget_light(fd, &fput_needed);
     if (file) {
-        loff_t pos = file_pos_read(file);
         trace_mark(fs_readv, "fd %lu vlen %lu", fd, vlen);
-        ret = vfs_readv(file, vec, vlen, &pos);
-        file_pos_write(file, pos);
+        ret = vfs_readv(file, vec, vlen, &file->f_pos);
         fput_light(file, fput_needed);
     }
 
@@ -701,10 +685,8 @@ sys_writev(unsigned long fd, const struc
 
     file = fget_light(fd, &fput_needed);
     if (file) {
-        loff_t pos = file_pos_read(file);
         trace_mark(fs_writev, "fd %lu vlen %lu", fd, vlen);
-        ret = vfs_writev(file, vec, vlen, &pos);
-        file_pos_write(file, pos);
+        ret = vfs_writev(file, vec, vlen, &file->f_pos);
         fput_light(file, fput_needed);
     }


      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
