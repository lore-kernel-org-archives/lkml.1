Return-Path: <linux-kernel-owner+w=401wt.eu-S1756370AbZDDQac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbZDDQac (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 12:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbZDDQaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 12:30:23 -0400
Received: from tichy.grunau.be ([85.131.189.73]:58501 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbZDDQaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 12:30:23 -0400
Date: Sat, 4 Apr 2009 18:29:54 +0200
From: Janne Grunau <j@jannau.net>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Rees <drees76@gmail.com>, Mark Lord <lkml@rtr.ca>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       tytso@mit.edu, jesper@krogh.cc,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090404162954.GA5170@aniel>
References: <20090403040649.GF3795@csclub.uwaterloo.ca> <alpine.LFD.2.00.0904022112260.4130@localhost.localdomain> <20090403072507.GO5178@kernel.dk> <20090403142129.GH3795@csclub.uwaterloo.ca> <49D625A0.1030202@rtr.ca> <49D66A40.5020503@garzik.org> <20090403212847.GC25887@aniel> <49D68631.4030706@garzik.org> <72dbd3150904031553r3c60a3a5k45f16e0e7513d488@mail.gmail.com> <49D69C1D.50209@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D69C1D.50209@garzik.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 07:30:37PM -0400, Jeff Garzik wrote:
> David Rees wrote:
> > The *only* reason MythTV fsyncs (or fdatasyncs) the data to disk all
> > the time is to keep a large amount of dirty pages from building up and
> > then causing horrible latencies when that data starts getting flushed
> > to disk.
> 
> sync_file_range() will definitely help that situation.

Jeff, could you please try following patch for 0.21 or update to the
latest trunk revision. I don't have a way to reproduce the high
latencies with fdatasync on ext3, data=ordered. Doing a parallel
"dd if=/dev/zero of=file" on the same partition introduces even with
sync_file_range latencies over 1 second.

Janne

---

Index: configure
===================================================================
--- configure	(revision 20302)
+++ configure	(working copy)
@@ -873,6 +873,7 @@
     sdl_video_size
     soundcard_h
     stdint_h
+    sync_file_range
     sys_poll_h
     sys_soundcard_h
     termios_h
@@ -2413,6 +2414,17 @@
 int main( void ) { return (round(3.999f) > 0)?0:1; }
 EOF
 
+# test for sync_file_range (linux only system call since 2.6.17)
+check_ld <<EOF && enable sync_file_range
+#define _GNU_SOURCE
+#include <fcntl.h>
+
+int main(int argc, char **argv){
+    sync_file_range(0,0,0,0);
+    return 0;
+}
+EOF
+
 # test for sizeof(int)
 for sizeof in 1 2 4 8 16; do
     check_cc <<EOF && _sizeof_int=$sizeof && break
Index: libs/libmythtv/ThreadedFileWriter.cpp
===================================================================
--- libs/libmythtv/ThreadedFileWriter.cpp	(revision 20302)
+++ libs/libmythtv/ThreadedFileWriter.cpp	(working copy)
@@ -18,6 +18,7 @@
 #include "ThreadedFileWriter.h"
 #include "mythcontext.h"
 #include "compat.h"
+#include "mythconfig.h"
 
 #if defined(_POSIX_SYNCHRONIZED_IO) && _POSIX_SYNCHRONIZED_IO > 0
 #define HAVE_FDATASYNC
@@ -122,6 +123,7 @@
     // file stuff
     filename(QDeepCopy<QString>(fname)), flags(pflags),
     mode(pmode),                         fd(-1),
+    m_file_sync(0),                      m_file_wpos(0),
     // state
     no_writes(false),                    flush(false),
     in_dtor(false),                      ignore_writes(false),
@@ -154,6 +156,8 @@
         buf = new char[TFW_DEF_BUF_SIZE + 1024];
         bzero(buf, TFW_DEF_BUF_SIZE + 64);
 
+        m_file_sync =  m_file_wpos = 0;
+
         tfw_buf_size = TFW_DEF_BUF_SIZE;
         tfw_min_write_size = TFW_MIN_WRITE_SIZE;
         pthread_create(&writer, NULL, boot_writer, this);
@@ -292,7 +296,22 @@
 {
     if (fd >= 0)
     {
-#ifdef HAVE_FDATASYNC
+#ifdef HAVE_SYNC_FILE_RANGE
+        uint64_t write_position;
+
+        buflock.lock();
+        write_position = m_file_wpos;
+        buflock.unlock();
+
+        if ((write_position - m_file_sync) > TFW_MAX_WRITE_SIZE ||
+            (write_position && m_file_sync < (uint64_t)tfw_min_write_size))
+        {
+            sync_file_range(fd, m_file_sync, write_position - m_file_sync,
+                            SYNC_FILE_RANGE_WRITE);
+            m_file_sync = write_position;
+        }
+
+#elif defined(HAVE_FDATASYNC)
         fdatasync(fd);
 #else
         fsync(fd);
@@ -414,6 +433,7 @@
 
         buflock.lock();
         rpos = (rpos + size) % tfw_buf_size;
+        m_file_wpos += size;
         buflock.unlock();
 
         bufferWroteData.wakeAll();
Index: libs/libmythtv/ThreadedFileWriter.h
===================================================================
--- libs/libmythtv/ThreadedFileWriter.h	(revision 20302)
+++ libs/libmythtv/ThreadedFileWriter.h	(working copy)
@@ -40,6 +40,8 @@
     int             flags;
     mode_t          mode;
     int             fd;
+    uint64_t        m_file_sync;  ///< offset synced to disk
+    uint64_t        m_file_wpos; ///< offset written to disk
 
     // state
     bool            no_writes;
