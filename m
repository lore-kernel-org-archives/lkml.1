Return-Path: <linux-kernel-owner+w=401wt.eu-S1752991Ab0ANOX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab0ANOX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 09:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771Ab0ANOXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 09:23:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34269 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab0ANOXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 09:23:24 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/2] perf tools: Cross platform perf.data analysis support
Date: Thu, 14 Jan 2010 12:23:10 -0200
Message-Id: <1263478990-8200-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1263478990-8200-1-git-send-email-acme@infradead.org>
References: <1263478990-8200-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

There are still some problems related to loading vmlinux files, but those are
unrelated to the feature implemented in this patch, so will get fixed in the
next patches, but here are some results:

1. collect perf.data file on a Fedora 12 machine, x86_64, 64-bit userland

2. transfer it to a Debian Testing machine, PARISC64, 32-bit userland

  acme@parisc:~/git/linux-2.6-tip$ perf buildid-list | head -5
  74f9930ee94475b6b3238caf3725a50d59cb994b [kernel.kallsyms]
  55fdd56670453ea66c011158c4b9d30179c1d049 /lib/modules/2.6.33-rc4-tip+/kernel/net/ipv4/netfilter/ipt_MASQUERADE.ko
  41adff63c730890480980d5d8ba513f1c216a858 /lib/modules/2.6.33-rc4-tip+/kernel/net/ipv4/netfilter/iptable_nat.ko
  90a33def1077bb8e97b8a78546dc96c2de62df46 /lib/modules/2.6.33-rc4-tip+/kernel/net/ipv4/netfilter/nf_nat.ko
  984c7bea90ce1376d5c8e7ef43a781801286e62d /lib/modules/2.6.33-rc4-tip+/kernel/drivers/net/tun.ko

  acme@parisc:~/git/linux-2.6-tip$ perf buildid-list | tail -5
  22492f3753c6a67de5c7ccbd6b863390c92c0723 /usr/lib64/libXt.so.6.0.0
  353802bb7e1b895ba43507cc678f951e778e4c6f /usr/lib64/libMagickCore.so.2.0.0
  d10c2897558595efe7be8b0584cf7e6398bc776c /usr/lib64/libfprint.so.0.0.0
  a83ecfb519a788774a84d5ddde633c9ba56c03ab /home/acme/bin/perf
  d3ca765a8ecf257d263801d7ad8c49c189082317 /usr/lib64/libdwarf.so.0.0
  acme@parisc:~/git/linux-2.6-tip$

  acme@parisc:~/git/linux-2.6-tip$ perf report --sort comm
  The file [kernel.kallsyms] cannot be used, trying to use /proc/kallsyms...

  ^^^^ The problem related to vmlinux handling, it shouldn't be trying this
  ^^^^ rather alien /proc/kallsyms at all...

  /lib64/libpthread-2.10.2.so with build id 5c68f7afeb33309c78037e374b0deee84dd441f6 not found, continuing without symbols
  /lib64/libc-2.10.2.so with build id eb4ec8fa8b2a5eb18cad173c92f27ed8887ed1c1 not found, continuing without symbols
  /home/acme/bin/perf with build id a83ecfb519a788774a84d5ddde633c9ba56c03ab not found, continuing without symbols
  /usr/sbin/openvpn with build id f2037a091ef36b591187a858d75e203690ea9409 not found, continuing without symbols
  Failed to open /lib/modules/2.6.33-rc4-tip+/kernel/drivers/net/e1000e/e1000e.ko, continuing without symbols
  Failed to open /lib/modules/2.6.33-rc4-tip+/kernel/drivers/net/wireless/iwlwifi/iwlcore.ko, continuing without symbols

  <SNIP more complaints about not finding the right build-ids,
        those will have to wait for 'perf archive' or plain
        copying what was collected by 'perf record' on the x86_64,
        source machine, see further below for an example of this>

  # Samples: 293085637
  #
  # Overhead          Command
  # ........  ...............
  #
      61.70%             find
      23.50%             perf
       5.86%          swapper
       3.12%             sshd
       2.39%             init
       0.87%             bash
       0.86%            sleep
       0.59%      dbus-daemon
       0.25%             hald
       0.24%   NetworkManager
       0.19%  hald-addon-rfki
       0.15%          openvpn
       0.07%             phy0
       0.07%         events/0
       0.05%          iwl3945
       0.05%         events/1
       0.03%      kondemand/0
  acme@parisc:~/git/linux-2.6-tip$

