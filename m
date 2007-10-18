Return-Path: <linux-kernel-owner+w=401wt.eu-S934085AbXJRP26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934085AbXJRP26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933528AbXJRP2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:28:08 -0400
Received: from services.sin.cvut.cz ([147.32.110.2]:60175 "EHLO
	services.sin.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763867AbXJRP2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:28:04 -0400
From: Jaroslav Sykora <jara@sin.cvut.cz>
Reply-To: jaroslav.sykora@gmail.com
To: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 5/5] Shadow directories: documentation
Date: Thu, 18 Oct 2007 17:28:00 +0200
User-Agent: KMail/1.9.7
References: <200710181721.09201.jara@sin.cvut.cz>
In-Reply-To: <200710181721.09201.jara@sin.cvut.cz>
X-Face: >I|[{8s3:Ic!^A\YY'ktAfvq]K.-@B=!>(:.VX7_KNlZ@`l)vxL}2g~)k(#@=?utf-8?q?BN=24U+3MgB2=0A=097yR=5D=26tZ8PTc=3D=60?=<A%=5!.VCQ~(<-2#;/xmM4t6'MB7zDSm7i$nn/x^TC*adoyqd"{b0,=?utf-8?q?Hr=5F=0A=09?=<.yl<O}[Z[s.oX/:P917[b9QB%3f]{m=`7azOx[(.XW)"nW?N]jA5=%!<=?utf-8?q?=27ayW=5E!NQg6RcZ=0A=09vG?=@\&{XT%rV)u^hXq%ecRC;$jLBaa>ZZB_o
Cc: linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710181728.00971.jara@sin.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation of the shadow directories.

Signed-off-by: Jaroslav Sykora <jaroslav.sykora@gmail.com>

 Documentation/filesystems/shadow-directories.txt |  177 +++++++++++++
 1 file changed, 177 insertions(+)

--- /dev/null	2007-10-18 09:34:42.624413454 +0200
+++ new/Documentation/filesystems/shadow-directories.txt	2007-10-18 17:03:06.000000000 +0200
@@ -0,0 +1,177 @@
+Shadow directories
+==================
+
+The Goal
+--------
+
+Let's say we have an archive file "hello.zip" with a hello world program source
+code. We want to do this:
+	cat hello.zip^/hello.c
+
+The '^' is an escape character and it tells the computer to treat the file
+as a directory.
+[Note: We can't do "cat hello.zip/hello.c" because of http://lwn.net/Articles/100148/ ]
+
+One way to implement the scenario above is to create a FUSE VFS server and chroot
+everything into it. This will work, but poorly. The performance will be low
+and many things, like setuid binaries, won't principally work (iff the server
+doesn't have root privileges).
+
+
+The Principle
+-------------
+
+For every process we define two VFS trees:
+(1) the standard system-wide tree, managed by mount/umount, implemented by native
+	filesystems like ext3, reiserfs, etc..;
+(2) a per-process shadow tree, usually implemented by FUSE.
+
+The main change is within VFS look up code: A file name is looked up in a standard
+tree and if it's found we're done. If not the name is transparently looked up
+in a shadow tree.
+
+[Picture: A standard and a shadow tree. The shadow tree will be in fact mounted
+ on some point in the standard tree, e.g. "/home/jara/.vfs/mnt". ]
+
+         Standard                     Shadow
+           "/"                          "/"
+     ,------|-------,              ,-----|------,
+   bin    home     usr           bin   home    usr
+            |                            |
+          jara                         jara
+       ,----|-----,                 ,----|-----,-------------,
+      tmp     hello.zip           tmp      hello.zip      hello.zip^
+                                                             |
+                                                    ,---------------,
+                                                 hello.c         Makefile
+
+
+Generally speaking a shadow tree is a superset of a standard tree -- everything
+we can find in the standard tree can be found in the shadow tree.
+But the standard tree is faster (it's a native FS), so we want to take most
+of files from it and only the rest from the other tree (see the directory
+hello.zip^ in the picture above which is not in the std. tree).
+
+In a task the standard tree is primarily defined by its root directory 
+(fs_struct.root). Secondarily it's represented by current working directory 
+and by opened directory handles. To map all these directories to corresponding 
+shadow directories we add shadow root, shadow current directory and shadow 
+directories for all the opened directories (in the struct file).
+
+The user needs to set only the shadow root directory for his/her login shell. The
+settings will be inherited by all child processes. Although we provide a system
+call to set up shadow current directory (SHDW_FD_PWD, bellow) and shadow directories
+of opened directories (@@fd>=0 bellow), this information can be automatically
+deduced from the standard directories.
+
+Example 1: See the picture above:
+A process has root=/ and pwd=/home/jara. The user's FUSE VFS server is mounted
+on "/home/jara/.vfs/mnt". We setup shadow root directory of the process with
+a system call:
+	setshdwpath(pid, SHDW_FD_ROOT, "/home/jara/.vfs/mnt");
+The kernel knows that pwd=/home/jara, so it can deduce that shadow pwd will
+be "/home/jara/.vfs/mnt/home/jara" (absolute path).
+
+
+The Escape Character Mode
+-------------------------
+
+As has been said above a file name look-up is now a two stage process: first
+we try to look-up the name in the standard tree and if we fail we try in the
+shadow tree. The problem is that there are hundreds of failed lookups on
+normal session start -- a few dozen per every starting process. All these
+bogus lookups will make it to the shadow root and will be processes by the user
+space VFS server implemented in FUSE. The lookups will be rejected and everything
+works as usuall but it's slow.
+
+To speed things up and to be practical we define an _escape character_. It's
+simply any character which can be used in a file name but which isn't used
+very often -- like '#' or '^'. We choose the '^' in this document.
+
+The escape character is loaded by the system call described bellow. All the
+lookups going to the shadow tree are filtered against the escape character.
+The VFS look-up procedure is thus:
+	1. a component of the path (a name) is looked up in the standard tree.
+	   If it's found, we're done.
+	2. if the escape character mode is enabled the name is checked if it
+	   contains the escape character. If not the file was not found.
+	3. the name is looked up in the shadow tree.
+
+
+Example 2: settings as in the ex.1:
+The user wants to read the file hello.c in the archive hello.zip in his
+home directory [see picture above]. The escape character is '^': He will do:
+	cat hello.zip^/hello.c
+The name "hello.zip^" will be looked up in the pwd=/home/jara and won't be found.
+The component contains the escape character '^' so it gets a second chance
+and will be looked up in the shadow pwd=/home/jara/.vfs/mnt/home/jara.
+The next component of the path (hello.c in this example) is looked up
+starting from the point where previous finished, so it will be found right
+in the first step of the two stage look-up process.
+
+
+
+The Syscalls
+------------
+
+Synopsis
+
+int getshdwinfo(int pid, int func, int *data);
+int setshdwinfo(int pid, int func, int data);
+int setshdwpath(int pid, int fd, const char *path);
+
+
+/* functions (parameter @func) */
+#define FSI_SHDW_ENABLE		1	/* enable shadow directories */
+#define FSI_SHDW_ESC_EN		2	/* enable use of escape character */
+#define FSI_SHDW_ESC_CHAR	3	/* specify escape character */
+
+/* pseudo file descriptors (parameter @fd) */
+#define SHDW_FD_ROOT		-1	/* pseudo FD for root shadow dir */
+#define SHDW_FD_PWD		-2	/* pseudo FD for pwd shadow dir */
+
+Description
+
+getshdwinfo() reads attributes of process @pid regarding shadow directories
+into @data, while setshdwinfo() sets the attributes.
+setshdwpath() sets path of shadow directory for a file descriptor,
+root directory or working directory of process @pid.
+
+@pid is the PID of the target process. The special value of 0 means 'current process'.
+Thus getshdwinfo(0, ...) is equivalent to getshdwinfo(getpid(), ...).
+
+@func determines the attribute being read or written. It may be:
+	FSI_SHDW_ENABLE -- shadow directories for the process are enabled
+			   iff @data != 0
+	FSI_SHDW_ESC_EN -- the escape character is used iff @data != 0
+			   (escape mode enabled)
+	FSI_SHDW_ESC_CHAR -- the @data specifies ASCII character used in the escape mode
+
+@fd is a file descriptor number in the target process whose shadow directory
+is being set. It may be:
+	@fd >= 0  -- a file descriptor number
+	SHDW_FD_ROOT -- the root directory
+	SHDW_FD_PWD -- the working directory
+
+@path is the path to the directory. May be NULL in which case:
+	(a) if @func==SHDW_FD_ROOT -- the shadow directories will be switched off;
+	(b) else try to deduce the path from the standard path and shadow root
+	    on demand.
+
+
+Return value
+
+On success zero is returned. On failure the negative error code is returned.
+
+
+Errors
+
+EINVAL -- Parameter is invalid: @func out of range.
+ESRCH -- Process @pid not found.
+EPERM -- Access to process @pid is denied.
+EFAULT -- Bad pointer @data or @path.
+EBADF -- File descriptor @fd does not exist.
+EACCES -- Access to VFS path @path denied.
+ENOENT -- VFS path @path does not exist.
+ENOTDIR -- VFS path @path points to non-directory object.
+
