Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbYFMO3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbYFMO3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 10:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758074AbYFMO3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 10:29:22 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:50455 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757585AbYFMO3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 10:29:20 -0400
Message-ID: <48528438.7070401@de.ibm.com>
Date: Fri, 13 Jun 2008 16:29:12 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Peter Oberparleiter <oberparleiter@googlemail.com>,
       ltp-coverage@lists.sourceforge.net, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] gcov kernel support
References: <4843F6BF.9070409@de.ibm.com>	<20080609002509.7782442e.akpm@linux-foundation.org>	<484D34DC.40401@de.ibm.com>	<20080609120954.7d41a5bf.akpm@linux-foundation.org>	<484FCC4A.1010605@de.ibm.com> <20080611132227.593b13ea.akpm@linux-foundation.org>
In-Reply-To: <20080611132227.593b13ea.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 11 Jun 2008 14:59:54 +0200
> Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:
> 
>> Andrew Morton wrote:
>> > On Mon, 09 Jun 2008 15:49:16 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:
>> > 
>> >> Andrew Morton wrote:
>> >> > On Mon, 02 Jun 2008 15:33:51 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:
>> >> > 
>> >> >> This is version #3 of the gcov kernel support patch set 
>> >> > 
>> >> > My build tree is now filled with dead symlinks, like
>> >> > 
>> >> > lrwxrwxrwx 1 akpm akpm 64 Jun  9 00:06 security/selinux/nlmsgtab.gcda -> /sys/kernel/debug/gcov/usr/src/25/security/selinux/nlmsgtab.gcda
>> >> 
>> >> Unfortunately a necessary evil of this approach: symlinks are created
>> >> for all compiled source files while link targets are only available when
>> >> the corresponding code is executed. In other words: those links will be
>> >> dead for source files which don't compile to actual code and for modules
>> >> as long as they are not loaded.
>> > 
>> > It doesn't seem awfully useful.  I don't run kernels on my build
>> > machines and I'm sure many are in the same situation.  So gcov is going
>> > to need a way of locating these files on the *target* machine.  And
>> > once that is available, there is no need to add all these symlinks into
>> > the build directory.
>> 
>> I don't see any other feasibly way to do it if we want the kernel to
>> work out-of-the-box with gcov. If the kernel was a user-space
>> application, gcc/libgcov would create the .gcda files in exactly the
>> same place where the symbolic links are now.
>> 
>> If we removed those symlinks, users would have to manually copy files
>> from /sys on the test machine to the correct position in /objtree on the
>> build machine before being able to get any kind of result. This would
>> IMO reduce the usefulness of the gcov kernel infrastructure noticeably
>> (though gcov-wrappers such as lcov could be modified to hide the
>> additional effort).
> 
> gcov needs both the .gcda files and the source tree available to do its
> work, I assume.
> 
> So a sensible scenario would be to copy the entire build tree,
> including the .gcda symlinks over to the target system, yes? 
> tar+scp+untar?
> 
> If so, it'd be good to get that tested and documented...

I followed your advice and did some more testing and found that
a) dead links are *really* (really) bothersome
b) CONFIG_MODVERSIONS=y breaks the current approach

The latter is not directly related to this link business but due to the
kbuild simplification patch being nacked by Sam Ravnborg (unlike my
initial assumption, the patch was still required by gcov).

To get to the point: I reworked the gcov approach again (I'm starting to
feel bad about the amount of changes, but - hey..). The result:
* no symbolic links needed in the build directory
* gcov plays nicely with CONFIG_MODVERSIONS=y
* a recommended approach for "gcov + separated test/build" is
  documented in Documentation/gcov.txt

All this comes as a patch against the code introduced by
gcov-add-gcov-profiling-infrastructure.patch (-mm3). If needed, I can
also merge the changes into the old patch and post that one (whatever
suits you best).

For -mm, please:
* drop gcov-create-links-to-gcda-files-in-build-directory.patch
* add this patch anywhere after
  gcov-add-gcov-profiling-infrastructure.patch

