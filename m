Return-Path: <linux-kernel-owner+w=401wt.eu-S935475AbYEUDmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935475AbYEUDmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 23:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933963AbYEUDd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 23:33:57 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:44167 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168AbYEUDdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 23:33:14 -0400
From: hooanon05@yahoo.co.jp
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Junjiro Okajima <hooanon05@yahoo.co.jp>
Subject: [AUFS PATCH v2.6.26-rc2-mm1 37/39] aufs mount/umount helpers
Date: Wed, 21 May 2008 12:23:07 +0900
Message-Id: <1211340189-11813-38-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.5.5.1.308.g1fbb5.dirty
In-Reply-To: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1211340189-11813-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Junjiro Okajima <hooanon05@yahoo.co.jp>

initial commit
they will be written all in C in the future.
mount.aufs		mount helper script
auplink			pseudo-link helper script
aulchown.c		pseudo-link helper for symlink
umount.aufs		umount helper script

Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
---
 Documentation/filesystems/aufs/aulchown.c  |   28 ++++
 Documentation/filesystems/aufs/auplink     |  168 +++++++++++++++++++++++
 Documentation/filesystems/aufs/mount.aufs  |  203 ++++++++++++++++++++++++++++
 Documentation/filesystems/aufs/umount.aufs |   31 +++++
 4 files changed, 430 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/aufs/aulchown.c
 create mode 100644 Documentation/filesystems/aufs/auplink
 create mode 100644 Documentation/filesystems/aufs/mount.aufs
 create mode 100644 Documentation/filesystems/aufs/umount.aufs

