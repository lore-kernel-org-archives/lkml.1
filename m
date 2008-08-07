Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbYHGGba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbYHGGba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 02:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbYHGGa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 02:30:58 -0400
Received: from zen.handcraftedcomputers.com.au ([203.122.247.90]:3331 "EHLO
	zen.handcraftedcomputers.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308AbYHGGa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 02:30:57 -0400
X-Greylist: delayed 839 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Aug 2008 02:30:56 EDT
Message-ID: <489A9357.50105@handcraftedcomputers.com.au>
Date: Thu, 07 Aug 2008 15:46:55 +0930
From: Daryl Tester <dt-lkml@handcraftedcomputers.com.au>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: PROBLEM?: "permission denied" when accessing /proc/self/fd/* after
 setuid
Content-Type: multipart/mixed;
 boundary="------------060809010506020707070001"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060809010506020707070001
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Howdee - first lkml post, please be gentle.  :-)

When a process setuid's to a non root user, under some circumstances
it can no longer open /dev/stdout or /dev/stderr (which symlink to
/proc/self/fd/1 & 2 respectively), which results in EACCESS.  Expected
behavior is that the process should be able to open these already
opened filed descriptors, but I'm not sure if this is intended or not.

Am I expecting too much here of /dev/std* and /proc/self/fd/* being
kosher methods to access a process' already open file descriptors?

(Background)

>From a discussion in <http://marc.info/?t=121760392200003&r=1&w=2>
a user was attempting to open /dev/stderr for a log file under a djb
supervised process.  The process initially runs as root, then setuid's
to another id.  This process is connected to another process (for
logging) on stdout (and dup'd onto stderr) via an anonymous pipe.
The open of /dev/stderr fails with EACCESS.

The above environment isn't necessary to replicate the problem, although
what stdout and stderr are attached to has some effect.  The attached C
code replicates the issue, but appears to not fail (that is, succeed) if
/proc/self/fd/2 is a terminal (e.g. /dev/pts/X) *and* that terminal is
owned by the same uid that the code uses (in this case, 500).  In the
case of an anonymous pipe it appears to fail consistently as the pipe is
owned by root.

So, for example:

# ls -nl /proc/self/fd/2 /dev/pts/2
crw------- 1 1000 5 136, 2 2008-08-07 15:36 /dev/pts/2
lrwx------ 1    0 0     64 2008-08-07 15:36 /proc/self/fd/2 -> /dev/pts/2
# ./self_fd /proc/self/fd/2
/proc/self/fd/2: uid: 1000, gid: 5
open(/proc/self/fd/2) as uid 500: Permission denied
/proc/self/fd/2: uid: 1000, gid: 5

I've managed to replicate this issue on several platforms - a Centos
5.2 machine running 2.6.18-92, an Ubuntu 8.04 x86_64 running 2.6.24-19,
and an Ubuntu 7.04 running 2.6.20-17 (A FreeBSD 4.11 box works OK
though :-).


Cheers,
  --dt

--------------060809010506020707070001
Content-Type: text/x-csrc;
 name="self_fd.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="self_fd.c"

/*
**  Issue as discovered by richard lucassen in
**  <http://marc.info/?t=121760392200003&r=1&w=2>
**  After setuid, open returns "permission denied" when trying to
**  open /dev/stdder (which symlinks to /proc/self/fd/2).
*/

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int open_file(char *pathname, char *msg);

int
main(int argc, char *argv[])
{
    if (argc != 2) {
        fprintf(stderr, "usage: self_fd /dev/stderr\n");
        /* Or, you could try some other file :-) */
        exit(1);
    }

    /* Check we are who we need to be */
    if (getuid() != 0) {
        fprintf(stderr, "I insist that I be run as root\n");
        exit(1);
    }

    open_file(argv[1], "root");

    /* Set ourselves to an arbitrary user id, group first */
    if (setgid(500) == -1) {
        perror("setgid(500)");
        exit(1);
    }
    if (setuid(500) == -1) {
        perror("setuid(500)");
        exit(1);
    }

    open_file(argv[1], "uid 500");

    return 0;
}

int
open_file(char *pathname, char *msg)
{
    int    fd;
    char   m[80];
    struct stat s;

    fd = open(pathname, O_WRONLY);
    if (fd == -1) {
        snprintf(m, sizeof m, "open(%s) as %s", pathname, msg);
        perror(m);
        if (stat(pathname, &s) == -1) {
            snprintf(m, sizeof m, "stat(%s) as %s", pathname, msg);
            perror(m);
        } else {
            fprintf(stderr, "%s: uid: %u, gid: %u\n", pathname,
                    s.st_uid, s.st_gid);
        }
        return 1;
    } else {
        if (fstat(fd, &s) == -1) {
            snprintf(m, sizeof m, "fstat(%s) as %s", pathname, msg);
            perror(m);
        } else {
            fprintf(stderr, "%s: uid: %u, gid: %u\n", pathname,
                    s.st_uid, s.st_gid);
        }
        close(fd);
        return 0;
    }
}

--------------060809010506020707070001--
