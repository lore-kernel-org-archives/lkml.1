Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab0BVOmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 09:42:46 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:41139 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab0BVOmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 09:42:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=niYz02emujVKXrDRLI+vyS/c1aDnzx6eOp5e1q/PO5f0G6nRoGsV4VF4/y+I5MHT8m
         U2NFjQ8/SfYawEp0nG++usJ93pc9/GoX3Y3emoV/Gesgcfe0jaZxuM+SdE/U4R5GpL2R
         AR+ymzUS4aClxq1jzM7ePo72QNY8uYGGoR2b8=
Message-ID: <4B8297D9.2080000@gmail.com>
Date: Mon, 22 Feb 2010 22:42:33 +0800
From: Hui Zhu <teawater@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, ozan@pardus.org.tr,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org,
       gdb-patches ml <gdb-patches@sourceware.org>,
       Michal Marek <mmarek@suse.cz>
Subject: [PATCH 2/2] markup_oops.pl and GDB: GDB: make it can show gdb command
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add a new target empty which level is same with corelow
target. It can save the memory and reg operation command's value and
send it to GDB as the inferior's value.
"target empty" to use this target.

2010-02-22  Hui Zhu  <teawater@gmail.com>

	* Makefile.in (SFILES): Add empty.c.
	(COMMON_OBS): Add empty.o
	* empty.c: New file.
---
 Makefile.in |    3 
 empty.c     |  296 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 298 insertions(+), 1 deletion(-)

--- a/Makefile.in
+++ b/Makefile.in
@@ -688,6 +688,7 @@ SFILES = ada-exp.y ada-lang.c ada-typepr
 	record.c gcore.c \
 	jit.c \
 	xml-syscall.c \
+	empty.c
 
 LINTFILES = $(SFILES) $(YYFILES) $(CONFIG_SRCS) init.c
 
@@ -839,7 +840,7 @@ COMMON_OBS = $(DEPFILES) $(CONFIG_OBS) $
 	prologue-value.o memory-map.o xml-support.o xml-syscall.o \
 	target-descriptions.o target-memory.o xml-tdesc.o xml-builtin.o \
 	inferior.o osdata.o gdb_usleep.o record.o gcore.o \
-	jit.o progspace.o
+	jit.o progspace.o empty.o
 
 # Definitions for the syscall's XML files and dir
 XML_SYSCALLS_DIR = syscalls/