--
[PATCH] gcov: revert link changes

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Change the gcov mechanism back to using symbolic links in sysfs. This is
necessary to fix problems when profiling with CONFIG_MODVERSIONS=y.
The correct usage of the gcov tool now looks like this:

  # cd $OBJTREE
  # gcov -o /sys/kernel/debug/gcov/$OBJTREE/init main.c

Also update documentation to include a description on how to use gcov
profiling in a separated build/test machine environment.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
---
 Documentation/gcov.txt |  138 ++++++++++++++++++++++++++++++++++++-----
 kernel/gcov/Makefile   |    2 
 kernel/gcov/fs.c       |  123 +++++++++++++++++++++++++++++++++++-
 kernel/gcov/gcc_3_4.c  |    6 +
 kernel/gcov/gcov.h     |    9 ++
 5 files changed, 262 insertions(+), 16 deletions(-)

Index: linux-2.6.26-rc5-mm3/Documentation/gcov.txt
===================================================================
--- linux-2.6.26-rc5-mm3.orig/Documentation/gcov.txt
+++ linux-2.6.26-rc5-mm3/Documentation/gcov.txt
@@ -6,7 +6,10 @@ Using gcov with the Linux kernel
 3. Customization
 4. Files
 5. Modules
-6. Troubleshooting
+6. Separated build and test machines
+7. Troubleshooting
+Appendix A: sample script: gather_on_build.sh
+Appendix B: sample script: gather_on_test.sh
 
 
 1. Introduction
@@ -15,16 +18,11 @@ Using gcov with the Linux kernel
 gcov profiling kernel support enables the use of GCC's coverage testing
 tool gcov [1] with the Linux kernel. Coverage data of a running kernel
 is exported in gcov-compatible format via the "gcov "debugfs directory.
+To get coverage data for a specific file, change to the kernel build
+directory and use gcov with the -o option as follows (requires root):
 
-Example:
-
-To get coverage data for file base.c in directory drivers/base, simply
-change to the kernel build directory and run gcov with the -o option
-(assumptions: kernel was built in /tmp/linux and debugfs is mounted at
-/sys/kernel/debug):
-
-# cd /tmp/linux
-# gcov -o drivers/base/ bus.c
+# cd /tmp/linux-out
+# gcov -o /sys/kernel/debug/gcov/tmp/linux/kernel spinlock.c
 
 This will create source code files annotated with execution counts
 in the current directory. In addition, graphical gcov front-ends such
@@ -38,6 +36,11 @@ Possible uses:
 * minimizing kernel configurations (do I need this option if the
   associated code is never executed?)
 
+--
+
+[1] http://gcc.gnu.org/onlinedocs/gcc/Gcov.html
+[2] http://ltp.sourceforge.net/coverage/lcov.php
+
 
 2. Preparation
 ==============
@@ -99,6 +102,11 @@ The gcov kernel support creates the foll
                 The actual gcov data file as understood by the gcov
                 tool. Resets file coverage data to zero when written to.
 
+        /sys/kernel/debug/gcov/path/to/compile/dir/file.gcno
+                Symbolic link to a static data file required by the gcov
+                tool. This file is generated by gcc when compiling with
+                option -ftest-coverage.
+
 
 5. Modules
 ==========
@@ -119,7 +127,56 @@ At run-time, a user can also choose to d
 module by writing to its data file or the global reset file.
 
 
