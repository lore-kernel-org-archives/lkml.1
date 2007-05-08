Return-Path: <linux-kernel-owner+w=401wt.eu-S967644AbXEHUv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967644AbXEHUv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934370AbXEHUvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:51:23 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:36084 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967171AbXEHUvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:51:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=eKLBpLeaFPlAByUD91CFfNczKl4zCpfDEqVeceBHwNGHQnbVWLEpdZc+5BlY5gfwNQxxmsU6wZ2hY/Cad6HjQyZBmeHAVxBsN5D7/hOuVCmUb772cwgpV5iCaVnqKw30ADQqSE2W5WYwLEUXK2P1BqJIqlAFK3lIu8jAwYdsvNA=
Message-ID: <f158dc670705081351j4d46b433o2bdd2e8212a52e15@mail.gmail.com>
Date: Tue, 8 May 2007 14:51:02 -0600
From: "Latchesar Ionkov" <lucho@ionkov.net>
To: "Andrew Morton" <akpm@osdl.org>
Subject: [PATCH 1/4] v9fs: rename non-vfs related structs and functions to be moved to net/9p
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 39394bec8ae4122a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset moves non-filesystem interfaces of v9fs from fs/9p to net/9p.
It moves the transport, packet marshalling and connection layers to net/9p
leaving only the VFS related files in fs/9p.

This patch:

Prepares the header and C files that are going to be moved to net/9p and
include/net/9p. It renames the structures, macros and functions of the
interfaces from v9fs_ to 9p_.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>
---
 fs/9p/9p.h         |  426 ++++++++++++++++++++++++++----------------------
 fs/9p/Makefile     |    3 +-
 fs/9p/conn.h       |   53 ++++++
 fs/9p/conv.c       |  373 ++++++++++++++++++++++++------------------
 fs/9p/conv.h       |   50 ------
 fs/9p/debug.h      |   77 ---------
 fs/9p/error.c      |  167 ++++++++++++++++++--
 fs/9p/error.h      |  177 --------------------
 fs/9p/fcall.c      |  135 ++++++++--------
 fs/9p/fcprint.c    |  140 +++++++++--------
 fs/9p/fid.c        |   28 ++--
 fs/9p/fid.h        |    4 +-
 fs/9p/mux.c        |  458 ++++++++++++++++++++++++++-------------------------
 fs/9p/mux.h        |   55 -------
 fs/9p/trans_fd.c   |  366 +++++++++++++++++++++++------------------
 fs/9p/transport.h  |   28 ++--
 fs/9p/util.c       |  125 ++++++++++++++
 fs/9p/v9fs.c       |  175 +++++++--------------
 fs/9p/v9fs.h       |   52 ++++--
 fs/9p/v9fs_vfs.h   |    6 +-
 fs/9p/vfs_addr.c   |   10 +-
 fs/9p/vfs_dentry.c |   12 +-
 fs/9p/vfs_dir.c    |   35 ++---
 fs/9p/vfs_file.c   |   28 ++--
 fs/9p/vfs_inode.c  |  186 +++++++++++-----------
 fs/9p/vfs_super.c  |   16 +-
 26 files changed, 1625 insertions(+), 1560 deletions(-)

diff --git a/fs/9p/9p.h b/fs/9p/9p.h
index 94e2f92..153129b 100644
--- a/fs/9p/9p.h
+++ b/fs/9p/9p.h
@@ -1,5 +1,5 @@
 /*
- * linux/fs/9p/9p.h
+ * include/net/9p/9p.h
  *
  * 9P protocol definitions.
  *
@@ -24,130 +24,171 @@
  *
  */

