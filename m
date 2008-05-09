Return-Path: <linux-kernel-owner+w=401wt.eu-S934534AbYEIFgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934534AbYEIFgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 01:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934268AbYEIFgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 01:36:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933484AbYEIFgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 01:36:40 -0400
Date: Thu, 8 May 2008 22:36:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Krogh <jesper@krogh.cc>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Many open/close on same files yeilds
 "No such file or directory".
Message-Id: <20080508223635.523b8fa7.akpm@linux-foundation.org>
In-Reply-To: <4823DFA6.9010504@krogh.cc>
References: <4819E316.7000607@krogh.cc>
	<4823DFA6.9010504@krogh.cc>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 May 2008 07:22:46 +0200 Jesper Krogh <jesper@krogh.cc> wrote:

> Hi.
> 
> A week has passed the problem still persist and I have done a fair 
> amount of testing.
> 
> I have now been able to reproduce it on 2 different servers, a 
> dual-core,8 cpu Sun X4600 amd64 and a 2 cpu single-core Sun V20Z.
> 
> It has been reproduced against 4 different diskarrays one of them being
> the IDE-SCSI(We have 2 of them) array mentioned before. The other one is
> an iSCSI SAN. And lately when trying to move of the "trouble systems" we
> hit the bug on a FC-SAN.
> 
> I belive that we can rule out hardware now.
> 
> I have both reproduced it on "old" ext3 volumes and freshly created
> ones.
> 
> I havent been able to reproduce it on the internal system disks of
> the servers, but thinking a bit more about the setup it seems that
> the filesystem need to have a significant load on the
> filesystem-structures (not data) to exploit the bug. The typical
> environment where I found it was serving (the same) ~5GB of files of the
> NFS-server to 48 dual-core machines, this bacically never hits the
> actual disk (with 32GB of ram in the machine). In this setup
> a single process could hit the bug on the server (the problem could
> also be seen over NFS from the clients).
> 
> It is worth keeping in mind that the problem is "rare". Thus all
> applications only opening and reading a single file every 10 minutes
> or so probably never hits it.
> 
> Altering the test-script so it just tries again to pick up the file,
> it succeeds on the second pass.
> 
>  From my perspective this defininately has something to do with how the
> OS caches/invalidates the filesystem structures it has in memory (or
> somewhere near that).
> 
> I still haven't been able to produce a small pack-and-shit test that
> knocks the problem out on every system. But please come with suggestions
> about how to write a piece of code that tries to hit the problem from
> my descriptions.

It's weird.

> My feeling is that the script below may reveal the bug on any "busy" 
> volume, where busy is lots of activity in the OS-cache of the volume,
> not on the actual drives.

By this do you mean that there has to be a lot of other activity on the
system to reproduce it?  Stuff which is turning over memory?

Because one possiblity is that the cached dentry got reclaimed by memory
pressure and we have some race bug which causes us to think that the file
doesn't exist.

(That still shouldn't happen because the dentry should be marked
recently-accessed, but perhaps the underlying inode gets reclaimed or
something.  Grasping at straws here)

> All suggestions are welcome.
> 
> I have tried 4 different kernel versions:
> 2.6.20, 2.6.22, 2.6.24, 2.6.25.2
> 
> Jesper
> 
> Jesper Krogh wrote:
> > Hi list.
> > 
> > I have a "fairly" reproducible problem. When a program opens and closes
> > the same file many times, it eventually ends up with a "no such file or
> > directory". Test program that can reproduce the problem on my setup:
> > 
> > root@hest:~# cat test-file-c.c
> > #include <stdlib.h>
> > #include <stdio.h>
> > #include <fcntl.h>
> > #include <unistd.h>
> > 
> > int main(int argc, char *argv[]) {
> >    unsigned long i=0;
> >    int fh;
> >    char *filename;
> > 
> >    filename=argv[1];
> > 
> >    while(1) {
> >       fh=open(filename, O_RDONLY);
> >       if (fh==-1) {
> >          printf("Failed to open %s\n", filename);
> >          printf("Open number: %ld\n",i);
> >          exit(10);
> >       }
> >       close(fh);
> >       i++;
> >    }
> > 
> >    exit(0);
> > }

gee.