-6. Troubleshooting
+6. Separated build and test machines
+====================================
+
+The gcov kernel profiling infrastructure is designed to work out-of-the
+box for setups where kernels are built and run on the same machine. In
+cases where the kernel runs on a separate machine, special preparations
+must be made, depending on where the gcov tool is used:
+
+a) gcov is run on the TEST machine
+
+The gcov tool version on the test machine must be compatible with the
+gcc version used for kernel build. Also the following files need to be
+copied from build to test machine:
+
+from the source tree:
+  - all C source files + headers
+
+from the build tree:
+  - all C source files + headers
+  - all .gcda and .gcno files
+  - all links to directories
+
+It is important to note that these files need to be placed into the
+exact same file system location on the test machine as on the build
+machine. If any of the path components is symbolic link, the actual
+directory needs to be used instead (due to make's CURDIR handling).
+
+b) gcov is run on the BUILD machine
+
+The following files need to be copied after each test case from test
+to build machine:
+
+from the gcov directory in sysfs:
+  - all .gcda files
+  - all links to .gcno files
+
+These files can be copied to any location on the build machine. gcov
+must then be called with the -o option pointing to that directory.
+
+Example directory setup on the build machine:
+
+  /tmp/linux:    kernel source tree
+  /tmp/out:      kernel build directory as specified by make O=
+  /tmp/coverage: location of the files copied from the test machine
+
+  [user@build] cd /tmp/out
+  [user@build] gcov -o /tmp/coverage/tmp/out/init main.c
+
+
+7. Troubleshooting
 ==================
 
 Problem:  Compilation aborts during linker step.
@@ -127,10 +184,62 @@ Cause:    Profiling flags are specified 
           linked to the main kernel or which are linked by a custom
           linker procedure.
 Solution: Exclude affected source files from profiling by specifying
-          GCOV := n in the corresponding Makefile.
+          GCOV := n or GCOV_basename.o := n in the corresponding
+          Makefile.
 
 
---
+Appendix A: gather_on_build.sh
+==============================
 
-[1] http://gcc.gnu.org/onlinedocs/gcc/Gcov.html
-[2] http://ltp.sourceforge.net/coverage/lcov.php
+Sample script to gather coverage meta files on the build machine
+(see 6a):
+
+#!/bin/bash
+
+KSRC=$1
+KOBJ=$2
+DEST=$3
+
+if [ -z "$KSRC" ] || [ -z "$KOBJ" ] || [ -z "$DEST" ]; then
+  echo "Usage: $0 <ksrc directory> <kobj directory> <output.tar.gz>" >&2
+  exit 1
+fi
+
+KSRC=$(cd $KSRC; printf "all:\n\t@echo \${CURDIR}\n" | make -f -)
+KOBJ=$(cd $KOBJ; printf "all:\n\t@echo \${CURDIR}\n" | make -f -)
+
+find $KSRC $KOBJ \( -name '*.gcno' -o -name '*.[ch]' -o -type l \) -a \
+                 -perm /u+r,g+r | tar cfz $DEST -P -T -
+
+if [ $? -eq 0 ] ; then
+  echo "$DEST successfully created, copy to test system and unpack with:"
+  echo "  tar xfz $DEST -P"
+else
+  echo "Could not create file $DEST"
+fi
+
+
+Appendix B: gather_on_test.sh
+=============================
+
+Sample script to gather coverage data files on the test machine
+(see 6b):
+
+#!/bin/bash
+
+DEST=$1
+GCDA=/sys/kernel/debug/gcov
+
+if [ -z "$DEST" ] ; then
+  echo "Usage: $0 <output.tar.gz>" >&2
+  exit 1
+fi
+
+find $GCDA -name '*.gcno' -o -name '*.gcda' | tar cfz $DEST -T -
+
+if [ $? -eq 0 ] ; then
+  echo "$DEST successfully created, copy to build system and unpack with:"
+  echo "  tar xfz $DEST"
+else
+  echo "Could not create file $DEST"
+fi
Index: linux-2.6.26-rc5-mm3/kernel/gcov/fs.c
===================================================================
--- linux-2.6.26-rc5-mm3.orig/kernel/gcov/fs.c
+++ linux-2.6.26-rc5-mm3/kernel/gcov/fs.c
@@ -36,11 +36,13 @@
  *         copy of the profiling data here to allow collecting coverage data
  *         for cleanup code. Such a node is called a "ghost".
  * @dentry: main debugfs entry, either a directory or data file