+#ifndef NET_9P_H
+#define NET_9P_H
+
+#define CONFIG_NET_9P_DEBUG
+
+#ifdef CONFIG_NET_9P_DEBUG
+
+#define P9_DEBUG_ERROR		(1<<0)
+#define P9_DEBUG_9P	        (1<<2)
+#define P9_DEBUG_VFS	        (1<<3)
+#define P9_DEBUG_CONV		(1<<4)
+#define P9_DEBUG_MUX		(1<<5)
+#define P9_DEBUG_TRANS		(1<<6)
+#define P9_DEBUG_SLABS	      	(1<<7)
+#define P9_DEBUG_FCALL		(1<<8)
+
+extern unsigned int p9_debug_level;
+
+#define P9_DPRINTK(level, format, arg...) \
+do {  \
+	if((p9_debug_level & level)==level) \
+		printk(KERN_NOTICE "-- %s (%d): " \
+		format , __FUNCTION__, current->pid , ## arg); \
+} while(0)
+
+#define PRINT_FCALL_ERROR(s, fcall) P9_DPRINTK(P9_DEBUG_ERROR, "%s:
%.*s\n", s, \
+	fcall?fcall->params.rerror.error.len:0, \
+	fcall?fcall->params.rerror.error.str:"");
+
+#else
+#define P9_DPRINTK(level, format, arg...)  do { } while (0)
+#define PRINT_FCALL_ERROR(s, fcall) do { } while (0)
+#endif
+
+#define P9_EPRINTK(level, format, arg...) \
+do { \
+	printk(level "9p: %s (%d): " \
+        	format , __FUNCTION__, current->pid , ## arg); \
+} while(0)
+
+
 /* Message Types */
 enum {
-	TVERSION = 100,
-	RVERSION,
-	TAUTH = 102,
-	RAUTH,
-	TATTACH = 104,
-	RATTACH,
-	TERROR = 106,
-	RERROR,
-	TFLUSH = 108,
-	RFLUSH,
-	TWALK = 110,
-	RWALK,
-	TOPEN = 112,
-	ROPEN,
-	TCREATE = 114,
-	RCREATE,
-	TREAD = 116,
-	RREAD,
-	TWRITE = 118,
-	RWRITE,
-	TCLUNK = 120,
-	RCLUNK,
-	TREMOVE = 122,
-	RREMOVE,
-	TSTAT = 124,
-	RSTAT,
-	TWSTAT = 126,
-	RWSTAT,
-};
-
-/* modes */
+	P9_TVERSION = 100,
+	P9_RVERSION,
+	P9_TAUTH = 102,
+	P9_RAUTH,
+	P9_TATTACH = 104,
+	P9_RATTACH,
+	P9_TERROR = 106,
+	P9_RERROR,
+	P9_TFLUSH = 108,
+	P9_RFLUSH,
+	P9_TWALK = 110,
+	P9_RWALK,
+	P9_TOPEN = 112,
+	P9_ROPEN,
+	P9_TCREATE = 114,
+	P9_RCREATE,
+	P9_TREAD = 116,
+	P9_RREAD,
+	P9_TWRITE = 118,
+	P9_RWRITE,
+	P9_TCLUNK = 120,
+	P9_RCLUNK,
+	P9_TREMOVE = 122,
+	P9_RREMOVE,
+	P9_TSTAT = 124,
+	P9_RSTAT,
+	P9_TWSTAT = 126,
+	P9_RWSTAT,
+};
+
+/* open modes */
 enum {
-	V9FS_OREAD = 0x00,
-	V9FS_OWRITE = 0x01,
-	V9FS_ORDWR = 0x02,
-	V9FS_OEXEC = 0x03,
-	V9FS_OEXCL = 0x04,
-	V9FS_OTRUNC = 0x10,
-	V9FS_OREXEC = 0x20,
-	V9FS_ORCLOSE = 0x40,
-	V9FS_OAPPEND = 0x80,
+	P9_OREAD = 0x00,
+	P9_OWRITE = 0x01,
+	P9_ORDWR = 0x02,
+	P9_OEXEC = 0x03,
+	P9_OEXCL = 0x04,
+	P9_OTRUNC = 0x10,
+	P9_OREXEC = 0x20,
+	P9_ORCLOSE = 0x40,
+	P9_OAPPEND = 0x80,
 };

 /* permissions */
 enum {
-	V9FS_DMDIR = 0x80000000,
-	V9FS_DMAPPEND = 0x40000000,
-	V9FS_DMEXCL = 0x20000000,
-	V9FS_DMMOUNT = 0x10000000,
-	V9FS_DMAUTH = 0x08000000,
-	V9FS_DMTMP = 0x04000000,
-	V9FS_DMSYMLINK = 0x02000000,
-	V9FS_DMLINK = 0x01000000,
+	P9_DMDIR = 0x80000000,
+	P9_DMAPPEND = 0x40000000,
+	P9_DMEXCL = 0x20000000,
+	P9_DMMOUNT = 0x10000000,
+	P9_DMAUTH = 0x08000000,
+	P9_DMTMP = 0x04000000,
+	P9_DMSYMLINK = 0x02000000,
+	P9_DMLINK = 0x01000000,
 	/* 9P2000.u extensions */
-	V9FS_DMDEVICE = 0x00800000,
-	V9FS_DMNAMEDPIPE = 0x00200000,
-	V9FS_DMSOCKET = 0x00100000,
-	V9FS_DMSETUID = 0x00080000,
-	V9FS_DMSETGID = 0x00040000,
+	P9_DMDEVICE = 0x00800000,
+	P9_DMNAMEDPIPE = 0x00200000,
+	P9_DMSOCKET = 0x00100000,
+	P9_DMSETUID = 0x00080000,
+	P9_DMSETGID = 0x00040000,
 };

 /* qid.types */
 enum {
-	V9FS_QTDIR = 0x80,
-	V9FS_QTAPPEND = 0x40,
-	V9FS_QTEXCL = 0x20,
-	V9FS_QTMOUNT = 0x10,
-	V9FS_QTAUTH = 0x08,
-	V9FS_QTTMP = 0x04,
-	V9FS_QTSYMLINK = 0x02,
-	V9FS_QTLINK = 0x01,
-	V9FS_QTFILE = 0x00,
+	P9_QTDIR = 0x80,
+	P9_QTAPPEND = 0x40,
+	P9_QTEXCL = 0x20,
+	P9_QTMOUNT = 0x10,
+	P9_QTAUTH = 0x08,
+	P9_QTTMP = 0x04,
+	P9_QTSYMLINK = 0x02,
+	P9_QTLINK = 0x01,
+	P9_QTFILE = 0x00,
 };

-#define V9FS_NOTAG	(u16)(~0)
-#define V9FS_NOFID	(u32)(~0)
-#define V9FS_MAXWELEM	16
+#define P9_NOTAG	(u16)(~0)
+#define P9_NOFID	(u32)(~0)
+#define P9_MAXWELEM	16

-/* ample room for Twrite/Rread header (iounit) */
-#define V9FS_IOHDRSZ	24
+/* ample room for Twrite/Rread header */
+#define P9_IOHDRSZ	24

-struct v9fs_str {
+struct p9_str {
 	u16 len;
 	char *str;
 };

 /* qids are the unique ID for a file (like an inode */
-struct v9fs_qid {
+struct p9_qid {
 	u8 type;
 	u32 version;
 	u64 path;
 };

 /* Plan 9 file metadata (stat) structure */
-struct v9fs_stat {
+struct p9_stat {
 	u16 size;
 	u16 type;
 	u32 dev;
-	struct v9fs_qid qid;
+	struct p9_qid qid;
 	u32 mode;
 	u32 atime;
 	u32 mtime;
 	u64 length;
-	struct v9fs_str name;
-	struct v9fs_str uid;
-	struct v9fs_str gid;
-	struct v9fs_str muid;
-	struct v9fs_str extension;	/* 9p2000.u extensions */
-	u32 n_uid;		/* 9p2000.u extensions */
-	u32 n_gid;		/* 9p2000.u extensions */
-	u32 n_muid;		/* 9p2000.u extensions */
+	struct p9_str name;
+	struct p9_str uid;
+	struct p9_str gid;
+	struct p9_str muid;
+	struct p9_str extension;	/* 9p2000.u extensions */
+	u32 n_uid;			/* 9p2000.u extensions */
+	u32 n_gid;			/* 9p2000.u extensions */
+	u32 n_muid;			/* 9p2000.u extensions */
 };

 /* file metadata (stat) structure used to create Twstat message
-   The is similar to v9fs_stat, but the strings don't point to
+   The is similar to p9_stat, but the strings don't point to
    the same memory block and should be freed separately
 */
-struct v9fs_wstat {
+struct p9_wstat {
 	u16 size;
 	u16 type;
 	u32 dev;
-	struct v9fs_qid qid;
+	struct p9_qid qid;
 	u32 mode;
 	u32 atime;
 	u32 mtime;
@@ -163,135 +204,134 @@ struct v9fs_wstat {
 };

 /* Structures for Protocol Operations */
-
-struct Tversion {
+struct p9_tversion {
 	u32 msize;
-	struct v9fs_str version;
+	struct p9_str version;
 };

-struct Rversion {
+struct p9_rversion {
 	u32 msize;
-	struct v9fs_str version;
+	struct p9_str version;
 };

-struct Tauth {
+struct p9_tauth {
 	u32 afid;
-	struct v9fs_str uname;
-	struct v9fs_str aname;
+	struct p9_str uname;
+	struct p9_str aname;
 };

-struct Rauth {
-	struct v9fs_qid qid;
+struct p9_rauth {
+	struct p9_qid qid;
 };

-struct Rerror {
-	struct v9fs_str error;
+struct p9_rerror {
+	struct p9_str error;
 	u32 errno;		/* 9p2000.u extension */
 };

-struct Tflush {
+struct p9_tflush {
 	u16 oldtag;
 };

-struct Rflush {
+struct p9_rflush {
 };

-struct Tattach {
+struct p9_tattach {
 	u32 fid;
 	u32 afid;
-	struct v9fs_str uname;
-	struct v9fs_str aname;
+	struct p9_str uname;
+	struct p9_str aname;
 };

-struct Rattach {
-	struct v9fs_qid qid;
+struct p9_rattach {
+	struct p9_qid qid;
 };

-struct Twalk {
+struct p9_twalk {
 	u32 fid;
 	u32 newfid;
 	u16 nwname;
-	struct v9fs_str wnames[16];
+	struct p9_str wnames[16];
 };

-struct Rwalk {
+struct p9_rwalk {
 	u16 nwqid;
-	struct v9fs_qid wqids[16];
+	struct p9_qid wqids[16];
 };

-struct Topen {
+struct p9_topen {
 	u32 fid;
 	u8 mode;
 };

-struct Ropen {
-	struct v9fs_qid qid;
+struct p9_ropen {
+	struct p9_qid qid;
 	u32 iounit;
 };

-struct Tcreate {
+struct p9_tcreate {
 	u32 fid;
-	struct v9fs_str name;
+	struct p9_str name;
 	u32 perm;
 	u8 mode;
-	struct v9fs_str extension;
+	struct p9_str extension;
 };

-struct Rcreate {
-	struct v9fs_qid qid;
+struct p9_rcreate {
+	struct p9_qid qid;
 	u32 iounit;
 };

-struct Tread {
+struct p9_tread {
 	u32 fid;
 	u64 offset;
 	u32 count;
 };

-struct Rread {
+struct p9_rread {
 	u32 count;
 	u8 *data;
 };

-struct Twrite {
+struct p9_twrite {
 	u32 fid;
 	u64 offset;
 	u32 count;
 	u8 *data;
 };

-struct Rwrite {
+struct p9_rwrite {
 	u32 count;
 };

-struct Tclunk {
+struct p9_tclunk {
 	u32 fid;
 };

-struct Rclunk {
+struct p9_rclunk {
 };

-struct Tremove {
+struct p9_tremove {
 	u32 fid;
 };

-struct Rremove {
+struct p9_rremove {
 };

-struct Tstat {
+struct p9_tstat {
 	u32 fid;
 };

-struct Rstat {
-	struct v9fs_stat stat;
+struct p9_rstat {
+	struct p9_stat stat;
 };

-struct Twstat {
+struct p9_twstat {
 	u32 fid;
-	struct v9fs_stat stat;
+	struct p9_stat stat;
 };

-struct Rwstat {
+struct p9_rwstat {
 };

 /*
@@ -299,77 +339,77 @@ struct Rwstat {
   *
   */

-struct v9fs_fcall {
+struct p9_fcall {
 	u32 size;
 	u8 id;
 	u16 tag;
 	void *sdata;

 	union {
-		struct Tversion tversion;
-		struct Rversion rversion;
-		struct Tauth tauth;
-		struct Rauth rauth;
-		struct Rerror rerror;
-		struct Tflush tflush;
-		struct Rflush rflush;
-		struct Tattach tattach;
-		struct Rattach rattach;
-		struct Twalk twalk;
-		struct Rwalk rwalk;
-		struct Topen topen;
-		struct Ropen ropen;
-		struct Tcreate tcreate;
-		struct Rcreate rcreate;
-		struct Tread tread;
-		struct Rread rread;
-		struct Twrite twrite;
-		struct Rwrite rwrite;
-		struct Tclunk tclunk;
-		struct Rclunk rclunk;
-		struct Tremove tremove;
-		struct Rremove rremove;
-		struct Tstat tstat;
-		struct Rstat rstat;
-		struct Twstat twstat;
-		struct Rwstat rwstat;
+		struct p9_tversion tversion;
+		struct p9_rversion rversion;
+		struct p9_tauth tauth;
+		struct p9_rauth rauth;
+		struct p9_rerror rerror;
+		struct p9_tflush tflush;
+		struct p9_rflush rflush;
+		struct p9_tattach tattach;
+		struct p9_rattach rattach;
+		struct p9_twalk twalk;
+		struct p9_rwalk rwalk;
+		struct p9_topen topen;
+		struct p9_ropen ropen;
+		struct p9_tcreate tcreate;
+		struct p9_rcreate rcreate;
+		struct p9_tread tread;
+		struct p9_rread rread;
+		struct p9_twrite twrite;
+		struct p9_rwrite rwrite;
+		struct p9_tclunk tclunk;
+		struct p9_rclunk rclunk;
+		struct p9_tremove tremove;
+		struct p9_rremove rremove;
+		struct p9_tstat tstat;
+		struct p9_rstat rstat;
+		struct p9_twstat twstat;
+		struct p9_rwstat rwstat;
 	} params;
 };

-#define PRINT_FCALL_ERROR(s, fcall) dprintk(DEBUG_ERROR, "%s: %.*s\n", s, \
-	fcall?fcall->params.rerror.error.len:0, \
-	fcall?fcall->params.rerror.error.str:"");
-
-int v9fs_t_version(struct v9fs_session_info *v9ses, u32 msize,
-		   char *version, struct v9fs_fcall **rcall);
-
-int v9fs_t_attach(struct v9fs_session_info *v9ses, char *uname, char *aname,
-		  u32 fid, u32 afid, struct v9fs_fcall **rcall);
-
-int v9fs_t_clunk(struct v9fs_session_info *v9ses, u32 fid);
-
-int v9fs_t_stat(struct v9fs_session_info *v9ses, u32 fid,
-		struct v9fs_fcall **rcall);
-
-int v9fs_t_wstat(struct v9fs_session_info *v9ses, u32 fid,
-		 struct v9fs_wstat *wstat, struct v9fs_fcall **rcall);
-
-int v9fs_t_walk(struct v9fs_session_info *v9ses, u32 fid, u32 newfid,
-		char *name, struct v9fs_fcall **rcall);
-
-int v9fs_t_open(struct v9fs_session_info *v9ses, u32 fid, u8 mode,
-		struct v9fs_fcall **rcall);
-
-int v9fs_t_remove(struct v9fs_session_info *v9ses, u32 fid,
-		  struct v9fs_fcall **rcall);
-
-int v9fs_t_create(struct v9fs_session_info *v9ses, u32 fid, char *name,
-	u32 perm, u8 mode, char *extension, struct v9fs_fcall **rcall);
-
-int v9fs_t_read(struct v9fs_session_info *v9ses, u32 fid,
-		u64 offset, u32 count, struct v9fs_fcall **rcall);
-
-int v9fs_t_write(struct v9fs_session_info *v9ses, u32 fid, u64 offset,
-		 u32 count, const char __user * data,
-		 struct v9fs_fcall **rcall);
-int v9fs_printfcall(char *, int, struct v9fs_fcall *, int);
+struct p9_idpool;
+
+int p9_deserialize_stat(void *buf, u32 buflen, struct p9_stat *stat,
+	int dotu);
+int p9_deserialize_fcall(void *buf, u32 buflen, struct p9_fcall *fc, int dotu);
+void p9_set_tag(struct p9_fcall *fc, u16 tag);
+struct p9_fcall *p9_create_tversion(u32 msize, char *version);
+struct p9_fcall *p9_create_tattach(u32 fid, u32 afid, char *uname,
+	char *aname);
+struct p9_fcall *p9_create_tauth(u32 afid, char *uname, char *aname);
+struct p9_fcall *p9_create_tflush(u16 oldtag);
+struct p9_fcall *p9_create_twalk(u32 fid, u32 newfid, u16 nwname,
+	char **wnames);
+struct p9_fcall *p9_create_topen(u32 fid, u8 mode);
+struct p9_fcall *p9_create_tcreate(u32 fid, char *name, u32 perm, u8 mode,
+	char *extension, int dotu);
+struct p9_fcall *p9_create_tread(u32 fid, u64 offset, u32 count);
+struct p9_fcall *p9_create_twrite(u32 fid, u64 offset, u32 count,
+	const char *data);
+struct p9_fcall *p9_create_twrite_u(u32 fid, u64 offset, u32 count,
+	const char __user *data);
+struct p9_fcall *p9_create_tclunk(u32 fid);
+struct p9_fcall *p9_create_tremove(u32 fid);
+struct p9_fcall *p9_create_tstat(u32 fid);
+struct p9_fcall *p9_create_twstat(u32 fid, struct p9_wstat *wstat,
+	int dotu);
+
+int p9_printfcall(char *buf, int buflen, struct p9_fcall *fc, int dotu);
+int p9_errstr2errno(char *errstr, int len);
+
+struct p9_idpool *p9_idpool_create(void);
+void p9_idpool_destroy(struct p9_idpool *);
+int p9_idpool_get(struct p9_idpool *p);
+void p9_idpool_put(int id, struct p9_idpool *p);
+int p9_idpool_check(int id, struct p9_idpool *p);
+
+#endif /* NET_9P_H */
diff --git a/fs/9p/Makefile b/fs/9p/Makefile
index 87897f8..c2305b5 100644
--- a/fs/9p/Makefile
+++ b/fs/9p/Makefile
@@ -14,5 +14,6 @@ obj-$(CONFIG_9P_FS) := 9p.o
 	error.o \
 	v9fs.o \
 	fid.o \
-	fcprint.o
+	fcprint.o \
+	util.o

diff --git a/fs/9p/conn.h b/fs/9p/conn.h
new file mode 100644
index 0000000..6e47684
--- /dev/null
+++ b/fs/9p/conn.h
@@ -0,0 +1,53 @@
+/*
+ * include/net/9p/conn.h
+ *
+ * Connection Definitions
+ *
+ *  Copyright (C) 2005 by Latchesar Ionkov <lucho@ionkov.net>
+ *  Copyright (C) 2004 by Eric Van Hensbergen <ericvh@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to:
+ *  Free Software Foundation
+ *  51 Franklin Street, Fifth Floor
+ *  Boston, MA  02111-1301  USA
+ *
+ */
+
+#ifndef NET_9P_CONN_H
+#define NET_9P_CONN_H
+
+struct p9_conn;
+struct p9_req;
+
+/**
+ * p9_mux_req_callback - callback function that is called when the
+ * response of a request is received. The callback is called from
+ * a workqueue and shouldn't block.
+ *
+ * @req - request
+ * @a - the pointer that was specified when the request was send to be
+ *      passed to the callback
+ */
+typedef void (*p9_conn_req_callback)(struct p9_req *req, void *a);
+
+struct p9_conn *p9_conn_create(struct p9_transport *trans, int msize,
+	unsigned char *dotu);
+void p9_conn_destroy(struct p9_conn *);
+int p9_conn_rpc(struct p9_conn *m, struct p9_fcall *tc, struct p9_fcall **rc);
+#if 0
+int p9_conn_rpcnb(struct p9_conn *m, struct p9_fcall *tc,
+	p9_conn_req_callback cb, void *a);
+#endif
+void p9_conn_cancel(struct p9_conn *m, int err);
+
+#endif /* NET_9P_CONN_H */
diff --git a/fs/9p/conv.c b/fs/9p/conv.c
index a3ed571..0c4a134 100644
--- a/fs/9p/conv.c
+++ b/fs/9p/conv.c
@@ -1,5 +1,5 @@
 /*
- * linux/fs/9p/conv.c
+ * net/9p/conv.c
  *
  * 9P protocol conversion functions
  *
@@ -30,10 +30,7 @@
 #include <linux/sched.h>
 #include <linux/idr.h>
 #include <asm/uaccess.h>
-#include "debug.h"
-#include "v9fs.h"
 #include "9p.h"
-#include "conv.h"

 /*
  * Buffer to help with string parsing
@@ -59,7 +56,7 @@ static int buf_check_size(struct cbuf *buf, int len)
 {
 	if (buf->p + len > buf->ep) {
 		if (buf->p < buf->ep) {
-			eprintk(KERN_ERR, "buffer overflow: want %d has %d\n",
+			P9_EPRINTK(KERN_ERR, "buffer overflow: want %d has %d\n",
 				len, (int)(buf->ep - buf->p));
 			dump_stack();
 			buf->p = buf->ep + 1;
@@ -183,7 +180,7 @@ static u64 buf_get_int64(struct cbuf *buf)
 	return ret;
 }

-static void buf_get_str(struct cbuf *buf, struct v9fs_str *vstr)
+static void buf_get_str(struct cbuf *buf, struct p9_str *vstr)
 {
 	vstr->len = buf_get_int16(buf);
 	if (!buf_check_overflow(buf) && buf_check_size(buf, vstr->len)) {
@@ -195,7 +192,7 @@ static void buf_get_str(struct cbuf *buf, struct
v9fs_str *vstr)
 	}
 }

-static void buf_get_qid(struct cbuf *bufp, struct v9fs_qid *qid)
+static void buf_get_qid(struct cbuf *bufp, struct p9_qid *qid)
 {
 	qid->type = buf_get_int8(bufp);
 	qid->version = buf_get_int32(bufp);
@@ -203,18 +200,18 @@ static void buf_get_qid(struct cbuf *bufp,
struct v9fs_qid *qid)
 }

 /**
- * v9fs_size_wstat - calculate the size of a variable length stat struct
+ * p9_size_wstat - calculate the size of a variable length stat struct
  * @stat: metadata (stat) structure
- * @extended: non-zero if 9P2000.u
+ * @dotu: non-zero if 9P2000.u
  *
  */

-static int v9fs_size_wstat(struct v9fs_wstat *wstat, int extended)
+static int p9_size_wstat(struct p9_wstat *wstat, int dotu)
 {
 	int size = 0;

 	if (wstat == NULL) {
-		eprintk(KERN_ERR, "v9fs_size_stat: got a NULL stat pointer\n");
+		P9_EPRINTK(KERN_ERR, "p9_size_stat: got a NULL stat pointer\n");
 		return 0;
 	}

@@ -239,7 +236,7 @@ static int v9fs_size_wstat(struct v9fs_wstat
*wstat, int extended)
 	if (wstat->muid)
 		size += strlen(wstat->muid);

-	if (extended) {
+	if (dotu) {
 		size += 4 +	/* n_uid[4] */
 		    4 +		/* n_gid[4] */
 		    4 +		/* n_muid[4] */
@@ -255,12 +252,12 @@ static int v9fs_size_wstat(struct v9fs_wstat
*wstat, int extended)
  * buf_get_stat - safely decode a recieved metadata (stat) structure
  * @bufp: buffer to deserialize
  * @stat: metadata (stat) structure
- * @extended: non-zero if 9P2000.u
+ * @dotu: non-zero if 9P2000.u
  *
  */

 static void
-buf_get_stat(struct cbuf *bufp, struct v9fs_stat *stat, int extended)
+buf_get_stat(struct cbuf *bufp, struct p9_stat *stat, int dotu)
 {
 	stat->size = buf_get_int16(bufp);
 	stat->type = buf_get_int16(bufp);
@@ -277,7 +274,7 @@ buf_get_stat(struct cbuf *bufp, struct v9fs_stat
*stat, int extended)
 	buf_get_str(bufp, &stat->gid);
 	buf_get_str(bufp, &stat->muid);

-	if (extended) {
+	if (dotu) {
 		buf_get_str(bufp, &stat->extension);
 		stat->n_uid = buf_get_int32(bufp);
 		stat->n_gid = buf_get_int32(bufp);
@@ -286,18 +283,18 @@ buf_get_stat(struct cbuf *bufp, struct v9fs_stat
*stat, int extended)
 }

 /**
- * v9fs_deserialize_stat - decode a received metadata structure
+ * p9_deserialize_stat - decode a received metadata structure
  * @buf: buffer to deserialize
  * @buflen: length of received buffer
  * @stat: metadata structure to decode into
- * @extended: non-zero if 9P2000.u
+ * @dotu: non-zero if 9P2000.u
  *
  * Note: stat will point to the buf region.
  */

 int
-v9fs_deserialize_stat(void *buf, u32 buflen, struct v9fs_stat *stat,
-		int extended)
+p9_deserialize_stat(void *buf, u32 buflen, struct p9_stat *stat,
+		int dotu)
 {
 	struct cbuf buffer;
 	struct cbuf *bufp = &buffer;
@@ -305,13 +302,14 @@ v9fs_deserialize_stat(void *buf, u32 buflen,
struct v9fs_stat *stat,

 	buf_init(bufp, buf, buflen);
 	p = bufp->p;
-	buf_get_stat(bufp, stat, extended);
+	buf_get_stat(bufp, stat, dotu);

 	if (buf_check_overflow(bufp))
 		return 0;
 	else
 		return bufp->p - p;
 }
+EXPORT_SYMBOL(p9_deserialize_stat);

 /**
  * deserialize_fcall - unmarshal a response
@@ -319,13 +317,13 @@ v9fs_deserialize_stat(void *buf, u32 buflen,
struct v9fs_stat *stat,
  * @buflen: length of received buffer
  * @rcall: fcall structure to populate
  * @rcalllen: length of fcall structure to populate
- * @extended: non-zero if 9P2000.u
+ * @dotu: non-zero if 9P2000.u
  *
  */

 int
-v9fs_deserialize_fcall(void *buf, u32 buflen, struct v9fs_fcall *rcall,
-		       int extended)
+p9_deserialize_fcall(void *buf, u32 buflen, struct p9_fcall *rcall,
+		       int dotu)
 {

 	struct cbuf buffer;
@@ -338,102 +336,103 @@ v9fs_deserialize_fcall(void *buf, u32 buflen,
struct v9fs_fcall *rcall,
 	rcall->id = buf_get_int8(bufp);
 	rcall->tag = buf_get_int16(bufp);

-	dprintk(DEBUG_CONV, "size %d id %d tag %d\n", rcall->size, rcall->id,
+	P9_DPRINTK(P9_DEBUG_CONV, "size %d id %d tag %d\n", rcall->size, rcall->id,
 		rcall->tag);

 	switch (rcall->id) {
 	default:
-		eprintk(KERN_ERR, "unknown message type: %d\n", rcall->id);
+		P9_EPRINTK(KERN_ERR, "unknown message type: %d\n", rcall->id);
 		return -EPROTO;
-	case RVERSION:
+	case P9_RVERSION:
 		rcall->params.rversion.msize = buf_get_int32(bufp);
 		buf_get_str(bufp, &rcall->params.rversion.version);
 		break;
-	case RFLUSH:
+	case P9_RFLUSH:
 		break;
-	case RATTACH:
+	case P9_RATTACH:
 		rcall->params.rattach.qid.type = buf_get_int8(bufp);
 		rcall->params.rattach.qid.version = buf_get_int32(bufp);
 		rcall->params.rattach.qid.path = buf_get_int64(bufp);
 		break;
-	case RWALK:
+	case P9_RWALK:
 		rcall->params.rwalk.nwqid = buf_get_int16(bufp);
-		if (rcall->params.rwalk.nwqid > V9FS_MAXWELEM) {
-			eprintk(KERN_ERR, "Rwalk with more than %d qids: %d\n",
-				V9FS_MAXWELEM, rcall->params.rwalk.nwqid);
+		if (rcall->params.rwalk.nwqid > P9_MAXWELEM) {
+			P9_EPRINTK(KERN_ERR, "Rwalk with more than %d qids: %d\n",
+				P9_MAXWELEM, rcall->params.rwalk.nwqid);
 			return -EPROTO;
 		}

 		for (i = 0; i < rcall->params.rwalk.nwqid; i++)
 			buf_get_qid(bufp, &rcall->params.rwalk.wqids[i]);
 		break;
-	case ROPEN:
+	case P9_ROPEN:
 		buf_get_qid(bufp, &rcall->params.ropen.qid);
 		rcall->params.ropen.iounit = buf_get_int32(bufp);
 		break;
-	case RCREATE:
+	case P9_RCREATE:
 		buf_get_qid(bufp, &rcall->params.rcreate.qid);
 		rcall->params.rcreate.iounit = buf_get_int32(bufp);
 		break;
-	case RREAD:
+	case P9_RREAD:
 		rcall->params.rread.count = buf_get_int32(bufp);
 		rcall->params.rread.data = bufp->p;
 		buf_check_size(bufp, rcall->params.rread.count);
 		break;
-	case RWRITE:
+	case P9_RWRITE:
 		rcall->params.rwrite.count = buf_get_int32(bufp);
 		break;
-	case RCLUNK:
+	case P9_RCLUNK:
 		break;
-	case RREMOVE:
+	case P9_RREMOVE:
 		break;
-	case RSTAT:
+	case P9_RSTAT:
 		buf_get_int16(bufp);
-		buf_get_stat(bufp, &rcall->params.rstat.stat, extended);
+		buf_get_stat(bufp, &rcall->params.rstat.stat, dotu);
 		break;
-	case RWSTAT:
+	case P9_RWSTAT:
 		break;
-	case RERROR:
+	case P9_RERROR:
 		buf_get_str(bufp, &rcall->params.rerror.error);
-		if (extended)
+		if (dotu)
 			rcall->params.rerror.errno = buf_get_int16(bufp);
 		break;
 	}

 	if (buf_check_overflow(bufp)) {
-		dprintk(DEBUG_ERROR, "buffer overflow\n");
+		P9_DPRINTK(P9_DEBUG_ERROR, "buffer overflow\n");
 		return -EIO;
 	}

 	return bufp->p - bufp->sp;
 }
+EXPORT_SYMBOL(p9_deserialize_fcall);

-static inline void v9fs_put_int8(struct cbuf *bufp, u8 val, u8 * p)
+static inline void p9_put_int8(struct cbuf *bufp, u8 val, u8 * p)
 {
 	*p = val;
 	buf_put_int8(bufp, val);
 }

-static inline void v9fs_put_int16(struct cbuf *bufp, u16 val, u16 * p)
+static inline void p9_put_int16(struct cbuf *bufp, u16 val, u16 * p)
 {
 	*p = val;
 	buf_put_int16(bufp, val);
 }

-static inline void v9fs_put_int32(struct cbuf *bufp, u32 val, u32 * p)
+static inline void p9_put_int32(struct cbuf *bufp, u32 val, u32 * p)
 {
 	*p = val;
 	buf_put_int32(bufp, val);
 }

-static inline void v9fs_put_int64(struct cbuf *bufp, u64 val, u64 * p)
+static inline void p9_put_int64(struct cbuf *bufp, u64 val, u64 * p)
 {
 	*p = val;
 	buf_put_int64(bufp, val);
 }

 static void
-v9fs_put_str(struct cbuf *bufp, char *data, struct v9fs_str *str)
+p9_put_str(struct cbuf *bufp, char *data, struct p9_str *str)
 {
 	int len;
 	char *s;
@@ -451,7 +450,16 @@ v9fs_put_str(struct cbuf *bufp, char *data,
struct v9fs_str *str)
 }

 static int
-v9fs_put_user_data(struct cbuf *bufp, const char __user * data, int count,
+p9_put_data(struct cbuf *bufp, const char *data, int count,
+		   unsigned char **pdata)
+{
+	*pdata = buf_alloc(bufp, count);
+	memmove(*pdata, data, count);
+	return count;
+}
+
+static int
+p9_put_user_data(struct cbuf *bufp, const char __user * data, int count,
 		   unsigned char **pdata)
 {
 	*pdata = buf_alloc(bufp, count);
@@ -459,73 +467,74 @@ v9fs_put_user_data(struct cbuf *bufp, const char
__user * data, int count,
 }

 static void
-v9fs_put_wstat(struct cbuf *bufp, struct v9fs_wstat *wstat,
-	       struct v9fs_stat *stat, int statsz, int extended)
+p9_put_wstat(struct cbuf *bufp, struct p9_wstat *wstat,
+	       struct p9_stat *stat, int statsz, int dotu)
 {
-	v9fs_put_int16(bufp, statsz, &stat->size);
-	v9fs_put_int16(bufp, wstat->type, &stat->type);
-	v9fs_put_int32(bufp, wstat->dev, &stat->dev);
-	v9fs_put_int8(bufp, wstat->qid.type, &stat->qid.type);
-	v9fs_put_int32(bufp, wstat->qid.version, &stat->qid.version);
-	v9fs_put_int64(bufp, wstat->qid.path, &stat->qid.path);
-	v9fs_put_int32(bufp, wstat->mode, &stat->mode);
-	v9fs_put_int32(bufp, wstat->atime, &stat->atime);
-	v9fs_put_int32(bufp, wstat->mtime, &stat->mtime);
-	v9fs_put_int64(bufp, wstat->length, &stat->length);
+	p9_put_int16(bufp, statsz, &stat->size);
+	p9_put_int16(bufp, wstat->type, &stat->type);
+	p9_put_int32(bufp, wstat->dev, &stat->dev);
+	p9_put_int8(bufp, wstat->qid.type, &stat->qid.type);
+	p9_put_int32(bufp, wstat->qid.version, &stat->qid.version);
+	p9_put_int64(bufp, wstat->qid.path, &stat->qid.path);
+	p9_put_int32(bufp, wstat->mode, &stat->mode);
+	p9_put_int32(bufp, wstat->atime, &stat->atime);
+	p9_put_int32(bufp, wstat->mtime, &stat->mtime);
+	p9_put_int64(bufp, wstat->length, &stat->length);

-	v9fs_put_str(bufp, wstat->name, &stat->name);
-	v9fs_put_str(bufp, wstat->uid, &stat->uid);
-	v9fs_put_str(bufp, wstat->gid, &stat->gid);
-	v9fs_put_str(bufp, wstat->muid, &stat->muid);
+	p9_put_str(bufp, wstat->name, &stat->name);
+	p9_put_str(bufp, wstat->uid, &stat->uid);
+	p9_put_str(bufp, wstat->gid, &stat->gid);
+	p9_put_str(bufp, wstat->muid, &stat->muid);

-	if (extended) {
-		v9fs_put_str(bufp, wstat->extension, &stat->extension);
-		v9fs_put_int32(bufp, wstat->n_uid, &stat->n_uid);
-		v9fs_put_int32(bufp, wstat->n_gid, &stat->n_gid);
-		v9fs_put_int32(bufp, wstat->n_muid, &stat->n_muid);
+	if (dotu) {
+		p9_put_str(bufp, wstat->extension, &stat->extension);
+		p9_put_int32(bufp, wstat->n_uid, &stat->n_uid);
+		p9_put_int32(bufp, wstat->n_gid, &stat->n_gid);
+		p9_put_int32(bufp, wstat->n_muid, &stat->n_muid);
 	}
 }

-static struct v9fs_fcall *
-v9fs_create_common(struct cbuf *bufp, u32 size, u8 id)
+static struct p9_fcall *
+p9_create_common(struct cbuf *bufp, u32 size, u8 id)
 {
-	struct v9fs_fcall *fc;
+	struct p9_fcall *fc;

 	size += 4 + 1 + 2;	/* size[4] id[1] tag[2] */
-	fc = kmalloc(sizeof(struct v9fs_fcall) + size, GFP_KERNEL);
+	fc = kmalloc(sizeof(struct p9_fcall) + size, GFP_KERNEL);
 	if (!fc)
 		return ERR_PTR(-ENOMEM);

 	fc->sdata = (char *)fc + sizeof(*fc);

 	buf_init(bufp, (char *)fc->sdata, size);
-	v9fs_put_int32(bufp, size, &fc->size);
-	v9fs_put_int8(bufp, id, &fc->id);
-	v9fs_put_int16(bufp, V9FS_NOTAG, &fc->tag);
+	p9_put_int32(bufp, size, &fc->size);
+	p9_put_int8(bufp, id, &fc->id);
+	p9_put_int16(bufp, P9_NOTAG, &fc->tag);

 	return fc;
 }

-void v9fs_set_tag(struct v9fs_fcall *fc, u16 tag)
+void p9_set_tag(struct p9_fcall *fc, u16 tag)
 {
 	fc->tag = tag;
 	*(__le16 *) (fc->sdata + 5) = cpu_to_le16(tag);
 }
+EXPORT_SYMBOL(p9_set_tag);

-struct v9fs_fcall *v9fs_create_tversion(u32 msize, char *version)
+struct p9_fcall *p9_create_tversion(u32 msize, char *version)
 {
 	int size;
-	struct v9fs_fcall *fc;
+	struct p9_fcall *fc;
 	struct cbuf buffer;
 	struct cbuf *bufp = &buffer;

 	size = 4 + 2 + strlen(version);	/* msize[4] version[s] */
-	fc = v9fs_create_common(bufp, size, TVERSION);
+	fc = p9_create_common(bufp, size, P9_TVERSION);
 	if (IS_ERR(fc))
 		goto error;

-	v9fs_put_int32(bufp, msize, &fc->params.tversion.msize);
-	v9fs_put_str(bufp, version, &fc->params.tversion.version);
+	p9_put_int32(bufp, msize, &fc->params.tversion.msize);
+	p9_put_str(bufp, version, &fc->params.tversion.version);

 	if (buf_check_overflow(bufp)) {
 		kfree(fc);
@@ -534,23 +543,23 @@ struct v9fs_fcall *v9fs_create_tversion(u32
msize, char *version)
       error:
 	return fc;
 }
+EXPORT_SYMBOL(p9_create_tversion);

-#if 0
-struct v9fs_fcall *v9fs_create_tauth(u32 afid, char *uname, char *aname)
+struct p9_fcall *p9_create_tauth(u32 afid, char *uname, char *aname)
 {
 	int size;
-	struct v9fs_fcall *fc;
+	struct p9_fcall *fc;
 	struct cbuf buffer;
 	struct cbuf *bufp = &buffer;

 	size = 4 + 2 + strlen(uname) + 2 + strlen(aname);	/* afid[4]
uname[s] aname[s] */
-	fc = v9fs_create_common(bufp, size, TAUTH);
+	fc = p9_create_common(bufp, size, P9_TAUTH);
 	if (IS_ERR(fc))
 		goto error;

-	v9fs_put_int32(bufp, afid, &fc->params.tauth.afid);
-	v9fs_put_str(bufp, uname, &fc->params.tauth.uname);
-	v9fs_put_str(bufp, aname, &fc->params.tauth.aname);
+	p9_put_int32(bufp, afid, &fc->params.tauth.afid);
+	p9_put_str(bufp, uname, &fc->params.tauth.uname);
+	p9_put_str(bufp, aname, &fc->params.tauth.aname);

 	if (buf_check_overflow(bufp)) {
 		kfree(fc);
@@ -559,43 +568,44 @@ struct v9fs_fcall *v9fs_create_tauth(u32 afid,
char *uname, char *aname)
       error:
 	return fc;
 }
-#endif  /*  0  */
+EXPORT_SYMBOL(p9_create_tauth);

-struct v9fs_fcall *
-v9fs_create_tattach(u32 fid, u32 afid, char *uname, char *aname)
+struct p9_fcall *
+p9_create_tattach(u32 fid, u32 afid, char *uname, char *aname)
 {
 	int size;
-	struct v9fs_fcall *fc;
+	struct p9_fcall *fc;
 	struct cbuf buffer;
 	struct cbuf *bufp = &buffer;

 	size = 4 + 4 + 2 + strlen(uname) + 2 + strlen(aname);	/* fid[4]
afid[4] uname[s] aname[s] */
-	fc = v9fs_create_common(bufp, size, TATTACH);
+	fc = p9_create_common(bufp, size, P9_TATTACH);
 	if (IS_ERR(fc))
 		goto error;

-	v9fs_put_int32(bufp, fid, &fc->params.tattach.fid);
-	v9fs_put_int32(bufp, afid, &fc->params.tattach.afid);
-	v9fs_put_str(bufp, uname, &fc->params.tattach.uname);
-	v9fs_put_str(bufp, aname, &fc->params.tattach.aname);
+	p9_put_int32(bufp, fid, &fc->params.tattach.fid);
+	p9_put_int32(bufp, afid, &fc->params.tattach.afid);
+	p9_put_str(bufp, uname, &fc->params.tattach.uname);
+	p9_put_str(bufp, aname, &fc->params.tattach.aname);

       error:
 	return fc;
 }
+EXPORT_SYMBOL(p9_create_tattach);

-struct v9fs_fcall *v9fs_create_tflush(u16 oldtag)
+struct p9_fcall *p9_create_tflush(u16 oldtag)
 {
 	int size;
-	struct v9fs_fcall *fc;
+	struct p9_fcall *fc;
 	struct cbuf buffer;
 	struct cbuf *bufp = &buffer;

 	size = 2;		/* oldtag[2] */
-	fc = v9fs_create_common(bufp, size, TFLUSH);
+	fc = p9_create_common(bufp, size, P9_TFLUSH);
 	if (IS_ERR(fc))
 		goto error;

-	v9fs_put_int16(bufp, oldtag, &fc->params.tflush.oldtag);
+	p9_put_int16(bufp, oldtag, &fc->params.tflush.oldtag);

 	if (buf_check_overflow(bufp)) {
 		kfree(fc);
@@ -604,17 +614,18 @@ struct v9fs_fcall *v9fs_create_tflush(u16 oldtag)
       error:
 	return fc;
 }
+EXPORT_SYMBOL(p9_create_tflush);

-struct v9fs_fcall *v9fs_create_twalk(u32 fid, u32 newfid, u16 nwname,
+struct p9_fcall *p9_create_twalk(u32 fid, u32 newfid, u16 nwname,
 				     char **wnames)
 {
 	int i, size;
-	struct v9fs_fcall *fc;
+	struct p9_fcall *fc;
 	struct cbuf buffer;
 	struct cbuf *bufp = &buffer;

-	if (nwname > V9FS_MAXWELEM) {
-		dprintk(DEBUG_ERROR, "nwname > %d\n", V9FS_MAXWELEM);
+	if (nwname > P9_MAXWELEM) {
+		P9_DPRINTK(P9_DEBUG_ERROR, "nwname > %d\n", P9_MAXWELEM);
 		return NULL;
 	}

@@ -623,15 +634,15 @@ struct v9fs_fcall *v9fs_create_twalk(u32 fid,
u32 newfid, u16 nwname,
 		size += 2 + strlen(wnames[i]);	/* wname[s] */
 	}

-	fc = v9fs_create_common(bufp, size, TWALK);
+	fc = p9_create_common(bufp, size, P9_TWALK);
 	if (IS_ERR(fc))
 		goto error;

-	v9fs_put_int32(bufp, fid, &fc->params.twalk.fid);
-	v9fs_put_int32(bufp, newfid, &fc->params.twalk.newfid);
-	v9fs_put_int16(bufp, nwname, &fc->params.twalk.nwname);
+	p9_put_int32(bufp, fid, &fc->params.twalk.fid);
+	p9_put_int32(bufp, newfid, &fc->params.twalk.newfid);
+	p9_put_int16(bufp, nwname, &fc->params.twalk.nwname);
 	for (i = 0; i < nwname; i++) {
-		v9fs_put_str(bufp, wnames[i], &fc->params.twalk.wnames[i]);
+		p9_put_str(bufp, wnames[i], &fc->params.twalk.wnames[i]);
 	}

 	if (buf_check_overflow(bufp)) {
@@ -641,21 +652,22 @@ struct v9fs_fcall *v9fs_create_twalk(u32 fid,
u32 newfid, u16 nwname,
       error:
 	return fc;
 }
+EXPORT_SYMBOL(p9_create_twalk);

-struct v9fs_fcall *v9fs_create_topen(u32 fid, u8 mode)
+struct p9_fcall *p9_create_topen(u32 fid, u8 mode)
 {
 	int size;
-	struct v9fs_fcall *fc;
+	struct p9_fcall *fc;
 	struct cbuf buffer;
 	struct cbuf *bufp = &buffer;

 	size = 4 + 1;		/* fid[4] mode[1] */
-	fc = v9fs_create_common(bufp, size, TOPEN);
+	fc = p9_create_common(bufp, size, P9_TOPEN);
 	if (IS_ERR(fc))
 		goto error;

-	v9fs_put_int32(bufp, fid, &fc->params.topen.fid);
-	v9fs_put_int8(bufp, mode, &fc->params.topen.mode);
+	p9_put_int32(bufp, fid, &fc->params.topen.fid);
+	p9_put_int8(bufp, mode, &fc->params.topen.mode);

 	if (buf_check_overflow(bufp)) {
 		kfree(fc);
@@ -664,31 +676,32 @@ struct v9fs_fcall *v9fs_create_topen(u32 fid, u8 mode)
       error:
 	return fc;
 }
+EXPORT_SYMBOL(p9_create_topen);

-struct v9fs_fcall *v9fs_create_tcreate(u32 fid, char *name, u32 perm, u8 mode,
-	char *extension, int extended)
+struct p9_fcall *p9_create_tcreate(u32 fid, char *name, u32 perm, u8 mode,
+	char *extension, int dotu)
 {
 	int size;
-	struct v9fs_fcall *fc;
+	struct p9_fcall *fc;
 	struct cbuf buffer;
 	struct cbuf *bufp = &buffer;

 	size = 4 + 2 + strlen(name) + 4 + 1;	/* fid[4] name[s] perm[4] mode[1] */
-	if (extended) {
+	if (dotu) {
 		size += 2 +			/* extension[s] */
 		    (extension == NULL ? 0 : strlen(extension));
 	}

-	fc = v9fs_create_common(bufp, size, TCREATE);
+	fc = p9_create_common(bufp, size, P9_TCREATE);
 	if (IS_ERR(fc))
 		goto error;

-	v9fs_put_int32(bufp, fid, &fc->params.tcreate.fid);
-	v9fs_put_str(bufp, name, &fc->params.tcreate.name);
-	v9fs_put_int32(bufp, perm, &fc->params.tcreate.perm);
-	v9fs_put_int8(bufp, mode, &fc->params.tcreate.mode);
-	if (extended)
-		v9fs_put_str(bufp, extension, &fc->params.tcreate.extension);
+	p9_put_int32(bufp, fid, &fc->params.tcreate.fid);
+	p9_put_str(bufp, name, &fc->params.tcreate.name);
+	p9_put_int32(bufp, perm, &fc->params.tcreate.perm);
+	p9_put_int8(bufp, mode, &fc->params.tcreate.mode);
+	if (dotu)
+		p9_put_str(bufp, extension, &fc->params.tcreate.extension);

 	if (buf_check_overflow(bufp)) {
 		kfree(fc);
@@ -697,22 +710,54 @@ struct v9fs_fcall *v9fs_create_tcreate(u32 fid,
char *name, u32 perm, u8 mode,
       error:
 	return fc;
 }
+EXPORT_SYMBOL(p9_create_tcreate);

-struct v9fs_fcall *v9fs_create_tread(u32 fid, u64 offset, u32 count)
+struct p9_fcall *p9_create_tread(u32 fid, u64 offset, u32 count)
 {
 	int size;
-	struct v9fs_fcall *fc;
+	struct p9_fcall *fc;
 	struct cbuf buffer;
 	struct cbuf *bufp = &buffer;

 	size = 4 + 8 + 4;	/* fid[4] offset[8] count[4] */
-	fc = v9fs_create_common(bufp, size, TREAD);
+	fc = p9_create_common(bufp, size, P9_TREAD);
+	if (IS_ERR(fc))
+		goto error;
+
+	p9_put_int32(bufp, fid, &fc->params.tread.fid);
+	p9_put_int64(bufp, offset, &fc->params.tread.offset);
+	p9_put_int32(bufp, count, &fc->params.tread.count);
+
+	if (buf_check_overflow(bufp)) {
+		kfree(fc);
+		fc = ERR_PTR(-ENOMEM);
+	}
+      error:
+	return fc;
+}
+EXPORT_SYMBOL(p9_create_tread);
+
+struct p9_fcall *p9_create_twrite(u32 fid, u64 offset, u32 count,
+				      const char *data)
+{
+	int size, err;
+	struct p9_fcall *fc;
+	struct cbuf buffer;
+	struct cbuf *bufp = &buffer;
+
+	size = 4 + 8 + 4 + count;	/* fid[4] offset[8] count[4] data[count] */
+	fc = p9_create_common(bufp, size, P9_TWRITE);
 	if (IS_ERR(fc))
 		goto error;

-	v9fs_put_int32(bufp, fid, &fc->params.tread.fid);
-	v9fs_put_int64(bufp, offset, &fc->params.tread.offset);
-	v9fs_put_int32(bufp, count, &fc->params.tread.count);
+	p9_put_int32(bufp, fid, &fc->params.twrite.fid);
+	p9_put_int64(bufp, offset, &fc->params.twrite.offset);
+	p9_put_int32(bufp, count, &fc->params.twrite.count);
+	err = p9_put_data(bufp, data, count, &fc->params.twrite.data);
+	if (err) {
+		kfree(fc);
+		fc = ERR_PTR(err);
+	}

 	if (buf_check_overflow(bufp)) {
 		kfree(fc);
@@ -721,24 +766,25 @@ struct v9fs_fcall *v9fs_create_tread(u32 fid,
u64 offset, u32 count)
       error:
 	return fc;
 }
+EXPORT_SYMBOL(p9_create_twrite);

-struct v9fs_fcall *v9fs_create_twrite(u32 fid, u64 offset, u32 count,
+struct p9_fcall *p9_create_twrite_u(u32 fid, u64 offset, u32 count,
 				      const char __user * data)
 {
 	int size, err;
-	struct v9fs_fcall *fc;
+	struct p9_fcall *fc;
 	struct cbuf buffer;
 	struct cbuf *bufp = &buffer;

 	size = 4 + 8 + 4 + count;	/* fid[4] offset[8] count[4] data[count] */
-	fc = v9fs_create_common(bufp, size, TWRITE);
+	fc = p9_create_common(bufp, size, P9_TWRITE);
 	if (IS_ERR(fc))
 		goto error;

-	v9fs_put_int32(bufp, fid, &fc->params.twrite.fid);
-	v9fs_put_int64(bufp, offset, &fc->params.twrite.offset);
-	v9fs_put_int32(bufp, count, &fc->params.twrite.count);
-	err = v9fs_put_user_data(bufp, data, count, &fc->params.twrite.data);
+	p9_put_int32(bufp, fid, &fc->params.twrite.fid);
+	p9_put_int64(bufp, offset, &fc->params.twrite.offset);
+	p9_put_int32(bufp, count, &fc->params.twrite.count);
+	err = p9_put_user_data(bufp, data, count, &fc->params.twrite.data);
 	if (err) {
 		kfree(fc);
 		fc = ERR_PTR(err);
@@ -751,20 +797,21 @@ struct v9fs_fcall *v9fs_create_twrite(u32 fid,
u64 offset, u32 count,
       error:
 	return fc;
 }
+EXPORT_SYMBOL(p9_create_twrite_u);

-struct v9fs_fcall *v9fs_create_tclunk(u32 fid)
+struct p9_fcall *p9_create_tclunk(u32 fid)
 {
 	int size;
-	struct v9fs_fcall *fc;
+	struct p9_fcall *fc;
 	struct cbuf buffer;
 	struct cbuf *bufp = &buffer;

 	size = 4;		/* fid[4] */
-	fc = v9fs_create_common(bufp, size, TCLUNK);
+	fc = p9_create_common(bufp, size, P9_TCLUNK);
 	if (IS_ERR(fc))
 		goto error;

-	v9fs_put_int32(bufp, fid, &fc->params.tclunk.fid);
+	p9_put_int32(bufp, fid, &fc->params.tclunk.fid);

 	if (buf_check_overflow(bufp)) {
 		kfree(fc);
@@ -773,20 +820,21 @@ struct v9fs_fcall *v9fs_create_tclunk(u32 fid)
       error:
 	return fc;
 }
+EXPORT_SYMBOL(p9_create_tclunk);

-struct v9fs_fcall *v9fs_create_tremove(u32 fid)
+struct p9_fcall *p9_create_tremove(u32 fid)
 {
 	int size;
-	struct v9fs_fcall *fc;
+	struct p9_fcall *fc;
 	struct cbuf buffer;
 	struct cbuf *bufp = &buffer;

 	size = 4;		/* fid[4] */
-	fc = v9fs_create_common(bufp, size, TREMOVE);
+	fc = p9_create_common(bufp, size, P9_TREMOVE);
 	if (IS_ERR(fc))
 		goto error;

-	v9fs_put_int32(bufp, fid, &fc->params.tremove.fid);
+	p9_put_int32(bufp, fid, &fc->params.tremove.fid);

 	if (buf_check_overflow(bufp)) {
 		kfree(fc);
@@ -795,20 +843,21 @@ struct v9fs_fcall *v9fs_create_tremove(u32 fid)
       error:
 	return fc;
 }
+EXPORT_SYMBOL(p9_create_tremove);

-struct v9fs_fcall *v9fs_create_tstat(u32 fid)
+struct p9_fcall *p9_create_tstat(u32 fid)
 {
 	int size;
-	struct v9fs_fcall *fc;
+	struct p9_fcall *fc;
 	struct cbuf buffer;
 	struct cbuf *bufp = &buffer;

 	size = 4;		/* fid[4] */
-	fc = v9fs_create_common(bufp, size, TSTAT);
+	fc = p9_create_common(bufp, size, P9_TSTAT);
 	if (IS_ERR(fc))
 		goto error;

-	v9fs_put_int32(bufp, fid, &fc->params.tstat.fid);
+	p9_put_int32(bufp, fid, &fc->params.tstat.fid);

 	if (buf_check_overflow(bufp)) {
 		kfree(fc);
@@ -817,24 +866,25 @@ struct v9fs_fcall *v9fs_create_tstat(u32 fid)
       error:
 	return fc;
 }
+EXPORT_SYMBOL(p9_create_tstat);

-struct v9fs_fcall *v9fs_create_twstat(u32 fid, struct v9fs_wstat *wstat,
-				      int extended)
+struct p9_fcall *p9_create_twstat(u32 fid, struct p9_wstat *wstat,
+				      int dotu)
 {
 	int size, statsz;
-	struct v9fs_fcall *fc;
+	struct p9_fcall *fc;
 	struct cbuf buffer;
 	struct cbuf *bufp = &buffer;

-	statsz = v9fs_size_wstat(wstat, extended);
+	statsz = p9_size_wstat(wstat, dotu);
 	size = 4 + 2 + 2 + statsz;	/* fid[4] stat[n] */
-	fc = v9fs_create_common(bufp, size, TWSTAT);
+	fc = p9_create_common(bufp, size, P9_TWSTAT);
 	if (IS_ERR(fc))
 		goto error;

-	v9fs_put_int32(bufp, fid, &fc->params.twstat.fid);
+	p9_put_int32(bufp, fid, &fc->params.twstat.fid);
 	buf_put_int16(bufp, statsz + 2);
-	v9fs_put_wstat(bufp, wstat, &fc->params.twstat.stat, statsz, extended);
+	p9_put_wstat(bufp, wstat, &fc->params.twstat.stat, statsz, dotu);

 	if (buf_check_overflow(bufp)) {
 		kfree(fc);
@@ -843,3 +893,4 @@ struct v9fs_fcall *v9fs_create_twstat(u32 fid,
struct v9fs_wstat *wstat,
       error:
 	return fc;
 }
+EXPORT_SYMBOL(p9_create_twstat);
diff --git a/fs/9p/conv.h b/fs/9p/conv.h
deleted file mode 100644
index dd5b6b1..0000000
--- a/fs/9p/conv.h
+++ /dev/null
@@ -1,50 +0,0 @@
-/*
- * linux/fs/9p/conv.h
- *
- * 9P protocol conversion definitions.
- *
- *  Copyright (C) 2005 by Latchesar Ionkov <lucho@ionkov.net>
- *  Copyright (C) 2004 by Eric Van Hensbergen <ericvh@gmail.com>
- *  Copyright (C) 2002 by Ron Minnich <rminnich@lanl.gov>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2
- *  as published by the Free Software Foundation.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to:
- *  Free Software Foundation
- *  51 Franklin Street, Fifth Floor
- *  Boston, MA  02111-1301  USA
- *
- */
-
-int v9fs_deserialize_stat(void *buf, u32 buflen, struct v9fs_stat *stat,
-	int extended);
-int v9fs_deserialize_fcall(void *buf, u32 buflen, struct v9fs_fcall *rcall,
-	int extended);
-
-void v9fs_set_tag(struct v9fs_fcall *fc, u16 tag);
-
-struct v9fs_fcall *v9fs_create_tversion(u32 msize, char *version);
-struct v9fs_fcall *v9fs_create_tattach(u32 fid, u32 afid, char *uname,
-	char *aname);
-struct v9fs_fcall *v9fs_create_tflush(u16 oldtag);
-struct v9fs_fcall *v9fs_create_twalk(u32 fid, u32 newfid, u16 nwname,
-	char **wnames);
-struct v9fs_fcall *v9fs_create_topen(u32 fid, u8 mode);
-struct v9fs_fcall *v9fs_create_tcreate(u32 fid, char *name, u32 perm, u8 mode,
-	char *extension, int extended);
-struct v9fs_fcall *v9fs_create_tread(u32 fid, u64 offset, u32 count);
-struct v9fs_fcall *v9fs_create_twrite(u32 fid, u64 offset, u32 count,
-	const char __user *data);
-struct v9fs_fcall *v9fs_create_tclunk(u32 fid);
-struct v9fs_fcall *v9fs_create_tremove(u32 fid);
-struct v9fs_fcall *v9fs_create_tstat(u32 fid);
-struct v9fs_fcall *v9fs_create_twstat(u32 fid, struct v9fs_wstat *wstat,
-	int extended);
diff --git a/fs/9p/debug.h b/fs/9p/debug.h
deleted file mode 100644
index 4228c0b..0000000
--- a/fs/9p/debug.h
+++ /dev/null
@@ -1,77 +0,0 @@
-/*
- *  linux/fs/9p/debug.h - V9FS Debug Definitions
- *
- *  Copyright (C) 2004 by Eric Van Hensbergen <ericvh@gmail.com>
- *  Copyright (C) 2002 by Ron Minnich <rminnich@lanl.gov>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2
- *  as published by the Free Software Foundation.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to:
- *  Free Software Foundation
- *  51 Franklin Street, Fifth Floor
- *  Boston, MA  02111-1301  USA
- *
- */
-
-#define DEBUG_ERROR		(1<<0)
-#define DEBUG_CURRENT		(1<<1)
-#define DEBUG_9P	        (1<<2)
-#define DEBUG_VFS	        (1<<3)
-#define DEBUG_CONV		(1<<4)
-#define DEBUG_MUX		(1<<5)
-#define DEBUG_TRANS		(1<<6)
-#define DEBUG_SLABS	      	(1<<7)
-#define DEBUG_FCALL		(1<<8)
-
-#define DEBUG_DUMP_PKT		0
-
-extern int v9fs_debug_level;
-
-#define dprintk(level, format, arg...) \
-do {  \
-	if((v9fs_debug_level & level)==level) \
-		printk(KERN_NOTICE "-- %s (%d): " \
-		format , __FUNCTION__, current->pid , ## arg); \
-} while(0)
-
-#define eprintk(level, format, arg...) \
-do { \
-	printk(level "v9fs: %s (%d): " \
-		format , __FUNCTION__, current->pid , ## arg); \
-} while(0)
-
-#if DEBUG_DUMP_PKT
-static inline void dump_data(const unsigned char *data, unsigned int datalen)
-{
-	int i, n;
-	char buf[5*8];
-
-	n = 0;
-	i = 0;
-	while (i < datalen) {
-		n += snprintf(buf+n, sizeof(buf)-n, "%02x", data[i++]);
-		if (i%4 == 0)
-			n += snprintf(buf+n, sizeof(buf)-n, " ");
-
-		if (i%16 == 0) {
-			dprintk(DEBUG_ERROR, "%s\n", buf);
-			n = 0;
-		}
-	}
-
-	dprintk(DEBUG_ERROR, "%s\n", buf);
-}
-#else				/* DEBUG_DUMP_PKT */
-static inline void dump_data(const unsigned char *data, unsigned int datalen)
-{
-
-}
-#endif				/* DEBUG_DUMP_PKT */
diff --git a/fs/9p/error.c b/fs/9p/error.c
index 0d7fa4e..53f2024 100644
--- a/fs/9p/error.c
+++ b/fs/9p/error.c
@@ -28,20 +28,161 @@
  */

 #include <linux/module.h>
-
 #include <linux/list.h>
 #include <linux/jhash.h>
+#include <linux/errno.h>
+#include <asm/errno.h>
+
+struct errormap {
+	char *name;
+	int val;
+
+	int namelen;
+	struct hlist_node list;
+};

-#include "debug.h"
-#include "error.h"
+#define ERRHASHSZ		32
+static struct hlist_head hash_errmap[ERRHASHSZ];
+
+/* FixMe - reduce to a reasonable size */
+static struct errormap errmap[] = {
+	{"Operation not permitted", EPERM},
+	{"wstat prohibited", EPERM},
+	{"No such file or directory", ENOENT},
+	{"directory entry not found", ENOENT},
+	{"file not found", ENOENT},
+	{"Interrupted system call", EINTR},
+	{"Input/output error", EIO},
+	{"No such device or address", ENXIO},
+	{"Argument list too long", E2BIG},
+	{"Bad file descriptor", EBADF},
+	{"Resource temporarily unavailable", EAGAIN},
+	{"Cannot allocate memory", ENOMEM},
+	{"Permission denied", EACCES},
+	{"Bad address", EFAULT},
+	{"Block device required", ENOTBLK},
+	{"Device or resource busy", EBUSY},
+	{"File exists", EEXIST},
+	{"Invalid cross-device link", EXDEV},
+	{"No such device", ENODEV},
+	{"Not a directory", ENOTDIR},
+	{"Is a directory", EISDIR},
+	{"Invalid argument", EINVAL},
+	{"Too many open files in system", ENFILE},
+	{"Too many open files", EMFILE},
+	{"Text file busy", ETXTBSY},
+	{"File too large", EFBIG},
+	{"No space left on device", ENOSPC},
+	{"Illegal seek", ESPIPE},
+	{"Read-only file system", EROFS},
+	{"Too many links", EMLINK},
+	{"Broken pipe", EPIPE},
+	{"Numerical argument out of domain", EDOM},
+	{"Numerical result out of range", ERANGE},
+	{"Resource deadlock avoided", EDEADLK},
+	{"File name too long", ENAMETOOLONG},
+	{"No locks available", ENOLCK},
+	{"Function not implemented", ENOSYS},
+	{"Directory not empty", ENOTEMPTY},
+	{"Too many levels of symbolic links", ELOOP},
+	{"No message of desired type", ENOMSG},
+	{"Identifier removed", EIDRM},
+	{"No data available", ENODATA},
+	{"Machine is not on the network", ENONET},
+	{"Package not installed", ENOPKG},
+	{"Object is remote", EREMOTE},
+	{"Link has been severed", ENOLINK},
+	{"Communication error on send", ECOMM},
+	{"Protocol error", EPROTO},
+	{"Bad message", EBADMSG},
+	{"File descriptor in bad state", EBADFD},
+	{"Streams pipe error", ESTRPIPE},
+	{"Too many users", EUSERS},
+	{"Socket operation on non-socket", ENOTSOCK},
+	{"Message too long", EMSGSIZE},
+	{"Protocol not available", ENOPROTOOPT},
+	{"Protocol not supported", EPROTONOSUPPORT},
+	{"Socket type not supported", ESOCKTNOSUPPORT},
+	{"Operation not supported", EOPNOTSUPP},
+	{"Protocol family not supported", EPFNOSUPPORT},
+	{"Network is down", ENETDOWN},
+	{"Network is unreachable", ENETUNREACH},
+	{"Network dropped connection on reset", ENETRESET},
+	{"Software caused connection abort", ECONNABORTED},
+	{"Connection reset by peer", ECONNRESET},
+	{"No buffer space available", ENOBUFS},
+	{"Transport endpoint is already connected", EISCONN},
+	{"Transport endpoint is not connected", ENOTCONN},
+	{"Cannot send after transport endpoint shutdown", ESHUTDOWN},
+	{"Connection timed out", ETIMEDOUT},
+	{"Connection refused", ECONNREFUSED},
+	{"Host is down", EHOSTDOWN},
+	{"No route to host", EHOSTUNREACH},
+	{"Operation already in progress", EALREADY},
+	{"Operation now in progress", EINPROGRESS},
+	{"Is a named type file", EISNAM},
+	{"Remote I/O error", EREMOTEIO},
+	{"Disk quota exceeded", EDQUOT},
+/* errors from fossil, vacfs, and u9fs */
+	{"fid unknown or out of range", EBADF},
+	{"permission denied", EACCES},
+	{"file does not exist", ENOENT},
+	{"authentication failed", ECONNREFUSED},
+	{"bad offset in directory read", ESPIPE},
+	{"bad use of fid", EBADF},
+	{"wstat can't convert between files and directories", EPERM},
+	{"directory is not empty", ENOTEMPTY},
+	{"file exists", EEXIST},
+	{"file already exists", EEXIST},
+	{"file or directory already exists", EEXIST},
+	{"fid already in use", EBADF},
+	{"file in use", ETXTBSY},
+	{"i/o error", EIO},
+	{"file already open for I/O", ETXTBSY},
+	{"illegal mode", EINVAL},
+	{"illegal name", ENAMETOOLONG},
+	{"not a directory", ENOTDIR},
+	{"not a member of proposed group", EPERM},
+	{"not owner", EACCES},
+	{"only owner can change group in wstat", EACCES},
+	{"read only file system", EROFS},
+	{"no access to special file", EPERM},
+	{"i/o count too large", EIO},
+	{"unknown group", EINVAL},
+	{"unknown user", EINVAL},
+	{"bogus wstat buffer", EPROTO},
+	{"exclusive use file already open", EAGAIN},
+	{"corrupted directory entry", EIO},
+	{"corrupted file entry", EIO},
+	{"corrupted block label", EIO},
+	{"corrupted meta data", EIO},
+	{"illegal offset", EINVAL},
+	{"illegal path element", ENOENT},
+	{"root of file system is corrupted", EIO},
+	{"corrupted super block", EIO},
+	{"protocol botch", EPROTO},
+	{"file system is full", ENOSPC},
+	{"file is in use", EAGAIN},
+	{"directory entry is not allocated", ENOENT},
+	{"file is read only", EROFS},
+	{"file has been removed", EIDRM},
+	{"only support truncation to zero length", EPERM},
+	{"cannot remove root", EPERM},
+	{"file too big", EFBIG},
+	{"venti i/o error", EIO},
+	/* these are not errors */
+	{"u9fs rhostsauth: no authentication required", 0},
+	{"u9fs authnone: no authentication required", 0},
+	{NULL, -1}
+};

 /**
- * v9fs_error_init - preload
+ * p9_error_init - preload
  * @errstr: error string
  *
  */

-int v9fs_error_init(void)
+int p9_error_init(void)
 {
 	struct errormap *c;
 	int bucket;
@@ -60,6 +201,7 @@ int v9fs_error_init(void)

 	return 1;
 }
+EXPORT_SYMBOL(p9_error_init);

 /**
  * errstr2errno - convert error string to error number
@@ -67,13 +209,17 @@ int v9fs_error_init(void)
  *
  */

-int v9fs_errstr2errno(char *errstr, int len)
+int p9_errstr2errno(char *errstr, int len)
 {
-	int errno = 0;
-	struct hlist_node *p = NULL;
-	struct errormap *c = NULL;
-	int bucket = jhash(errstr, len, 0) % ERRHASHSZ;
+	int errno;
+	struct hlist_node *p;
+	struct errormap *c;
+	int bucket;

+	errno = 0;
+	p = NULL;
+	c = NULL;
+	bucket = jhash(errstr, len, 0) % ERRHASHSZ;
 	hlist_for_each_entry(c, p, &hash_errmap[bucket], list) {
 		if (c->namelen==len && !memcmp(c->name, errstr, len)) {
 			errno = c->val;
@@ -91,3 +237,4 @@ int v9fs_errstr2errno(char *errstr, int len)

 	return -errno;
 }
+EXPORT_SYMBOL(p9_errstr2errno);
diff --git a/fs/9p/error.h b/fs/9p/error.h
deleted file mode 100644
index 5f3ca52..0000000
--- a/fs/9p/error.h
+++ /dev/null
@@ -1,177 +0,0 @@
-/*
- * linux/fs/9p/error.h
- *
- * Huge Nasty Error Table
- *
- * Plan 9 uses error strings, Unix uses error numbers.  This table tries to
- * match UNIX strings and Plan 9 strings to unix error numbers.  It is used
- * to preload the dynamic error table which can also track user-specific error
- * strings.
- *
- *  Copyright (C) 2004 by Eric Van Hensbergen <ericvh@gmail.com>
- *  Copyright (C) 2002 by Ron Minnich <rminnich@lanl.gov>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2
- *  as published by the Free Software Foundation.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to:
- *  Free Software Foundation
- *  51 Franklin Street, Fifth Floor
- *  Boston, MA  02111-1301  USA
- *
- */
-
-#include <linux/errno.h>
-#include <asm/errno.h>
-
-struct errormap {
-	char *name;
-	int val;
-
-	int namelen;
-	struct hlist_node list;
-};
-
-#define ERRHASHSZ		32
-static struct hlist_head hash_errmap[ERRHASHSZ];
-
-/* FixMe - reduce to a reasonable size */
-static struct errormap errmap[] = {
-	{"Operation not permitted", EPERM},
-	{"wstat prohibited", EPERM},
-	{"No such file or directory", ENOENT},
-	{"directory entry not found", ENOENT},
-	{"file not found", ENOENT},
-	{"Interrupted system call", EINTR},
-	{"Input/output error", EIO},
-	{"No such device or address", ENXIO},
-	{"Argument list too long", E2BIG},
-	{"Bad file descriptor", EBADF},
-	{"Resource temporarily unavailable", EAGAIN},
-	{"Cannot allocate memory", ENOMEM},
-	{"Permission denied", EACCES},
-	{"Bad address", EFAULT},
-	{"Block device required", ENOTBLK},
-	{"Device or resource busy", EBUSY},
-	{"File exists", EEXIST},
-	{"Invalid cross-device link", EXDEV},
-	{"No such device", ENODEV},
-	{"Not a directory", ENOTDIR},
-	{"Is a directory", EISDIR},
-	{"Invalid argument", EINVAL},
-	{"Too many open files in system", ENFILE},
-	{"Too many open files", EMFILE},
-	{"Text file busy", ETXTBSY},
-	{"File too large", EFBIG},
-	{"No space left on device", ENOSPC},
-	{"Illegal seek", ESPIPE},
-	{"Read-only file system", EROFS},
-	{"Too many links", EMLINK},
-	{"Broken pipe", EPIPE},
-	{"Numerical argument out of domain", EDOM},
-	{"Numerical result out of range", ERANGE},
-	{"Resource deadlock avoided", EDEADLK},
-	{"File name too long", ENAMETOOLONG},
-	{"No locks available", ENOLCK},
-	{"Function not implemented", ENOSYS},
-	{"Directory not empty", ENOTEMPTY},
-	{"Too many levels of symbolic links", ELOOP},
-	{"No message of desired type", ENOMSG},
-	{"Identifier removed", EIDRM},
-	{"No data available", ENODATA},
-	{"Machine is not on the network", ENONET},
-	{"Package not installed", ENOPKG},
-	{"Object is remote", EREMOTE},
-	{"Link has been severed", ENOLINK},
-	{"Communication error on send", ECOMM},
-	{"Protocol error", EPROTO},
-	{"Bad message", EBADMSG},
-	{"File descriptor in bad state", EBADFD},
-	{"Streams pipe error", ESTRPIPE},
-	{"Too many users", EUSERS},
-	{"Socket operation on non-socket", ENOTSOCK},
-	{"Message too long", EMSGSIZE},
-	{"Protocol not available", ENOPROTOOPT},
-	{"Protocol not supported", EPROTONOSUPPORT},
-	{"Socket type not supported", ESOCKTNOSUPPORT},
-	{"Operation not supported", EOPNOTSUPP},
-	{"Protocol family not supported", EPFNOSUPPORT},
-	{"Network is down", ENETDOWN},
-	{"Network is unreachable", ENETUNREACH},
-	{"Network dropped connection on reset", ENETRESET},
-	{"Software caused connection abort", ECONNABORTED},
-	{"Connection reset by peer", ECONNRESET},
-	{"No buffer space available", ENOBUFS},
-	{"Transport endpoint is already connected", EISCONN},
-	{"Transport endpoint is not connected", ENOTCONN},
-	{"Cannot send after transport endpoint shutdown", ESHUTDOWN},
-	{"Connection timed out", ETIMEDOUT},
-	{"Connection refused", ECONNREFUSED},
-	{"Host is down", EHOSTDOWN},
-	{"No route to host", EHOSTUNREACH},
-	{"Operation already in progress", EALREADY},
-	{"Operation now in progress", EINPROGRESS},
-	{"Is a named type file", EISNAM},
-	{"Remote I/O error", EREMOTEIO},
-	{"Disk quota exceeded", EDQUOT},
-/* errors from fossil, vacfs, and u9fs */
-	{"fid unknown or out of range", EBADF},
-	{"permission denied", EACCES},
-	{"file does not exist", ENOENT},
-	{"authentication failed", ECONNREFUSED},
-	{"bad offset in directory read", ESPIPE},
-	{"bad use of fid", EBADF},
-	{"wstat can't convert between files and directories", EPERM},
-	{"directory is not empty", ENOTEMPTY},
-	{"file exists", EEXIST},
-	{"file already exists", EEXIST},
-	{"file or directory already exists", EEXIST},
-	{"fid already in use", EBADF},
-	{"file in use", ETXTBSY},
-	{"i/o error", EIO},
-	{"file already open for I/O", ETXTBSY},
-	{"illegal mode", EINVAL},
-	{"illegal name", ENAMETOOLONG},
-	{"not a directory", ENOTDIR},
-	{"not a member of proposed group", EPERM},
-	{"not owner", EACCES},
-	{"only owner can change group in wstat", EACCES},
-	{"read only file system", EROFS},
-	{"no access to special file", EPERM},
-	{"i/o count too large", EIO},
-	{"unknown group", EINVAL},
-	{"unknown user", EINVAL},
-	{"bogus wstat buffer", EPROTO},
-	{"exclusive use file already open", EAGAIN},
-	{"corrupted directory entry", EIO},
-	{"corrupted file entry", EIO},
-	{"corrupted block label", EIO},
-	{"corrupted meta data", EIO},
-	{"illegal offset", EINVAL},
-	{"illegal path element", ENOENT},
-	{"root of file system is corrupted", EIO},
-	{"corrupted super block", EIO},
-	{"protocol botch", EPROTO},
-	{"file system is full", ENOSPC},
-	{"file is in use", EAGAIN},
-	{"directory entry is not allocated", ENOENT},
-	{"file is read only", EROFS},
-	{"file has been removed", EIDRM},
-	{"only support truncation to zero length", EPERM},
-	{"cannot remove root", EPERM},
-	{"file too big", EFBIG},
-	{"venti i/o error", EIO},
-	/* these are not errors */
-	{"u9fs rhostsauth: no authentication required", 0},
-	{"u9fs authnone: no authentication required", 0},
-	{NULL, -1}
-};
-
-extern int v9fs_error_init(void);
diff --git a/fs/9p/fcall.c b/fs/9p/fcall.c
index dc336a6..e4bd0cb 100644
--- a/fs/9p/fcall.c
+++ b/fs/9p/fcall.c
@@ -29,12 +29,10 @@
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/idr.h>
-
-#include "debug.h"
-#include "v9fs.h"
 #include "9p.h"
-#include "conv.h"
-#include "mux.h"
+#include "transport.h"
+#include "conn.h"
+#include "v9fs.h"

 /**
  * v9fs_t_version - negotiate protocol parameters with sever
@@ -47,16 +45,16 @@

 int
 v9fs_t_version(struct v9fs_session_info *v9ses, u32 msize,
-	       char *version, struct v9fs_fcall **rcp)
+	       char *version, struct p9_fcall **rcp)
 {
 	int ret;
-	struct v9fs_fcall *tc;
+	struct p9_fcall *tc;

-	dprintk(DEBUG_9P, "msize: %d version: %s\n", msize, version);
-	tc = v9fs_create_tversion(msize, version);
+	P9_DPRINTK(P9_DEBUG_9P, "msize: %d version: %s\n", msize, version);
+	tc = p9_create_tversion(msize, version);

 	if (!IS_ERR(tc)) {
-		ret = v9fs_mux_rpc(v9ses->mux, tc, rcp);
+		ret = p9_conn_rpc(v9ses->conn, tc, rcp);
 		kfree(tc);
 	} else
 		ret = PTR_ERR(tc);
@@ -77,17 +75,17 @@ v9fs_t_version(struct v9fs_session_info *v9ses, u32 msize,

 int
 v9fs_t_attach(struct v9fs_session_info *v9ses, char *uname, char *aname,
-	      u32 fid, u32 afid, struct v9fs_fcall **rcp)
+	      u32 fid, u32 afid, struct p9_fcall **rcp)
 {
 	int ret;
-	struct v9fs_fcall* tc;
+	struct p9_fcall* tc;

-	dprintk(DEBUG_9P, "uname '%s' aname '%s' fid %d afid %d\n", uname,
+	P9_DPRINTK(P9_DEBUG_9P, "uname '%s' aname '%s' fid %d afid %d\n", uname,
 		aname, fid, afid);

-	tc = v9fs_create_tattach(fid, afid, uname, aname);
+	tc = p9_create_tattach(fid, afid, uname, aname);
 	if (!IS_ERR(tc)) {
-		ret = v9fs_mux_rpc(v9ses->mux, tc, rcp);
+		ret = p9_conn_rpc(v9ses->conn, tc, rcp);
 		kfree(tc);
 	} else
 		ret = PTR_ERR(tc);
@@ -95,8 +93,8 @@ v9fs_t_attach(struct v9fs_session_info *v9ses, char
*uname, char *aname,
 	return ret;
 }

-static void v9fs_t_clunk_cb(void *a, struct v9fs_fcall *tc,
-	struct v9fs_fcall *rc, int err)
+static void v9fs_t_clunk_cb(void *a, struct p9_fcall *tc,
+	struct p9_fcall *rc, int err)
 {
 	int fid, id;
 	struct v9fs_session_info *v9ses;
@@ -108,9 +106,9 @@ static void v9fs_t_clunk_cb(void *a, struct v9fs_fcall *tc,

 	kfree(tc);
 	kfree(rc);
-	if (id == RCLUNK) {
+	if (id == P9_RCLUNK) {
 		v9ses = a;
-		v9fs_put_idpool(fid, &v9ses->fidpool);
+		p9_idpool_put(fid, v9ses->fidpool);
 	}
 }

@@ -126,19 +124,19 @@ int
 v9fs_t_clunk(struct v9fs_session_info *v9ses, u32 fid)
 {
 	int ret;
-	struct v9fs_fcall *tc, *rc;
+	struct p9_fcall *tc, *rc;

-	dprintk(DEBUG_9P, "fid %d\n", fid);
+	P9_DPRINTK(P9_DEBUG_9P, "fid %d\n", fid);

 	rc = NULL;
-	tc = v9fs_create_tclunk(fid);
+	tc = p9_create_tclunk(fid);
 	if (!IS_ERR(tc))
-		ret = v9fs_mux_rpc(v9ses->mux, tc, &rc);
+		ret = p9_conn_rpc(v9ses->conn, tc, &rc);
 	else
 		ret = PTR_ERR(tc);

 	if (ret)
-		dprintk(DEBUG_ERROR, "failed fid %d err %d\n", fid, ret);
+		P9_DPRINTK(P9_DEBUG_ERROR, "failed fid %d err %d\n", fid, ret);

 	v9fs_t_clunk_cb(v9ses, tc, rc, ret);
 	return ret;
@@ -154,13 +152,13 @@ v9fs_t_clunk(struct v9fs_session_info *v9ses, u32 fid)
 int v9fs_t_flush(struct v9fs_session_info *v9ses, u16 oldtag)
 {
 	int ret;
-	struct v9fs_fcall *tc;
+	struct p9_fcall *tc;

-	dprintk(DEBUG_9P, "oldtag %d\n", oldtag);
+	P9_DPRINTK(P9_DEBUG_9P, "oldtag %d\n", oldtag);

-	tc = v9fs_create_tflush(oldtag);
+	tc = p9_create_tflush(oldtag);
 	if (!IS_ERR(tc)) {
-		ret = v9fs_mux_rpc(v9ses->mux, tc, NULL);
+		ret = p9_conn_rpc(v9ses->conn, tc, NULL);
 		kfree(tc);
 	} else
 		ret = PTR_ERR(tc);
@@ -178,17 +176,17 @@ int v9fs_t_flush(struct v9fs_session_info
*v9ses, u16 oldtag)
  */

 int
-v9fs_t_stat(struct v9fs_session_info *v9ses, u32 fid, struct v9fs_fcall **rcp)
+v9fs_t_stat(struct v9fs_session_info *v9ses, u32 fid, struct p9_fcall **rcp)
 {
 	int ret;
-	struct v9fs_fcall *tc;
+	struct p9_fcall *tc;

-	dprintk(DEBUG_9P, "fid %d\n", fid);
+	P9_DPRINTK(P9_DEBUG_9P, "fid %d\n", fid);

 	ret = -ENOMEM;
-	tc = v9fs_create_tstat(fid);
+	tc = p9_create_tstat(fid);
 	if (!IS_ERR(tc)) {
-		ret = v9fs_mux_rpc(v9ses->mux, tc, rcp);
+		ret = p9_conn_rpc(v9ses->conn, tc, rcp);
 		kfree(tc);
 	} else
 		ret = PTR_ERR(tc);
@@ -207,16 +205,16 @@ v9fs_t_stat(struct v9fs_session_info *v9ses, u32
fid, struct v9fs_fcall **rcp)

 int
 v9fs_t_wstat(struct v9fs_session_info *v9ses, u32 fid,
-	     struct v9fs_wstat *wstat, struct v9fs_fcall **rcp)
+	     struct p9_wstat *wstat, struct p9_fcall **rcp)
 {
 	int ret;
-	struct v9fs_fcall *tc;
+	struct p9_fcall *tc;

-	dprintk(DEBUG_9P, "fid %d\n", fid);
+	P9_DPRINTK(P9_DEBUG_9P, "fid %d\n", fid);

-	tc = v9fs_create_twstat(fid, wstat, v9ses->extended);
+	tc = p9_create_twstat(fid, wstat, v9ses->extended);
 	if (!IS_ERR(tc)) {
-		ret = v9fs_mux_rpc(v9ses->mux, tc, rcp);
+		ret = p9_conn_rpc(v9ses->conn, tc, rcp);
 		kfree(tc);
 	} else
 		ret = PTR_ERR(tc);
@@ -238,22 +236,22 @@ v9fs_t_wstat(struct v9fs_session_info *v9ses, u32 fid,

 int
 v9fs_t_walk(struct v9fs_session_info *v9ses, u32 fid, u32 newfid,
-	    char *name, struct v9fs_fcall **rcp)
+	    char *name, struct p9_fcall **rcp)
 {
 	int ret;
-	struct v9fs_fcall *tc;
+	struct p9_fcall *tc;
 	int nwname;

-	dprintk(DEBUG_9P, "fid %d newfid %d wname '%s'\n", fid, newfid, name);
+	P9_DPRINTK(P9_DEBUG_9P, "fid %d newfid %d wname '%s'\n", fid, newfid, name);

 	if (name)
 		nwname = 1;
 	else
 		nwname = 0;

-	tc = v9fs_create_twalk(fid, newfid, nwname, &name);
+	tc = p9_create_twalk(fid, newfid, nwname, &name);
 	if (!IS_ERR(tc)) {
-		ret = v9fs_mux_rpc(v9ses->mux, tc, rcp);
+		ret = p9_conn_rpc(v9ses->conn, tc, rcp);
 		kfree(tc);
 	} else
 		ret = PTR_ERR(tc);
@@ -273,16 +271,16 @@ v9fs_t_walk(struct v9fs_session_info *v9ses, u32
fid, u32 newfid,

 int
 v9fs_t_open(struct v9fs_session_info *v9ses, u32 fid, u8 mode,
-	    struct v9fs_fcall **rcp)
+	    struct p9_fcall **rcp)
 {
 	int ret;
-	struct v9fs_fcall *tc;
+	struct p9_fcall *tc;

-	dprintk(DEBUG_9P, "fid %d mode %d\n", fid, mode);
+	P9_DPRINTK(P9_DEBUG_9P, "fid %d mode %d\n", fid, mode);

-	tc = v9fs_create_topen(fid, mode);
+	tc = p9_create_topen(fid, mode);
 	if (!IS_ERR(tc)) {
-		ret = v9fs_mux_rpc(v9ses->mux, tc, rcp);
+		ret = p9_conn_rpc(v9ses->conn, tc, rcp);
 		kfree(tc);
 	} else
 		ret = PTR_ERR(tc);
@@ -300,16 +298,16 @@ v9fs_t_open(struct v9fs_session_info *v9ses, u32
fid, u8 mode,

 int
 v9fs_t_remove(struct v9fs_session_info *v9ses, u32 fid,
-	      struct v9fs_fcall **rcp)
+	      struct p9_fcall **rcp)
 {
 	int ret;
-	struct v9fs_fcall *tc;
+	struct p9_fcall *tc;

-	dprintk(DEBUG_9P, "fid %d\n", fid);
+	P9_DPRINTK(P9_DEBUG_9P, "fid %d\n", fid);

-	tc = v9fs_create_tremove(fid);
+	tc = p9_create_tremove(fid);
 	if (!IS_ERR(tc)) {
-		ret = v9fs_mux_rpc(v9ses->mux, tc, rcp);
+		ret = p9_conn_rpc(v9ses->conn, tc, rcp);
 		kfree(tc);
 	} else
 		ret = PTR_ERR(tc);
@@ -330,19 +328,19 @@ v9fs_t_remove(struct v9fs_session_info *v9ses, u32 fid,

 int
 v9fs_t_create(struct v9fs_session_info *v9ses, u32 fid, char *name, u32 perm,
-	u8 mode, char *extension, struct v9fs_fcall **rcp)
+	u8 mode, char *extension, struct p9_fcall **rcp)
 {
 	int ret;
-	struct v9fs_fcall *tc;
+	struct p9_fcall *tc;

-	dprintk(DEBUG_9P, "fid %d name '%s' perm %x mode %d\n",
+	P9_DPRINTK(P9_DEBUG_9P, "fid %d name '%s' perm %x mode %d\n",
 		fid, name, perm, mode);

-	tc = v9fs_create_tcreate(fid, name, perm, mode, extension,
+	tc = p9_create_tcreate(fid, name, perm, mode, extension,
 		v9ses->extended);

 	if (!IS_ERR(tc)) {
-		ret = v9fs_mux_rpc(v9ses->mux, tc, rcp);
+		ret = p9_conn_rpc(v9ses->conn, tc, rcp);
 		kfree(tc);
 	} else
 		ret = PTR_ERR(tc);
@@ -362,17 +360,17 @@ v9fs_t_create(struct v9fs_session_info *v9ses,
u32 fid, char *name, u32 perm,

 int
 v9fs_t_read(struct v9fs_session_info *v9ses, u32 fid, u64 offset,
-	    u32 count, struct v9fs_fcall **rcp)
+	    u32 count, struct p9_fcall **rcp)
 {
 	int ret;
-	struct v9fs_fcall *tc, *rc;
+	struct p9_fcall *tc, *rc;

-	dprintk(DEBUG_9P, "fid %d offset 0x%llux count 0x%x\n", fid,
+	P9_DPRINTK(P9_DEBUG_9P, "fid %d offset 0x%llux count 0x%x\n", fid,
 		(long long unsigned) offset, count);

-	tc = v9fs_create_tread(fid, offset, count);
+	tc = p9_create_tread(fid, offset, count);
 	if (!IS_ERR(tc)) {
-		ret = v9fs_mux_rpc(v9ses->mux, tc, &rc);
+		ret = p9_conn_rpc(v9ses->conn, tc, &rc);
 		if (!ret)
 			ret = rc->params.rread.count;
 		if (rcp)
@@ -399,17 +397,18 @@ v9fs_t_read(struct v9fs_session_info *v9ses, u32
fid, u64 offset,

 int
 v9fs_t_write(struct v9fs_session_info *v9ses, u32 fid, u64 offset, u32 count,
-	const char __user *data, struct v9fs_fcall **rcp)
+	const char __user *data, struct p9_fcall **rcp)
 {
 	int ret;
-	struct v9fs_fcall *tc, *rc;
+	struct p9_fcall *tc, *rc;

-	dprintk(DEBUG_9P, "fid %d offset 0x%llux count 0x%x\n", fid,
+	P9_DPRINTK(P9_DEBUG_9P, "fid %d offset 0x%llux count 0x%x\n", fid,
 		(long long unsigned) offset, count);

-	tc = v9fs_create_twrite(fid, offset, count, data);
+	tc = p9_create_twrite_u(fid, offset, count, data);
+	P9_DPRINTK(P9_DEBUG_ERROR, "tcall %p\n", tc);
 	if (!IS_ERR(tc)) {
-		ret = v9fs_mux_rpc(v9ses->mux, tc, &rc);
+		ret = p9_conn_rpc(v9ses->conn, tc, &rc);

 		if (!ret)
 			ret = rc->params.rwrite.count;
diff --git a/fs/9p/fcprint.c b/fs/9p/fcprint.c
index 34b9611..2a80c4b 100644
--- a/fs/9p/fcprint.c
+++ b/fs/9p/fcprint.c
@@ -1,5 +1,5 @@
 /*
- *  linux/fs/9p/fcprint.c
+ *  net/9p/fcprint.c
  *
  *  Print 9P call.
  *
@@ -25,30 +25,28 @@
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/idr.h>
-
-#include "debug.h"
-#include "v9fs.h"
 #include "9p.h"
-#include "mux.h"
+
+#ifdef CONFIG_NET_9P_DEBUG

 static int
-v9fs_printqid(char *buf, int buflen, struct v9fs_qid *q)
+p9_printqid(char *buf, int buflen, struct p9_qid *q)
 {
 	int n;
 	char b[10];

 	n = 0;
-	if (q->type & V9FS_QTDIR)
+	if (q->type & P9_QTDIR)
 		b[n++] = 'd';
-	if (q->type & V9FS_QTAPPEND)
+	if (q->type & P9_QTAPPEND)
 		b[n++] = 'a';
-	if (q->type & V9FS_QTAUTH)
+	if (q->type & P9_QTAUTH)
 		b[n++] = 'A';
-	if (q->type & V9FS_QTEXCL)
+	if (q->type & P9_QTEXCL)
 		b[n++] = 'l';
-	if (q->type & V9FS_QTTMP)
+	if (q->type & P9_QTTMP)
 		b[n++] = 't';
-	if (q->type & V9FS_QTSYMLINK)
+	if (q->type & P9_QTSYMLINK)
 		b[n++] = 'L';
 	b[n] = '\0';

@@ -57,29 +55,29 @@ v9fs_printqid(char *buf, int buflen, struct v9fs_qid *q)
 }

 static int
-v9fs_printperm(char *buf, int buflen, int perm)
+p9_printperm(char *buf, int buflen, int perm)
 {
 	int n;
 	char b[15];

 	n = 0;
-	if (perm & V9FS_DMDIR)
+	if (perm & P9_DMDIR)
 		b[n++] = 'd';
-	if (perm & V9FS_DMAPPEND)
+	if (perm & P9_DMAPPEND)
 		b[n++] = 'a';
-	if (perm & V9FS_DMAUTH)
+	if (perm & P9_DMAUTH)
 		b[n++] = 'A';
-	if (perm & V9FS_DMEXCL)
+	if (perm & P9_DMEXCL)
 		b[n++] = 'l';
-	if (perm & V9FS_DMTMP)
+	if (perm & P9_DMTMP)
 		b[n++] = 't';
-	if (perm & V9FS_DMDEVICE)
+	if (perm & P9_DMDEVICE)
 		b[n++] = 'D';
-	if (perm & V9FS_DMSOCKET)
+	if (perm & P9_DMSOCKET)
 		b[n++] = 'S';
-	if (perm & V9FS_DMNAMEDPIPE)
+	if (perm & P9_DMNAMEDPIPE)
 		b[n++] = 'P';
-	if (perm & V9FS_DMSYMLINK)
+	if (perm & P9_DMSYMLINK)
 		b[n++] = 'L';
 	b[n] = '\0';

@@ -87,7 +85,7 @@ v9fs_printperm(char *buf, int buflen, int perm)
 }

 static int
-v9fs_printstat(char *buf, int buflen, struct v9fs_stat *st, int extended)
+p9_printstat(char *buf, int buflen, struct p9_stat *st, int extended)
 {
 	int n;

@@ -105,9 +103,9 @@ v9fs_printstat(char *buf, int buflen, struct
v9fs_stat *st, int extended)
 		n += scnprintf(buf+n, buflen-n, "(%d)", st->n_muid);

 	n += scnprintf(buf+n, buflen-n, " q ");
-	n += v9fs_printqid(buf+n, buflen-n, &st->qid);
+	n += p9_printqid(buf+n, buflen-n, &st->qid);
 	n += scnprintf(buf+n, buflen-n, " m ");
-	n += v9fs_printperm(buf+n, buflen-n, st->mode);
+	n += p9_printperm(buf+n, buflen-n, st->mode);
 	n += scnprintf(buf+n, buflen-n, " at %d mt %d l %lld",
 		st->atime, st->mtime, (long long int) st->length);

@@ -119,7 +117,7 @@ v9fs_printstat(char *buf, int buflen, struct
v9fs_stat *st, int extended)
 }

 static int
-v9fs_dumpdata(char *buf, int buflen, u8 *data, int datalen)
+p9_dumpdata(char *buf, int buflen, u8 *data, int datalen)
 {
 	int i, n;

@@ -139,13 +137,13 @@ v9fs_dumpdata(char *buf, int buflen, u8 *data,
int datalen)
 }

 static int
-v9fs_printdata(char *buf, int buflen, u8 *data, int datalen)
+p9_printdata(char *buf, int buflen, u8 *data, int datalen)
 {
-	return v9fs_dumpdata(buf, buflen, data, datalen<16?datalen:16);
+	return p9_dumpdata(buf, buflen, data, datalen<16?datalen:16);
 }

 int
-v9fs_printfcall(char *buf, int buflen, struct v9fs_fcall *fc, int extended)
+p9_printfcall(char *buf, int buflen, struct p9_fcall *fc, int extended)
 {
 	int i, ret, type, tag;

@@ -157,21 +155,21 @@ v9fs_printfcall(char *buf, int buflen, struct
v9fs_fcall *fc, int extended)

 	ret = 0;
 	switch (type) {
-	case TVERSION:
+	case P9_TVERSION:
 		ret += scnprintf(buf+ret, buflen-ret,
 			"Tversion tag %u msize %u version '%.*s'", tag,
 			fc->params.tversion.msize, fc->params.tversion.version.len,
 			fc->params.tversion.version.str);
 		break;

-	case RVERSION:
+	case P9_RVERSION:
 		ret += scnprintf(buf+ret, buflen-ret,
 			"Rversion tag %u msize %u version '%.*s'", tag,
 			fc->params.rversion.msize, fc->params.rversion.version.len,
 			fc->params.rversion.version.str);
 		break;

-	case TAUTH:
+	case P9_TAUTH:
 		ret += scnprintf(buf+ret, buflen-ret,
 			"Tauth tag %u afid %d uname '%.*s' aname '%.*s'", tag,
 			fc->params.tauth.afid, fc->params.tauth.uname.len,
@@ -179,12 +177,12 @@ v9fs_printfcall(char *buf, int buflen, struct
v9fs_fcall *fc, int extended)
 			fc->params.tauth.aname.str);
 		break;

-	case RAUTH:
+	case P9_RAUTH:
 		ret += scnprintf(buf+ret, buflen-ret, "Rauth tag %u qid ", tag);
-		v9fs_printqid(buf+ret, buflen-ret, &fc->params.rauth.qid);
+		p9_printqid(buf+ret, buflen-ret, &fc->params.rauth.qid);
 		break;

-	case TATTACH:
+	case P9_TATTACH:
 		ret += scnprintf(buf+ret, buflen-ret,
 			"Tattach tag %u fid %d afid %d uname '%.*s' aname '%.*s'",
 			tag, fc->params.tattach.fid, fc->params.tattach.afid,
@@ -192,12 +190,12 @@ v9fs_printfcall(char *buf, int buflen, struct
v9fs_fcall *fc, int extended)
 			fc->params.tattach.aname.len, fc->params.tattach.aname.str);
 		break;

-	case RATTACH:
+	case P9_RATTACH:
 		ret += scnprintf(buf+ret, buflen-ret, "Rattach tag %u qid ", tag);
-		v9fs_printqid(buf+ret, buflen-ret, &fc->params.rattach.qid);
+		p9_printqid(buf+ret, buflen-ret, &fc->params.rattach.qid);
 		break;

-	case RERROR:
+	case P9_RERROR:
 		ret += scnprintf(buf+ret, buflen-ret, "Rerror tag %u ename '%.*s'",
 			tag, fc->params.rerror.error.len,
 			fc->params.rerror.error.str);
@@ -206,16 +204,16 @@ v9fs_printfcall(char *buf, int buflen, struct
v9fs_fcall *fc, int extended)
 				fc->params.rerror.errno);
 		break;

-	case TFLUSH:
+	case P9_TFLUSH:
 		ret += scnprintf(buf+ret, buflen-ret, "Tflush tag %u oldtag %u",
 			tag, fc->params.tflush.oldtag);
 		break;

-	case RFLUSH:
+	case P9_RFLUSH:
 		ret += scnprintf(buf+ret, buflen-ret, "Rflush tag %u", tag);
 		break;

-	case TWALK:
+	case P9_TWALK:
 		ret += scnprintf(buf+ret, buflen-ret,
 			"Twalk tag %u fid %d newfid %d nwname %d", tag,
 			fc->params.twalk.fid, fc->params.twalk.newfid,
@@ -226,46 +224,46 @@ v9fs_printfcall(char *buf, int buflen, struct
v9fs_fcall *fc, int extended)
 				fc->params.twalk.wnames[i].str);
 		break;

-	case RWALK:
+	case P9_RWALK:
 		ret += scnprintf(buf+ret, buflen-ret, "Rwalk tag %u nwqid %d",
 			tag, fc->params.rwalk.nwqid);
 		for(i = 0; i < fc->params.rwalk.nwqid; i++)
-			ret += v9fs_printqid(buf+ret, buflen-ret,
+			ret += p9_printqid(buf+ret, buflen-ret,
 				&fc->params.rwalk.wqids[i]);
 		break;

-	case TOPEN:
+	case P9_TOPEN:
 		ret += scnprintf(buf+ret, buflen-ret,
 			"Topen tag %u fid %d mode %d", tag,
 			fc->params.topen.fid, fc->params.topen.mode);
 		break;

-	case ROPEN:
+	case P9_ROPEN:
 		ret += scnprintf(buf+ret, buflen-ret, "Ropen tag %u", tag);
-		ret += v9fs_printqid(buf+ret, buflen-ret, &fc->params.ropen.qid);
+		ret += p9_printqid(buf+ret, buflen-ret, &fc->params.ropen.qid);
 		ret += scnprintf(buf+ret, buflen-ret," iounit %d",
 			fc->params.ropen.iounit);
 		break;

-	case TCREATE:
+	case P9_TCREATE:
 		ret += scnprintf(buf+ret, buflen-ret,
 			"Tcreate tag %u fid %d name '%.*s' perm ", tag,
 			fc->params.tcreate.fid, fc->params.tcreate.name.len,
 			fc->params.tcreate.name.str);

-		ret += v9fs_printperm(buf+ret, buflen-ret, fc->params.tcreate.perm);
+		ret += p9_printperm(buf+ret, buflen-ret, fc->params.tcreate.perm);
 		ret += scnprintf(buf+ret, buflen-ret, " mode %d",
 			fc->params.tcreate.mode);
 		break;

-	case RCREATE:
+	case P9_RCREATE:
 		ret += scnprintf(buf+ret, buflen-ret, "Rcreate tag %u", tag);
-		ret += v9fs_printqid(buf+ret, buflen-ret, &fc->params.rcreate.qid);
+		ret += p9_printqid(buf+ret, buflen-ret, &fc->params.rcreate.qid);
 		ret += scnprintf(buf+ret, buflen-ret, " iounit %d",
 			fc->params.rcreate.iounit);
 		break;

-	case TREAD:
+	case P9_TREAD:
 		ret += scnprintf(buf+ret, buflen-ret,
 			"Tread tag %u fid %d offset %lld count %u", tag,
 			fc->params.tread.fid,
@@ -273,66 +271,66 @@ v9fs_printfcall(char *buf, int buflen, struct
v9fs_fcall *fc, int extended)
 			fc->params.tread.count);
 		break;

-	case RREAD:
+	case P9_RREAD:
 		ret += scnprintf(buf+ret, buflen-ret,
 			"Rread tag %u count %u data ", tag,
 			fc->params.rread.count);
-		ret += v9fs_printdata(buf+ret, buflen-ret, fc->params.rread.data,
+		ret += p9_printdata(buf+ret, buflen-ret, fc->params.rread.data,
 			fc->params.rread.count);
 		break;

-	case TWRITE:
+	case P9_TWRITE:
 		ret += scnprintf(buf+ret, buflen-ret,
 			"Twrite tag %u fid %d offset %lld count %u data ",
 			tag, fc->params.twrite.fid,
 			(long long int) fc->params.twrite.offset,
 			fc->params.twrite.count);
-		ret += v9fs_printdata(buf+ret, buflen-ret, fc->params.twrite.data,
+		ret += p9_printdata(buf+ret, buflen-ret, fc->params.twrite.data,
 			fc->params.twrite.count);
 		break;

-	case RWRITE:
+	case P9_RWRITE:
 		ret += scnprintf(buf+ret, buflen-ret, "Rwrite tag %u count %u",
 			tag, fc->params.rwrite.count);
 		break;

-	case TCLUNK:
+	case P9_TCLUNK:
 		ret += scnprintf(buf+ret, buflen-ret, "Tclunk tag %u fid %d",
 			tag, fc->params.tclunk.fid);
 		break;

-	case RCLUNK:
+	case P9_RCLUNK:
 		ret += scnprintf(buf+ret, buflen-ret, "Rclunk tag %u", tag);
 		break;

-	case TREMOVE:
+	case P9_TREMOVE:
 		ret += scnprintf(buf+ret, buflen-ret, "Tremove tag %u fid %d",
 			tag, fc->params.tremove.fid);
 		break;

-	case RREMOVE:
+	case P9_RREMOVE:
 		ret += scnprintf(buf+ret, buflen-ret, "Rremove tag %u", tag);
 		break;

-	case TSTAT:
+	case P9_TSTAT:
 		ret += scnprintf(buf+ret, buflen-ret, "Tstat tag %u fid %d",
 			tag, fc->params.tstat.fid);
 		break;

-	case RSTAT:
+	case P9_RSTAT:
 		ret += scnprintf(buf+ret, buflen-ret, "Rstat tag %u ", tag);
-		ret += v9fs_printstat(buf+ret, buflen-ret, &fc->params.rstat.stat,
+		ret += p9_printstat(buf+ret, buflen-ret, &fc->params.rstat.stat,
 			extended);
 		break;

-	case TWSTAT:
+	case P9_TWSTAT:
 		ret += scnprintf(buf+ret, buflen-ret, "Twstat tag %u fid %d ",
 			tag, fc->params.twstat.fid);
-		ret += v9fs_printstat(buf+ret, buflen-ret, &fc->params.twstat.stat,
+		ret += p9_printstat(buf+ret, buflen-ret, &fc->params.twstat.stat,
 			extended);
 		break;

-	case RWSTAT:
+	case P9_RWSTAT:
 		ret += scnprintf(buf+ret, buflen-ret, "Rwstat tag %u", tag);
 		break;

@@ -343,3 +341,13 @@ v9fs_printfcall(char *buf, int buflen, struct
v9fs_fcall *fc, int extended)

 	return ret;
 }
+
+#else
+int
+p9_printfcall(char *buf, int buflen, struct p9_fcall *fc, int extended)
+{
+	return 0;
+}
+#endif /* CONFIG_NET_9P_DEBUG */
+
+EXPORT_SYMBOL(p9_printfcall);
diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index 9041971..68d69ef 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -26,10 +26,8 @@
 #include <linux/sched.h>
 #include <linux/idr.h>
 #include <asm/semaphore.h>
-
-#include "debug.h"
-#include "v9fs.h"
 #include "9p.h"
+#include "v9fs.h"
 #include "v9fs_vfs.h"
 #include "fid.h"

@@ -43,13 +41,13 @@
 int v9fs_fid_insert(struct v9fs_fid *fid, struct dentry *dentry)
 {
 	struct list_head *fid_list = (struct list_head *)dentry->d_fsdata;
-	dprintk(DEBUG_9P, "fid %d (%p) dentry %s (%p)\n", fid->fid, fid,
+	P9_DPRINTK(P9_DEBUG_9P, "fid %d (%p) dentry %s (%p)\n", fid->fid, fid,
 		dentry->d_iname, dentry);
 	if (dentry->d_fsdata == NULL) {
 		dentry->d_fsdata =
 		    kmalloc(sizeof(struct list_head), GFP_KERNEL);
 		if (dentry->d_fsdata == NULL) {
-			dprintk(DEBUG_ERROR, "Out of memory\n");
+			P9_DPRINTK(P9_DEBUG_ERROR, "Out of memory\n");
 			return -ENOMEM;
 		}
 		fid_list = (struct list_head *)dentry->d_fsdata;
@@ -71,10 +69,10 @@ struct v9fs_fid *v9fs_fid_create(struct
v9fs_session_info *v9ses, int fid)
 {
 	struct v9fs_fid *new;

-	dprintk(DEBUG_9P, "fid create fid %d\n", fid);
+	P9_DPRINTK(P9_DEBUG_9P, "fid create fid %d\n", fid);
 	new = kmalloc(sizeof(struct v9fs_fid), GFP_KERNEL);
 	if (new == NULL) {
-		dprintk(DEBUG_ERROR, "Out of Memory\n");
+		P9_DPRINTK(P9_DEBUG_ERROR, "Out of Memory\n");
 		return ERR_PTR(-ENOMEM);
 	}

@@ -119,13 +117,13 @@ struct v9fs_fid *v9fs_fid_lookup(struct dentry *dentry)
 	struct list_head *fid_list = (struct list_head *)dentry->d_fsdata;
 	struct v9fs_fid *return_fid = NULL;

-	dprintk(DEBUG_9P, " dentry: %s (%p)\n", dentry->d_iname, dentry);
+	P9_DPRINTK(P9_DEBUG_9P, " dentry: %s (%p)\n", dentry->d_iname, dentry);

 	if (fid_list)
 		return_fid = list_entry(fid_list->next, struct v9fs_fid, list);

 	if (!return_fid) {
-		dprintk(DEBUG_ERROR, "Couldn't find a fid in dentry\n");
+		P9_DPRINTK(P9_DEBUG_ERROR, "Couldn't find a fid in dentry\n");
 		return_fid = ERR_PTR(-EBADF);
 	}

@@ -150,7 +148,7 @@ struct v9fs_fid *v9fs_fid_clone(struct dentry *dentry)
 {
 	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(dentry->d_inode);
 	struct v9fs_fid *base_fid, *new_fid = ERR_PTR(-EBADF);
-	struct v9fs_fcall *fcall = NULL;
+	struct p9_fcall *fcall = NULL;
 	int fid, err;

 	base_fid = v9fs_fid_lookup(dentry);
@@ -159,23 +157,23 @@ struct v9fs_fid *v9fs_fid_clone(struct dentry *dentry)
 		return base_fid;

 	if(base_fid) {  /* clone fid */
-		fid = v9fs_get_idpool(&v9ses->fidpool);
+		fid = p9_idpool_get(v9ses->fidpool);
 		if (fid < 0) {
-			eprintk(KERN_WARNING, "newfid fails!\n");
+			P9_EPRINTK(KERN_WARNING, "newfid fails!\n");
 			new_fid = ERR_PTR(-ENOSPC);
 			goto Release_Fid;
 		}

 		err = v9fs_t_walk(v9ses, base_fid->fid, fid, NULL, &fcall);
 		if (err < 0) {
-			dprintk(DEBUG_ERROR, "clone walk didn't work\n");
-			v9fs_put_idpool(fid, &v9ses->fidpool);
+			P9_DPRINTK(P9_DEBUG_ERROR, "clone walk didn't work\n");
+			p9_idpool_put(fid, v9ses->fidpool);
 			new_fid = ERR_PTR(err);
 			goto Free_Fcall;
 		}
 		new_fid = v9fs_fid_create(v9ses, fid);
 		if (new_fid == NULL) {
-			dprintk(DEBUG_ERROR, "out of memory\n");
+			P9_DPRINTK(P9_DEBUG_ERROR, "out of memory\n");
 			new_fid = ERR_PTR(-ENOMEM);
 		}
 Free_Fcall:
diff --git a/fs/9p/fid.h b/fs/9p/fid.h
index 48fc170..a261ddf 100644
--- a/fs/9p/fid.h
+++ b/fs/9p/fid.h
@@ -36,13 +36,13 @@ struct v9fs_fid {
 	unsigned char fidopen;	  /* set when fid is opened */
 	unsigned char fidclunked; /* set when fid has already been clunked */

-	struct v9fs_qid qid;
+	struct p9_qid qid;
 	u32 iounit;

 	/* readdir stuff */
 	int rdir_fpos;
 	loff_t rdir_pos;
-	struct v9fs_fcall *rdir_fcall;
+	struct p9_fcall *rdir_fcall;

 	/* management stuff */
 	uid_t uid;		/* user associated with this fid */
diff --git a/fs/9p/mux.c b/fs/9p/mux.c
index c783874..0c0eb23 100644
--- a/fs/9p/mux.c
+++ b/fs/9p/mux.c
@@ -1,5 +1,5 @@
 /*
- * linux/fs/9p/mux.c
+ * net/9p/mux.c
  *
  * Protocol Multiplexer
  *
@@ -30,13 +30,9 @@
 #include <linux/kthread.h>
 #include <linux/idr.h>
 #include <linux/mutex.h>
-
-#include "debug.h"
-#include "v9fs.h"
 #include "9p.h"
-#include "conv.h"
 #include "transport.h"
-#include "mux.h"
+#include "conn.h"

 #define ERREQFLUSH	1
 #define SCHED_TIMEOUT	10
@@ -55,33 +51,33 @@ enum {
 	Flushed,
 };

-struct v9fs_mux_poll_task;
+struct p9_mux_poll_task;

-struct v9fs_req {
+struct p9_req {
 	spinlock_t lock;
 	int tag;
-	struct v9fs_fcall *tcall;
-	struct v9fs_fcall *rcall;
+	struct p9_fcall *tcall;
+	struct p9_fcall *rcall;
 	int err;
-	v9fs_mux_req_callback cb;
+	p9_conn_req_callback cb;
 	void *cba;
 	int flush;
 	struct list_head req_list;
 };

-struct v9fs_mux_data {
+struct p9_conn {
 	spinlock_t lock;
 	struct list_head mux_list;
-	struct v9fs_mux_poll_task *poll_task;
+	struct p9_mux_poll_task *poll_task;
 	int msize;
 	unsigned char *extended;
-	struct v9fs_transport *trans;
-	struct v9fs_idpool tagpool;
+	struct p9_transport *trans;
+	struct p9_idpool *tagpool;
 	int err;
 	wait_queue_head_t equeue;
 	struct list_head req_list;
 	struct list_head unsent_req_list;
-	struct v9fs_fcall *rcall;
+	struct p9_fcall *rcall;
 	int rpos;
 	char *rbuf;
 	int wpos;
@@ -95,44 +91,44 @@ struct v9fs_mux_data {
 	unsigned long wsched;
 };

-struct v9fs_mux_poll_task {
+struct p9_mux_poll_task {
 	struct task_struct *task;
 	struct list_head mux_list;
 	int muxnum;
 };

-struct v9fs_mux_rpc {
-	struct v9fs_mux_data *m;
+struct p9_mux_rpc {
+	struct p9_conn *m;
 	int err;
-	struct v9fs_fcall *tcall;
-	struct v9fs_fcall *rcall;
+	struct p9_fcall *tcall;
+	struct p9_fcall *rcall;
 	wait_queue_head_t wqueue;
 };

-static int v9fs_poll_proc(void *);
-static void v9fs_read_work(struct work_struct *work);
-static void v9fs_write_work(struct work_struct *work);
-static void v9fs_pollwait(struct file *filp, wait_queue_head_t * wait_address,
+static int p9_poll_proc(void *);
+static void p9_read_work(struct work_struct *work);
+static void p9_write_work(struct work_struct *work);
+static void p9_pollwait(struct file *filp, wait_queue_head_t * wait_address,
 			  poll_table * p);
-static u16 v9fs_mux_get_tag(struct v9fs_mux_data *);
-static void v9fs_mux_put_tag(struct v9fs_mux_data *, u16);
+static u16 p9_mux_get_tag(struct p9_conn *);
+static void p9_mux_put_tag(struct p9_conn *, u16);

-static DEFINE_MUTEX(v9fs_mux_task_lock);
-static struct workqueue_struct *v9fs_mux_wq;
+static DEFINE_MUTEX(p9_mux_task_lock);
+static struct workqueue_struct *p9_mux_wq;

-static int v9fs_mux_num;
-static int v9fs_mux_poll_task_num;
-static struct v9fs_mux_poll_task v9fs_mux_poll_tasks[100];
+static int p9_mux_num;
+static int p9_mux_poll_task_num;
+static struct p9_mux_poll_task p9_mux_poll_tasks[100];

-int v9fs_mux_global_init(void)
+int p9_mux_global_init(void)
 {
 	int i;

-	for (i = 0; i < ARRAY_SIZE(v9fs_mux_poll_tasks); i++)
-		v9fs_mux_poll_tasks[i].task = NULL;
+	for (i = 0; i < ARRAY_SIZE(p9_mux_poll_tasks); i++)
+		p9_mux_poll_tasks[i].task = NULL;

-	v9fs_mux_wq = create_workqueue("v9fs");
-	if (!v9fs_mux_wq) {
+	p9_mux_wq = create_workqueue("v9fs");
+	if (!p9_mux_wq) {
 		printk(KERN_WARNING "v9fs: mux: creating workqueue failed\n");
 		return -ENOMEM;
 	}
@@ -140,111 +136,111 @@ int v9fs_mux_global_init(void)
 	return 0;
 }

-void v9fs_mux_global_exit(void)
+void p9_mux_global_exit(void)
 {
-	destroy_workqueue(v9fs_mux_wq);
+	destroy_workqueue(p9_mux_wq);
 }

 /**
- * v9fs_mux_calc_poll_procs - calculates the number of polling procs
+ * p9_mux_calc_poll_procs - calculates the number of polling procs
  * based on the number of mounted v9fs filesystems.
  *
  * The current implementation returns sqrt of the number of mounts.
  */
-static int v9fs_mux_calc_poll_procs(int muxnum)
+static int p9_mux_calc_poll_procs(int muxnum)
 {
 	int n;

-	if (v9fs_mux_poll_task_num)
-		n = muxnum / v9fs_mux_poll_task_num +
-		    (muxnum % v9fs_mux_poll_task_num ? 1 : 0);
+	if (p9_mux_poll_task_num)
+		n = muxnum / p9_mux_poll_task_num +
+		    (muxnum % p9_mux_poll_task_num ? 1 : 0);
 	else
 		n = 1;

-	if (n > ARRAY_SIZE(v9fs_mux_poll_tasks))
-		n = ARRAY_SIZE(v9fs_mux_poll_tasks);
+	if (n > ARRAY_SIZE(p9_mux_poll_tasks))
+		n = ARRAY_SIZE(p9_mux_poll_tasks);

 	return n;
 }

-static int v9fs_mux_poll_start(struct v9fs_mux_data *m)
+static int p9_mux_poll_start(struct p9_conn *m)
 {
 	int i, n;
-	struct v9fs_mux_poll_task *vpt, *vptlast;
+	struct p9_mux_poll_task *vpt, *vptlast;
 	struct task_struct *pproc;

-	dprintk(DEBUG_MUX, "mux %p muxnum %d procnum %d\n", m, v9fs_mux_num,
-		v9fs_mux_poll_task_num);
-	mutex_lock(&v9fs_mux_task_lock);
-
-	n = v9fs_mux_calc_poll_procs(v9fs_mux_num + 1);
-	if (n > v9fs_mux_poll_task_num) {
-		for (i = 0; i < ARRAY_SIZE(v9fs_mux_poll_tasks); i++) {
-			if (v9fs_mux_poll_tasks[i].task == NULL) {
-				vpt = &v9fs_mux_poll_tasks[i];
-				dprintk(DEBUG_MUX, "create proc %p\n", vpt);
-				pproc = kthread_create(v9fs_poll_proc, vpt,
+	P9_DPRINTK(P9_DEBUG_MUX, "mux %p muxnum %d procnum %d\n", m, p9_mux_num,
+		p9_mux_poll_task_num);
+	mutex_lock(&p9_mux_task_lock);
+
+	n = p9_mux_calc_poll_procs(p9_mux_num + 1);
+	if (n > p9_mux_poll_task_num) {
+		for (i = 0; i < ARRAY_SIZE(p9_mux_poll_tasks); i++) {
+			if (p9_mux_poll_tasks[i].task == NULL) {
+				vpt = &p9_mux_poll_tasks[i];
+				P9_DPRINTK(P9_DEBUG_MUX, "create proc %p\n", vpt);
+				pproc = kthread_create(p9_poll_proc, vpt,
 						   "v9fs-poll");

 				if (!IS_ERR(pproc)) {
 					vpt->task = pproc;
 					INIT_LIST_HEAD(&vpt->mux_list);
 					vpt->muxnum = 0;
-					v9fs_mux_poll_task_num++;
+					p9_mux_poll_task_num++;
 					wake_up_process(vpt->task);
 				}
 				break;
 			}
 		}

-		if (i >= ARRAY_SIZE(v9fs_mux_poll_tasks))
-			dprintk(DEBUG_ERROR, "warning: no free poll slots\n");
+		if (i >= ARRAY_SIZE(p9_mux_poll_tasks))
+			P9_DPRINTK(P9_DEBUG_ERROR, "warning: no free poll slots\n");
 	}

-	n = (v9fs_mux_num + 1) / v9fs_mux_poll_task_num +
-	    ((v9fs_mux_num + 1) % v9fs_mux_poll_task_num ? 1 : 0);
+	n = (p9_mux_num + 1) / p9_mux_poll_task_num +
+	    ((p9_mux_num + 1) % p9_mux_poll_task_num ? 1 : 0);

 	vptlast = NULL;
-	for (i = 0; i < ARRAY_SIZE(v9fs_mux_poll_tasks); i++) {
-		vpt = &v9fs_mux_poll_tasks[i];
+	for (i = 0; i < ARRAY_SIZE(p9_mux_poll_tasks); i++) {
+		vpt = &p9_mux_poll_tasks[i];
 		if (vpt->task != NULL) {
 			vptlast = vpt;
 			if (vpt->muxnum < n) {
-				dprintk(DEBUG_MUX, "put in proc %d\n", i);
+				P9_DPRINTK(P9_DEBUG_MUX, "put in proc %d\n", i);
 				list_add(&m->mux_list, &vpt->mux_list);
 				vpt->muxnum++;
 				m->poll_task = vpt;
 				memset(&m->poll_waddr, 0, sizeof(m->poll_waddr));
-				init_poll_funcptr(&m->pt, v9fs_pollwait);
+				init_poll_funcptr(&m->pt, p9_pollwait);
 				break;
 			}
 		}
 	}

-	if (i >= ARRAY_SIZE(v9fs_mux_poll_tasks)) {
+	if (i >= ARRAY_SIZE(p9_mux_poll_tasks)) {
 		if (vptlast == NULL)
 			return -ENOMEM;

-		dprintk(DEBUG_MUX, "put in proc %d\n", i);
+		P9_DPRINTK(P9_DEBUG_MUX, "put in proc %d\n", i);
 		list_add(&m->mux_list, &vptlast->mux_list);
 		vptlast->muxnum++;
 		m->poll_task = vptlast;
 		memset(&m->poll_waddr, 0, sizeof(m->poll_waddr));
-		init_poll_funcptr(&m->pt, v9fs_pollwait);
+		init_poll_funcptr(&m->pt, p9_pollwait);
 	}

-	v9fs_mux_num++;
-	mutex_unlock(&v9fs_mux_task_lock);
+	p9_mux_num++;
+	mutex_unlock(&p9_mux_task_lock);

 	return 0;
 }

-static void v9fs_mux_poll_stop(struct v9fs_mux_data *m)
+static void p9_mux_poll_stop(struct p9_conn *m)
 {
 	int i;
-	struct v9fs_mux_poll_task *vpt;
+	struct p9_mux_poll_task *vpt;

-	mutex_lock(&v9fs_mux_task_lock);
+	mutex_lock(&p9_mux_task_lock);
 	vpt = m->poll_task;
 	list_del(&m->mux_list);
 	for(i = 0; i < ARRAY_SIZE(m->poll_waddr); i++) {
@@ -255,31 +251,31 @@ static void v9fs_mux_poll_stop(struct v9fs_mux_data *m)
 	}
 	vpt->muxnum--;
 	if (!vpt->muxnum) {
-		dprintk(DEBUG_MUX, "destroy proc %p\n", vpt);
+		P9_DPRINTK(P9_DEBUG_MUX, "destroy proc %p\n", vpt);
 		kthread_stop(vpt->task);
 		vpt->task = NULL;
-		v9fs_mux_poll_task_num--;
+		p9_mux_poll_task_num--;
 	}
-	v9fs_mux_num--;
-	mutex_unlock(&v9fs_mux_task_lock);
+	p9_mux_num--;
+	mutex_unlock(&p9_mux_task_lock);
 }

 /**
- * v9fs_mux_init - allocate and initialize the per-session mux data
+ * p9_conn_create - allocate and initialize the per-session mux data
  * Creates the polling task if this is the first session.
  *
  * @trans - transport structure
  * @msize - maximum message size
  * @extended - pointer to the extended flag
  */
-struct v9fs_mux_data *v9fs_mux_init(struct v9fs_transport *trans, int msize,
+struct p9_conn *p9_conn_create(struct p9_transport *trans, int msize,
 				    unsigned char *extended)
 {
 	int i, n;
-	struct v9fs_mux_data *m, *mtmp;
+	struct p9_conn *m, *mtmp;

-	dprintk(DEBUG_MUX, "transport %p msize %d\n", trans, msize);
-	m = kmalloc(sizeof(struct v9fs_mux_data), GFP_KERNEL);
+	P9_DPRINTK(P9_DEBUG_MUX, "transport %p msize %d\n", trans, msize);
+	m = kmalloc(sizeof(struct p9_conn), GFP_KERNEL);
 	if (!m)
 		return ERR_PTR(-ENOMEM);

@@ -288,8 +284,12 @@ struct v9fs_mux_data *v9fs_mux_init(struct
v9fs_transport *trans, int msize,
 	m->msize = msize;
 	m->extended = extended;
 	m->trans = trans;
-	idr_init(&m->tagpool.pool);
-	init_MUTEX(&m->tagpool.lock);
+	m->tagpool = p9_idpool_create();
+	if (!m->tagpool) {
+		kfree(m);
+		return ERR_PTR(PTR_ERR(m->tagpool));
+	}
+
 	m->err = 0;
 	init_waitqueue_head(&m->equeue);
 	INIT_LIST_HEAD(&m->req_list);
@@ -299,29 +299,29 @@ struct v9fs_mux_data *v9fs_mux_init(struct
v9fs_transport *trans, int msize,
 	m->rbuf = NULL;
 	m->wpos = m->wsize = 0;
 	m->wbuf = NULL;
-	INIT_WORK(&m->rq, v9fs_read_work);
-	INIT_WORK(&m->wq, v9fs_write_work);
+	INIT_WORK(&m->rq, p9_read_work);
+	INIT_WORK(&m->wq, p9_write_work);
 	m->wsched = 0;
 	memset(&m->poll_waddr, 0, sizeof(m->poll_waddr));
 	m->poll_task = NULL;
-	n = v9fs_mux_poll_start(m);
+	n = p9_mux_poll_start(m);
 	if (n)
 		return ERR_PTR(n);

 	n = trans->poll(trans, &m->pt);
 	if (n & POLLIN) {
-		dprintk(DEBUG_MUX, "mux %p can read\n", m);
+		P9_DPRINTK(P9_DEBUG_MUX, "mux %p can read\n", m);
 		set_bit(Rpending, &m->wsched);
 	}

 	if (n & POLLOUT) {
-		dprintk(DEBUG_MUX, "mux %p can write\n", m);
+		P9_DPRINTK(P9_DEBUG_MUX, "mux %p can write\n", m);
 		set_bit(Wpending, &m->wsched);
 	}

 	for(i = 0; i < ARRAY_SIZE(m->poll_waddr); i++) {
 		if (IS_ERR(m->poll_waddr[i])) {
-			v9fs_mux_poll_stop(m);
+			p9_mux_poll_stop(m);
 			mtmp = (void *)m->poll_waddr;	/* the error code */
 			kfree(m);
 			m = mtmp;
@@ -331,56 +331,58 @@ struct v9fs_mux_data *v9fs_mux_init(struct
v9fs_transport *trans, int msize,

 	return m;
 }
+EXPORT_SYMBOL(p9_conn_create);

 /**
- * v9fs_mux_destroy - cancels all pending requests and frees mux resources
+ * p9_mux_destroy - cancels all pending requests and frees mux resources
  */
-void v9fs_mux_destroy(struct v9fs_mux_data *m)
+void p9_conn_destroy(struct p9_conn *m)
 {
-	dprintk(DEBUG_MUX, "mux %p prev %p next %p\n", m,
+	P9_DPRINTK(P9_DEBUG_MUX, "mux %p prev %p next %p\n", m,
 		m->mux_list.prev, m->mux_list.next);
-	v9fs_mux_cancel(m, -ECONNRESET);
+	p9_conn_cancel(m, -ECONNRESET);

 	if (!list_empty(&m->req_list)) {
 		/* wait until all processes waiting on this session exit */
-		dprintk(DEBUG_MUX, "mux %p waiting for empty request queue\n",
+		P9_DPRINTK(P9_DEBUG_MUX, "mux %p waiting for empty request queue\n",
 			m);
 		wait_event_timeout(m->equeue, (list_empty(&m->req_list)), 5000);
-		dprintk(DEBUG_MUX, "mux %p request queue empty: %d\n", m,
+		P9_DPRINTK(P9_DEBUG_MUX, "mux %p request queue empty: %d\n", m,
 			list_empty(&m->req_list));
 	}

-	v9fs_mux_poll_stop(m);
+	p9_mux_poll_stop(m);
 	m->trans = NULL;
-
+	p9_idpool_destroy(m->tagpool);
 	kfree(m);
 }
+EXPORT_SYMBOL(p9_conn_destroy);

 /**
- * v9fs_pollwait - called by files poll operation to add v9fs-poll task
+ * p9_pollwait - called by files poll operation to add v9fs-poll task
  * 	to files wait queue
  */
 static void
-v9fs_pollwait(struct file *filp, wait_queue_head_t * wait_address,
+p9_pollwait(struct file *filp, wait_queue_head_t * wait_address,
 	      poll_table * p)
 {
 	int i;
-	struct v9fs_mux_data *m;
+	struct p9_conn *m;

-	m = container_of(p, struct v9fs_mux_data, pt);
+	m = container_of(p, struct p9_conn, pt);
 	for(i = 0; i < ARRAY_SIZE(m->poll_waddr); i++)
 		if (m->poll_waddr[i] == NULL)
 			break;

 	if (i >= ARRAY_SIZE(m->poll_waddr)) {
-		dprintk(DEBUG_ERROR, "not enough wait_address slots\n");
+		P9_DPRINTK(P9_DEBUG_ERROR, "not enough wait_address slots\n");
 		return;
 	}

 	m->poll_waddr[i] = wait_address;

 	if (!wait_address) {
-		dprintk(DEBUG_ERROR, "no wait_address\n");
+		P9_DPRINTK(P9_DEBUG_ERROR, "no wait_address\n");
 		m->poll_waddr[i] = ERR_PTR(-EIO);
 		return;
 	}
@@ -390,9 +392,9 @@ v9fs_pollwait(struct file *filp, wait_queue_head_t
* wait_address,
 }

 /**
- * v9fs_poll_mux - polls a mux and schedules read or write works if necessary
+ * p9_poll_mux - polls a mux and schedules read or write works if necessary
  */
-static void v9fs_poll_mux(struct v9fs_mux_data *m)
+static void p9_poll_mux(struct p9_conn *m)
 {
 	int n;

@@ -401,69 +403,69 @@ static void v9fs_poll_mux(struct v9fs_mux_data *m)

 	n = m->trans->poll(m->trans, NULL);
 	if (n < 0 || n & (POLLERR | POLLHUP | POLLNVAL)) {
-		dprintk(DEBUG_MUX, "error mux %p err %d\n", m, n);
+		P9_DPRINTK(P9_DEBUG_MUX, "error mux %p err %d\n", m, n);
 		if (n >= 0)
 			n = -ECONNRESET;
-		v9fs_mux_cancel(m, n);
+		p9_conn_cancel(m, n);
 	}

 	if (n & POLLIN) {
 		set_bit(Rpending, &m->wsched);
-		dprintk(DEBUG_MUX, "mux %p can read\n", m);
+		P9_DPRINTK(P9_DEBUG_MUX, "mux %p can read\n", m);
 		if (!test_and_set_bit(Rworksched, &m->wsched)) {
-			dprintk(DEBUG_MUX, "schedule read work mux %p\n", m);
-			queue_work(v9fs_mux_wq, &m->rq);
+			P9_DPRINTK(P9_DEBUG_MUX, "schedule read work mux %p\n", m);
+			queue_work(p9_mux_wq, &m->rq);
 		}
 	}

 	if (n & POLLOUT) {
 		set_bit(Wpending, &m->wsched);
-		dprintk(DEBUG_MUX, "mux %p can write\n", m);
+		P9_DPRINTK(P9_DEBUG_MUX, "mux %p can write\n", m);
 		if ((m->wsize || !list_empty(&m->unsent_req_list))
 		    && !test_and_set_bit(Wworksched, &m->wsched)) {
-			dprintk(DEBUG_MUX, "schedule write work mux %p\n", m);
-			queue_work(v9fs_mux_wq, &m->wq);
+			P9_DPRINTK(P9_DEBUG_MUX, "schedule write work mux %p\n", m);
+			queue_work(p9_mux_wq, &m->wq);
 		}
 	}
 }

 /**
- * v9fs_poll_proc - polls all v9fs transports for new events and queues
+ * p9_poll_proc - polls all v9fs transports for new events and queues
  * 	the appropriate work to the work queue
  */
-static int v9fs_poll_proc(void *a)
+static int p9_poll_proc(void *a)
 {
-	struct v9fs_mux_data *m, *mtmp;
-	struct v9fs_mux_poll_task *vpt;
+	struct p9_conn *m, *mtmp;
+	struct p9_mux_poll_task *vpt;

 	vpt = a;
-	dprintk(DEBUG_MUX, "start %p %p\n", current, vpt);
+	P9_DPRINTK(P9_DEBUG_MUX, "start %p %p\n", current, vpt);
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);

 		list_for_each_entry_safe(m, mtmp, &vpt->mux_list, mux_list) {
-			v9fs_poll_mux(m);
+			p9_poll_mux(m);
 		}

-		dprintk(DEBUG_MUX, "sleeping...\n");
+		P9_DPRINTK(P9_DEBUG_MUX, "sleeping...\n");
 		schedule_timeout(SCHED_TIMEOUT * HZ);
 	}

 	__set_current_state(TASK_RUNNING);
-	dprintk(DEBUG_MUX, "finish\n");
+	P9_DPRINTK(P9_DEBUG_MUX, "finish\n");
 	return 0;
 }

 /**
- * v9fs_write_work - called when a transport can send some data
+ * p9_write_work - called when a transport can send some data
  */
-static void v9fs_write_work(struct work_struct *work)
+static void p9_write_work(struct work_struct *work)
 {
 	int n, err;
-	struct v9fs_mux_data *m;
-	struct v9fs_req *req;
+	struct p9_conn *m;
+	struct p9_req *req;

-	m = container_of(work, struct v9fs_mux_data, wq);
+	m = container_of(work, struct p9_conn, wq);

 	if (m->err < 0) {
 		clear_bit(Wworksched, &m->wsched);
@@ -478,7 +480,7 @@ static void v9fs_write_work(struct work_struct *work)

 		spin_lock(&m->lock);
 again:
-		req = list_entry(m->unsent_req_list.next, struct v9fs_req,
+		req = list_entry(m->unsent_req_list.next, struct p9_req,
 			       req_list);
 		list_move_tail(&req->req_list, &m->req_list);
 		if (req->err == ERREQFLUSH)
@@ -487,14 +489,13 @@ again:
 		m->wbuf = req->tcall->sdata;
 		m->wsize = req->tcall->size;
 		m->wpos = 0;
-		dump_data(m->wbuf, m->wsize);
 		spin_unlock(&m->lock);
 	}

-	dprintk(DEBUG_MUX, "mux %p pos %d size %d\n", m, m->wpos, m->wsize);
+	P9_DPRINTK(P9_DEBUG_MUX, "mux %p pos %d size %d\n", m, m->wpos, m->wsize);
 	clear_bit(Wpending, &m->wsched);
 	err = m->trans->write(m->trans, m->wbuf + m->wpos, m->wsize - m->wpos);
-	dprintk(DEBUG_MUX, "mux %p sent %d bytes\n", m, err);
+	P9_DPRINTK(P9_DEBUG_MUX, "mux %p sent %d bytes\n", m, err);
 	if (err == -EAGAIN) {
 		clear_bit(Wworksched, &m->wsched);
 		return;
@@ -514,8 +515,8 @@ again:
 			n = m->trans->poll(m->trans, NULL);

 		if (n & POLLOUT) {
-			dprintk(DEBUG_MUX, "schedule write work mux %p\n", m);
-			queue_work(v9fs_mux_wq, &m->wq);
+			P9_DPRINTK(P9_DEBUG_MUX, "schedule write work mux %p\n", m);
+			queue_work(p9_mux_wq, &m->wq);
 		} else
 			clear_bit(Wworksched, &m->wsched);
 	} else
@@ -524,26 +525,26 @@ again:
 	return;

       error:
-	v9fs_mux_cancel(m, err);
+	p9_conn_cancel(m, err);
 	clear_bit(Wworksched, &m->wsched);
 }

-static void process_request(struct v9fs_mux_data *m, struct v9fs_req *req)
+static void process_request(struct p9_conn *m, struct p9_req *req)
 {
 	int ecode;
-	struct v9fs_str *ename;
+	struct p9_str *ename;

-	if (!req->err && req->rcall->id == RERROR) {
+	if (!req->err && req->rcall->id == P9_RERROR) {
 		ecode = req->rcall->params.rerror.errno;
 		ename = &req->rcall->params.rerror.error;

-		dprintk(DEBUG_MUX, "Rerror %.*s\n", ename->len, ename->str);
+		P9_DPRINTK(P9_DEBUG_MUX, "Rerror %.*s\n", ename->len, ename->str);

 		if (*m->extended)
 			req->err = -ecode;

 		if (!req->err) {
-			req->err = v9fs_errstr2errno(ename->str, ename->len);
+			req->err = p9_errstr2errno(ename->str, ename->len);

 			if (!req->err) {	/* string match failed */
 				PRINT_FCALL_ERROR("unknown error", req->rcall);
@@ -553,7 +554,7 @@ static void process_request(struct v9fs_mux_data
*m, struct v9fs_req *req)
 				req->err = -ESERVERFAULT;
 		}
 	} else if (req->tcall && req->rcall->id != req->tcall->id + 1) {
-		dprintk(DEBUG_ERROR, "fcall mismatch: expected %d, got %d\n",
+		P9_DPRINTK(P9_DEBUG_ERROR, "fcall mismatch: expected %d, got %d\n",
 			req->tcall->id + 1, req->rcall->id);
 		if (!req->err)
 			req->err = -EIO;
@@ -561,39 +562,39 @@ static void process_request(struct v9fs_mux_data
*m, struct v9fs_req *req)
 }

 /**
- * v9fs_read_work - called when there is some data to be read from a transport
+ * p9_read_work - called when there is some data to be read from a transport
  */
-static void v9fs_read_work(struct work_struct *work)
+static void p9_read_work(struct work_struct *work)
 {
 	int n, err;
-	struct v9fs_mux_data *m;
-	struct v9fs_req *req, *rptr, *rreq;
-	struct v9fs_fcall *rcall;
+	struct p9_conn *m;
+	struct p9_req *req, *rptr, *rreq;
+	struct p9_fcall *rcall;
 	char *rbuf;

-	m = container_of(work, struct v9fs_mux_data, rq);
+	m = container_of(work, struct p9_conn, rq);

 	if (m->err < 0)
 		return;

 	rcall = NULL;
-	dprintk(DEBUG_MUX, "start mux %p pos %d\n", m, m->rpos);
+	P9_DPRINTK(P9_DEBUG_MUX, "start mux %p pos %d\n", m, m->rpos);

 	if (!m->rcall) {
 		m->rcall =
-		    kmalloc(sizeof(struct v9fs_fcall) + m->msize, GFP_KERNEL);
+		    kmalloc(sizeof(struct p9_fcall) + m->msize, GFP_KERNEL);
 		if (!m->rcall) {
 			err = -ENOMEM;
 			goto error;
 		}

-		m->rbuf = (char *)m->rcall + sizeof(struct v9fs_fcall);
+		m->rbuf = (char *)m->rcall + sizeof(struct p9_fcall);
 		m->rpos = 0;
 	}

 	clear_bit(Rpending, &m->wsched);
 	err = m->trans->read(m->trans, m->rbuf + m->rpos, m->msize - m->rpos);
-	dprintk(DEBUG_MUX, "mux %p got %d bytes\n", m, err);
+	P9_DPRINTK(P9_DEBUG_MUX, "mux %p got %d bytes\n", m, err);
 	if (err == -EAGAIN) {
 		clear_bit(Rworksched, &m->wsched);
 		return;
@@ -606,7 +607,7 @@ static void v9fs_read_work(struct work_struct *work)
 	while (m->rpos > 4) {
 		n = le32_to_cpu(*(__le32 *) m->rbuf);
 		if (n >= m->msize) {
-			dprintk(DEBUG_ERROR,
+			P9_DPRINTK(P9_DEBUG_ERROR,
 				"requested packet size too big: %d\n", n);
 			err = -EIO;
 			goto error;
@@ -615,32 +616,33 @@ static void v9fs_read_work(struct work_struct *work)
 		if (m->rpos < n)
 			break;

-		dump_data(m->rbuf, n);
 		err =
-		    v9fs_deserialize_fcall(m->rbuf, n, m->rcall, *m->extended);
+		    p9_deserialize_fcall(m->rbuf, n, m->rcall, *m->extended);
 		if (err < 0) {
 			goto error;
 		}

-		if ((v9fs_debug_level&DEBUG_FCALL) == DEBUG_FCALL) {
+#ifdef CONFIG_NET_9P_DEBUG
+		if ((p9_debug_level&P9_DEBUG_FCALL) == P9_DEBUG_FCALL) {
 			char buf[150];

-			v9fs_printfcall(buf, sizeof(buf), m->rcall,
+			p9_printfcall(buf, sizeof(buf), m->rcall,
 				*m->extended);
 			printk(KERN_NOTICE ">>> %p %s\n", m, buf);
 		}
+#endif

 		rcall = m->rcall;
 		rbuf = m->rbuf;
 		if (m->rpos > n) {
-			m->rcall = kmalloc(sizeof(struct v9fs_fcall) + m->msize,
+			m->rcall = kmalloc(sizeof(struct p9_fcall) + m->msize,
 					   GFP_KERNEL);
 			if (!m->rcall) {
 				err = -ENOMEM;
 				goto error;
 			}

-			m->rbuf = (char *)m->rcall + sizeof(struct v9fs_fcall);
+			m->rbuf = (char *)m->rcall + sizeof(struct p9_fcall);
 			memmove(m->rbuf, rbuf + n, m->rpos - n);
 			m->rpos -= n;
 		} else {
@@ -649,7 +651,7 @@ static void v9fs_read_work(struct work_struct *work)
 			m->rpos = 0;
 		}

-		dprintk(DEBUG_MUX, "mux %p fcall id %d tag %d\n", m, rcall->id,
+		P9_DPRINTK(P9_DEBUG_MUX, "mux %p fcall id %d tag %d\n", m, rcall->id,
 			rcall->tag);

 		req = NULL;
@@ -677,8 +679,8 @@ static void v9fs_read_work(struct work_struct *work)
 				wake_up(&m->equeue);
 			}
 		} else {
-			if (err >= 0 && rcall->id != RFLUSH)
-				dprintk(DEBUG_ERROR,
+			if (err >= 0 && rcall->id != P9_RFLUSH)
+				P9_DPRINTK(P9_DEBUG_ERROR,
 					"unexpected response mux %p id %d tag %d\n",
 					m, rcall->id, rcall->tag);
 			kfree(rcall);
@@ -692,8 +694,8 @@ static void v9fs_read_work(struct work_struct *work)
 			n = m->trans->poll(m->trans, NULL);

 		if (n & POLLIN) {
-			dprintk(DEBUG_MUX, "schedule read work mux %p\n", m);
-			queue_work(v9fs_mux_wq, &m->rq);
+			P9_DPRINTK(P9_DEBUG_MUX, "schedule read work mux %p\n", m);
+			queue_work(p9_mux_wq, &m->rq);
 		} else
 			clear_bit(Rworksched, &m->wsched);
 	} else
@@ -702,12 +704,12 @@ static void v9fs_read_work(struct work_struct *work)
 	return;

       error:
-	v9fs_mux_cancel(m, err);
+	p9_conn_cancel(m, err);
 	clear_bit(Rworksched, &m->wsched);
 }

 /**
- * v9fs_send_request - send 9P request
+ * p9_send_request - send 9P request
  * The function can sleep until the request is scheduled for sending.
  * The function can be interrupted. Return from the function is not
  * a guarantee that the request is sent successfully. Can return errors
@@ -718,37 +720,40 @@ static void v9fs_read_work(struct work_struct *work)
  * @cb: callback function to call when response is received
  * @cba: parameter to pass to the callback function
  */
-static struct v9fs_req *v9fs_send_request(struct v9fs_mux_data *m,
-					  struct v9fs_fcall *tc,
-					  v9fs_mux_req_callback cb, void *cba)
+static struct p9_req *p9_send_request(struct p9_conn *m,
+					  struct p9_fcall *tc,
+					  p9_conn_req_callback cb, void *cba)
 {
 	int n;
-	struct v9fs_req *req;
+	struct p9_req *req;

-	dprintk(DEBUG_MUX, "mux %p task %p tcall %p id %d\n", m, current,
+	P9_DPRINTK(P9_DEBUG_MUX, "mux %p task %p tcall %p id %d\n", m, current,
 		tc, tc->id);
 	if (m->err < 0)
 		return ERR_PTR(m->err);

-	req = kmalloc(sizeof(struct v9fs_req), GFP_KERNEL);
+	req = kmalloc(sizeof(struct p9_req), GFP_KERNEL);
 	if (!req)
 		return ERR_PTR(-ENOMEM);

-	if (tc->id == TVERSION)
-		n = V9FS_NOTAG;
+	if (tc->id == P9_TVERSION)
+		n = P9_NOTAG;
 	else
-		n = v9fs_mux_get_tag(m);
+		n = p9_mux_get_tag(m);

 	if (n < 0)
 		return ERR_PTR(-ENOMEM);

-	v9fs_set_tag(tc, n);
-	if ((v9fs_debug_level&DEBUG_FCALL) == DEBUG_FCALL) {
+	p9_set_tag(tc, n);
+
+#ifdef CONFIG_NET_9P_DEBUG
+	if ((p9_debug_level&P9_DEBUG_FCALL) == P9_DEBUG_FCALL) {
 		char buf[150];

-		v9fs_printfcall(buf, sizeof(buf), tc, *m->extended);
+		p9_printfcall(buf, sizeof(buf), tc, *m->extended);
 		printk(KERN_NOTICE "<<< %p %s\n", m, buf);
 	}
+#endif

 	spin_lock_init(&req->lock);
 	req->tag = n;
@@ -769,26 +774,26 @@ static struct v9fs_req *v9fs_send_request(struct
v9fs_mux_data *m,
 		n = m->trans->poll(m->trans, NULL);

 	if (n & POLLOUT && !test_and_set_bit(Wworksched, &m->wsched))
-		queue_work(v9fs_mux_wq, &m->wq);
+		queue_work(p9_mux_wq, &m->wq);

 	return req;
 }

-static void v9fs_mux_free_request(struct v9fs_mux_data *m, struct
v9fs_req *req)
+static void p9_mux_free_request(struct p9_conn *m, struct p9_req *req)
 {
-	v9fs_mux_put_tag(m, req->tag);
+	p9_mux_put_tag(m, req->tag);
 	kfree(req);
 }

-static void v9fs_mux_flush_cb(struct v9fs_req *freq, void *a)
+static void p9_mux_flush_cb(struct p9_req *freq, void *a)
 {
-	v9fs_mux_req_callback cb;
+	p9_conn_req_callback cb;
 	int tag;
-	struct v9fs_mux_data *m;
-	struct v9fs_req *req, *rreq, *rptr;
+	struct p9_conn *m;
+	struct p9_req *req, *rreq, *rptr;

 	m = a;
-	dprintk(DEBUG_MUX, "mux %p tc %p rc %p err %d oldtag %d\n", m,
+	P9_DPRINTK(P9_DEBUG_MUX, "mux %p tc %p rc %p err %d oldtag %d\n", m,
 		freq->tcall, freq->rcall, freq->err,
 		freq->tcall->params.tflush.oldtag);

@@ -820,22 +825,22 @@ static void v9fs_mux_flush_cb(struct v9fs_req
*freq, void *a)

 	kfree(freq->tcall);
 	kfree(freq->rcall);
-	v9fs_mux_free_request(m, freq);
+	p9_mux_free_request(m, freq);
 }

 static int
-v9fs_mux_flush_request(struct v9fs_mux_data *m, struct v9fs_req *req)
+p9_mux_flush_request(struct p9_conn *m, struct p9_req *req)
 {
-	struct v9fs_fcall *fc;
-	struct v9fs_req *rreq, *rptr;
+	struct p9_fcall *fc;
+	struct p9_req *rreq, *rptr;

-	dprintk(DEBUG_MUX, "mux %p req %p tag %d\n", m, req, req->tag);
+	P9_DPRINTK(P9_DEBUG_MUX, "mux %p req %p tag %d\n", m, req, req->tag);

 	/* if a response was received for a request, do nothing */
 	spin_lock(&req->lock);
 	if (req->rcall || req->err) {
 		spin_unlock(&req->lock);
-		dprintk(DEBUG_MUX, "mux %p req %p response already received\n", m, req);
+		P9_DPRINTK(P9_DEBUG_MUX, "mux %p req %p response already
received\n", m, req);
 		return 0;
 	}

@@ -846,7 +851,7 @@ v9fs_mux_flush_request(struct v9fs_mux_data *m,
struct v9fs_req *req)
 	/* if the request is not sent yet, just remove it from the list */
 	list_for_each_entry_safe(rreq, rptr, &m->unsent_req_list, req_list) {
 		if (rreq->tag == req->tag) {
-			dprintk(DEBUG_MUX, "mux %p req %p request is not sent yet\n", m, req);
+			P9_DPRINTK(P9_DEBUG_MUX, "mux %p req %p request is not sent yet\n", m, req);
 			list_del(&rreq->req_list);
 			req->flush = Flushed;
 			spin_unlock(&m->lock);
@@ -858,17 +863,17 @@ v9fs_mux_flush_request(struct v9fs_mux_data *m,
struct v9fs_req *req)
 	spin_unlock(&m->lock);

 	clear_thread_flag(TIF_SIGPENDING);
-	fc = v9fs_create_tflush(req->tag);
-	v9fs_send_request(m, fc, v9fs_mux_flush_cb, m);
+	fc = p9_create_tflush(req->tag);
+	p9_send_request(m, fc, p9_mux_flush_cb, m);
 	return 1;
 }

 static void
-v9fs_mux_rpc_cb(struct v9fs_req *req, void *a)
+p9_conn_rpc_cb(struct p9_req *req, void *a)
 {
-	struct v9fs_mux_rpc *r;
+	struct p9_mux_rpc *r;

-	dprintk(DEBUG_MUX, "req %p r %p\n", req, a);
+	P9_DPRINTK(P9_DEBUG_MUX, "req %p r %p\n", req, a);
 	r = a;
 	r->rcall = req->rcall;
 	r->err = req->err;
@@ -880,20 +885,20 @@ v9fs_mux_rpc_cb(struct v9fs_req *req, void *a)
 }

 /**
- * v9fs_mux_rpc - sends 9P request and waits until a response is available.
+ * p9_mux_rpc - sends 9P request and waits until a response is available.
  *	The function can be interrupted.
  * @m: mux data
  * @tc: request to be sent
  * @rc: pointer where a pointer to the response is stored
  */
 int
-v9fs_mux_rpc(struct v9fs_mux_data *m, struct v9fs_fcall *tc,
-	     struct v9fs_fcall **rc)
+p9_conn_rpc(struct p9_conn *m, struct p9_fcall *tc,
+	     struct p9_fcall **rc)
 {
 	int err, sigpending;
 	unsigned long flags;
-	struct v9fs_req *req;
-	struct v9fs_mux_rpc r;
+	struct p9_req *req;
+	struct p9_mux_rpc r;

 	r.err = 0;
 	r.tcall = tc;
@@ -910,10 +915,10 @@ v9fs_mux_rpc(struct v9fs_mux_data *m, struct
v9fs_fcall *tc,
 		clear_thread_flag(TIF_SIGPENDING);
 	}

-	req = v9fs_send_request(m, tc, v9fs_mux_rpc_cb, &r);
+	req = p9_send_request(m, tc, p9_conn_rpc_cb, &r);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
-		dprintk(DEBUG_MUX, "error %d\n", err);
+		P9_DPRINTK(P9_DEBUG_MUX, "error %d\n", err);
 		return err;
 	}

@@ -922,7 +927,7 @@ v9fs_mux_rpc(struct v9fs_mux_data *m, struct v9fs_fcall *tc,
 		err = r.err;

 	if (err == -ERESTARTSYS && m->trans->status == Connected && m->err == 0) {
-		if (v9fs_mux_flush_request(m, req)) {
+		if (p9_mux_flush_request(m, req)) {
 			/* wait until we get response of the flush message */
 			do {
 				clear_thread_flag(TIF_SIGPENDING);
@@ -947,50 +952,52 @@ v9fs_mux_rpc(struct v9fs_mux_data *m, struct
v9fs_fcall *tc,
 	else
 		kfree(r.rcall);

-	v9fs_mux_free_request(m, req);
+	p9_mux_free_request(m, req);
 	if (err > 0)
 		err = -EIO;

 	return err;
 }
+EXPORT_SYMBOL(p9_conn_rpc);

 #if 0
 /**
- * v9fs_mux_rpcnb - sends 9P request without waiting for response.
+ * p9_conn_rpcnb - sends 9P request without waiting for response.
  * @m: mux data
  * @tc: request to be sent
  * @cb: callback function to be called when response arrives
  * @cba: value to pass to the callback function
  */
-int v9fs_mux_rpcnb(struct v9fs_mux_data *m, struct v9fs_fcall *tc,
-		   v9fs_mux_req_callback cb, void *a)
+int p9_conn_rpcnb(struct p9_conn *m, struct p9_fcall *tc,
+		   p9_conn_req_callback cb, void *a)
 {
 	int err;
-	struct v9fs_req *req;
+	struct p9_req *req;

-	req = v9fs_send_request(m, tc, cb, a);
+	req = p9_send_request(m, tc, cb, a);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
-		dprintk(DEBUG_MUX, "error %d\n", err);
+		P9_DPRINTK(P9_DEBUG_MUX, "error %d\n", err);
 		return PTR_ERR(req);
 	}

-	dprintk(DEBUG_MUX, "mux %p tc %p tag %d\n", m, tc, req->tag);
+	P9_DPRINTK(P9_DEBUG_MUX, "mux %p tc %p tag %d\n", m, tc, req->tag);
 	return 0;
 }
+EXPORT_SYMBOL(p9_conn_rpcnb);
 #endif  /*  0  */

 /**
- * v9fs_mux_cancel - cancel all pending requests with error
+ * p9_conn_cancel - cancel all pending requests with error
  * @m: mux data
  * @err: error code
  */
-void v9fs_mux_cancel(struct v9fs_mux_data *m, int err)
+void p9_conn_cancel(struct p9_conn *m, int err)
 {
-	struct v9fs_req *req, *rtmp;
+	struct p9_req *req, *rtmp;
 	LIST_HEAD(cancel_list);

-	dprintk(DEBUG_ERROR, "mux %p err %d\n", m, err);
+	P9_DPRINTK(P9_DEBUG_ERROR, "mux %p err %d\n", m, err);
 	m->err = err;
 	spin_lock(&m->lock);
 	list_for_each_entry_safe(req, rtmp, &m->req_list, req_list) {
@@ -1014,20 +1021,21 @@ void v9fs_mux_cancel(struct v9fs_mux_data *m, int err)

 	wake_up(&m->equeue);
 }
+EXPORT_SYMBOL(p9_conn_cancel);

-static u16 v9fs_mux_get_tag(struct v9fs_mux_data *m)
+static u16 p9_mux_get_tag(struct p9_conn *m)
 {
 	int tag;

-	tag = v9fs_get_idpool(&m->tagpool);
+	tag = p9_idpool_get(m->tagpool);
 	if (tag < 0)
-		return V9FS_NOTAG;
+		return P9_NOTAG;
 	else
 		return (u16) tag;
 }

-static void v9fs_mux_put_tag(struct v9fs_mux_data *m, u16 tag)
+static void p9_mux_put_tag(struct p9_conn *m, u16 tag)
 {
-	if (tag != V9FS_NOTAG && v9fs_check_idpool(tag, &m->tagpool))
-		v9fs_put_idpool(tag, &m->tagpool);
+	if (tag != P9_NOTAG && p9_idpool_check(tag, m->tagpool))
+		p9_idpool_put(tag, m->tagpool);
 }
diff --git a/fs/9p/mux.h b/fs/9p/mux.h
deleted file mode 100644
index fb10c50..0000000
--- a/fs/9p/mux.h
+++ /dev/null
@@ -1,55 +0,0 @@
-/*
- * linux/fs/9p/mux.h
- *
- * Multiplexer Definitions
- *
- *  Copyright (C) 2005 by Latchesar Ionkov <lucho@ionkov.net>
- *  Copyright (C) 2004 by Eric Van Hensbergen <ericvh@gmail.com>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2
- *  as published by the Free Software Foundation.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to:
- *  Free Software Foundation
- *  51 Franklin Street, Fifth Floor
- *  Boston, MA  02111-1301  USA
- *
- */
-
-struct v9fs_mux_data;
-struct v9fs_req;
-
-/**
- * v9fs_mux_req_callback - callback function that is called when the
- * response of a request is received. The callback is called from
- * a workqueue and shouldn't block.
- *
- * @a - the pointer that was specified when the request was send to be
- *      passed to the callback
- * @tc - request call
- * @rc - response call
- * @err - error code (non-zero if error occured)
- */
-typedef void (*v9fs_mux_req_callback)(struct v9fs_req *req, void *a);
-
-int v9fs_mux_global_init(void);
-void v9fs_mux_global_exit(void);
-
-struct v9fs_mux_data *v9fs_mux_init(struct v9fs_transport *trans, int msize,
-	unsigned char *extended);
-void v9fs_mux_destroy(struct v9fs_mux_data *);
-
-int v9fs_mux_send(struct v9fs_mux_data *m, struct v9fs_fcall *tc);
-struct v9fs_fcall *v9fs_mux_recv(struct v9fs_mux_data *m);
-int v9fs_mux_rpc(struct v9fs_mux_data *m, struct v9fs_fcall *tc,
struct v9fs_fcall **rc);
-
-void v9fs_mux_flush(struct v9fs_mux_data *m, int sendflush);
-void v9fs_mux_cancel(struct v9fs_mux_data *m, int err);
-int v9fs_errstr2errno(char *errstr, int len);
diff --git a/fs/9p/trans_fd.c b/fs/9p/trans_fd.c
index 34d4335..deccd9e 100644
--- a/fs/9p/trans_fd.c
+++ b/fs/9p/trans_fd.c
@@ -36,35 +36,223 @@
 #include <linux/inet.h>
 #include <linux/idr.h>
 #include <linux/file.h>
-
-#include "debug.h"
-#include "v9fs.h"
+#include "9p.h"
 #include "transport.h"

-#define V9FS_PORT 564
+#define P9_PORT 564

-struct v9fs_trans_fd {
+struct p9_trans_fd {
 	struct file *rd;
 	struct file *wr;
 };

+static int p9_socket_open(struct p9_transport *trans, struct socket *csocket);
+static int p9_fd_open(struct p9_transport *trans, int rfd, int wfd);
+static int p9_fd_read(struct p9_transport *trans, void *v, int len);
+static int p9_fd_write(struct p9_transport *trans, void *v, int len);
+static unsigned int p9_fd_poll(struct p9_transport *trans,
+	struct poll_table_struct *pt);
+static void p9_fd_close(struct p9_transport *trans);
+
+struct p9_transport *p9_trans_create_tcp(const char *addr, int port)
+{
+	int err;
+	struct p9_transport *trans;
+	struct socket *csocket;
+	struct sockaddr_in sin_server;
+
+	csocket = NULL;
+	trans = kmalloc(sizeof(struct p9_transport), GFP_KERNEL);
+	if (!trans)
+		return ERR_PTR(-ENOMEM);
+
+	trans->write = p9_fd_write;
+	trans->read = p9_fd_read;
+	trans->close = p9_fd_close;
+	trans->poll = p9_fd_poll;
+
+	sin_server.sin_family = AF_INET;
+	sin_server.sin_addr.s_addr = in_aton(addr);
+	sin_server.sin_port = htons(port);
+	sock_create_kern(PF_INET, SOCK_STREAM, IPPROTO_TCP, &csocket);
+
+	if (!csocket) {
+		P9_EPRINTK(KERN_ERR, "p9_trans_tcp: problem creating socket\n");
+		err = -EIO;
+		goto error;
+	}
+
+	err = csocket->ops->connect(csocket,
+				    (struct sockaddr *)&sin_server,
+				    sizeof(struct sockaddr_in), 0);
+	if (err < 0) {
+		P9_EPRINTK(KERN_ERR,
+			"p9_trans_tcp: problem connecting socket to %s\n",
+			addr);
+		goto error;
+	}
+
+	err = p9_socket_open(trans, csocket);
+	if (err < 0)
+		goto error;
+
+	return trans;
+
+error:
+	if (csocket)
+		sock_release(csocket);
+
+	kfree(trans);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL(p9_trans_create_tcp);
+
+struct p9_transport *p9_trans_create_unix(const char *addr)
+{
+	int err;
+	struct socket *csocket;
+	struct sockaddr_un sun_server;
+	struct p9_transport *trans;
+
+	csocket = NULL;
+	trans = kmalloc(sizeof(struct p9_transport), GFP_KERNEL);
+	if (!trans)
+		return ERR_PTR(-ENOMEM);
+
+	trans->write = p9_fd_write;
+	trans->read = p9_fd_read;
+	trans->close = p9_fd_close;
+	trans->poll = p9_fd_poll;
+
+	if (strlen(addr) > UNIX_PATH_MAX) {
+		P9_EPRINTK(KERN_ERR, "p9_trans_unix: address too long: %s\n",
+			addr);
+		err = -ENAMETOOLONG;
+		goto error;
+	}
+
+	sun_server.sun_family = PF_UNIX;
+	strcpy(sun_server.sun_path, addr);
+	sock_create_kern(PF_UNIX, SOCK_STREAM, 0, &csocket);
+	err = csocket->ops->connect(csocket, (struct sockaddr *)&sun_server,
+			sizeof(struct sockaddr_un) - 1, 0);
+	if (err < 0) {
+		P9_EPRINTK(KERN_ERR,
+			"p9_trans_unix: problem connecting socket: %s: %d\n",
+			addr, err);
+		goto error;
+	}
+
+	err = p9_socket_open(trans, csocket);
+	if (err < 0)
+		goto error;
+
+	return trans;
+
+error:
+	if (csocket)
+		sock_release(csocket);
+
+	kfree(trans);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL(p9_trans_create_unix);
+
+struct p9_transport *p9_trans_create_fd(int rfd, int wfd)
+{
+	int err;
+	struct p9_transport *trans;
+
+	if (rfd == ~0 || wfd == ~0) {
+		printk(KERN_ERR "v9fs: Insufficient options for proto=fd\n");
+		return ERR_PTR(-ENOPROTOOPT);
+	}
+
+	trans = kmalloc(sizeof(struct p9_transport), GFP_KERNEL);
+	if (!trans)
+		return ERR_PTR(-ENOMEM);
+
+	trans->write = p9_fd_write;
+	trans->read = p9_fd_read;
+	trans->close = p9_fd_close;
+	trans->poll = p9_fd_poll;
+
+	err = p9_fd_open(trans, rfd, wfd);
+	if (err < 0)
+		goto error;
+
+	return trans;
+
+error:
+	kfree(trans);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL(p9_trans_create_fd);
+
+static int p9_socket_open(struct p9_transport *trans, struct socket *csocket)
+{
+	int fd, ret;
+
+	csocket->sk->sk_allocation = GFP_NOIO;
+	fd = sock_map_fd(csocket);
+	if (fd < 0) {
+		P9_EPRINTK(KERN_ERR, "p9_socket_open: failed to map fd\n");
+		return fd;
+	}
+
+	ret = p9_fd_open(trans, fd, fd);
+	if (ret < 0) {
+		P9_EPRINTK(KERN_ERR, "p9_socket_open: failed to open fd\n");
+		sockfd_put(csocket);
+		return ret;
+	}
+
+	((struct p9_trans_fd *)trans->priv)->rd->f_flags |= O_NONBLOCK;
+
+	return 0;
+}
+
+static int p9_fd_open(struct p9_transport *trans, int rfd, int wfd)
+{
+	struct p9_trans_fd *ts = kmalloc(sizeof(struct p9_trans_fd),
+					   GFP_KERNEL);
+	if (!ts)
+		return -ENOMEM;
+
+	ts->rd = fget(rfd);
+	ts->wr = fget(wfd);
+	if (!ts->rd || !ts->wr) {
+		if (ts->rd)
+			fput(ts->rd);
+		if (ts->wr)
+			fput(ts->wr);
+		kfree(ts);
+		return -EIO;
+	}
+
+	trans->priv = ts;
+	trans->status = Connected;
+
+	return 0;
+}
+
 /**
- * v9fs_fd_read- read from a fd
+ * p9_fd_read- read from a fd
  * @v9ses: session information
  * @v: buffer to receive data into
  * @len: size of receive buffer
  *
  */
-static int v9fs_fd_read(struct v9fs_transport *trans, void *v, int len)
+static int p9_fd_read(struct p9_transport *trans, void *v, int len)
 {
 	int ret;
-	struct v9fs_trans_fd *ts;
+	struct p9_trans_fd *ts;

 	if (!trans || trans->status == Disconnected || !(ts = trans->priv))
 		return -EREMOTEIO;

 	if (!(ts->rd->f_flags & O_NONBLOCK))
-		dprintk(DEBUG_ERROR, "blocking read ...\n");
+		P9_DPRINTK(P9_DEBUG_ERROR, "blocking read ...\n");

 	ret = kernel_read(ts->rd, ts->rd->f_pos, v, len);
 	if (ret <= 0 && ret != -ERESTARTSYS && ret != -EAGAIN)
@@ -73,23 +261,23 @@ static int v9fs_fd_read(struct v9fs_transport
*trans, void *v, int len)
 }

 /**
- * v9fs_fd_write - write to a socket
+ * p9_fd_write - write to a socket
  * @v9ses: session information
  * @v: buffer to send data from
  * @len: size of send buffer
  *
  */
-static int v9fs_fd_write(struct v9fs_transport *trans, void *v, int len)
+static int p9_fd_write(struct p9_transport *trans, void *v, int len)
 {
 	int ret;
 	mm_segment_t oldfs;
-	struct v9fs_trans_fd *ts;
+	struct p9_trans_fd *ts;

 	if (!trans || trans->status == Disconnected || !(ts = trans->priv))
 		return -EREMOTEIO;

 	if (!(ts->wr->f_flags & O_NONBLOCK))
-		dprintk(DEBUG_ERROR, "blocking write ...\n");
+		P9_DPRINTK(P9_DEBUG_ERROR, "blocking write ...\n");

 	oldfs = get_fs();
 	set_fs(get_ds());
@@ -103,10 +291,10 @@ static int v9fs_fd_write(struct v9fs_transport
*trans, void *v, int len)
 }

 static unsigned int
-v9fs_fd_poll(struct v9fs_transport *trans, struct poll_table_struct *pt)
+p9_fd_poll(struct p9_transport *trans, struct poll_table_struct *pt)
 {
 	int ret, n;
-	struct v9fs_trans_fd *ts;
+	struct p9_trans_fd *ts;
 	mm_segment_t oldfs;

 	if (!trans || trans->status != Connected || !(ts = trans->priv))
@@ -139,133 +327,14 @@ v9fs_fd_poll(struct v9fs_transport *trans,
struct poll_table_struct *pt)
 	return ret;
 }

-static int v9fs_fd_open(struct v9fs_session_info *v9ses, int rfd, int wfd)
-{
-	struct v9fs_transport *trans = v9ses->transport;
-	struct v9fs_trans_fd *ts = kmalloc(sizeof(struct v9fs_trans_fd),
-					   GFP_KERNEL);
-	if (!ts)
-		return -ENOMEM;
-
-	ts->rd = fget(rfd);
-	ts->wr = fget(wfd);
-	if (!ts->rd || !ts->wr) {
-		if (ts->rd)
-			fput(ts->rd);
-		if (ts->wr)
-			fput(ts->wr);
-		kfree(ts);
-		return -EIO;
-	}
-
-	trans->priv = ts;
-	trans->status = Connected;
-
-	return 0;
-}
-
-static int v9fs_fd_init(struct v9fs_session_info *v9ses, const char *addr,
-			char *data)
-{
-	if (v9ses->rfdno == ~0 || v9ses->wfdno == ~0) {
-		printk(KERN_ERR "v9fs: Insufficient options for proto=fd\n");
-		return -ENOPROTOOPT;
-	}
-
-	return v9fs_fd_open(v9ses, v9ses->rfdno, v9ses->wfdno);
-}
-
-static int v9fs_socket_open(struct v9fs_session_info *v9ses,
-			    struct socket *csocket)
-{
-	int fd, ret;
-
-	csocket->sk->sk_allocation = GFP_NOIO;
-	if ((fd = sock_map_fd(csocket)) < 0) {
-		eprintk(KERN_ERR, "v9fs_socket_open: failed to map fd\n");
-		ret = fd;
-	      release_csocket:
-		sock_release(csocket);
-		return ret;
-	}
-
-	if ((ret = v9fs_fd_open(v9ses, fd, fd)) < 0) {
-		sockfd_put(csocket);
-		eprintk(KERN_ERR, "v9fs_socket_open: failed to open fd\n");
-		goto release_csocket;
-	}
-
-	((struct v9fs_trans_fd *)v9ses->transport->priv)->rd->f_flags |=
-	    O_NONBLOCK;
-	return 0;
-}
-
-static int v9fs_tcp_init(struct v9fs_session_info *v9ses, const char *addr,
-			 char *data)
-{
-	int ret;
-	struct socket *csocket = NULL;
-	struct sockaddr_in sin_server;
-
-	sin_server.sin_family = AF_INET;
-	sin_server.sin_addr.s_addr = in_aton(addr);
-	sin_server.sin_port = htons(v9ses->port);
-	sock_create_kern(PF_INET, SOCK_STREAM, IPPROTO_TCP, &csocket);
-
-	if (!csocket) {
-		eprintk(KERN_ERR, "v9fs_trans_tcp: problem creating socket\n");
-		return -1;
-	}
-
-	ret = csocket->ops->connect(csocket,
-				    (struct sockaddr *)&sin_server,
-				    sizeof(struct sockaddr_in), 0);
-	if (ret < 0) {
-		eprintk(KERN_ERR,
-			"v9fs_trans_tcp: problem connecting socket to %s\n",
-			addr);
-		return ret;
-	}
-
-	return v9fs_socket_open(v9ses, csocket);
-}
-
-static int
-v9fs_unix_init(struct v9fs_session_info *v9ses, const char *addr, char *data)
-{
-	int ret;
-	struct socket *csocket;
-	struct sockaddr_un sun_server;
-
-	if (strlen(addr) > UNIX_PATH_MAX) {
-		eprintk(KERN_ERR, "v9fs_trans_unix: address too long: %s\n",
-			addr);
-		return -ENAMETOOLONG;
-	}
-
-	sun_server.sun_family = PF_UNIX;
-	strcpy(sun_server.sun_path, addr);
-	sock_create_kern(PF_UNIX, SOCK_STREAM, 0, &csocket);
-	ret = csocket->ops->connect(csocket, (struct sockaddr *)&sun_server,
-			sizeof(struct sockaddr_un) - 1, 0);
-	if (ret < 0) {
-		eprintk(KERN_ERR,
-			"v9fs_trans_unix: problem connecting socket: %s: %d\n",
-			addr, ret);
-		return ret;
-	}
-
-	return v9fs_socket_open(v9ses, csocket);
-}
-
 /**
- * v9fs_sock_close - shutdown socket
+ * p9_sock_close - shutdown socket
  * @trans: private socket structure
  *
  */
-static void v9fs_fd_close(struct v9fs_transport *trans)
+static void p9_fd_close(struct p9_transport *trans)
 {
-	struct v9fs_trans_fd *ts;
+	struct p9_trans_fd *ts;

 	if (!trans)
 		return;
@@ -283,26 +352,3 @@ static void v9fs_fd_close(struct v9fs_transport *trans)
 	kfree(ts);
 }

-struct v9fs_transport v9fs_trans_fd = {
-	.init = v9fs_fd_init,
-	.write = v9fs_fd_write,
-	.read = v9fs_fd_read,
-	.close = v9fs_fd_close,
-	.poll = v9fs_fd_poll,
-};
-
-struct v9fs_transport v9fs_trans_tcp = {
-	.init = v9fs_tcp_init,
-	.write = v9fs_fd_write,
-	.read = v9fs_fd_read,
-	.close = v9fs_fd_close,
-	.poll = v9fs_fd_poll,
-};
-
-struct v9fs_transport v9fs_trans_unix = {
-	.init = v9fs_unix_init,
-	.write = v9fs_fd_write,
-	.read = v9fs_fd_read,
-	.close = v9fs_fd_close,
-	.poll = v9fs_fd_poll,
-};
diff --git a/fs/9p/transport.h b/fs/9p/transport.h
index b38a4b8..462d422 100644
--- a/fs/9p/transport.h
+++ b/fs/9p/transport.h
@@ -1,5 +1,5 @@
 /*
- * linux/fs/9p/transport.h
+ * include/net/9p/transport.h
  *
  * Transport Definition
  *
@@ -23,23 +23,27 @@
  *
  */

-enum v9fs_transport_status {
+#ifndef NET_9P_TRANSPORT_H
+#define NET_9P_TRANSPORT_H
+
+enum p9_transport_status {
 	Connected,
 	Disconnected,
 	Hung,
 };

-struct v9fs_transport {
-	enum v9fs_transport_status status;
+struct p9_transport {
+	enum p9_transport_status status;
 	void *priv;

-	int (*init) (struct v9fs_session_info *, const char *, char *);
-	int (*write) (struct v9fs_transport *, void *, int);
-	int (*read) (struct v9fs_transport *, void *, int);
-	void (*close) (struct v9fs_transport *);
-	unsigned int (*poll)(struct v9fs_transport *, struct poll_table_struct *);
+	int (*write) (struct p9_transport *, void *, int);
+	int (*read) (struct p9_transport *, void *, int);
+	void (*close) (struct p9_transport *);
+	unsigned int (*poll)(struct p9_transport *, struct poll_table_struct *);
 };

-extern struct v9fs_transport v9fs_trans_tcp;
-extern struct v9fs_transport v9fs_trans_unix;
-extern struct v9fs_transport v9fs_trans_fd;
+struct p9_transport *p9_trans_create_tcp(const char *addr, int port);
+struct p9_transport *p9_trans_create_unix(const char *addr);
+struct p9_transport *p9_trans_create_fd(int rfd, int wfd);
+
+#endif /* NET_9P_TRANSPORT_H */
diff --git a/fs/9p/util.c b/fs/9p/util.c
new file mode 100644
index 0000000..9910e3e
--- /dev/null
+++ b/fs/9p/util.c
@@ -0,0 +1,125 @@
+/*
+ *  net/9p/util.c
+ *
+ *  This file contains some helper functions
+ *
+ *  Copyright (C) 2007 by Latchesar Ionkov <lucho@ionkov.net>
+ *  Copyright (C) 2004 by Eric Van Hensbergen <ericvh@gmail.com>
+ *  Copyright (C) 2002 by Ron Minnich <rminnich@lanl.gov>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2
+ *  as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to:
+ *  Free Software Foundation
+ *  51 Franklin Street, Fifth Floor
+ *  Boston, MA  02111-1301  USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/parser.h>
+#include <linux/idr.h>
+#include "9p.h"
+
+struct p9_idpool {
+	struct semaphore lock;
+	struct idr pool;
+};
+
+struct p9_idpool *p9_idpool_create(void)
+{
+	struct p9_idpool *p;
+
+	p = kmalloc(sizeof(struct p9_idpool), GFP_KERNEL);
+	if (!p)
+		return ERR_PTR(-ENOMEM);
+
+	init_MUTEX(&p->lock);
+	idr_init(&p->pool);
+
+	return p;
+}
+EXPORT_SYMBOL(p9_idpool_create);
+
+void p9_idpool_destroy(struct p9_idpool *p)
+{
+	idr_destroy(&p->pool);
+	kfree(p);
+}
+EXPORT_SYMBOL(p9_idpool_destroy);
+
+/**
+ * p9_idpool_get - allocate numeric id from pool
+ * @p - pool to allocate from
+ *
+ * XXX - This seems to be an awful generic function, should it be in idr.c with
+ *            the lock included in struct idr?
+ */
+
+int p9_idpool_get(struct p9_idpool *p)
+{
+	int i = 0;
+	int error;
+
+retry:
+	if (idr_pre_get(&p->pool, GFP_KERNEL) == 0)
+		return 0;
+
+	if (down_interruptible(&p->lock) == -EINTR) {
+		P9_EPRINTK(KERN_WARNING, "Interrupted while locking\n");
+		return -1;
+	}
+
+	/* no need to store exactly p, we just need something non-null */
+	error = idr_get_new(&p->pool, p, &i);
+	up(&p->lock);
+
+	if (error == -EAGAIN)
+		goto retry;
+	else if (error)
+		return -1;
+
+	return i;
+}
+EXPORT_SYMBOL(p9_idpool_get);
+
+/**
+ * p9_idpool_put - release numeric id from pool
+ * @p - pool to allocate from
+ *
+ * XXX - This seems to be an awful generic function, should it be in idr.c with
+ *            the lock included in struct idr?
+ */
+
+void p9_idpool_put(int id, struct p9_idpool *p)
+{
+	if (down_interruptible(&p->lock) == -EINTR) {
+		P9_EPRINTK(KERN_WARNING, "Interrupted while locking\n");
+		return;
+	}
+	idr_remove(&p->pool, id);
+	up(&p->lock);
+}
+EXPORT_SYMBOL(p9_idpool_put);
+
+/**
+ * p9_idpool_check - check if the specified id is available
+ * @id - id to check
+ * @p - pool
+ */
+int p9_idpool_check(int id, struct p9_idpool *p)
+{
+	return idr_find(&p->pool, id) != NULL;
+}
+EXPORT_SYMBOL(p9_idpool_check);
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 6ad6f19..52dba51 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -29,16 +29,14 @@
 #include <linux/sched.h>
 #include <linux/parser.h>
 #include <linux/idr.h>
-
-#include "debug.h"
-#include "v9fs.h"
 #include "9p.h"
-#include "v9fs_vfs.h"
 #include "transport.h"
-#include "mux.h"
+#include "conn.h"
+#include "v9fs.h"
+#include "v9fs_vfs.h"

 /* TODO: sysfs or debugfs interface */
-int v9fs_debug_level = 0;	/* feature-rific global debug level  */
+unsigned int p9_debug_level = 0;	/* feature-rific global debug level  */

 /*
   * Option Parsing (code inspired by NFS code)
@@ -122,7 +120,7 @@ static void v9fs_parse_options(char *options,
struct v9fs_session_info *v9ses)
 		token = match_token(p, tokens, args);
 		if (token < Opt_uname) {
 			if ((ret = match_int(&args[0], &option)) < 0) {
-				dprintk(DEBUG_ERROR,
+				P9_DPRINTK(P9_DEBUG_ERROR,
 					"integer field, but no integer?\n");
 				continue;
 			}
@@ -197,68 +195,6 @@ struct v9fs_session_info *v9fs_inode2v9ses(struct
inode *inode)
 }

 /**
- * v9fs_get_idpool - allocate numeric id from pool
- * @p - pool to allocate from
- *
- * XXX - This seems to be an awful generic function, should it be in idr.c with
- *            the lock included in struct idr?
- */
-
-int v9fs_get_idpool(struct v9fs_idpool *p)
-{
-	int i = 0;
-	int error;
-
-retry:
-	if (idr_pre_get(&p->pool, GFP_KERNEL) == 0)
-		return 0;
-
-	if (down_interruptible(&p->lock) == -EINTR) {
-		eprintk(KERN_WARNING, "Interrupted while locking\n");
-		return -1;
-	}
-
-	/* no need to store exactly p, we just need something non-null */
-	error = idr_get_new(&p->pool, p, &i);
-	up(&p->lock);
-
-	if (error == -EAGAIN)
-		goto retry;
-	else if (error)
-		return -1;
-
-	return i;
-}
-
-/**
- * v9fs_put_idpool - release numeric id from pool
- * @p - pool to allocate from
- *
- * XXX - This seems to be an awful generic function, should it be in idr.c with
- *            the lock included in struct idr?
- */
-
-void v9fs_put_idpool(int id, struct v9fs_idpool *p)
-{
-	if (down_interruptible(&p->lock) == -EINTR) {
-		eprintk(KERN_WARNING, "Interrupted while locking\n");
-		return;
-	}
-	idr_remove(&p->pool, id);
-	up(&p->lock);
-}
-
-/**
- * v9fs_check_idpool - check if the specified id is available
- * @id - id to check
- * @p - pool
- */
-int v9fs_check_idpool(int id, struct v9fs_idpool *p)
-{
-	return idr_find(&p->pool, id) != NULL;
-}
-
-/**
  * v9fs_session_init - initialize session
  * @v9ses: session information structure
  * @dev_name: device being mounted
@@ -270,12 +206,12 @@ int
 v9fs_session_init(struct v9fs_session_info *v9ses,
 		  const char *dev_name, char *data)
 {
-	struct v9fs_fcall *fcall = NULL;
-	struct v9fs_transport *trans_proto;
+	struct p9_fcall *fcall = NULL;
+	struct p9_transport *trans;
 	int n = 0;
 	int newfid = -1;
 	int retval = -EINVAL;
-	struct v9fs_str *version;
+	struct p9_str *version;

 	v9ses->name = __getname();
 	if (!v9ses->name)
@@ -293,22 +229,25 @@ v9fs_session_init(struct v9fs_session_info *v9ses,
 	v9fs_parse_options(data, v9ses);

 	/* set global debug level */
-	v9fs_debug_level = v9ses->debug;
+	p9_debug_level = v9ses->debug;

-	/* id pools that are session-dependent: fids and tags */
-	idr_init(&v9ses->fidpool.pool);
-	init_MUTEX(&v9ses->fidpool.lock);
+	v9ses->fidpool = p9_idpool_create();
+	if (IS_ERR(v9ses->fidpool)) {
+		retval = PTR_ERR(v9ses->fidpool);
+		v9ses->fidpool = NULL;
+		goto SessCleanUp;
+	}

 	switch (v9ses->proto) {
 	case PROTO_TCP:
-		trans_proto = &v9fs_trans_tcp;
+		trans = p9_trans_create_tcp(dev_name, v9ses->port);
 		break;
 	case PROTO_UNIX:
-		trans_proto = &v9fs_trans_unix;
+		trans = p9_trans_create_unix(dev_name);
 		*v9ses->remotename = 0;
 		break;
 	case PROTO_FD:
-		trans_proto = &v9fs_trans_fd;
+		trans = p9_trans_create_fd(v9ses->rfdno, v9ses->wfdno);
 		*v9ses->remotename = 0;
 		break;
 	default:
@@ -317,30 +256,24 @@ v9fs_session_init(struct v9fs_session_info *v9ses,
 		goto SessCleanUp;
 	};

-	v9ses->transport = kmalloc(sizeof(*v9ses->transport), GFP_KERNEL);
-	if (!v9ses->transport) {
-		retval = -ENOMEM;
-		goto SessCleanUp;
-	}
-
-	memmove(v9ses->transport, trans_proto, sizeof(*v9ses->transport));
-
-	if ((retval = v9ses->transport->init(v9ses, dev_name, data)) < 0) {
-		eprintk(KERN_ERR, "problem initializing transport\n");
+	if (IS_ERR(trans)) {
+		retval = PTR_ERR(trans);
+		trans = NULL;
 		goto SessCleanUp;
 	}

+	v9ses->transport = trans;
 	v9ses->inprogress = 0;
 	v9ses->shutdown = 0;
 	v9ses->session_hung = 0;

-	v9ses->mux = v9fs_mux_init(v9ses->transport, v9ses->maxdata + V9FS_IOHDRSZ,
+	v9ses->conn = p9_conn_create(v9ses->transport, v9ses->maxdata + P9_IOHDRSZ,
 		&v9ses->extended);

-	if (IS_ERR(v9ses->mux)) {
-		retval = PTR_ERR(v9ses->mux);
-		v9ses->mux = NULL;
-		dprintk(DEBUG_ERROR, "problem initializing mux\n");
+	if (IS_ERR(v9ses->conn)) {
+		retval = PTR_ERR(v9ses->conn);
+		v9ses->conn = NULL;
+		P9_DPRINTK(P9_DEBUG_ERROR, "problem initializing mux\n");
 		goto SessCleanUp;
 	}

@@ -354,16 +287,16 @@ v9fs_session_init(struct v9fs_session_info *v9ses,
 						&fcall);

 		if (retval < 0) {
-			dprintk(DEBUG_ERROR, "v9fs_t_version failed\n");
+			P9_DPRINTK(P9_DEBUG_ERROR, "v9fs_t_version failed\n");
 			goto FreeFcall;
 		}

 		version = &fcall->params.rversion.version;
 		if (version->len==8 && !memcmp(version->str, "9P2000.u", 8)) {
-			dprintk(DEBUG_9P, "9P2000 UNIX extensions enabled\n");
+			P9_DPRINTK(P9_DEBUG_9P, "9P2000 UNIX extensions enabled\n");
 			v9ses->extended = 1;
 		} else if (version->len==6 && !memcmp(version->str, "9P2000", 6)) {
-			dprintk(DEBUG_9P, "9P2000 legacy mode enabled\n");
+			P9_DPRINTK(P9_DEBUG_9P, "9P2000 legacy mode enabled\n");
 			v9ses->extended = 0;
 		} else {
 			retval = -EREMOTEIO;
@@ -377,18 +310,18 @@ v9fs_session_init(struct v9fs_session_info *v9ses,
 			v9ses->maxdata = n;
 	}

-	newfid = v9fs_get_idpool(&v9ses->fidpool);
+	newfid = p9_idpool_get(v9ses->fidpool);
 	if (newfid < 0) {
-		eprintk(KERN_WARNING, "couldn't allocate FID\n");
+		P9_EPRINTK(KERN_WARNING, "couldn't allocate FID\n");
 		retval = -ENOMEM;
 		goto SessCleanUp;
 	}
 	/* it is a little bit ugly, but we have to prevent newfid */
 	/* being the same as afid, so if it is, get a new fid     */
 	if (v9ses->afid != ~0 && newfid == v9ses->afid) {
-		newfid = v9fs_get_idpool(&v9ses->fidpool);
+		newfid = p9_idpool_get(v9ses->fidpool);
 		if (newfid < 0) {
-			eprintk(KERN_WARNING, "couldn't allocate FID\n");
+			P9_EPRINTK(KERN_WARNING, "couldn't allocate FID\n");
 			retval = -ENOMEM;
 			goto SessCleanUp;
 		}
@@ -398,14 +331,14 @@ v9fs_session_init(struct v9fs_session_info *v9ses,
 	     v9fs_t_attach(v9ses, v9ses->name, v9ses->remotename, newfid,
 			   v9ses->afid, NULL))
 	    < 0) {
-		dprintk(DEBUG_ERROR, "cannot attach\n");
+		P9_DPRINTK(P9_DEBUG_ERROR, "cannot attach\n");
 		goto SessCleanUp;
 	}

 	if (v9ses->afid != ~0) {
-		dprintk(DEBUG_ERROR, "afid not equal to ~0\n");
+		P9_DPRINTK(P9_DEBUG_ERROR, "afid not equal to ~0\n");
 		if (v9fs_t_clunk(v9ses, v9ses->afid))
-			dprintk(DEBUG_ERROR, "clunk failed\n");
+			P9_DPRINTK(P9_DEBUG_ERROR, "clunk failed\n");
 	}

 	return newfid;
@@ -426,9 +359,9 @@ v9fs_session_init(struct v9fs_session_info *v9ses,

 void v9fs_session_close(struct v9fs_session_info *v9ses)
 {
-	if (v9ses->mux) {
-		v9fs_mux_destroy(v9ses->mux);
-		v9ses->mux = NULL;
+	if (v9ses->conn) {
+		p9_conn_destroy(v9ses->conn);
+		v9ses->conn = NULL;
 	}

 	if (v9ses->transport) {
@@ -437,6 +370,11 @@ void v9fs_session_close(struct v9fs_session_info *v9ses)
 		v9ses->transport = NULL;
 	}

+	if (v9ses->fidpool) {
+		p9_idpool_destroy(v9ses->fidpool);
+		v9ses->fidpool = NULL;
+	}
+
 	__putname(v9ses->name);
 	__putname(v9ses->remotename);
 }
@@ -446,12 +384,14 @@ void v9fs_session_close(struct v9fs_session_info *v9ses)
  * 	and cancel all pending requests.
  */
 void v9fs_session_cancel(struct v9fs_session_info *v9ses) {
-	dprintk(DEBUG_ERROR, "cancel session %p\n", v9ses);
+	P9_DPRINTK(P9_DEBUG_ERROR, "cancel session %p\n", v9ses);
 	v9ses->transport->status = Disconnected;
-	v9fs_mux_cancel(v9ses->mux, -EIO);
+	p9_conn_cancel(v9ses->conn, -EIO);
 }

-extern int v9fs_error_init(void);
+extern int p9_error_init(void);
+extern int p9_mux_global_init(void);
+extern void p9_mux_global_exit(void);

 /**
  * v9fs_init - Initialize module
@@ -462,20 +402,17 @@ static int __init init_v9fs(void)
 {
 	int ret;

-	v9fs_error_init();
-
+	p9_error_init();
 	printk(KERN_INFO "Installing v9fs 9p2000 file system support\n");
-
-	ret = v9fs_mux_global_init();
+	ret = p9_mux_global_init();
 	if (ret) {
-		printk(KERN_WARNING "v9fs: starting mux failed\n");
+		printk(KERN_WARNING "9p: starting mux failed\n");
 		return ret;
 	}
+
 	ret = register_filesystem(&v9fs_fs_type);
-	if (ret) {
+	if (ret)
 		printk(KERN_WARNING "v9fs: registering file system failed\n");
-		v9fs_mux_global_exit();
-	}

 	return ret;
 }
@@ -487,8 +424,8 @@ static int __init init_v9fs(void)

 static void __exit exit_v9fs(void)
 {
-	v9fs_mux_global_exit();
 	unregister_filesystem(&v9fs_fs_type);
+	p9_mux_global_exit();
 }

 module_init(init_v9fs)
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index 820bf5c..0a0be4f 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -22,16 +22,6 @@
  */

 /*
-  * Idpool structure provides lock and id management
-  *
-  */
-
-struct v9fs_idpool {
-	struct semaphore lock;
-	struct idr pool;
-};
-
-/*
   * Session structure provides information for an opened session
   *
   */
@@ -55,10 +45,10 @@ struct v9fs_session_info {
 	unsigned int gid;	/* default gid for legacy support */

 	/* book keeping */
-	struct v9fs_idpool fidpool;	/* The FID pool for file descriptors */
+	struct p9_idpool *fidpool;	/* The FID pool for file descriptors */

-	struct v9fs_transport *transport;
-	struct v9fs_mux_data *mux;
+	struct p9_transport *transport;
+	struct p9_conn *conn;

 	int inprogress;		/* session in progress => true */
 	int shutdown;		/* session shutting down. no more attaches. */
@@ -85,11 +75,41 @@ extern struct dentry *v9fs_debugfs_root;
 int v9fs_session_init(struct v9fs_session_info *, const char *, char *);
 struct v9fs_session_info *v9fs_inode2v9ses(struct inode *);
 void v9fs_session_close(struct v9fs_session_info *v9ses);
-int v9fs_get_idpool(struct v9fs_idpool *p);
-void v9fs_put_idpool(int id, struct v9fs_idpool *p);
-int v9fs_check_idpool(int id, struct v9fs_idpool *p);
 void v9fs_session_cancel(struct v9fs_session_info *v9ses);

+int v9fs_t_version(struct v9fs_session_info *v9ses, u32 msize,
+		   char *version, struct p9_fcall **rcall);
+
+int v9fs_t_attach(struct v9fs_session_info *v9ses, char *uname, char *aname,
+		  u32 fid, u32 afid, struct p9_fcall **rcall);
+
+int v9fs_t_clunk(struct v9fs_session_info *v9ses, u32 fid);
+
+int v9fs_t_stat(struct v9fs_session_info *v9ses, u32 fid,
+		struct p9_fcall **rcall);
+
+int v9fs_t_wstat(struct v9fs_session_info *v9ses, u32 fid,
+		 struct p9_wstat *wstat, struct p9_fcall **rcall);
+
+int v9fs_t_walk(struct v9fs_session_info *v9ses, u32 fid, u32 newfid,
+		char *name, struct p9_fcall **rcall);
+
+int v9fs_t_open(struct v9fs_session_info *v9ses, u32 fid, u8 mode,
+		struct p9_fcall **rcall);
+
+int v9fs_t_remove(struct v9fs_session_info *v9ses, u32 fid,
+		  struct p9_fcall **rcall);
+
+int v9fs_t_create(struct v9fs_session_info *v9ses, u32 fid, char *name,
+	u32 perm, u8 mode, char *extension, struct p9_fcall **rcall);
+
+int v9fs_t_read(struct v9fs_session_info *v9ses, u32 fid,
+		u64 offset, u32 count, struct p9_fcall **rcall);
+
+int v9fs_t_write(struct v9fs_session_info *v9ses, u32 fid, u64 offset,
+		 u32 count, const char __user * data,
+		 struct p9_fcall **rcall);
+
 #define V9FS_MAGIC 0x01021997

 /* other default globals */
diff --git a/fs/9p/v9fs_vfs.h b/fs/9p/v9fs_vfs.h
index 6a82d39..fd01d90 100644
--- a/fs/9p/v9fs_vfs.h
+++ b/fs/9p/v9fs_vfs.h
@@ -45,10 +45,10 @@ extern struct dentry_operations v9fs_dentry_operations;
 extern struct dentry_operations v9fs_cached_dentry_operations;

 struct inode *v9fs_get_inode(struct super_block *sb, int mode);
-ino_t v9fs_qid2ino(struct v9fs_qid *qid);
-void v9fs_stat2inode(struct v9fs_stat *, struct inode *, struct super_block *);
+ino_t v9fs_qid2ino(struct p9_qid *qid);
+void v9fs_stat2inode(struct p9_stat *, struct inode *, struct super_block *);
 int v9fs_dir_release(struct inode *inode, struct file *filp);
 int v9fs_file_open(struct inode *inode, struct file *file);
-void v9fs_inode2stat(struct inode *inode, struct v9fs_stat *stat);
+void v9fs_inode2stat(struct inode *inode, struct p9_stat *stat);
 void v9fs_dentry_release(struct dentry *);
 int v9fs_uflags2omode(int uflags);
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index bed48fa..1470cb8 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -33,10 +33,8 @@
 #include <linux/inet.h>
 #include <linux/pagemap.h>
 #include <linux/idr.h>
-
-#include "debug.h"
-#include "v9fs.h"
 #include "9p.h"
+#include "v9fs.h"
 #include "v9fs_vfs.h"
 #include "fid.h"

@@ -56,14 +54,14 @@ static int v9fs_vfs_readpage(struct file *filp,
struct page *page)
 	int count = PAGE_CACHE_SIZE;
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
-	int rsize = v9ses->maxdata - V9FS_IOHDRSZ;
+	int rsize = v9ses->maxdata - P9_IOHDRSZ;
 	struct v9fs_fid *v9f = filp->private_data;
-	struct v9fs_fcall *fcall = NULL;
+	struct p9_fcall *fcall = NULL;
 	int fid = v9f->fid;
 	int total = 0;
 	int result = 0;

-	dprintk(DEBUG_VFS, "\n");
+	P9_DPRINTK(P9_DEBUG_VFS, "\n");

 	buffer = kmap(page);
 	do {
diff --git a/fs/9p/vfs_dentry.c b/fs/9p/vfs_dentry.c
index ddffd8a..070a9b5 100644
--- a/fs/9p/vfs_dentry.c
+++ b/fs/9p/vfs_dentry.c
@@ -34,10 +34,8 @@
 #include <linux/inet.h>
 #include <linux/namei.h>
 #include <linux/idr.h>
-
-#include "debug.h"
-#include "v9fs.h"
 #include "9p.h"
+#include "v9fs.h"
 #include "v9fs_vfs.h"
 #include "fid.h"

@@ -52,7 +50,7 @@

 static int v9fs_dentry_delete(struct dentry *dentry)
 {
-	dprintk(DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);
+	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);

 	return 1;
 }
@@ -69,7 +67,7 @@ static int v9fs_dentry_delete(struct dentry *dentry)
 static int v9fs_cached_dentry_delete(struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
-	dprintk(DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);
+	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);

 	if(!inode)
 		return 1;
@@ -87,7 +85,7 @@ void v9fs_dentry_release(struct dentry *dentry)
 {
 	int err;

-	dprintk(DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);
+	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);

 	if (dentry->d_fsdata != NULL) {
 		struct list_head *fid_list = dentry->d_fsdata;
@@ -98,7 +96,7 @@ void v9fs_dentry_release(struct dentry *dentry)
 			err = v9fs_t_clunk(current_fid->v9ses, current_fid->fid);

 			if (err < 0)
-				dprintk(DEBUG_ERROR, "clunk failed: %d name %s\n",
+				P9_DPRINTK(P9_DEBUG_ERROR, "clunk failed: %d name %s\n",
 					err, dentry->d_iname);

 			v9fs_fid_destroy(current_fid);
diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index 3129688..a28639b 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -33,11 +33,8 @@
 #include <linux/sched.h>
 #include <linux/inet.h>
 #include <linux/idr.h>
-
-#include "debug.h"
-#include "v9fs.h"
 #include "9p.h"
-#include "conv.h"
+#include "v9fs.h"
 #include "v9fs_vfs.h"
 #include "fid.h"

@@ -47,14 +44,14 @@
  *
  */

-static inline int dt_type(struct v9fs_stat *mistat)
+static inline int dt_type(struct p9_stat *mistat)
 {
 	unsigned long perm = mistat->mode;
 	int rettype = DT_REG;

-	if (perm & V9FS_DMDIR)
+	if (perm & P9_DMDIR)
 		rettype = DT_DIR;
-	if (perm & V9FS_DMSYMLINK)
+	if (perm & P9_DMSYMLINK)
 		rettype = DT_LNK;

 	return rettype;
@@ -70,17 +67,17 @@ static inline int dt_type(struct v9fs_stat *mistat)

 static int v9fs_dir_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
-	struct v9fs_fcall *fcall = NULL;
+	struct p9_fcall *fcall = NULL;
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
 	struct v9fs_fid *file = filp->private_data;
 	unsigned int i, n, s;
 	int fid = -1;
 	int ret = 0;
-	struct v9fs_stat stat;
+	struct p9_stat stat;
 	int over = 0;

-	dprintk(DEBUG_VFS, "name %s\n", filp->f_path.dentry->d_name.name);
+	P9_DPRINTK(P9_DEBUG_VFS, "name %s\n", filp->f_path.dentry->d_name.name);

 	fid = file->fid;

@@ -93,12 +90,12 @@ static int v9fs_dir_readdir(struct file *filp,
void *dirent, filldir_t filldir)
 		n = file->rdir_fcall->params.rread.count;
 		i = file->rdir_fpos;
 		while (i < n) {
-			s = v9fs_deserialize_stat(
+			s = p9_deserialize_stat(
 				file->rdir_fcall->params.rread.data + i,
 				n - i, &stat, v9ses->extended);

 			if (s == 0) {
-				dprintk(DEBUG_ERROR,
+				P9_DPRINTK(P9_DEBUG_ERROR,
 					"error while deserializing stat\n");
 				ret = -EIO;
 				goto FreeStructs;
@@ -126,9 +123,9 @@ static int v9fs_dir_readdir(struct file *filp,
void *dirent, filldir_t filldir)

 	while (!over) {
 		ret = v9fs_t_read(v9ses, fid, filp->f_pos,
-			v9ses->maxdata-V9FS_IOHDRSZ, &fcall);
+			v9ses->maxdata-P9_IOHDRSZ, &fcall);
 		if (ret < 0) {
-			dprintk(DEBUG_ERROR, "error while reading: %d: %p\n",
+			P9_DPRINTK(P9_DEBUG_ERROR, "error while reading: %d: %p\n",
 				ret, fcall);
 			goto FreeStructs;
 		} else if (ret == 0)
@@ -137,11 +134,11 @@ static int v9fs_dir_readdir(struct file *filp,
void *dirent, filldir_t filldir)
 		n = ret;
 		i = 0;
 		while (i < n) {
-			s = v9fs_deserialize_stat(fcall->params.rread.data + i,
+			s = p9_deserialize_stat(fcall->params.rread.data + i,
 				n - i, &stat, v9ses->extended);

 			if (s == 0) {
-				dprintk(DEBUG_ERROR,
+				P9_DPRINTK(P9_DEBUG_ERROR,
 					"error while deserializing stat\n");
 				return -EIO;
 			}
@@ -183,18 +180,18 @@ int v9fs_dir_release(struct inode *inode, struct
file *filp)
 	struct v9fs_fid *fid = filp->private_data;
 	int fidnum = -1;

-	dprintk(DEBUG_VFS, "inode: %p filp: %p fid: %d\n", inode, filp,
+	P9_DPRINTK(P9_DEBUG_VFS, "inode: %p filp: %p fid: %d\n", inode, filp,
 		fid->fid);
 	fidnum = fid->fid;

 	filemap_write_and_wait(inode->i_mapping);

 	if (fidnum >= 0) {
-		dprintk(DEBUG_VFS, "fidopen: %d v9f->fid: %d\n", fid->fidopen,
+		P9_DPRINTK(P9_DEBUG_VFS, "fidopen: %d v9f->fid: %d\n", fid->fidopen,
 			fid->fid);

 		if (v9fs_t_clunk(v9ses, fidnum))
-			dprintk(DEBUG_ERROR, "clunk failed\n");
+			P9_DPRINTK(P9_DEBUG_ERROR, "clunk failed\n");

 		kfree(fid->rdir_fcall);
 		kfree(fid);
diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index c7b6772..a6bf0fc 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -35,10 +35,8 @@
 #include <linux/list.h>
 #include <asm/uaccess.h>
 #include <linux/idr.h>
-
-#include "debug.h"
-#include "v9fs.h"
 #include "9p.h"
+#include "v9fs.h"
 #include "v9fs_vfs.h"
 #include "fid.h"

@@ -55,11 +53,11 @@ int v9fs_file_open(struct inode *inode, struct file *file)
 {
 	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
 	struct v9fs_fid *vfid;
-	struct v9fs_fcall *fcall = NULL;
+	struct p9_fcall *fcall = NULL;
 	int omode;
 	int err;

-	dprintk(DEBUG_VFS, "inode: %p file: %p \n", inode, file);
+	P9_DPRINTK(P9_DEBUG_VFS, "inode: %p file: %p \n", inode, file);

 	vfid = v9fs_fid_clone(file->f_path.dentry);
 	if (IS_ERR(vfid))
@@ -82,7 +80,7 @@ int v9fs_file_open(struct inode *inode, struct file *file)
 	kfree(fcall);

 	if((vfid->qid.version) && (v9ses->cache)) {
-		dprintk(DEBUG_VFS, "cached");
+		P9_DPRINTK(P9_DEBUG_VFS, "cached");
 		/* enable cached file options */
 		if(file->f_op == &v9fs_file_operations)
 			file->f_op = &v9fs_cached_file_operations;
@@ -111,7 +109,7 @@ static int v9fs_file_lock(struct file *filp, int
cmd, struct file_lock *fl)
 	int res = 0;
 	struct inode *inode = filp->f_path.dentry->d_inode;

-	dprintk(DEBUG_VFS, "filp: %p lock: %p\n", filp, fl);
+	P9_DPRINTK(P9_DEBUG_VFS, "filp: %p lock: %p\n", filp, fl);

 	/* No mandatory locks */
 	if ((inode->i_mode & (S_ISGID | S_IXGRP)) == S_ISGID)
@@ -140,16 +138,16 @@ v9fs_file_read(struct file *filp, char __user *
data, size_t count,
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
 	struct v9fs_fid *v9f = filp->private_data;
-	struct v9fs_fcall *fcall = NULL;
+	struct p9_fcall *fcall = NULL;
 	int fid = v9f->fid;
 	int rsize = 0;
 	int result = 0;
 	int total = 0;
 	int n;

-	dprintk(DEBUG_VFS, "\n");
+	P9_DPRINTK(P9_DEBUG_VFS, "\n");

-	rsize = v9ses->maxdata - V9FS_IOHDRSZ;
+	rsize = v9ses->maxdata - P9_IOHDRSZ;
 	if (v9f->iounit != 0 && rsize > v9f->iounit)
 		rsize = v9f->iounit;

@@ -170,7 +168,7 @@ v9fs_file_read(struct file *filp, char __user *
data, size_t count,

 		n = copy_to_user(data, fcall->params.rread.data, result);
 		if (n) {
-			dprintk(DEBUG_ERROR, "Problem copying to user %d\n", n);
+			P9_DPRINTK(P9_DEBUG_ERROR, "Problem copying to user %d\n", n);
 			kfree(fcall);
 			return -EFAULT;
 		}
@@ -204,15 +202,15 @@ v9fs_file_write(struct file *filp, const char
__user * data,
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
 	struct v9fs_fid *v9fid = filp->private_data;
-	struct v9fs_fcall *fcall;
+	struct p9_fcall *fcall;
 	int fid = v9fid->fid;
 	int result = -EIO;
 	int rsize = 0;
 	int total = 0;

-	dprintk(DEBUG_VFS, "data %p count %d offset %x\n", data, (int)count,
+	P9_DPRINTK(P9_DEBUG_VFS, "data %p count %d offset %x\n", data, (int)count,
 		(int)*offset);
-	rsize = v9ses->maxdata - V9FS_IOHDRSZ;
+	rsize = v9ses->maxdata - P9_IOHDRSZ;
 	if (v9fid->iounit != 0 && rsize > v9fid->iounit)
 		rsize = v9fid->iounit;

@@ -232,7 +230,7 @@ v9fs_file_write(struct file *filp, const char __user * data,
 		fcall = NULL;

 		if (result != rsize) {
-			eprintk(KERN_ERR,
+			P9_EPRINTK(KERN_ERR,
 				"short write: v9fs_t_write returned %d\n",
 				result);
 			break;
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index b01b0a4..a74c93e 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -34,10 +34,8 @@
 #include <linux/inet.h>
 #include <linux/namei.h>
 #include <linux/idr.h>
-
-#include "debug.h"
-#include "v9fs.h"
 #include "9p.h"
+#include "v9fs.h"
 #include "v9fs_vfs.h"
 #include "fid.h"

@@ -58,27 +56,27 @@ static int unixmode2p9mode(struct
v9fs_session_info *v9ses, int mode)
 	int res;
 	res = mode & 0777;
 	if (S_ISDIR(mode))
-		res |= V9FS_DMDIR;
+		res |= P9_DMDIR;
 	if (v9ses->extended) {
 		if (S_ISLNK(mode))
-			res |= V9FS_DMSYMLINK;
+			res |= P9_DMSYMLINK;
 		if (v9ses->nodev == 0) {
 			if (S_ISSOCK(mode))
-				res |= V9FS_DMSOCKET;
+				res |= P9_DMSOCKET;
 			if (S_ISFIFO(mode))
-				res |= V9FS_DMNAMEDPIPE;
+				res |= P9_DMNAMEDPIPE;
 			if (S_ISBLK(mode))
-				res |= V9FS_DMDEVICE;
+				res |= P9_DMDEVICE;
 			if (S_ISCHR(mode))
-				res |= V9FS_DMDEVICE;
+				res |= P9_DMDEVICE;
 		}

 		if ((mode & S_ISUID) == S_ISUID)
-			res |= V9FS_DMSETUID;
+			res |= P9_DMSETUID;
 		if ((mode & S_ISGID) == S_ISGID)
-			res |= V9FS_DMSETGID;
-		if ((mode & V9FS_DMLINK))
-			res |= V9FS_DMLINK;
+			res |= P9_DMSETGID;
+		if ((mode & P9_DMLINK))
+			res |= P9_DMLINK;
 	}

 	return res;
@@ -97,27 +95,27 @@ static int p9mode2unixmode(struct
v9fs_session_info *v9ses, int mode)

 	res = mode & 0777;

-	if ((mode & V9FS_DMDIR) == V9FS_DMDIR)
+	if ((mode & P9_DMDIR) == P9_DMDIR)
 		res |= S_IFDIR;
-	else if ((mode & V9FS_DMSYMLINK) && (v9ses->extended))
+	else if ((mode & P9_DMSYMLINK) && (v9ses->extended))
 		res |= S_IFLNK;
-	else if ((mode & V9FS_DMSOCKET) && (v9ses->extended)
+	else if ((mode & P9_DMSOCKET) && (v9ses->extended)
 		 && (v9ses->nodev == 0))
 		res |= S_IFSOCK;
-	else if ((mode & V9FS_DMNAMEDPIPE) && (v9ses->extended)
+	else if ((mode & P9_DMNAMEDPIPE) && (v9ses->extended)
 		 && (v9ses->nodev == 0))
 		res |= S_IFIFO;
-	else if ((mode & V9FS_DMDEVICE) && (v9ses->extended)
+	else if ((mode & P9_DMDEVICE) && (v9ses->extended)
 		 && (v9ses->nodev == 0))
 		res |= S_IFBLK;
 	else
 		res |= S_IFREG;

 	if (v9ses->extended) {
-		if ((mode & V9FS_DMSETUID) == V9FS_DMSETUID)
+		if ((mode & P9_DMSETUID) == P9_DMSETUID)
 			res |= S_ISUID;

-		if ((mode & V9FS_DMSETGID) == V9FS_DMSETGID)
+		if ((mode & P9_DMSETGID) == P9_DMSETGID)
 			res |= S_ISGID;
 	}

@@ -132,26 +130,26 @@ int v9fs_uflags2omode(int uflags)
 	switch (uflags&3) {
 	default:
 	case O_RDONLY:
-		ret = V9FS_OREAD;
+		ret = P9_OREAD;
 		break;

 	case O_WRONLY:
-		ret = V9FS_OWRITE;
+		ret = P9_OWRITE;
 		break;

 	case O_RDWR:
-		ret = V9FS_ORDWR;
+		ret = P9_ORDWR;
 		break;
 	}

 	if (uflags & O_EXCL)
-		ret |= V9FS_OEXCL;
+		ret |= P9_OEXCL;

 	if (uflags & O_TRUNC)
-		ret |= V9FS_OTRUNC;
+		ret |= P9_OTRUNC;

 	if (uflags & O_APPEND)
-		ret |= V9FS_OAPPEND;
+		ret |= P9_OAPPEND;

 	return ret;
 }
@@ -164,7 +162,7 @@ int v9fs_uflags2omode(int uflags)
  */

 static void
-v9fs_blank_wstat(struct v9fs_wstat *wstat)
+v9fs_blank_wstat(struct p9_wstat *wstat)
 {
 	wstat->type = ~0;
 	wstat->dev = ~0;
@@ -197,7 +195,7 @@ struct inode *v9fs_get_inode(struct super_block
*sb, int mode)
 	struct inode *inode;
 	struct v9fs_session_info *v9ses = sb->s_fs_info;

-	dprintk(DEBUG_VFS, "super block: %p mode: %o\n", sb, mode);
+	P9_DPRINTK(P9_DEBUG_VFS, "super block: %p mode: %o\n", sb, mode);

 	inode = new_inode(sb);
 	if (inode) {
@@ -215,7 +213,7 @@ struct inode *v9fs_get_inode(struct super_block
*sb, int mode)
 		case S_IFCHR:
 		case S_IFSOCK:
 			if(!v9ses->extended) {
-				dprintk(DEBUG_ERROR, "special files without extended mode\n");
+				P9_DPRINTK(P9_DEBUG_ERROR, "special files without extended mode\n");
 				return ERR_PTR(-EINVAL);
 			}
 			init_special_inode(inode, inode->i_mode,
@@ -227,7 +225,7 @@ struct inode *v9fs_get_inode(struct super_block
*sb, int mode)
 			break;
 		case S_IFLNK:
 			if(!v9ses->extended) {
-				dprintk(DEBUG_ERROR, "extended modes used w/o 9P2000.u\n");
+				P9_DPRINTK(P9_DEBUG_ERROR, "extended modes used w/o 9P2000.u\n");
 				return ERR_PTR(-EINVAL);
 			}
 			inode->i_op = &v9fs_symlink_inode_operations;
@@ -241,12 +239,12 @@ struct inode *v9fs_get_inode(struct super_block
*sb, int mode)
 			inode->i_fop = &v9fs_dir_operations;
 			break;
 		default:
-			dprintk(DEBUG_ERROR, "BAD mode 0x%x S_IFMT 0x%x\n",
+			P9_DPRINTK(P9_DEBUG_ERROR, "BAD mode 0x%x S_IFMT 0x%x\n",
 				mode, mode & S_IFMT);
 			return ERR_PTR(-EINVAL);
 		}
 	} else {
-		eprintk(KERN_WARNING, "Problem allocating inode\n");
+		P9_EPRINTK(KERN_WARNING, "Problem allocating inode\n");
 		return ERR_PTR(-ENOMEM);
 	}
 	return inode;
@@ -254,22 +252,22 @@ struct inode *v9fs_get_inode(struct super_block
*sb, int mode)

 static int
 v9fs_create(struct v9fs_session_info *v9ses, u32 pfid, char *name, u32 perm,
-	u8 mode, char *extension, u32 *fidp, struct v9fs_qid *qid, u32 *iounit)
+	u8 mode, char *extension, u32 *fidp, struct p9_qid *qid, u32 *iounit)
 {
 	int fid;
 	int err;
-	struct v9fs_fcall *fcall;
+	struct p9_fcall *fcall;

-	fid = v9fs_get_idpool(&v9ses->fidpool);
+	fid = p9_idpool_get(v9ses->fidpool);
 	if (fid < 0) {
-		eprintk(KERN_WARNING, "no free fids available\n");
+		P9_EPRINTK(KERN_WARNING, "no free fids available\n");
 		return -ENOSPC;
 	}

 	err = v9fs_t_walk(v9ses, pfid, fid, NULL, &fcall);
 	if (err < 0) {
 		PRINT_FCALL_ERROR("clone error", fcall);
-		if (fcall && fcall->id == RWALK)
+		if (fcall && fcall->id == P9_RWALK)
 			goto clunk_fid;
 		else
 			goto put_fid;
@@ -296,11 +294,11 @@ v9fs_create(struct v9fs_session_info *v9ses, u32
pfid, char *name, u32 perm,

 clunk_fid:
 	v9fs_t_clunk(v9ses, fid);
-	fid = V9FS_NOFID;
+	fid = P9_NOFID;

 put_fid:
-	if (fid != V9FS_NOFID)
-		v9fs_put_idpool(fid, &v9ses->fidpool);
+	if (fid != P9_NOFID)
+		p9_idpool_put(fid, v9ses->fidpool);

 	kfree(fcall);
 	return err;
@@ -312,11 +310,11 @@ v9fs_clone_walk(struct v9fs_session_info *v9ses,
u32 fid, struct dentry *dentry)
 	int err;
 	int nfid;
 	struct v9fs_fid *ret;
-	struct v9fs_fcall *fcall;
+	struct p9_fcall *fcall;

-	nfid = v9fs_get_idpool(&v9ses->fidpool);
+	nfid = p9_idpool_get(v9ses->fidpool);
 	if (nfid < 0) {
-		eprintk(KERN_WARNING, "no free fids available\n");
+		P9_EPRINTK(KERN_WARNING, "no free fids available\n");
 		return ERR_PTR(-ENOSPC);
 	}

@@ -324,11 +322,11 @@ v9fs_clone_walk(struct v9fs_session_info *v9ses,
u32 fid, struct dentry *dentry)
 		&fcall);

 	if (err < 0) {
-		if (fcall && fcall->id == RWALK)
+		if (fcall && fcall->id == P9_RWALK)
 			goto clunk_fid;

 		PRINT_FCALL_ERROR("walk error", fcall);
-		v9fs_put_idpool(nfid, &v9ses->fidpool);
+		p9_idpool_put(nfid, v9ses->fidpool);
 		goto error;
 	}

@@ -362,7 +360,7 @@ v9fs_inode_from_fid(struct v9fs_session_info
*v9ses, u32 fid,
 {
 	int err, umode;
 	struct inode *ret;
-	struct v9fs_fcall *fcall;
+	struct p9_fcall *fcall;

 	ret = NULL;
 	err = v9fs_t_stat(v9ses, fid, &fcall);
@@ -401,7 +399,7 @@ error:

 static int v9fs_remove(struct inode *dir, struct dentry *file, int rmdir)
 {
-	struct v9fs_fcall *fcall = NULL;
+	struct p9_fcall *fcall = NULL;
 	struct super_block *sb = NULL;
 	struct v9fs_session_info *v9ses = NULL;
 	struct v9fs_fid *v9fid = NULL;
@@ -409,7 +407,7 @@ static int v9fs_remove(struct inode *dir, struct
dentry *file, int rmdir)
 	int fid = -1;
 	int result = 0;

-	dprintk(DEBUG_VFS, "inode: %p dentry: %p rmdir: %d\n", dir, file,
+	P9_DPRINTK(P9_DEBUG_VFS, "inode: %p dentry: %p rmdir: %d\n", dir, file,
 		rmdir);

 	file_inode = file->d_inode;
@@ -421,7 +419,7 @@ static int v9fs_remove(struct inode *dir, struct
dentry *file, int rmdir)

 	fid = v9fid->fid;
 	if (fid < 0) {
-		dprintk(DEBUG_ERROR, "inode #%lu, no fid!\n",
+		P9_DPRINTK(P9_DEBUG_ERROR, "inode #%lu, no fid!\n",
 			file_inode->i_ino);
 		return -EBADF;
 	}
@@ -432,7 +430,7 @@ static int v9fs_remove(struct inode *dir, struct
dentry *file, int rmdir)
 		goto Error;
 	}

-	v9fs_put_idpool(fid, &v9ses->fidpool);
+	p9_idpool_put(fid, v9ses->fidpool);
 	v9fs_fid_destroy(v9fid);

 Error:
@@ -465,7 +463,7 @@ v9fs_vfs_create(struct inode *dir, struct dentry
*dentry, int mode,
 	struct v9fs_session_info *v9ses;
 	struct v9fs_fid *dfid, *vfid, *ffid;
 	struct inode *inode;
-	struct v9fs_qid qid;
+	struct p9_qid qid;
 	struct file *filp;

 	inode = NULL;
@@ -569,10 +567,10 @@ static int v9fs_vfs_mkdir(struct inode *dir,
struct dentry *dentry, int mode)
 	perm = unixmode2p9mode(v9ses, mode | S_IFDIR);

 	err = v9fs_create(v9ses, dfid->fid, (char *) dentry->d_name.name,
-		perm, V9FS_OREAD, NULL, &fid, NULL, NULL);
+		perm, P9_OREAD, NULL, &fid, NULL, NULL);

 	if (err) {
-		dprintk(DEBUG_ERROR, "create error %d\n", err);
+		P9_DPRINTK(P9_DEBUG_ERROR, "create error %d\n", err);
 		goto clean_up_dfid;
 	}

@@ -622,12 +620,12 @@ static struct dentry *v9fs_vfs_lookup(struct
inode *dir, struct dentry *dentry,
 	struct v9fs_fid *dirfid;
 	struct v9fs_fid *fid;
 	struct inode *inode;
-	struct v9fs_fcall *fcall = NULL;
+	struct p9_fcall *fcall = NULL;
 	int dirfidnum = -1;
 	int newfid = -1;
 	int result = 0;

-	dprintk(DEBUG_VFS, "dir: %p dentry: (%s) %p nameidata: %p\n",
+	P9_DPRINTK(P9_DEBUG_VFS, "dir: %p dentry: (%s) %p nameidata: %p\n",
 		dir, dentry->d_name.name, dentry, nameidata);

 	sb = dir->i_sb;
@@ -639,9 +637,9 @@ static struct dentry *v9fs_vfs_lookup(struct inode
*dir, struct dentry *dentry,

 	dirfidnum = dirfid->fid;

-	newfid = v9fs_get_idpool(&v9ses->fidpool);
+	newfid = p9_idpool_get(v9ses->fidpool);
 	if (newfid < 0) {
-		eprintk(KERN_WARNING, "newfid fails!\n");
+		P9_EPRINTK(KERN_WARNING, "newfid fails!\n");
 		result = -ENOSPC;
 		goto Release_Dirfid;
 	}
@@ -652,27 +650,27 @@ static struct dentry *v9fs_vfs_lookup(struct
inode *dir, struct dentry *dentry,
 	up(&dirfid->lock);

 	if (result < 0) {
-		if (fcall && fcall->id == RWALK)
+		if (fcall && fcall->id == P9_RWALK)
 			v9fs_t_clunk(v9ses, newfid);
 		else
-			v9fs_put_idpool(newfid, &v9ses->fidpool);
+			p9_idpool_put(newfid, v9ses->fidpool);

 		if (result == -ENOENT) {
 			d_add(dentry, NULL);
-			dprintk(DEBUG_VFS,
+			P9_DPRINTK(P9_DEBUG_VFS,
 				"Return negative dentry %p count %d\n",
 				dentry, atomic_read(&dentry->d_count));
 			kfree(fcall);
 			return NULL;
 		}
-		dprintk(DEBUG_ERROR, "walk error:%d\n", result);
+		P9_DPRINTK(P9_DEBUG_ERROR, "walk error:%d\n", result);
 		goto FreeFcall;
 	}
 	kfree(fcall);

 	result = v9fs_t_stat(v9ses, newfid, &fcall);
 	if (result < 0) {
-		dprintk(DEBUG_ERROR, "stat error\n");
+		P9_DPRINTK(P9_DEBUG_ERROR, "stat error\n");
 		goto FreeFcall;
 	}

@@ -680,7 +678,7 @@ static struct dentry *v9fs_vfs_lookup(struct inode
*dir, struct dentry *dentry,
 		fcall->params.rstat.stat.mode));

 	if (IS_ERR(inode) && (PTR_ERR(inode) == -ENOSPC)) {
-		eprintk(KERN_WARNING, "inode alloc failes, returns %ld\n",
+		P9_EPRINTK(KERN_WARNING, "inode alloc failes, returns %ld\n",
 			PTR_ERR(inode));

 		result = -ENOSPC;
@@ -691,7 +689,7 @@ static struct dentry *v9fs_vfs_lookup(struct inode
*dir, struct dentry *dentry,

 	fid = v9fs_fid_create(v9ses, newfid);
 	if (fid == NULL) {
-		dprintk(DEBUG_ERROR, "couldn't insert\n");
+		P9_DPRINTK(P9_DEBUG_ERROR, "couldn't insert\n");
 		result = -ENOMEM;
 		goto FreeFcall;
 	}
@@ -763,14 +761,14 @@ v9fs_vfs_rename(struct inode *old_dir, struct
dentry *old_dentry,
 	struct v9fs_fid *oldfid = v9fs_fid_lookup(old_dentry);
 	struct v9fs_fid *olddirfid;
 	struct v9fs_fid *newdirfid;
-	struct v9fs_wstat wstat;
-	struct v9fs_fcall *fcall = NULL;
+	struct p9_wstat wstat;
+	struct p9_fcall *fcall = NULL;
 	int fid = -1;
 	int olddirfidnum = -1;
 	int newdirfidnum = -1;
 	int retval = 0;

-	dprintk(DEBUG_VFS, "\n");
+	P9_DPRINTK(P9_DEBUG_VFS, "\n");

 	if(IS_ERR(oldfid))
 		return PTR_ERR(oldfid);
@@ -789,7 +787,7 @@ v9fs_vfs_rename(struct inode *old_dir, struct
dentry *old_dentry,

 	/* 9P can only handle file rename in the same directory */
 	if (memcmp(&olddirfid->qid, &newdirfid->qid, sizeof(newdirfid->qid))) {
-		dprintk(DEBUG_ERROR, "old dir and new dir are different\n");
+		P9_DPRINTK(P9_DEBUG_ERROR, "old dir and new dir are different\n");
 		retval = -EXDEV;
 		goto Clunk_newdir;
 	}
@@ -799,7 +797,7 @@ v9fs_vfs_rename(struct inode *old_dir, struct
dentry *old_dentry,
 	newdirfidnum = newdirfid->fid;

 	if (fid < 0) {
-		dprintk(DEBUG_ERROR, "no fid for old file #%lu\n",
+		P9_DPRINTK(P9_DEBUG_ERROR, "no fid for old file #%lu\n",
 			old_inode->i_ino);
 		retval = -EBADF;
 		goto Clunk_newdir;
@@ -840,19 +838,19 @@ static int
 v9fs_vfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		 struct kstat *stat)
 {
-	struct v9fs_fcall *fcall = NULL;
+	struct p9_fcall *fcall = NULL;
 	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(dentry->d_inode);
 	struct v9fs_fid *fid = v9fs_fid_clone(dentry);
 	int err = -EPERM;

-	dprintk(DEBUG_VFS, "dentry: %p\n", dentry);
+	P9_DPRINTK(P9_DEBUG_VFS, "dentry: %p\n", dentry);
 	if(IS_ERR(fid))
 		return PTR_ERR(fid);

 	err = v9fs_t_stat(v9ses, fid->fid, &fcall);

 	if (err < 0)
-		dprintk(DEBUG_ERROR, "stat error\n");
+		P9_DPRINTK(P9_DEBUG_ERROR, "stat error\n");
 	else {
 		v9fs_stat2inode(&fcall->params.rstat.stat, dentry->d_inode,
 				  dentry->d_inode->i_sb);
@@ -875,11 +873,11 @@ static int v9fs_vfs_setattr(struct dentry
*dentry, struct iattr *iattr)
 {
 	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(dentry->d_inode);
 	struct v9fs_fid *fid = v9fs_fid_clone(dentry);
-	struct v9fs_fcall *fcall = NULL;
-	struct v9fs_wstat wstat;
+	struct p9_fcall *fcall = NULL;
+	struct p9_wstat wstat;
 	int res = -EPERM;

-	dprintk(DEBUG_VFS, "\n");
+	P9_DPRINTK(P9_DEBUG_VFS, "\n");
 	if(IS_ERR(fid))
 		return PTR_ERR(fid);

@@ -926,7 +924,7 @@ static int v9fs_vfs_setattr(struct dentry *dentry,
struct iattr *iattr)
  */

 void
-v9fs_stat2inode(struct v9fs_stat *stat, struct inode *inode,
+v9fs_stat2inode(struct p9_stat *stat, struct inode *inode,
 	struct super_block *sb)
 {
 	int n;
@@ -967,7 +965,7 @@ v9fs_stat2inode(struct v9fs_stat *stat, struct inode *inode,
 		case 'b':
 			break;
 		default:
-			dprintk(DEBUG_ERROR, "Unknown special type %c (%.*s)\n",
+			P9_DPRINTK(P9_DEBUG_ERROR, "Unknown special type %c (%.*s)\n",
 				type, stat->extension.len, stat->extension.str);
 		};
 		inode->i_rdev = MKDEV(major, minor);
@@ -987,7 +985,7 @@ v9fs_stat2inode(struct v9fs_stat *stat, struct inode *inode,
  * BUG: potential for inode number collisions?
  */

-ino_t v9fs_qid2ino(struct v9fs_qid *qid)
+ino_t v9fs_qid2ino(struct p9_qid *qid)
 {
 	u64 path = qid->path + 2;
 	ino_t i = 0;
@@ -1012,7 +1010,7 @@ static int v9fs_readlink(struct dentry *dentry,
char *buffer, int buflen)
 {
 	int retval = -EPERM;

-	struct v9fs_fcall *fcall = NULL;
+	struct p9_fcall *fcall = NULL;
 	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(dentry->d_inode);
 	struct v9fs_fid *fid = v9fs_fid_clone(dentry);

@@ -1021,15 +1019,15 @@ static int v9fs_readlink(struct dentry
*dentry, char *buffer, int buflen)

 	if (!v9ses->extended) {
 		retval = -EBADF;
-		dprintk(DEBUG_ERROR, "not extended\n");
+		P9_DPRINTK(P9_DEBUG_ERROR, "not extended\n");
 		goto ClunkFid;
 	}

-	dprintk(DEBUG_VFS, " %s\n", dentry->d_name.name);
+	P9_DPRINTK(P9_DEBUG_VFS, " %s\n", dentry->d_name.name);
 	retval = v9fs_t_stat(v9ses, fid->fid, &fcall);

 	if (retval < 0) {
-		dprintk(DEBUG_ERROR, "stat error\n");
+		P9_DPRINTK(P9_DEBUG_ERROR, "stat error\n");
 		goto FreeFcall;
 	}

@@ -1038,7 +1036,7 @@ static int v9fs_readlink(struct dentry *dentry,
char *buffer, int buflen)
 		goto ClunkFid;
 	}

-	if (!(fcall->params.rstat.stat.mode & V9FS_DMSYMLINK)) {
+	if (!(fcall->params.rstat.stat.mode & P9_DMSYMLINK)) {
 		retval = -EINVAL;
 		goto FreeFcall;
 	}
@@ -1050,7 +1048,7 @@ static int v9fs_readlink(struct dentry *dentry,
char *buffer, int buflen)
 	memmove(buffer, fcall->params.rstat.stat.extension.str, buflen - 1);
 	buffer[buflen-1] = 0;

-	dprintk(DEBUG_ERROR, "%s -> %.*s (%s)\n", dentry->d_name.name,
fcall->params.rstat.stat.extension.len,
+	P9_DPRINTK(P9_DEBUG_ERROR, "%s -> %.*s (%s)\n", dentry->d_name.name,
fcall->params.rstat.stat.extension.len,
 		fcall->params.rstat.stat.extension.str, buffer);
 	retval = buflen;

@@ -1084,13 +1082,13 @@ static int v9fs_vfs_readlink(struct dentry
*dentry, char __user * buffer,
 	if (buflen > PATH_MAX)
 		buflen = PATH_MAX;

-	dprintk(DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);
+	P9_DPRINTK(P9_DEBUG_VFS, " dentry: %s (%p)\n", dentry->d_iname, dentry);

 	retval = v9fs_readlink(dentry, link, buflen);

 	if (retval > 0) {
 		if ((ret = copy_to_user(buffer, link, retval)) != 0) {
-			dprintk(DEBUG_ERROR, "problem copying to user: %d\n",
+			P9_DPRINTK(P9_DEBUG_ERROR, "problem copying to user: %d\n",
 				ret);
 			retval = ret;
 		}
@@ -1112,7 +1110,7 @@ static void *v9fs_vfs_follow_link(struct dentry
*dentry, struct nameidata *nd)
 	int len = 0;
 	char *link = __getname();

-	dprintk(DEBUG_VFS, "%s n", dentry->d_name.name);
+	P9_DPRINTK(P9_DEBUG_VFS, "%s n", dentry->d_name.name);

 	if (!link)
 		link = ERR_PTR(-ENOMEM);
@@ -1141,7 +1139,7 @@ static void v9fs_vfs_put_link(struct dentry
*dentry, struct nameidata *nd, void
 {
 	char *s = nd_get_link(nd);

-	dprintk(DEBUG_VFS, " %s %s\n", dentry->d_name.name, s);
+	P9_DPRINTK(P9_DEBUG_VFS, " %s %s\n", dentry->d_name.name, s);
 	if (!IS_ERR(s))
 		__putname(s);
 }
@@ -1157,7 +1155,7 @@ static int v9fs_vfs_mkspecial(struct inode *dir,
struct dentry *dentry,

 	v9ses = v9fs_inode2v9ses(dir);
 	if (!v9ses->extended) {
-		dprintk(DEBUG_ERROR, "not extended\n");
+		P9_DPRINTK(P9_DEBUG_ERROR, "not extended\n");
 		return -EPERM;
 	}

@@ -1170,7 +1168,7 @@ static int v9fs_vfs_mkspecial(struct inode *dir,
struct dentry *dentry,
 	perm = unixmode2p9mode(v9ses, mode);

 	err = v9fs_create(v9ses, dfid->fid, (char *) dentry->d_name.name,
-		perm, V9FS_OREAD, (char *) extension, &fid, NULL, NULL);
+		perm, P9_OREAD, (char *) extension, &fid, NULL, NULL);

 	if (err)
 		goto clunk_dfid;
@@ -1224,7 +1222,7 @@ error:
 static int
 v9fs_vfs_symlink(struct inode *dir, struct dentry *dentry, const char *symname)
 {
-	dprintk(DEBUG_VFS, " %lu,%s,%s\n", dir->i_ino, dentry->d_name.name,
+	P9_DPRINTK(P9_DEBUG_VFS, " %lu,%s,%s\n", dir->i_ino, dentry->d_name.name,
 		symname);

 	return v9fs_vfs_mkspecial(dir, dentry, S_IFLNK, symname);
@@ -1251,7 +1249,7 @@ v9fs_vfs_link(struct dentry *old_dentry, struct
inode *dir,
 	struct v9fs_fid *oldfid;
 	char *name;

-	dprintk(DEBUG_VFS, " %lu,%s,%s\n", dir->i_ino, dentry->d_name.name,
+	P9_DPRINTK(P9_DEBUG_VFS, " %lu,%s,%s\n", dir->i_ino, dentry->d_name.name,
 		old_dentry->d_name.name);

 	oldfid = v9fs_fid_clone(old_dentry);
@@ -1265,7 +1263,7 @@ v9fs_vfs_link(struct dentry *old_dentry, struct
inode *dir,
 	}

 	sprintf(name, "%d\n", oldfid->fid);
-	retval = v9fs_vfs_mkspecial(dir, dentry, V9FS_DMLINK, name);
+	retval = v9fs_vfs_mkspecial(dir, dentry, P9_DMLINK, name);
 	__putname(name);

 clunk_fid:
@@ -1288,7 +1286,7 @@ v9fs_vfs_mknod(struct inode *dir, struct dentry
*dentry, int mode, dev_t rdev)
 	int retval;
 	char *name;

-	dprintk(DEBUG_VFS, " %lu,%s mode: %x MAJOR: %u MINOR: %u\n", dir->i_ino,
+	P9_DPRINTK(P9_DEBUG_VFS, " %lu,%s mode: %x MAJOR: %u MINOR: %u\n", dir->i_ino,
 		dentry->d_name.name, mode, MAJOR(rdev), MINOR(rdev));

 	if (!new_valid_dev(rdev))
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 0ec42f6..68d9e4a 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -37,10 +37,8 @@
 #include <linux/seq_file.h>
 #include <linux/mount.h>
 #include <linux/idr.h>
-
-#include "debug.h"
-#include "v9fs.h"
 #include "9p.h"
+#include "v9fs.h"
 #include "v9fs_vfs.h"
 #include "fid.h"

@@ -107,7 +105,7 @@ static int v9fs_get_sb(struct file_system_type
*fs_type, int flags,
 		       struct vfsmount *mnt)
 {
 	struct super_block *sb = NULL;
-	struct v9fs_fcall *fcall = NULL;
+	struct p9_fcall *fcall = NULL;
 	struct inode *inode = NULL;
 	struct dentry *root = NULL;
 	struct v9fs_session_info *v9ses = NULL;
@@ -119,14 +117,14 @@ static int v9fs_get_sb(struct file_system_type
*fs_type, int flags,
 	int newfid = 0;
 	int retval = 0;

-	dprintk(DEBUG_VFS, " \n");
+	P9_DPRINTK(P9_DEBUG_VFS, " \n");

 	v9ses = kzalloc(sizeof(struct v9fs_session_info), GFP_KERNEL);
 	if (!v9ses)
 		return -ENOMEM;

 	if ((newfid = v9fs_session_init(v9ses, dev_name, data)) < 0) {
-		dprintk(DEBUG_ERROR, "problem initiating session\n");
+		P9_DPRINTK(P9_DEBUG_ERROR, "problem initiating session\n");
 		retval = newfid;
 		goto out_free_session;
 	}
@@ -157,7 +155,7 @@ static int v9fs_get_sb(struct file_system_type
*fs_type, int flags,

 	stat_result = v9fs_t_stat(v9ses, newfid, &fcall);
 	if (stat_result < 0) {
-		dprintk(DEBUG_ERROR, "stat error\n");
+		P9_DPRINTK(P9_DEBUG_ERROR, "stat error\n");
 		v9fs_t_clunk(v9ses, newfid);
 	} else {
 		/* Setup the Root Inode */
@@ -211,7 +209,7 @@ static void v9fs_kill_super(struct super_block *s)
 {
 	struct v9fs_session_info *v9ses = s->s_fs_info;

-	dprintk(DEBUG_VFS, " %p\n", s);
+	P9_DPRINTK(P9_DEBUG_VFS, " %p\n", s);

 	v9fs_dentry_release(s->s_root);	/* clunk root */

@@ -219,7 +217,7 @@ static void v9fs_kill_super(struct super_block *s)

 	v9fs_session_close(v9ses);
 	kfree(v9ses);
-	dprintk(DEBUG_VFS, "exiting kill_super\n");
+	P9_DPRINTK(P9_DEBUG_VFS, "exiting kill_super\n");
 }

 /**
-- 
1.4.4.2
