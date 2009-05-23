Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbZEWXyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbZEWXyc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 19:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbZEWXyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 19:54:25 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:33142 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbZEWXyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 19:54:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=v7z0zCpxwSMp+ceUXPilPtC5V3KrKocX3/Adi8bRmlcOwVKhlAYCuJlMna3/nGW10Z
         gDVGViJHTxyA2orT64wyYljSWQEUGOHNa1JSPYr1SGz5Ase6K01wT+EK9XHcoa55TM1o
         03u7pKC0DIpL6KHN5+kKCmvErrTgJjH1Q3FJU=
Message-ID: <4A188CAD.1080009@googlemail.com>
Date: Sun, 24 May 2009 00:54:21 +0100
From: Ken Milmore <ken.milmore@googlemail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Neil Brown <neilb@suse.de>
Subject: Write barriers on MD RAID1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Support for write barriers on MD RAID1 devices appears to be broken on 
2.6.29 and later kernels.  Mounting an ext3 or ext4 filesystem over an 
md raid1 block device gives the kernel message:

   JBD: barrier-based sync failed on md0 - disabling barriers

Is this intentional?  It looks like a regression to me, since write 
barriers (ostensibly) worked for MD RAID1 on earlier kernels (well, all 
of the 2.6.27 series at least...)

Doing a git bisect suggested that this is the culprit:

commit cec0707e40ae25794b5a2de7b7f03c51961f80d9
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Tue Jan 13 15:28:32 2009 +0100

     block: silently error an unsupported barrier bio

Rolling this back from 2.6.29.4 made the JBD error message go away for 
me.  I tried to do some disk benchmarking to determine if write barriers 
were really still working, but the results were not very conclusive.

Details of test setup:
- 2.6.29.4 kernel (config from slackware-current)
- ext3 filesystem (mounted with barrier=1), also tried ext4
- MD RAID1 block device over two SATA disks
- Intel motherboard AHCI controller (82801)

I got similar behaviour on a virtualised setup using qemu, with the RAID 
over two emulated IDE disks.

Please contact me if I can provide any further information.

-Ken Milmore.