+ * @links: associated symbolic links
  * @name: data file basename
  *
  * struct gcov_node represents an entity within the gcov/ subdirectory
  * of debugfs. There are directory and data file nodes. The latter represent
- * the actual synthesized data file.
+ * the actual synthesized data file plus any associated symbolic links which
+ * are needed by the gcov tool to work correctly.
  */
 struct gcov_node {
 	struct list_head list;
@@ -50,9 +52,12 @@ struct gcov_node {
 	struct gcov_info *info;
 	struct gcov_info *ghost;
 	struct dentry *dentry;
+	struct dentry **links;
 	char name[0];
 };
 
+static const char objtree[] = OBJTREE;
+static const char srctree[] = SRCTREE;
 static struct gcov_node root_node;
 static struct dentry *reset_dentry;
 static LIST_HEAD(all_head);
@@ -238,6 +243,104 @@ static ssize_t gcov_seq_write(struct fil
 	return len;
 }
 
+/* Given a string <path> representing a file path of format:
+ *   path/to/file.gcda
+ * construct and return a new string:
+ *   <dir/>path/to/file.<ext> */
+static char *link_target(const char *dir, const char *path, const char *ext)
+{
+	char *target;
+	char *old_ext;
+	char *copy;
+
+	copy = kstrdup(path, GFP_KERNEL);
+	if (!copy)
+		return NULL;
+	old_ext = strrchr(copy, '.');
+	if (old_ext)
+		*old_ext = '\0';
+	if (dir)
+		target = kasprintf(GFP_KERNEL, "%s/%s.%s", dir, copy, ext);
+	else
+		target = kasprintf(GFP_KERNEL, "%s.%s", copy, ext);
+	kfree(copy);
+
+	return target;
+}
+
+/* Construct a string representing the symbolic link target for the given
+ * gcov data file name and link type. Depending on the link type and the
+ * location of the data file, the link target can either point to a
+ * subdirectory of srctree, objtree or in an external location. */
+static char *get_link_target(const char *filename, const struct gcov_link *ext)
+{
+	const char *rel;
+	char *result;
+
+	if (strncmp(filename, objtree, strlen(objtree)) == 0) {
+		rel = filename + strlen(objtree) + 1;
+		if (ext->dir == src_tree)
+			result = link_target(srctree, rel, ext->ext);
+		else
+			result = link_target(objtree, rel, ext->ext);
+	} else {
+		/* External compilation. */
+		result = link_target(NULL, filename, ext->ext);
+	}
+
+	return result;
+}
+
+#define SKEW_PREFIX	".tmp_"
+
+/* For a filename .tmp_filename.ext return filename.ext. Needed to compensate
+ * for filename skewing caused by the mod-versioning mechanism. */
+static const char *deskew(const char *basename)
+{
+	if (strncmp(basename, SKEW_PREFIX, sizeof(SKEW_PREFIX) - 1) == 0)
+		return basename + sizeof(SKEW_PREFIX) - 1;
+	return basename;
+}
+
+/* Create links to additional files (usually .c and .gcno files) which the
+ * gcov tool expects to find in the same directory as the gcov data file. */
+static void add_links(struct gcov_node *node, struct dentry *parent)
+{
+	char *basename;
+	char *target;
+	int num;
+	int i;
+
+	for (num = 0; gcov_link[num].ext; num++)
+		/* Nothing. */;
+	node->links = kcalloc(num, sizeof(struct dentry *), GFP_KERNEL);
+	if (!node->links)
+		return;
+	for (i = 0; i < num; i++) {
+		target = get_link_target(get_node_info(node)->filename,
+					 &gcov_link[i]);
+		if (!target)
+			goto out_err;
+		basename = strrchr(target, '/');
+		if (!basename)
+			goto out_err;
+		basename++;
+		node->links[i] = debugfs_create_symlink(deskew(basename),
+							parent,	target);
+		if (!node->links[i])
+			goto out_err;
+		kfree(target);
+	}
+
+	return;
+out_err:
+	kfree(target);
+	while (i-- > 0)
+		debugfs_remove(node->links[i]);
+	kfree(node->links);
+	node->links = NULL;
+}
+
 static struct file_operations gcov_data_fops = {
 	.open = gcov_seq_open,
 	.release = gcov_seq_release,
@@ -273,7 +376,7 @@ static struct gcov_node *new_node(struct
 	init_node(node, info, name);
 	/* Differentiate between gcov data file nodes and directory nodes. */
 	if (info) {
-		node->dentry = debugfs_create_file(node->name, 0600,
+		node->dentry = debugfs_create_file(deskew(node->name), 0600,
 					parent->dentry, node, &gcov_data_fops);
 	} else
 		node->dentry = debugfs_create_dir(node->name, parent->dentry);
@@ -282,12 +385,27 @@ static struct gcov_node *new_node(struct
 		kfree(node);
 		return NULL;
 	}
+	if (info)
+		add_links(node, parent->dentry);
 	list_add(&node->list, &parent->children);
 	list_add(&node->all, &all_head);
 
 	return node;
 }
 
+/* Remove symbolic links associated with node. */
+static void remove_links(struct gcov_node *node)
+{
+	int i;
+
+	if (!node->links)
+		return;
+	for (i = 0; gcov_link[i].ext; i++)
+		debugfs_remove(node->links[i]);
+	kfree(node->links);
+	node->links = NULL;
+}
+
 /* Remove node from all lists and debugfs and release associated resources.
  * Needs to be called with node_lock held. */
 static void release_node(struct gcov_node *node)
@@ -295,6 +413,7 @@ static void release_node(struct gcov_nod
 	list_del(&node->list);
 	list_del(&node->all);
 	debugfs_remove(node->dentry);
+	remove_links(node);
 	if (node->ghost)
 		gcov_info_free(node->ghost);
 	kfree(node);
Index: linux-2.6.26-rc5-mm3/kernel/gcov/gcc_3_4.c
===================================================================
--- linux-2.6.26-rc5-mm3.orig/kernel/gcov/gcc_3_4.c
+++ linux-2.6.26-rc5-mm3/kernel/gcov/gcc_3_4.c
@@ -20,6 +20,12 @@
 #include <linux/seq_file.h>
 #include "gcov.h"
 
+/* Symbolic links to be created for each profiling data file. */
+const struct gcov_link gcov_link[] = {
+	{ obj_tree, "gcno" },	/* Link to .gcno file in $(objtree). */
+	{ 0, NULL},
+};
+
 /* Determine whether a counter is active. Based on gcc magic. Doesn't change
  * at run-time. */
 static int counter_active(struct gcov_info *info, unsigned int type)
Index: linux-2.6.26-rc5-mm3/kernel/gcov/gcov.h
===================================================================
--- linux-2.6.26-rc5-mm3.orig/kernel/gcov/gcov.h
+++ linux-2.6.26-rc5-mm3/kernel/gcov/gcov.h
@@ -116,4 +116,13 @@ void gcov_info_add(struct gcov_info *des
 struct gcov_info *gcov_info_dup(struct gcov_info *info);
 void gcov_info_free(struct gcov_info *info);
 
+struct gcov_link {
+	enum {
+		obj_tree,
+		src_tree,
+	} dir;
+	const char *ext;
+};
+extern const struct gcov_link gcov_link[];
+
 #endif /* GCOV_H */
Index: linux-2.6.26-rc5-mm3/kernel/gcov/Makefile
===================================================================
--- linux-2.6.26-rc5-mm3.orig/kernel/gcov/Makefile
+++ linux-2.6.26-rc5-mm3/kernel/gcov/Makefile
@@ -1 +1,3 @@
+EXTRA_CFLAGS := -DSRCTREE='"$(srctree)"' -DOBJTREE='"$(objtree)"'
+
 obj-$(CONFIG_GCOV_PROFILE) := base.o fs.o gcc_3_4.o