--- /dev/null
+++ b/empty.c
@@ -0,0 +1,296 @@
+/* Empty target for GDB, the GNU debugger.
+
+   Copyright (C) 2010 Free Software Foundation, Inc.
+
+   This file is part of GDB.
+
+   This program is free software; you can redistribute it and/or modify
+   it under the terms of the GNU General Public License as published by
+   the Free Software Foundation; either version 3 of the License, or
+   (at your option) any later version.
+
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */
+
+#include "defs.h"
+#include "gdbcmd.h"
+#include "regcache.h"
+#include "gdbthread.h"
+#include "event-top.h"
+#include "exceptions.h"
+#include "completer.h"
+#include "arch-utils.h"
+#include "gdbcore.h"
+#include "exec.h"
+#include "record.h"
+#include "elf-bfd.h"
+#include "gcore.h"
+
+#define EMPTY_PID	1
+
+static struct target_ops empty_ops;
+
+static gdb_byte *empty_regbuf = NULL;
+
+struct empty_mem_list_s
+{
+  struct empty_mem_list_s *prev;
+  struct empty_mem_list_s *next;
+  ULONGEST begin;
+  ULONGEST end;
+  gdb_byte *buf;
+};
+
+static struct empty_mem_list_s *empty_mem_list = NULL;
+
+static void
+empty_open (char *arg, int from_tty)
+{
+  int regnum = gdbarch_num_regs (get_current_arch ());
+
+  empty_regbuf = xzalloc (MAX_REGISTER_SIZE * regnum);
+
+  push_target (&empty_ops);
+
+  inferior_ptid = pid_to_ptid (EMPTY_PID);
+  inferior_appeared (current_inferior (), EMPTY_PID);
+  add_thread_silent (inferior_ptid);
+}
+
+static void
+empty_close (int quitting)
+{
+  struct empty_mem_list_s *mlp;
+
+  for (mlp = empty_mem_list; mlp;)
+    {
+      struct empty_mem_list_s *tmp = mlp;
+
+      mlp = mlp->next;
+      xfree (tmp->buf);
+      xfree (tmp);
+    }
+
+  if (empty_regbuf)
+    {
+      xfree (empty_regbuf);
+      empty_regbuf = NULL;
+    }
+}
+
+static void
+empty_kill (struct target_ops *ops)
+{
+  unpush_target (ops);
+}
+
+static void
+empty_fetch_registers (struct target_ops *ops,
+                       struct regcache *regcache, int regno)
+{
+  if (regno < 0)
+    {
+      int num = gdbarch_num_regs (get_regcache_arch (regcache));
+      int i;
+
+      for (i = 0; i < num; i ++)
+        regcache_raw_supply (regcache, i,
+                             empty_regbuf + MAX_REGISTER_SIZE * i);
+    }
+  else
+    regcache_raw_supply (regcache, regno,
+                         empty_regbuf + MAX_REGISTER_SIZE * regno);
+}
+
+static void
+empty_prepare_to_store (struct regcache *regcache)
+{
+}
+
+static void
+empty_store_registers (struct target_ops *ops,
+                        struct regcache *regcache, int regno)
+{
+  regcache_raw_collect (regcache, regno,
+                        empty_regbuf + MAX_REGISTER_SIZE * regno);
+}
+
+static LONGEST
+empty_xfer_partial (struct target_ops *ops, enum target_object object,
+		    const char *annex, gdb_byte *readbuf,
+		    const gdb_byte *writebuf, ULONGEST offset,
+                    LONGEST len)
+{
+  struct empty_mem_list_s *mlp;
+
+  if (ops->beneath != NULL)
+    {
+      if (ops->beneath->to_xfer_partial (ops->beneath, object, annex,
+                                         readbuf, writebuf, offset, len) == len)
+        return len;
+    }
+
+  if (readbuf)
+    {
+      memset (readbuf, 0, len);
+
+      for (mlp = empty_mem_list; mlp; mlp = mlp->next)
+        {
+          ULONGEST wbegin = 0;
+          ULONGEST wend = 0;
+
+          if (mlp->begin >= offset && mlp->begin <= offset + len)
+            {
+              wbegin = offset;
+
+              if (mlp->end > offset + len)
+                wend = offset + len;
+              else
+                wend = mlp->end;
+            }
+          else if (mlp->end >= offset && mlp->end <= offset + len)
+            {
+              wend = offset + len;
+
+              if (mlp->begin > offset)
+                wbegin = mlp->begin;
+              else
+                wbegin = offset;
+            }
+          else if (mlp->begin < offset && mlp->end > offset +len)
+            {
+              wbegin = offset;
+              wend = offset + len;
+            }
+
+          if (wbegin != wend)
+            memcpy (readbuf + wbegin - offset,
+                    mlp->buf + wbegin - mlp->begin, wend - wbegin);
+        }
+    }
+  else
+    {
+      struct empty_mem_list_s *mlp_new = NULL;
+      struct empty_mem_list_s *mlp_head = NULL, *mlp_tail = NULL;
+      struct empty_mem_list_s *mlp_bodycore = NULL;
+      struct empty_mem_list_s *mlp_bodyhead = NULL, *mlp_bodytail = NULL;
+      ULONGEST begin = offset, end = offset +len;
+      gdb_byte *buf;
+
+      /* Get mlp_head, mlp_tail, mlp_bodyhead, mlp_bodytail, begin, end.  */
+      for (mlp = empty_mem_list; mlp; mlp = mlp->next)
+        {
+          if (mlp->end < begin)
+            mlp_head = mlp;
+          else if (begin >= mlp->begin && end <= mlp->end)
+            {
+              mlp_bodycore = mlp;
+              break;
+            }
+          else if ((mlp->begin >= begin && mlp->begin <= end)
+                   || (mlp->end >= begin && mlp->end <= end)
+                   || (mlp->begin < begin && mlp->end > end))
+            {
+              if (mlp_bodyhead)
+                mlp_bodytail = mlp;
+              else
+                {
+                  mlp_bodyhead = mlp;
+                  mlp_bodytail = mlp;
+                }
+              if (mlp->begin < begin)
+                begin = mlp->begin;
+              if (mlp->begin > end)
+                end = mlp->end;
+            }
+          else if (end < mlp->begin)
+            {
+              mlp_tail = mlp;
+              break;
+            }
+        }
+
+      if (mlp_bodycore)
+        {
+          memcpy (mlp_bodycore->buf + begin - mlp_bodycore->begin, writebuf, len);
+        }
+      else
+        {
+          mlp_new = xmalloc (sizeof (struct empty_mem_list_s));
+          mlp_new->begin = begin;
+          mlp_new->end = end;
+          mlp_new->buf = xzalloc (end - begin);
+
+          /* Write the mlp_body value to mlp_new and release mlp_body.  */
+          for (mlp = mlp_bodyhead; mlp && mlp->prev != mlp_bodytail;)
+            {
+              struct empty_mem_list_s *tmp = mlp;
+
+              mlp = mlp->next;
+              memcpy (mlp_new->buf + tmp->begin - begin, tmp->buf, tmp->end - tmp->begin);
+              xfree (tmp->buf);
+              xfree (tmp);
+            }
+
+          /* Write the new value to mlp_new. */
+          memcpy (mlp_new->buf + offset - begin, writebuf, len);
+
+          /* Add mlp_new to list.  */
+          mlp_new->prev = mlp_head;
+          mlp_new->next = mlp_tail;
+          if (mlp_head)
+            mlp_head->next = mlp_new;
+          if (mlp_tail)
+            mlp_tail->prev = mlp_new;
+          if (!mlp_new->prev)
+            empty_mem_list = mlp_new;
+        }
+
+        reinit_frame_cache ();
+    }
+
+  return len;
+}
+
+static int
+ignore (struct gdbarch *gdbarch, struct bp_target_info *bp_tgt)
+{
+  return 0;
+}
+
+static void
+init_empty_ops (void)
+{
+  empty_ops.to_shortname = "empty";
+  empty_ops.to_longname = "Empty target";
+  empty_ops.to_doc = "Empty target";
+  empty_ops.to_open = empty_open;
+  empty_ops.to_close = empty_close;
+  empty_ops.to_attach = find_default_attach;
+  empty_ops.to_kill = empty_kill;
+  empty_ops.to_fetch_registers = empty_fetch_registers;
+  empty_ops.to_prepare_to_store = empty_prepare_to_store;
+  empty_ops.to_store_registers = empty_store_registers;
+  empty_ops.to_xfer_partial = empty_xfer_partial;
+  empty_ops.to_insert_breakpoint = ignore;
+  empty_ops.to_remove_breakpoint = ignore;
+  empty_ops.to_create_inferior = find_default_create_inferior;
+  empty_ops.to_stratum = core_stratum;
+  empty_ops.to_has_execution = default_child_has_execution;
+  empty_ops.to_has_memory = default_child_has_memory;
+  empty_ops.to_has_stack = default_child_has_stack;
+  empty_ops.to_has_registers = default_child_has_registers;
+  empty_ops.to_magic = OPS_MAGIC;
+}
+
+void
+_initialize_empty (void)
+{
+  init_empty_ops ();
+  add_target (&empty_ops);
+}

