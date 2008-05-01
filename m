Return-Path: <linux-kernel-owner+w=401wt.eu-S1762917AbYEAPtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762917AbYEAPtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758336AbYEAPtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:49:11 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:51089 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760092AbYEAPtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:49:09 -0400
X-Greylist: delayed 813 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 May 2008 11:49:08 EDT
Message-ID: <4819E316.7000607@krogh.cc>
Date: Thu, 01 May 2008 17:34:46 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Many open/close on same files yeilds "No such file or directory".
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list.

I have a "fairly" reproducible problem. When a program opens and closes
the same file many times, it eventually ends up with a "no such file or
directory". Test program that can reproduce the problem on my setup:

root@hest:~# cat test-file-c.c
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    unsigned long i=0;
    int fh;
    char *filename;

    filename=argv[1];

    while(1) {
       fh=open(filename, O_RDONLY);
       if (fh==-1) {
          printf("Failed to open %s\n", filename);
          printf("Open number: %ld\n",i);
          exit(10);
       }
       close(fh);
       i++;
    }

    exit(0);
}
root@hest:~# ./test-file-c /z/bio/databases/online/index/index-by-accno
Failed to open /z/bio/databases/online/index/index-by-accno
Open number: 61785000
root@hest:~# ./test-file-c /z/bio/databases/online/index/index-by-accno
Failed to open /z/bio/databases/online/index/index-by-accno
Open number: 120929685
(The problem is not isolate to a single file on the filesystem).


strace on the program reviel that the system indeed return a "No such
file or directory" to the program.

This is run on an Ubuntu Gutsy (vendor kernel): 2.6.22-14-server on an
4.5TB ext3 filesystem on an LVM volume. The volume was created on a
dapper (2 releases back) and has just followed with during upgrades.
I cannot reproduce it on other disks attached to the same server or on
other servers attached to similar disksystems.

The filesystem was taken offline yesterday for a forced fsck and it was
found to be clean.

The diskarray is a quite old Fibrenetix FX1200 with 12xPATA disk
in raid5 (with hotspare) exposed to the OS as 3 SCSI-disks of
2+2+0.5TB assembled with LVM afterwards. The SCSI-controller is a:
05:08.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X 
Fusion-MPT Dual Ultra320 SCSI (rev c1)

What suggestions do you have to solve this problem?

I'm about to mkfs.ext3 the volume and spool it back in from the backup,
but somehow I'm not convinced that it will solve the problem at all.
It may just be a hardware problem, but dmesg doesnt tell anything.

We actually got the problem from a perl-script, but this seems to be the
minimal program that reproduces the problem.

Jesper
-- 
Jesper