Which matches what we get when running the same command for the same perf.data
file on the F12, x86_64, source machine:

  [root@doppio linux-2.6-tip]# perf report --sort comm
  # Samples: 293085637
  #
  # Overhead          Command
  # ........  ...............
  #
      61.70%             find
      23.50%             perf
       5.86%          swapper
       3.12%             sshd
       2.39%             init
       0.87%             bash
       0.86%            sleep
       0.59%      dbus-daemon
       0.25%             hald
       0.24%   NetworkManager
       0.19%  hald-addon-rfki
       0.15%          openvpn
       0.07%             phy0
       0.07%         events/0
       0.05%          iwl3945
       0.05%         events/1
       0.03%      kondemand/0
  [root@doppio linux-2.6-tip]#

The other modes work as well, modulo the problem with vmlinux:

  acme@parisc:~/git/linux-2.6-tip$ perf report --sort comm,dso 2> /dev/null | head -15
  # Samples: 293085637
  #
  # Overhead          Command                      Shared Object
  # ........  ...............  .................................
  #
      35.11%             find                   ffffffff81002b5a
      18.25%             perf                   ffffffff8102235f
      16.17%             find  libc-2.10.2.so
       9.07%             find  find
       5.80%          swapper                   ffffffff8102235f
       3.95%             perf  libc-2.10.2.so
       2.33%             init                   ffffffff810091b9
       1.65%             sshd  libcrypto.so.0.9.8k
       1.35%             find  [e1000e]
       0.68%            sleep  libc-2.10.2.so
  acme@parisc:~/git/linux-2.6-tip$

And the lack of the right buildids:

  acme@parisc:~/git/linux-2.6-tip$ perf report --sort comm,dso,symbol 2> /dev/null | head -15
  # Samples: 293085637
  #
  # Overhead          Command                      Shared Object  Symbol
  # ........  ...............  .................................  ......
  #
      35.11%             find                   ffffffff81002b5a  [k] 0xffffffff81002b5a
      18.25%             perf                   ffffffff8102235f  [k] 0xffffffff8102235f
      16.17%             find  libc-2.10.2.so                     [.] 0x00000000045782
       9.07%             find  find                               [.] 0x0000000000fb0e
       5.80%          swapper                   ffffffff8102235f  [k] 0xffffffff8102235f
       3.95%             perf  libc-2.10.2.so                     [.] 0x0000000007f398
       2.33%             init                   ffffffff810091b9  [k] 0xffffffff810091b9
       1.65%             sshd  libcrypto.so.0.9.8k                [.] 0x00000000105440
       1.35%             find  [e1000e]                           [k] 0x00000000010948
       0.68%            sleep  libc-2.10.2.so                     [.] 0x0000000011ad5b
  acme@parisc:~/git/linux-2.6-tip$