diff --git a/Documentation/filesystems/aufs/aulchown.c b/Documentation/filesystems/aufs/aulchown.c
new file mode 100644
index 0000000..eb09270
--- /dev/null
+++ b/Documentation/filesystems/aufs/aulchown.c
@@ -0,0 +1,28 @@
+
+/*
+ * While this tool should be atomic, I choose loose/rough way.
+ * cf. auplink and aufs.5
+ */
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <stdio.h>
+
+int main(int argc, char *argv[])
+{
+	int err, nerr;
+	struct stat st;
+
+	nerr = 0;
+	while (*++argv) {
+		err = lstat(*argv, &st);
+		if (!err && S_ISLNK(st.st_mode))
+			err = lchown(*argv, st.st_uid, st.st_gid);
+		if (!err)
+			continue;
+		perror(*argv);
+		nerr++;
+	}
+	return nerr;
+}
diff --git a/Documentation/filesystems/aufs/auplink b/Documentation/filesystems/aufs/auplink
new file mode 100644
index 0000000..dec6ee9
--- /dev/null
+++ b/Documentation/filesystems/aufs/auplink
@@ -0,0 +1,168 @@
+#!/bin/sh
+
+# Copyright (C) 2006, 2007, 2008 Junjiro Okajima
+#
+# This program, aufs is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+
+#set -x; echo $0 $@
+tmp=/tmp/$$
+set -e
+
+Usage()
+{
+	cat <<- EOF 1>&2
+	usage: $0 aufs_mount_point list|cpup|flush
+	'list' shows the pseudo-linked inode numbers and filenames.
+	'cpup' copies-up all pseudo-link to the writeble branch.
+	'flush' calls 'cpup', and then "mount -o remount,clean_plink=inum"
+	and remove the whiteouted plink.
+	EOF
+	rm -f $tmp $tmp.*
+	exit 1
+}
+
+eecho() { echo "$@" 1>&2; }
+
+conv() # [escape]
+{
+	sed -r -e '
+	s/\\/\\134/g
+	s/$/\\012/
+	' |
+	tr -d '\n' |
+	sed -r -e '
+	s/ /\\040/g
+	s/\t/\\011/g
+	s/\r/\\015/g
+	s/\\012$//
+	' |
+	{ test "$1" = "escape" && sed -r -e 's/\\/\\\\/g' || cat; }
+	echo
+}
+
+Find() # dir [ find_args ]
+{
+	dir="$1"
+	shift
+	find "$dir" -xdev -noleaf $@
+}
+
+List()
+{
+	sed -e 's/^\([0-9]*\) .*$/-o -inum \1/' |
+	cut -c3- |
+	xargs -n 200 |
+	while read args
+	do Find "$mntpnt" \( $args \) $@
+	done
+}
+
+Cpup()
+{
+	List \( \( -type l -fprint $tmp.slink \) \
+		-o ! -type l -fprint $tmp.other  \)
+
+	# do nothing but update something. it causes copyup.
+	xargs -r touch -ac -r $tmp.other < $tmp.other
+	xargs -r aulchown < $tmp.slink
+}
+
+test $# -eq 2 || Usage
+cd "$1"
+mntpnt=`readlink -f "$PWD"`
+e_mntpnt=`echo "$mntpnt" | conv escape`
+cd "$OLDPWD"
+
+do_flush=0
+f=${AUPLINK_CONFIG:-/etc/default/auplink}
+if [ -r $f ]
+then
+	. $f
+	for i in $FLUSH
+	do
+		test "$i" = "$mntpnt" -o "$i" = "ALL" || continue
+		do_flush=1
+		break
+	done
+fi
+case $2 in
+cpup|flush) test $do_flush -eq 0 && exit 0;;
+esac
+
+ent=`grep " $e_mntpnt aufs .*,si=" /proc/mounts | tail -n 1`
+test ! "$ent" && exit 0
+eval `echo "$ent" | tr ',' '\n' | grep '^si='`
+test ! "$si" && eecho no such mount-point $e_mntpnt && exit 1
+
+si_dir=/sys/fs/aufs/si_$si
+if [ -r $si_dir/br0 ]
+then
+	cd $si_dir
+	ls -1 br* |
+	cut -c3- |
+	sort -n |
+	sed -e 's/^/br/' |
+	xargs -rn 200 cat
+	cd $OLDPWD
+else
+	echo "$ent" |
+	tr ',' '\n' |
+	sed -e 's/\\/\\\\/g' |
+	egrep '^(dirs=|br:)' |
+	tr ':' '\n'
+fi |
+grep '=rw$' |
+sed -e 's/=rw$//' |
+while read wbr
+do
+	d=`echo $wbr/.wh..wh.plink`
+	# -printf '%n %p\n'
+	test -d "$d" && Find "$d" -maxdepth 1 ! -type d -printf '%n\t%p\n'
+done |
+while read nlink pname
+do
+	inum=`basename "$pname" | cut -f1 -d.`
+	echo $inum $nlink "$pname"
+done > $tmp
+test -s $tmp || { rm -f $tmp $tmp.*; exit 0; }
+
+# debug
+#mount -o remount,list_plink "$mntpnt"
+
+case $2 in
+list)
+	cut -f1 -d' ' $tmp | tr '\n' ' '
+	echo
+	List < $tmp
+	;;
+cpup)
+	Cpup < $tmp
+	;;
+flush)
+	#echo -n Flushing pseudo-links on "$mntpnt"...
+	Cpup < $tmp
+
+	# all are copied-up, and then remove all pseudo-links.
+	mount -o remount,clean_plink "$mntpnt"
+	cut -f3- -d' ' $tmp | xargs -r rm
+	# debug
+	#mount -o remount,list_plink "$mntpnt"
+	#echo done.
+	;;
+*)
+	Usage;;
+esac
+
+rm -f $tmp $tmp.*
diff --git a/Documentation/filesystems/aufs/mount.aufs b/Documentation/filesystems/aufs/mount.aufs
new file mode 100644
index 0000000..7458fc5
--- /dev/null
+++ b/Documentation/filesystems/aufs/mount.aufs
@@ -0,0 +1,203 @@
+#!/bin/sh -
+
+# Copyright (C) 2005, 2006, 2007 Junjiro Okajima
+#
+# This program, aufs is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+
+#
+# The main purpose of this script is updating /etc/mtab and calling auplilnk.
+# This script is highly depending on mount(8) in util-linux-2.12p package.
+# TODO: rewrite in C.
+# TODO: updating mtab for bind-mount is not fully supportetd.
+#
+
+PATH=/usr/bin:/usr/sbin:/bin:/sbin
+export PATH
+eecho() { echo "$@" 1>&2; }
+
+conv() # [escape]
+{
+	sed -r -e '
+	s/\\/\\134/g
+	s/$/\\012/
+	' |
+	tr -d '\n' |
+	sed -r -e '
+	s/ /\\040/g
+	s/\t/\\011/g
+	s/\r/\\015/g
+	s/\\012$//
+	' |
+	{ test "$1" = "escape" && sed -r -e 's/\\/\\\\/g' || cat; }
+	echo
+}
+
+########################################
+
+set -e
+#set -x; echo $0 $@
+tmp=/tmp/$$
+fstype=`basename "$0" | cut -f2 -d.`
+
+########################################
+# mount(8) always passes the arguments in this order
+
+do_update=1
+verbose=0
+dev="$1"
+e_dev=`echo "$dev" | conv escape`
+cd "$2"
+mntpnt=`readlink -f "$PWD"`
+e_mntpnt=`echo "$mntpnt" | conv escape`
+cd "$OLDPWD"
+shift 2
+test "$1" = "-n" && do_update=0 && shift
+test "$1" = "-v" && verbose=1 && shift
+test "$1" = "-o" || { eecho Bad arg. "$@"; exit 1; }
+shift
+remount=0
+echo "$@" | grep -q ',remount[,$]' && remount=1
+
+f=/etc/mtab
+test ! -r $f -o \( $do_update -eq 1 -a ! -w $f \) &&
+eecho ${f}: Permission denied &&
+exit 1
+
+f=/proc/mounts
+test \( $do_update -eq 1 -o $verbose -eq 1 \) -a ! -r $f &&
+eecho ${f}: Permission denied. &&
+exit 1
+
+oldmtab=
+> $tmp.old_opt
+if [ $remount -eq 1 ]
+then
+oldmtab=`grep "^$e_dev $e_mntpnt $fstype .*,si=" $f | tail -n 1`
+echo "$oldmtab" |
+sed -e '
+s:^'"$dev $mntpnt $fstype"' ::
+s/\( [0-9]*\)\{2\}$//
+' | tr ',' '\n' > $tmp.old_opt
+#test -s $tmp.old_opt
+eval `grep '^si=' $tmp.old_opt`
+
+# append brs from sysfs
+si_dir=/sys/fs/aufs/si_$si
+if [ -r $si_dir/br0 ]
+then
+	cd $si_dir
+	{
+	ls -1 br* |
+	cut -c3- |
+	sort -n |
+	sed -e 's/^/br/' |
+	xargs -n 200 sed -e 's/^/:/' |
+	tr -d '\n' |
+	sed -e 's/^/br/'
+	echo # last newline
+	} >> $tmp.old_opt
+	cd $OLDPWD
+	#cat $tmp.old_opt; #rm -f $tmp $tmp.*; exit
+fi
+fi
+
+echo "$@" | tr ',' '\n' > $tmp.new_opt
+remount=
+fgrep -v remount $tmp.new_opt > $tmp #|| :
+diff -q $tmp.new_opt $tmp > /dev/null ||
+{
+	mv $tmp $tmp.new_opt
+	remount="remount,"
+}
+#cat $tmp.new_opt; rm -f $tmp $tmp.*; exit
+
+#more $tmp.old_opt $tmp.new_opt
+real_opt=`comm -13 $tmp.old_opt $tmp.new_opt | tee $tmp | paste -s -d, -`
+real_opt="${remount}${real_opt}"
+test "$real_opt" = "" &&
+eecho bad arg "$@" &&
+rm -f $tmp $tmp.* &&
+exit 1
+#echo ${real_opt}; exit
+
+test "$remount" &&
+egrep -q '^((add|ins|append|prepend|del)[:=]|(mod|imod)[:=][^,]*=ro|(noplink|ro)$)' $tmp &&
+auplink "$mntpnt" flush
+rm -f $tmp $tmp.*
+
+########################################
+# actual mount operation
+
+set +e
+mount -in -t $fstype -o "$real_opt" "$dev" "$mntpnt"
+err=$?
+set -e
+
+test $do_update -eq 0 -a $verbose -eq 0 && exit $err
+
+########################################
+# in order to handle '-v' option, keep going even if we failed
+
+failure()
+{
+	eecho failure "$1" $?
+	exit 1
+}
+
+newmtab=`{ grep "^$e_dev $e_mntpnt $fstype" /proc/mounts ||
+	failure "bad /proc/mounts"; } |
+	tail -n 1 | sed -e 's:^'"$e_dev $e_mntpnt $fstype"' ::'`
+digits=`echo "$newmtab" | rev | cut -f-2 -d' ' | rev`
+newmtab=`echo "$newmtab" | rev | cut -f3- -d' ' | rev | conv escape`
+newmtab="$e_dev $e_mntpnt $fstype $newmtab $digits"
+
+#if [ $do_update -eq 1 -a -w /etc -a -w /etc/mtab ]
+if [ $do_update -eq 1 ]
+then
+lock_pid=/etc/mtab~$$
+lock=/etc/mtab~
+f=/etc/mtab.aufs.tmp
+touch $lock_pid || failure "creating pid lockfile"
+
+# re-define
+failure()
+{
+	eecho failure "$1" $?
+	test $err -eq 0 && eecho failed updating /etc/mtab
+	exit 1
+}
+#trap "rm -f $lock; failure" `seq 32`
+
+ln $lock_pid $lock || failure "linking lockfile"
+rm $lock_pid || failure "removing pid lockfile"
+
+if [ "$oldmtab" = "" ]
+then
+	{ cat /etc/mtab; echo "$newmtab"; } |
+	dd of=$f 2> /dev/null || failure "appending $f"
+else
+	tac /etc/mtab |
+	awk -v new="$newmtab" -v mntpnt="$e_mntpnt" -v fstype="$fstype" '
+	!done && $2 == mntpnt && $3 == fstype {print new; done = 1; next}
+	{print}
+	' | tac > $f || failure "creating $f"
+fi
+mv $f /etc/mtab || failure "renaming from $f"
+rm $lock || failure "removing lockfile"
+fi
+
+test $verbose -eq 1 &&
+echo "$dev" on "$mntpnt" type "$fstype" \(`echo "$newmtab" | cut -f4 -d' '`\)
+exit $err
diff --git a/Documentation/filesystems/aufs/umount.aufs b/Documentation/filesystems/aufs/umount.aufs
new file mode 100644
index 0000000..7c38c5d
--- /dev/null
+++ b/Documentation/filesystems/aufs/umount.aufs
@@ -0,0 +1,31 @@
+#!/bin/sh -
+
+# Copyright (C) 2007 Junjiro Okajima
+#
+# This program, aufs is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+
+#
+# The main purpose of this script is calling auplink.
+#
+
+PATH=/usr/bin:/usr/sbin:/bin:/sbin
+export PATH
+
+set -e
+#set -x; echo $0 $@
+dev="$1"
+shift
+auplink "$dev" flush
+exec umount -i $@ "$dev"
-- 
1.5.5.1.308.g1fbb5.dirty

