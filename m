Return-Path: <linux-kernel-owner+w=401wt.eu-S1765363AbYEIFXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765363AbYEIFXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 01:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757156AbYEIFXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 01:23:06 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:36563 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760171AbYEIFXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 01:23:01 -0400
Message-ID: <4823DFA6.9010504@krogh.cc>
Date: Fri, 09 May 2008 07:22:46 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Many open/close on same files yeilds "No such file or directory".
References: <4819E316.7000607@krogh.cc>
In-Reply-To: <4819E316.7000607@krogh.cc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

A week has passed the problem still persist and I have done a fair 
amount of testing.

I have now been able to reproduce it on 2 different servers, a 
dual-core,8 cpu Sun X4600 amd64 and a 2 cpu single-core Sun V20Z.

It has been reproduced against 4 different diskarrays one of them being
the IDE-SCSI(We have 2 of them) array mentioned before. The other one is
an iSCSI SAN. And lately when trying to move of the "trouble systems" we
hit the bug on a FC-SAN.

I belive that we can rule out hardware now.

I have both reproduced it on "old" ext3 volumes and freshly created
ones.

I havent been able to reproduce it on the internal system disks of
the servers, but thinking a bit more about the setup it seems that
the filesystem need to have a significant load on the
filesystem-structures (not data) to exploit the bug. The typical
environment where I found it was serving (the same) ~5GB of files of the
NFS-server to 48 dual-core machines, this bacically never hits the
actual disk (with 32GB of ram in the machine). In this setup
a single process could hit the bug on the server (the problem could
also be seen over NFS from the clients).

It is worth keeping in mind that the problem is "rare". Thus all
applications only opening and reading a single file every 10 minutes
or so probably never hits it.

Altering the test-script so it just tries again to pick up the file,
it succeeds on the second pass.

 From my perspective this defininately has something to do with how the
OS caches/invalidates the filesystem structures it has in memory (or
somewhere near that).

I still haven't been able to produce a small pack-and-shit test that
knocks the problem out on every system. But please come with suggestions
about how to write a piece of code that tries to hit the problem from
my descriptions.

My feeling is that the script below may reveal the bug on any "busy" 
volume, where busy is lots of activity in the OS-cache of the volume,
not on the actual drives.

All suggestions are welcome.

I have tried 4 different kernel versions:
2.6.20, 2.6.22, 2.6.24, 2.6.25.2

Jesper

Jesper Krogh wrote:
> Hi list.
> 
> I have a "fairly" reproducible problem. When a program opens and closes
> the same file many times, it eventually ends up with a "no such file or
> directory". Test program that can reproduce the problem on my setup:
> 
> root@hest:~# cat test-file-c.c
> #include <stdlib.h>
> #include <stdio.h>
> #include <fcntl.h>
> #include <unistd.h>
> 
> int main(int argc, char *argv[]) {
>    unsigned long i=0;
>    int fh;
>    char *filename;
> 
>    filename=argv[1];
> 
>    while(1) {
>       fh=open(filename, O_RDONLY);
>       if (fh==-1) {
>          printf("Failed to open %s\n", filename);
>          printf("Open number: %ld\n",i);
>          exit(10);
>       }
>       close(fh);
>       i++;
>    }
> 
>    exit(0);
> }
> root@hest:~# ./test-file-c /z/bio/databases/online/index/index-by-accno
> Failed to open /z/bio/databases/online/index/index-by-accno
> Open number: 61785000
> root@hest:~# ./test-file-c /z/bio/databases/online/index/index-by-accno
> Failed to open /z/bio/databases/online/index/index-by-accno
> Open number: 120929685
> (The problem is not isolate to a single file on the filesystem).
> 
> 
> strace on the program reviel that the system indeed return a "No such
> file or directory" to the program.
> 
> This is run on an Ubuntu Gutsy (vendor kernel): 2.6.22-14-server on an
> 4.5TB ext3 filesystem on an LVM volume. The volume was created on a
> dapper (2 releases back) and has just followed with during upgrades.
> I cannot reproduce it on other disks attached to the same server or on
> other servers attached to similar disksystems.
> 
> The filesystem was taken offline yesterday for a forced fsck and it was
> found to be clean.
> 
> The diskarray is a quite old Fibrenetix FX1200 with 12xPATA disk
> in raid5 (with hotspare) exposed to the OS as 3 SCSI-disks of
> 2+2+0.5TB assembled with LVM afterwards. The SCSI-controller is a:
> 05:08.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X 
> Fusion-MPT Dual Ultra320 SCSI (rev c1)
> 
> What suggestions do you have to solve this problem?
> 
> I'm about to mkfs.ext3 the volume and spool it back in from the backup,
> but somehow I'm not convinced that it will solve the problem at all.
> It may just be a hardware problem, but dmesg doesnt tell anything.
> 
> We actually got the problem from a perl-script, but this seems to be the
> minimal program that reproduces the problem.
> 
> Jesper

