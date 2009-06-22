Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbZFVTqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbZFVTqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 15:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZFVTqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:46:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47847 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbZFVTqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:46:48 -0400
Date: Mon, 22 Jun 2009 20:46:49 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.31 - sequence of chroot calls makes filesystem unmountable
Message-ID: <20090622194649.GD12575@amd.home.annexia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I discovered an odd bug in 2.6.31 (from Fedora Rawhide which is mostly
tracking git).  A sequence of chroot() and open() syscalls executed as
root can make a filesystem unmountable.

Test program below, along with a wrapper script.

The filesystem stays unmountable even after the program & script exit.
'lsof' and 'fuser' don't show anything holding the filesystem open.

Some sample output is here:
https://bugzilla.redhat.com/show_bug.cgi?id=507066#c10

Rich.

Save as /tmp/test.c
Compile: gcc -Wall -o /tmp/test /tmp/test.c
----------------------------------------------------------------------
#define _XOPEN_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

int
main (int argc, char *argv[])
{
  int fd, r;

  if (chdir ("/") == -1) {
    perror ("chdir");
    exit (1);
  }

  if (chroot ("/tmp/mnt") == -1) {
    perror ("chroot#1");
    exit (1);
  }
  fd = open ("/hello", O_WRONLY|O_CREAT|O_NOCTTY, 0666);
  if (fd == -1) {
    perror ("open");
    exit (1);
  }
  if (chroot (".") == -1) {
    perror ("chroot#2");
    exit (1);
  }
  if (close (fd) == -1) {
    perror ("close");
    exit (1);
  }

  r = system ("umount /tmp/mnt");
  if (r == -1 || WEXITSTATUS(r) != 0) {
    fprintf (stderr, "umount failed\n");
    exit (1);
  }

  exit (0);
}
----------------------------------------------------------------------


Wrapper script (/tmp/test.sh)
----------------------------------------------------------------------
#!/bin/sh -

set -e

dd if=/dev/zero of=/tmp/fs bs=1024k count=10
/sbin/mkfs.ext2 -F /tmp/fs

rm -rf /tmp/mnt
mkdir /tmp/mnt

mount -o loop /tmp/fs /tmp/mnt

/tmp/test

echo Finished test successfully.
----------------------------------------------------------------------

-- 
Richard Jones, Emerging Technologies, Red Hat  http://et.redhat.com/~rjones
virt-p2v converts physical machines to virtual machines.  Boot with a
live CD or over the network (PXE) and turn machines into Xen guests.
http://et.redhat.com/~rjones/virt-p2v
