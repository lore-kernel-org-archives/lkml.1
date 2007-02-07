Return-Path: <linux-kernel-owner+w=401wt.eu-S1161400AbXBGReR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161400AbXBGReR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 12:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965689AbXBGReR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 12:34:17 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:3917 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965541AbXBGReQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 12:34:16 -0500
Date: Wed, 7 Feb 2007 18:34:14 +0100
From: Olivier Galibert <galibert@pobox.com>
To: "Hack inc." <linux-kernel@vger.kernel.org>, autofs@linux.kernel.org
Subject: Bad race condition in the new autofs protocol somewhere
Message-ID: <20070207173414.GA64492@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	"Hack inc." <linux-kernel@vger.kernel.org>, autofs@linux.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The setup:
  /people is a NIS automount.  /people/gadda points to m179:/disk05/disk11/gadda
  /hosts is a two-level automount, /hosts/xx/yy points to xx:/yy using:

in auto.master:
  /hosts file:/etc/auto.hosts

in /etc/auto.hosts:
  * -fstype=autofs,-Dhost=& file=/etc/auto.hosts.sub

in /etc/auto.hosts.sub:
  * ${host}:/&

/people/gadda/normalisation is a symlink to /hosts/m179/disk03/gadda/lemonde

I have a small test program:

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <time.h>
#include <unistd.h>

int main(void)
{
  for(;;) {
    struct timeval tv1, tv2;
    struct timespec ts;
    gettimeofday(&tv1, 0);
    int fd = open("/people/gadda/normalisation/tempo4.general", O_RDONLY);
    gettimeofday(&tv2, 0);
    if(fd < 0)
      printf("%d.%06d - %d.%06d failure\n", (int)tv1.tv_sec, (int)tv1.tv_usec, (int)tv2.tv_sec, (int)tv2.tv_usec);
    else
      close(fd);

    ts.tv_sec = 0;
    ts.tv_nsec = lrand48() % 100000;
    nanosleep(&ts, 0);    
  }
}

I.e. try opening an existing file "through" the symlink and the
automounts, give the time before and after the open syscall if it
fails.  Wait for a random time no more than 0.1s and try again.

Actually the random time is no more than 0.1ms, oops.  Whatever.

Then I start the automounter with a 1 second timeout, and I get random
failures.

1170867758.212109 - 1170867758.222789 failure
1170867758.668086 - 1170867758.678607 failure
1170867760.007998 - 1170867760.057324 failure

The log from an extra-verbose, but otherwise unchanged, git-of-today
version of autofs is:

Feb  7 18:02:24 m78 automount[16532]: Starting automounter version 5.0.1-rc3, master map auto.master
Feb  7 18:02:24 m78 automount[16532]: using kernel protocol version 5.00
Feb  7 18:02:24 m78 automount[16532]: mounted indirect mount on /hosts with timeout 1, freq 1 seconds
Feb  7 18:02:24 m78 automount[16532]: mounted indirect mount on /people with timeout 1, freq 1 seconds
Feb  7 18:02:24 m78 automount[16532]: mounted indirect mount on /corpora with timeout 1, freq 1 seconds
Feb  7 18:02:24 m78 automount[16532]: mounted indirect mount on /w3 with timeout 1, freq 1 seconds
Feb  7 18:02:24 m78 automount[16532]: mounted indirect mount on /vol with timeout 1, freq 1 seconds
Feb  7 18:02:33 m78 automount[16532]: 1170867753.258726 got packet type 3
Feb  7 18:02:33 m78 automount[16532]: attempting to mount entry /people/gadda
Feb  7 18:02:33 m78 automount[16532]: mount(nfs): mounted m179:/disk05/disk11/gadda on /people/gadda
Feb  7 18:02:33 m78 automount[16532]: mounted /people/gadda
Feb  7 18:02:33 m78 automount[16532]: 1170867753.355598 got packet type 3
Feb  7 18:02:33 m78 automount[16532]: attempting to mount entry /hosts/m179
Feb  7 18:02:33 m78 automount[16532]: mounted indirect mount on /hosts/m179 with timeout 1, freq 1 seconds
Feb  7 18:02:33 m78 automount[16532]: mounted /hosts/m179
Feb  7 18:02:33 m78 automount[16532]: 1170867753.456997 got packet type 3
Feb  7 18:02:33 m78 automount[16532]: attempting to mount entry /hosts/m179/disk03
Feb  7 18:02:33 m78 automount[16532]: mount(nfs): mounted m179:/disk03 on /hosts/m179/disk03
Feb  7 18:02:33 m78 automount[16532]: mounted /hosts/m179/disk03
Feb  7 18:02:35 m78 automount[16532]: mount still busy /people
Feb  7 18:02:35 m78 automount[16532]: mount still busy /hosts/m179
Feb  7 18:02:36 m78 automount[16532]: mount still busy /hosts
Feb  7 18:02:37 m78 automount[16532]: mount still busy /people
Feb  7 18:02:38 m78 automount[16532]: 1170867758.212137 got packet type 4
Feb  7 18:02:38 m78 automount[16532]: 1170867758.212282 expiring path /people/gadda
Feb  7 18:02:38 m78 automount[16532]: 1170867758.212983 unmounting dir = /people/gadda
Feb  7 18:02:38 m78 automount[16532]: 1170867758.222742 expired /people/gadda
Feb  7 18:02:38 m78 automount[16532]: 1170867758.224147 got packet type 3
Feb  7 18:02:38 m78 automount[16532]: attempting to mount entry /people/gadda
Feb  7 18:02:38 m78 automount[16532]: mount(nfs): mounted m179:/disk05/disk11/gadda on /people/gadda
Feb  7 18:02:38 m78 automount[16532]: mounted /people/gadda
Feb  7 18:02:38 m78 automount[16532]: 1170867758.668221 got packet type 4
Feb  7 18:02:38 m78 automount[16532]: 1170867758.668379 expiring path /hosts/m179/disk03
Feb  7 18:02:38 m78 automount[16532]: 1170867758.669053 unmounting dir = /hosts/m179/disk03
Feb  7 18:02:38 m78 automount[16532]: 1170867758.678567 expired /hosts/m179/disk03
Feb  7 18:02:38 m78 automount[16532]: 1170867758.680159 got packet type 3
Feb  7 18:02:38 m78 automount[16532]: attempting to mount entry /hosts/m179/disk03
Feb  7 18:02:38 m78 automount[16532]: mount(nfs): mounted m179:/disk03 on /hosts/m179/disk03
Feb  7 18:02:38 m78 automount[16532]: mounted /hosts/m179/disk03
Feb  7 18:02:38 m78 automount[16532]: mount still busy /hosts/m179
Feb  7 18:02:39 m78 automount[16532]: mount still busy /people
Feb  7 18:02:39 m78 automount[16532]: mount still busy /hosts
Feb  7 18:02:40 m78 automount[16532]: 1170867760.004392 got packet type 4
Feb  7 18:02:40 m78 automount[16532]: 1170867760.004561 expiring path /people/gadda
Feb  7 18:02:40 m78 automount[16532]: 1170867760.005341 unmounting dir = /people/gadda
Feb  7 18:02:40 m78 automount[16532]: 1170867760.057275 expired /people/gadda
Feb  7 18:02:40 m78 automount[16532]: 1170867760.060045 got packet type 3
Feb  7 18:02:40 m78 automount[16532]: attempting to mount entry /people/gadda
Feb  7 18:02:40 m78 automount[16532]: mount(nfs): mounted m179:/disk05/disk11/gadda on /people/gadda
Feb  7 18:02:40 m78 automount[16532]: mounted /people/gadda
Feb  7 18:02:41 m78 automount[16532]: 1170867761.200013 got packet type 4
Feb  7 18:02:41 m78 automount[16532]: 1170867761.200177 expiring path /people/gadda
Feb  7 18:02:41 m78 automount[16532]: 1170867761.200877 unmounting dir = /people/gadda
Feb  7 18:02:41 m78 automount[16532]: 1170867761.210517 expired /people/gadda
Feb  7 18:02:41 m78 automount[16532]: 1170867761.687942 got packet type 4
Feb  7 18:02:41 m78 automount[16532]: 1170867761.688101 expiring path /hosts/m179/disk03
Feb  7 18:02:41 m78 automount[16532]: 1170867761.688816 unmounting dir = /hosts/m179/disk03
Feb  7 18:02:41 m78 automount[16532]: 1170867761.698293 expired /hosts/m179/disk03
Feb  7 18:02:42 m78 automount[16532]: mount still busy /hosts
Feb  7 18:02:43 m78 automount[16532]: mount still busy /hosts
Feb  7 18:02:44 m78 automount[16532]: umounted indirect mount /hosts/m179
Feb  7 18:02:44 m78 automount[16532]: shut down path /hosts/m179

So we can see that the requests fail from losing either of the
mountpoints and having a race between the umount, the remount and the
open.

Kernel is fedora core 5 2.6.18-2200.fc5.  I can reproduce the problem
at will and in a very short time, and m78 is currently dedicated to
fixing it, so what should I do at that point?

Note that autofs4 fails too on that race, but my guess is that autofs5
has a higher probability of being fixed.

  OG.

