Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbXKEOQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbXKEOQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 09:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754986AbXKEOP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 09:15:57 -0500
Received: from ag-out-0708.google.com ([72.14.246.242]:35377 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbXKEOP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 09:15:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent;
        b=exHaPhtIILoNWfvClxTe/Iu08Fyf3dhuBc/t+QLA0IQQs8ROBg9IO+gERAEgbEL9ySx9hHCXZjS1ez+n8XNIyPsAYMUHoAnwveEz+Loo0DPfjIdQXLaqDW/lbHUBiE2U7m0EH2C0UpQEAl80par6DHWyjll63jb2WA98WOMqiZQ=
Date: Mon, 5 Nov 2007 22:14:42 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: jdike@karaya.com, Andrew Morton <akpm@osdl.org>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [git Patch] UML: More varied improvements
Message-ID: <20071105141442.GB8245@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, Jeff!

This patch also does some improvements for uml code. Improvements include
dropping unnecessary cast, killing some unnecessary code and still some
constifying for pointers etc..

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Jeff Dike <jdike@karaya.com>

---
 arch/um/drivers/ubd_kern.c             |    6 +++---
 arch/um/include/kern_util.h            |    2 +-
 arch/um/kernel/mem.c                   |    2 +-
 arch/um/kernel/process.c               |    4 +---
 arch/um/os-Linux/drivers/tuntap_user.c |    2 +-
 arch/um/os-Linux/mem.c                 |    7 ++++---
 arch/um/os-Linux/sigio.c               |    2 +-
 7 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index e184b44..7b3271d 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -229,7 +229,7 @@ static int proc_ide_read_media(char *page, char **start, off_t off, int count,
 	return len;
 }
 
-static void make_ide_entries(char *dev_name)
+static void make_ide_entries(const char *dev_name)
 {
 	struct proc_dir_entry *dir, *ent;
 	char name[64];
@@ -244,7 +244,7 @@ static void make_ide_entries(char *dev_name)
 	ent->data = NULL;
 	ent->read_proc = proc_ide_read_media;
 	ent->write_proc = NULL;
-	sprintf(name,"ide0/%s", dev_name);
+	snprintf(name, sizeof(name), "ide0/%s", dev_name);
 	proc_symlink(dev_name, proc_ide_root, name);
 }
 
@@ -440,7 +440,7 @@ __uml_help(ubd_setup,
 "    an 's' will cause data to be written to disk on the host immediately.\n\n"
 );
 
-static int udb_setup(char *str)
+static int udb_setup(const char *str)
 {
 	printk("udb%s specified on command line is almost certainly a ubd -> "
 	       "udb TYPO\n", str);
diff --git a/arch/um/include/kern_util.h b/arch/um/include/kern_util.h
index 74ce8e5..aa27eb0 100644
--- a/arch/um/include/kern_util.h
+++ b/arch/um/include/kern_util.h
@@ -81,7 +81,7 @@ extern void do_uml_exitcalls(void);
 extern int attach_debugger(int idle_pid, int pid, int stop);
 extern int config_gdb(char *str);
 extern int remove_gdb(void);
-extern char *uml_strdup(char *string);
+extern char *uml_strdup(const char *string);
 extern void unprotect_kernel_mem(void);
 extern void protect_kernel_mem(void);
 extern void uml_cleanup(void);
diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 59822de..9edde52 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -65,7 +65,7 @@ static void setup_highmem(unsigned long highmem_start,
 void __init mem_init(void)
 {
 	/* clear the zero-page */
-	memset((void *) empty_zero_page, 0, PAGE_SIZE);
+	memset(empty_zero_page, 0, PAGE_SIZE);
 
 	/* Map in the area just after the brk now that kmalloc is about
 	 * to be turned on.
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 0eae00b..35849b5 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -60,8 +60,6 @@ unsigned long alloc_stack(int order, int atomic)
 	if (atomic)
 		flags = GFP_ATOMIC;
 	page = __get_free_pages(flags, order);
-	if (page == 0)
-		return 0;
 
 	return page;
 }
@@ -331,7 +329,7 @@ void do_uml_exitcalls(void)
 		(*call)();
 }
 
-char *uml_strdup(char *string)
+char *uml_strdup(const char *string)
 {
 	return kstrdup(string, GFP_KERNEL);
 }
diff --git a/arch/um/os-Linux/drivers/tuntap_user.c b/arch/um/os-Linux/drivers/tuntap_user.c
index 6c55d3c..2f0055b 100644
--- a/arch/um/os-Linux/drivers/tuntap_user.c
+++ b/arch/um/os-Linux/drivers/tuntap_user.c
@@ -148,7 +148,7 @@ static int tuntap_open(void *data)
 		memset(&ifr, 0, sizeof(ifr));
 		ifr.ifr_flags = IFF_TAP | IFF_NO_PI;
 		strlcpy(ifr.ifr_name, pri->dev_name, sizeof(ifr.ifr_name));
-		if (ioctl(pri->fd, TUNSETIFF, (void *) &ifr) < 0) {
+		if (ioctl(pri->fd, TUNSETIFF, &ifr) < 0) {
 			err = -errno;
 			printk(UM_KERN_ERR "TUNSETIFF failed, errno = %d\n",
 			       errno);
diff --git a/arch/um/os-Linux/mem.c b/arch/um/os-Linux/mem.c
index 436f8d2..ee13060 100644
--- a/arch/um/os-Linux/mem.c
+++ b/arch/um/os-Linux/mem.c
@@ -30,7 +30,7 @@ static char *tempdir = NULL;
 
 static void __init find_tempdir(void)
 {
-	char *dirs[] = { "TMP", "TEMP", "TMPDIR", NULL };
+	const char *dirs[] = { "TMP", "TEMP", "TMPDIR", NULL };
 	int i;
 	char *dir = NULL;
 
@@ -59,9 +59,10 @@ static void __init find_tempdir(void)
  * read the file as needed.  If there's an error, -errno is returned;
  * if the end of the file is reached, 0 is returned.
  */
-static int next(int fd, char *buf, int size, char c)
+static int next(int fd, char *buf, size_t size, char c)
 {
-	int n, len;
+	ssize_t n;
+	size_t len;
 	char *ptr;
 
 	while((ptr = strchr(buf, c)) == NULL){
diff --git a/arch/um/os-Linux/sigio.c b/arch/um/os-Linux/sigio.c
index dc03e9c..7243f57 100644
--- a/arch/um/os-Linux/sigio.c
+++ b/arch/um/os-Linux/sigio.c
@@ -407,7 +407,7 @@ static int async_pty(int master, int slave)
 	if((fcntl(slave, F_SETFL, flags | O_NONBLOCK) < 0))
 		return -errno;
 
-	return(0);
+	return 0;
 }
 
 static void __init check_one_sigio(void (*proc)(int, int))

