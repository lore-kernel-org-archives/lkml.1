Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbZIANIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbZIANIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 09:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbZIANIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 09:08:41 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:41976 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbZIANIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 09:08:40 -0400
From: Jim Meyering <jim@meyering.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: make getdents/readdir POSIX compliant wrt mount-point dirent.d_ino
Date: Tue, 01 Sep 2009 15:07:23 +0200
Message-ID: <87y6oyhkz8.fsf@meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, on all unix and linux-based systems the dirent.d_ino of a mount
point (as read from its parent directory) fails to match the stat-returned
st_ino value for that same entry.  That is contrary to POSIX 2008.

I'm bringing this up today because I've just had to disable an
optimization in coreutils ls -i:

  http://thread.gmane.org/gmane.comp.gnu.coreutils.bugs/17887

Normally, work-arounds in coreutils penalize non-linux, or old-linux
kernels, but this is the first that has penalized *all* unix/linux-based
systems.  Ironically, the sole system that can still take advanatage
of the optimization is Cygwin.

I'm hoping that Linux can catch up before too long.

------------------------
The POSIX readdir spec says this:

    The structure dirent defined in the <dirent.h> header describes a
    directory entry. The value of the structure's d_ino member shall be set
    to the file serial number of the file named by the d_name member.

The description for sys/stat.h makes the connection between
"file serial number" and the stat.st_ino member:

    The <sys/stat.h> header shall define the stat structure, which shall
    include at least the following members:
    ...
        ino_t st_ino                File serial number.
------------------------

The current linux/unix readdir behavior makes it so ls -i cannot perform
the optimization of printing only readdir-returned inode numbers, and
instead must incur the cost of actually stat'ing each entry in order to
be assured that it prints valid inode numbers.

If you have gnu coreutils 6.0 or newer (but not built from today's
git repository) tools on your system, you can demonstrate the mismatch
with the following shell code: [if not, use the C program in
 <http://thread.gmane.org/gmane.comp.gnu.coreutils.bugs/14020>]

#!/bin/sh
mount_points=$(df --local -P 2>&1 | sed -n 's,.*[0-9]% \(/.\),\1,p')

# Given e.g., /dev/shm, produce the list of GNU ls options that
# let us list just that entry using readdir data from its parent:
# ls -i -I '[^s]*' -I 's[^h]*' -I 'sh[^m]*' -I 'shm?*' -I '.?*' \
# -I '?' -I '??' /dev
ls_ignore_options()
{
  name=$1
  opts="-I '.?*' -I '$name?*'"
  while :; do
    glob=$(echo "$name"|sed 's/\(.*\)\(.\)$/\1[^\2]*/')
    opts="$opts -I '$glob'"
    name=$(echo "$name"|sed 's/.$//')
    test -z "$name" && break
    glob=$(echo "$name"|sed 's/./?/g')
    opts="$opts -I '$glob'"
  done
  echo "$opts"
}

inode_via_readdir()
{
  mount_point=$1
  base=$(basename $mount_point)
  case $base in
    .*) skip_test_ 'mount point component starts with "."' ;;
    *[*?]*) skip_test_ 'mount point component contains "?" or "*"' ;;
  esac
  opts=$(ls_ignore_options "$base")
  parent_dir=$(dirname $mount_point)
  eval "ls -i $opts $parent_dir" | sed 's/ .*//'
}

first_failure=1
for dir in $mount_points; do
  readdir_inode=$(inode_via_readdir $dir)
  stat_inode=$(env stat --format=%i $dir)
  if test "$readdir_inode" != "$stat_inode"; then
    test $first_failure = 1 \
      && printf '%8s %8s %-20s\n' st_ino d_ino mount-point
    printf '%8d %8d %-20s\n' $stat_inode $readdir_inode $dir
    first_failure=0
  fi
done
#--------------------------------------------------------------

For example, here's the result of running it on one
of my systems:

  st_ino    d_ino mount-point
    3508    36850 /lib/init/rw
     824   376097 /dev
    6237     3532 /dev/shm
       2     8177 /boot
       2    12265 /full
       2   147197 /h
       2   298428 /f
       2   310689 /usr
       2    73585 /var
    6992   253457 /t
       2   327041 /b
       2     4113 /d
       2   302521 /x
       2    53378 /media/sdd1

The d_ino number is what ls -i $parent_dir would print,
before today's fix, while the st_ino value is the correct inode
number for that directory.