But if we:

  acme@parisc:~/git/linux-2.6-tip$ ls ~/.debug
  ls: cannot access /home/acme/.debug: No such file or directory
  acme@parisc:~/git/linux-2.6-tip$ mkdir -p ~/.debug/lib64/libc-2.10.2.so/
  acme@parisc:~/git/linux-2.6-tip$ scp doppio:.debug/lib64/libc-2.10.2.so/* ~/.debug/lib64/libc-2.10.2.so/
  acme@doppio's password:
  eb4ec8fa8b2a5eb18cad173c92f27ed8887ed1c1	             100% 1783KB 714.7KB/s   00:02
  acme@parisc:~/git/linux-2.6-tip$ mkdir -p ~/.debug/.build-id/eb
  acme@parisc:~/git/linux-2.6-tip$ ln -s ../../lib64/libc-2.10.2.so/eb4ec8fa8b2a5eb18cad173c92f27ed8887ed1c1 ~/.debug/.build-id/eb/4ec8fa8b2a5eb18cad173c92f27ed8887ed1c1
  acme@parisc:~/git/linux-2.6-tip$ perf report --dsos libc-2.10.2.so 2> /dev/null
  # dso: libc-2.10.2.so
  # Samples: 64281170
  #
  # Overhead          Command  Symbol
  # ........  ...............  ......
  #
      14.98%             perf  [.] __GI_strcmp
      12.30%             find  [.] __GI_memmove
       9.25%             find  [.] _int_malloc
       7.60%             find  [.] _IO_vfprintf_internal
       6.10%             find  [.] _IO_new_file_xsputn
       6.02%             find  [.] __GI_close
       3.08%             find  [.] _IO_file_overflow_internal
       3.08%             find  [.] malloc_consolidate
       3.08%             find  [.] _int_free
       3.08%             find  [.] __strchrnul
       3.08%             find  [.] __getdents64
       3.08%             find  [.] __write_nocancel
       3.08%            sleep  [.] __GI__dl_addr
       3.08%             sshd  [.] __libc_select
       3.08%             find  [.] _IO_new_file_write
       3.07%             find  [.] _IO_new_do_write
       3.06%             find  [.] __GI___errno_location
       3.05%             find  [.] __GI___libc_malloc
       3.04%             perf  [.] __GI_memcpy
       1.71%             find  [.] __fprintf_chk
       1.29%             bash  [.] __gconv_transform_utf8_internal
       0.79%      dbus-daemon  [.] __GI_strlen
  #
  # (For a higher level overview, try: perf report --sort comm,dso)
  #
  acme@parisc:~/git/linux-2.6-tip$

Which matches what we get on the source, F12, x86_64 machine:

  [root@doppio linux-2.6-tip]# perf report --dsos libc-2.10.2.so
  # dso: libc-2.10.2.so
  # Samples: 64281170
  #
  # Overhead          Command  Symbol
  # ........  ...............  ......
  #
      14.98%             perf  [.] __GI_strcmp
      12.30%             find  [.] __GI_memmove
       9.25%             find  [.] _int_malloc
       7.60%             find  [.] _IO_vfprintf_internal
       6.10%             find  [.] _IO_new_file_xsputn
       6.02%             find  [.] __GI_close
       3.08%             find  [.] _IO_file_overflow_internal
       3.08%             find  [.] malloc_consolidate
       3.08%             find  [.] _int_free
       3.08%             find  [.] __strchrnul
       3.08%             find  [.] __getdents64
       3.08%             find  [.] __write_nocancel
       3.08%            sleep  [.] __GI__dl_addr
       3.08%             sshd  [.] __libc_select
       3.08%             find  [.] _IO_new_file_write
       3.07%             find  [.] _IO_new_do_write
       3.06%             find  [.] __GI___errno_location
       3.05%             find  [.] __GI___libc_malloc
       3.04%             perf  [.] __GI_memcpy
       1.71%             find  [.] __fprintf_chk
       1.29%             bash  [.] __gconv_transform_utf8_internal
       0.79%      dbus-daemon  [.] __GI_strlen
  #
  # (For a higher level overview, try: perf report --sort comm,dso)
  #
  [root@doppio linux-2.6-tip]#

So I think this is really, really nice in that it demonstrates the portability
of perf.data files and the use of build-ids accross such aliens worlds :-)

There are some things to fix tho, like the bitmap on the header, but things are
looking good.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c  |   63 +++++++++++++++++++++-----
 tools/perf/util/header.h  |    2 +
 tools/perf/util/session.c |  108 ++++++++++++++++++++++++++++++++++++++++----
 tools/perf/util/session.h |    7 +++-
 4 files changed, 157 insertions(+), 23 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index ec96321..b31e0ae 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1,8 +1,10 @@
 #include <sys/types.h>
+#include <byteswap.h>
 #include <unistd.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <linux/list.h>
+#include <linux/kernel.h>
 
 #include "util.h"
 #include "header.h"
@@ -464,8 +466,21 @@ static int do_read(int fd, void *buf, size_t size)
 	return 0;
 }
 
+static int perf_header__getbuffer64(struct perf_header *self,
+				    int fd, void *buf, size_t size)
+{
+	if (do_read(fd, buf, size))
+		return -1;
+
+	if (self->needs_swap)
+		mem_bswap_64(buf, size);
+
+	return 0;
+}
+
 int perf_header__process_sections(struct perf_header *self, int fd,
 				  int (*process)(struct perf_file_section *self,
+						 struct perf_header *ph,
 						 int feat, int fd))
 {
 	struct perf_file_section *feat_sec;
@@ -486,7 +501,7 @@ int perf_header__process_sections(struct perf_header *self, int fd,
 
 	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
 
-	if (do_read(fd, feat_sec, sec_size))
+	if (perf_header__getbuffer64(self, fd, feat_sec, sec_size))
 		goto out_free;
 
 	err = 0;
@@ -494,7 +509,7 @@ int perf_header__process_sections(struct perf_header *self, int fd,
 		if (perf_header__has_feat(self, feat)) {
 			struct perf_file_section *sec = &feat_sec[idx++];
 
-			err = process(sec, feat, fd);
+			err = process(sec, self, feat, fd);
 			if (err < 0)
 				break;
 		}
@@ -511,10 +526,20 @@ int perf_file_header__read(struct perf_file_header *self,
 	lseek(fd, 0, SEEK_SET);
 
 	if (do_read(fd, self, sizeof(*self)) ||
-	    self->magic     != PERF_MAGIC ||
-	    self->attr_size != sizeof(struct perf_file_attr))
+	    memcmp(&self->magic, __perf_magic, sizeof(self->magic)))
 		return -1;
 
+	if (self->attr_size != sizeof(struct perf_file_attr)) {
+		u64 attr_size = bswap_64(self->attr_size);
+
+		if (attr_size != sizeof(struct perf_file_attr))
+			return -1;
+
+		mem_bswap_64(self, offsetof(struct perf_file_header,
+					    adds_features));
+		ph->needs_swap = true;
+	}
+
 	if (self->size != sizeof(*self)) {
 		/* Support the previous format */
 		if (self->size == offsetof(typeof(*self), adds_features))
