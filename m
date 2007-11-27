Return-Path: <linux-kernel-owner+w=401wt.eu-S1757812AbXK0LVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbXK0LVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 06:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbXK0LVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 06:21:43 -0500
Received: from sacred.ru ([62.205.161.221]:38491 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588AbXK0LVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 06:21:40 -0500
Message-ID: <474BFD83.6060500@openvz.org>
Date: Tue, 27 Nov 2007 14:20:35 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 2.6.24-rc3] Fix /proc/net breakage
References: <20071119191000.GA1560@elf.ucw.cz>	<200711192304.25087.rjw@sisk.pl> <4743026B.2020907@openvz.org> <m1hcj8mz1p.fsf_-_@ebiederm.dsl.xmission.com>
In-Reply-To: <m1hcj8mz1p.fsf_-_@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 27 Nov 2007 14:20:38 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]

> 
> Well I clearly goofed when I added the initial network namespace support
> for /proc/net.  Currently things work but there are odd details visible
> to user space, even when we have a single network namespace.
> 
> Since we do not cache proc_dir_entry dentries at the moment we can
> just modify ->lookup to return a different directory inode depending
> on the network namespace of the process looking at /proc/net, replacing
> the current technique of using a magic and fragile follow_link method.
> 
> To accomplish that this patch:
> - introduces a shadow_proc method to allow different dentries to
>   be returned from proc_lookup.
> - Removes the old /proc/net follow_link magic
> - Fixes a weakness in our not caching of proc generic dentries.
> 
> As shadow_proc uses a task struct to decided which dentry to return we
> can go back later and fix the proc generic caching without modifying any code that
> uses the shadow_proc method.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Thanks, Eric. 

Much better ('find /proc' works and so does 'ls ..'), but one 
issue is still unsolved :(

I mentioned the program, that opens the directory and dumps the
content of the /proc/self/fd. Here it is (stupid but simple):

==== prog.c
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <asm/fcntl.h>
#include <unistd.h>

int main(int argc, char **argv)
{
        int fd;

        fd = open(argv[1], O_RDONLY|O_DIRECTORY);
        if (fd == -1) {
                perror("Can't open");
                return 1;
        }

        system("ls -l /proc/self/fd");
        return 0;
}
====

So. Here's the result of running this program:

# cd /proc/net/
# pwd
/proc/net
# ~/a.out .
total 0
lrwx------  1 root root 64 Nov 27 13:27 0 -> /dev/pts/0
lrwx------  1 root root 64 Nov 27 13:27 1 -> /dev/pts/0
lrwx------  1 root root 64 Nov 27 13:27 2 -> /dev/pts/0
lr-x------  1 root root 64 Nov 27 13:27 3 -> /proc/net (deleted)
lr-x------  1 root root 64 Nov 27 13:27 4 -> /proc/4475/fd

# cd /proc
# pwd         
/proc
# ~/a.out net
total 0
lrwx------  1 root root 64 Nov 27 13:27 0 -> /dev/pts/0
lrwx------  1 root root 64 Nov 27 13:27 1 -> /dev/pts/0
lrwx------  1 root root 64 Nov 27 13:27 2 -> /dev/pts/0
lr-x------  1 root root 64 Nov 27 13:27 3 -> /proc/net
lr-x------  1 root root 64 Nov 27 13:27 4 -> /proc/4477/fd

# cd /proc/net/stat
# pwd
/proc/net/stat
# ~/a.out ..
total 0
lrwx------  1 root root 64 Nov 27 13:29 0 -> /dev/pts/0
lrwx------  1 root root 64 Nov 27 13:29 1 -> /dev/pts/0
lrwx------  1 root root 64 Nov 27 13:29 2 -> /dev/pts/0
lr-x------  1 root root 64 Nov 27 13:29 3 -> /proc/net (deleted)
lr-x------  1 root root 64 Nov 27 13:29 4 -> /proc/4482/fd
# ~/a.out .
total 0
lrwx------  1 root root 64 Nov 27 13:32 0 -> /dev/pts/0
lrwx------  1 root root 64 Nov 27 13:32 1 -> /dev/pts/0
lrwx------  1 root root 64 Nov 27 13:32 2 -> /dev/pts/0
lr-x------  1 root root 64 Nov 27 13:32 3 -> /proc/net/stat
lr-x------  1 root root 64 Nov 27 13:32 4 -> /proc/4488/fd

Bad thing is that . when cdir is /proc/net and .. when cdir is
anything under /proc/net (i.e. the /proc/net itself) is marked as "(deleted)".

[snip]

Thanks,
Pavel
