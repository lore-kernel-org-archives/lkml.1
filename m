Return-Path: <linux-kernel-owner+w=401wt.eu-S1757895AbYEBFkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbYEBFkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 01:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYEBFjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 01:39:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752461AbYEBFjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 01:39:53 -0400
Date: Thu, 1 May 2008 22:39:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Krogh <jesper@krogh.cc>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Many open/close on same files yeilds
 "No such file or directory".
Message-Id: <20080501223938.921f7cd2.akpm@linux-foundation.org>
In-Reply-To: <4819E316.7000607@krogh.cc>
References: <4819E316.7000607@krogh.cc>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 May 2008 17:34:46 +0200 Jesper Krogh <jesper@krogh.cc> wrote:

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
>     unsigned long i=0;
>     int fh;
>     char *filename;
> 
>     filename=argv[1];
> 
>     while(1) {
>        fh=open(filename, O_RDONLY);
>        if (fh==-1) {
>           printf("Failed to open %s\n", filename);
>           printf("Open number: %ld\n",i);
>           exit(10);
>        }
>        close(fh);
>        i++;
>     }
> 
>     exit(0);
> }
> root@hest:~# ./test-file-c /z/bio/databases/online/index/index-by-accno
> Failed to open /z/bio/databases/online/index/index-by-accno
> Open number: 61785000
> root@hest:~# ./test-file-c /z/bio/databases/online/index/index-by-accno
> Failed to open /z/bio/databases/online/index/index-by-accno
> Open number: 120929685
> (The problem is not isolate to a single file on the filesystem).
> 

What an amazing bug.

> strace on the program reviel that the system indeed return a "No such
> file or directory" to the program.
> 
> This is run on an Ubuntu Gutsy (vendor kernel): 2.6.22-14-server on an
> 4.5TB ext3 filesystem on an LVM volume. The volume was created on a
> dapper (2 releases back) and has just followed with during upgrades.

The test program is (almost) all in RAM and won't care about the hardware.

> I cannot reproduce it on other disks attached to the same server or on
> other servers attached to similar disksystems.

hmm.

I guess it would be interesting to remount that filesystem with `noatime'
to eliminate the last bit of I/O and block-=realted code.

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

I'd suspect that after 1e8 loops your CPU got too hot and started to
misbehave.