@@ -524,16 +549,28 @@ int perf_file_header__read(struct perf_file_header *self,
 	}
 
 	memcpy(&ph->adds_features, &self->adds_features,
-	       sizeof(self->adds_features));
+	       sizeof(ph->adds_features));
+	/*
+	 * FIXME: hack that assumes that if we need swap the perf.data file
+	 * may be coming from an arch with a different word-size, ergo different
+	 * DEFINE_BITMAP format, investigate more later, but for now its mostly
+	 * safe to assume that we have a build-id section. Trace files probably
+	 * have several other issues in this realm anyway...
+	 */
+	if (ph->needs_swap) {
+		memset(&ph->adds_features, 0, sizeof(ph->adds_features));
+		perf_header__set_feat(ph, HEADER_BUILD_ID);
+	}
 
 	ph->event_offset = self->event_types.offset;
-	ph->event_size	 = self->event_types.size;
-	ph->data_offset	 = self->data.offset;
+	ph->event_size   = self->event_types.size;
+	ph->data_offset  = self->data.offset;
 	ph->data_size	 = self->data.size;
 	return 0;
 }
 
 static int perf_file_section__process(struct perf_file_section *self,
+				      struct perf_header *ph,
 				      int feat, int fd)
 {
 	if (lseek(fd, self->offset, SEEK_SET) < 0) {
@@ -548,7 +585,7 @@ static int perf_file_section__process(struct perf_file_section *self,
 		break;
 
 	case HEADER_BUILD_ID:
-		if (perf_header__read_build_ids(fd, self->offset, self->size))
+		if (perf_header__read_build_ids(ph, fd, self->offset, self->size))
 			pr_debug("Failed to read buildids, continuing...\n");
 		break;
 	default:
@@ -560,7 +597,7 @@ static int perf_file_section__process(struct perf_file_section *self,
 
 int perf_header__read(struct perf_header *self, int fd)
 {
-	struct perf_file_header f_header;
+	struct perf_file_header	f_header;
 	struct perf_file_attr	f_attr;
 	u64			f_id;
 	int nr_attrs, nr_ids, i, j;
@@ -577,8 +614,9 @@ int perf_header__read(struct perf_header *self, int fd)
 		struct perf_header_attr *attr;
 		off_t tmp;
 
-		if (do_read(fd, &f_attr, sizeof(f_attr)))
+		if (perf_header__getbuffer64(self, fd, &f_attr, sizeof(f_attr)))
 			goto out_errno;
+
 		tmp = lseek(fd, 0, SEEK_CUR);
 
 		attr = perf_header_attr__new(&f_attr.attr);
@@ -589,7 +627,7 @@ int perf_header__read(struct perf_header *self, int fd)
 		lseek(fd, f_attr.ids.offset, SEEK_SET);
 
 		for (j = 0; j < nr_ids; j++) {
-			if (do_read(fd, &f_id, sizeof(f_id)))
+			if (perf_header__getbuffer64(self, fd, &f_id, sizeof(f_id)))
 				goto out_errno;
 
 			if (perf_header_attr__add_id(attr, f_id) < 0) {
@@ -610,7 +648,8 @@ int perf_header__read(struct perf_header *self, int fd)
 		events = malloc(f_header.event_types.size);
 		if (events == NULL)
 			return -ENOMEM;
-		if (do_read(fd, events, f_header.event_types.size))
+		if (perf_header__getbuffer64(self, fd, events,
+					     f_header.event_types.size))
 			goto out_errno;
 		event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
 	}
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 2b69aab..ccc8540 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -52,6 +52,7 @@ struct perf_header {
 	u64			data_size;
 	u64			event_offset;
 	u64			event_size;
+	bool			needs_swap;
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
 };
 
@@ -80,6 +81,7 @@ bool perf_header__has_feat(const struct perf_header *self, int feat);
 
 int perf_header__process_sections(struct perf_header *self, int fd,
 				  int (*process)(struct perf_file_section *self,
+						 struct perf_header *ph,
 						 int feat, int fd));
 
 #endif /* __PERF_HEADER_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index e3ccdb4..604e14f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1,5 +1,6 @@
 #include <linux/kernel.h>
 
+#include <byteswap.h>
 #include <unistd.h>
 #include <sys/types.h>
 
@@ -201,21 +202,88 @@ void event__print_totals(void)
 			event__name[i], event__total[i]);
 }
 
+void mem_bswap_64(void *src, int byte_size)
+{
+	u64 *m = src;
+
+	while (byte_size > 0) {
+		*m = bswap_64(*m);
+		byte_size -= sizeof(u64);
+		++m;
+	}
+}
+
+static void event__all64_swap(event_t *self)
+{
+	struct perf_event_header *hdr = &self->header;
+	mem_bswap_64(hdr + 1, self->header.size - sizeof(*hdr));
+}
+
+static void event__comm_swap(event_t *self)
+{
+	self->comm.pid = bswap_32(self->comm.pid);
+	self->comm.tid = bswap_32(self->comm.tid);
+}
+
+static void event__mmap_swap(event_t *self)
+{
+	self->mmap.pid	 = bswap_32(self->mmap.pid);
+	self->mmap.tid	 = bswap_32(self->mmap.tid);
+	self->mmap.start = bswap_64(self->mmap.start);
+	self->mmap.len	 = bswap_64(self->mmap.len);
+	self->mmap.pgoff = bswap_64(self->mmap.pgoff);
+}
+
+static void event__task_swap(event_t *self)
+{
+	self->fork.pid	= bswap_32(self->fork.pid);
+	self->fork.tid	= bswap_32(self->fork.tid);
+	self->fork.ppid	= bswap_32(self->fork.ppid);
+	self->fork.ptid	= bswap_32(self->fork.ptid);
+	self->fork.time	= bswap_64(self->fork.time);
+}
+
+static void event__read_swap(event_t *self)
+{
+	self->read.pid		= bswap_32(self->read.pid);
+	self->read.tid		= bswap_32(self->read.tid);
+	self->read.value	= bswap_64(self->read.value);
+	self->read.time_enabled	= bswap_64(self->read.time_enabled);
+	self->read.time_running	= bswap_64(self->read.time_running);
+	self->read.id		= bswap_64(self->read.id);
+}
+
+typedef void (*event__swap_op)(event_t *self);
+
+static event__swap_op event__swap_ops[] = {
+	[PERF_RECORD_MMAP]   = event__mmap_swap,
+	[PERF_RECORD_COMM]   = event__comm_swap,
+	[PERF_RECORD_FORK]   = event__task_swap,
+	[PERF_RECORD_EXIT]   = event__task_swap,
+	[PERF_RECORD_LOST]   = event__all64_swap,
+	[PERF_RECORD_READ]   = event__read_swap,
+	[PERF_RECORD_SAMPLE] = event__all64_swap,
+	[PERF_RECORD_MAX]    = NULL,
+};
+
 static int perf_session__process_event(struct perf_session *self,
 				       event_t *event,
 				       struct perf_event_ops *ops,
-				       unsigned long offset, unsigned long head)
+				       u64 offset, u64 head)
 {
 	trace_event(event);
 
 	if (event->header.type < PERF_RECORD_MAX) {
-		dump_printf("%#lx [%#x]: PERF_RECORD_%s",
+		dump_printf("%#Lx [%#x]: PERF_RECORD_%s",
 			    offset + head, event->header.size,
 			    event__name[event->header.type]);
 		++event__total[0];
 		++event__total[event->header.type];
 	}
 
+	if (self->header.needs_swap && event__swap_ops[event->header.type])
+		event__swap_ops[event->header.type](event);
+
 	switch (event->header.type) {
 	case PERF_RECORD_SAMPLE:
 		return ops->sample(event, self);
@@ -241,7 +309,15 @@ static int perf_session__process_event(struct perf_session *self,
 	}
 }
 
-int perf_header__read_build_ids(int input, u64 offset, u64 size)
+void perf_event_header__bswap(struct perf_event_header *self)
+{
+	self->type = bswap_32(self->type);
+	self->misc = bswap_16(self->misc);
+	self->size = bswap_16(self->size);
+}
+
+int perf_header__read_build_ids(struct perf_header *self,
+				int input, u64 offset, u64 size)
 {
 	struct build_id_event bev;
 	char filename[PATH_MAX];
@@ -256,6 +332,9 @@ int perf_header__read_build_ids(int input, u64 offset, u64 size)
 		if (read(input, &bev, sizeof(bev)) != sizeof(bev))
 			goto out;
 
+		if (self->needs_swap)
+			perf_event_header__bswap(&bev.header);
+
 		len = bev.header.size - sizeof(bev);
 		if (read(input, filename, len) != len)
 			goto out;
@@ -292,9 +371,9 @@ static struct thread *perf_session__register_idle_thread(struct perf_session *se
 int perf_session__process_events(struct perf_session *self,
 				 struct perf_event_ops *ops)
 {
-	int err;
-	unsigned long head, shift;
-	unsigned long offset = 0;
+	int err, mmap_prot, mmap_flags;
+	u64 head, shift;
+	u64 offset = 0;
 	size_t	page_size;
 	event_t *event;
 	uint32_t size;
@@ -330,9 +409,16 @@ out_getcwd_err:
 	offset += shift;
 	head -= shift;
 
+	mmap_prot  = PROT_READ;
+	mmap_flags = MAP_SHARED;
+
+	if (self->header.needs_swap) {
+		mmap_prot  |= PROT_WRITE;
+		mmap_flags = MAP_PRIVATE;
+	}
 remap:
-	buf = mmap(NULL, page_size * self->mmap_window, PROT_READ,
-		   MAP_SHARED, self->fd, offset);
+	buf = mmap(NULL, page_size * self->mmap_window, mmap_prot,
+		   mmap_flags, self->fd, offset);
 	if (buf == MAP_FAILED) {
 		pr_err("failed to mmap file\n");
 		err = -errno;
@@ -342,6 +428,8 @@ remap:
 more:
 	event = (event_t *)(buf + head);
 
+	if (self->header.needs_swap)
+		perf_event_header__bswap(&event->header);
 	size = event->header.size;
 	if (size == 0)
 		size = 8;
@@ -361,12 +449,12 @@ more:
 
 	size = event->header.size;
 
-	dump_printf("\n%#lx [%#x]: event: %d\n",
+	dump_printf("\n%#Lx [%#x]: event: %d\n",
 		    offset + head, event->header.size, event->header.type);
 
 	if (size == 0 ||
 	    perf_session__process_event(self, event, ops, offset, head) < 0) {
-		dump_printf("%#lx [%#x]: skipping unknown header type: %d\n",
+		dump_printf("%#Lx [%#x]: skipping unknown header type: %d\n",
 			    offset + head, event->header.size,
 			    event->header.type);
 		/*
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index d4a9d20..36d1a80 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -51,6 +51,8 @@ struct perf_event_ops {
 struct perf_session *perf_session__new(const char *filename, int mode, bool force);
 void perf_session__delete(struct perf_session *self);
 
+void perf_event_header__bswap(struct perf_event_header *self);
+
 int perf_session__process_events(struct perf_session *self,
 				 struct perf_event_ops *event_ops);
 
@@ -61,7 +63,8 @@ struct symbol **perf_session__resolve_callchain(struct perf_session *self,
 
 bool perf_session__has_traces(struct perf_session *self, const char *msg);
 
-int perf_header__read_build_ids(int input, u64 offset, u64 file_size);
+int perf_header__read_build_ids(struct perf_header *self, int input,
+				u64 offset, u64 file_size);
 
 int perf_session__set_kallsyms_ref_reloc_sym(struct perf_session *self,
 					     const char *symbol_name,
@@ -69,4 +72,6 @@ int perf_session__set_kallsyms_ref_reloc_sym(struct perf_session *self,
 void perf_session__reloc_vmlinux_maps(struct perf_session *self,
 				      u64 unrelocated_addr);
 
+void mem_bswap_64(void *src, int byte_size);
+
 #endif /* __PERF_SESSION_H */
-- 
1.6.5

