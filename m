Return-Path: <linux-kernel-owner+w=401wt.eu-S932268AbYALBLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268AbYALBLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 20:11:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932095AbYALBK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 20:10:56 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:33478 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091AbYALBKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 20:10:54 -0500
Date: Fri, 11 Jan 2008 19:10:15 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv + ADMA + Samsung disk problem
In-reply-to: <20080111231813.GB7052@boogie.lpds.sztaki.hu>
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Allen Martin <AMartin@nvidia.com>, Mark Lord <lkml@rtr.ca>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Kuan Luo <kluo@nvidia.com>, Peer Chen <pchen@nvidia.com>
Message-id: <47881377.4070508@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <477B0429.7040909@gmail.com> <477B0CFD.1030603@shaw.ca>
 <F72FA20C31DD4F4C997B91C5B3690A09505577@hqemmail07.nvidia.com>
 <477BDEA5.8040701@garzik.org>
 <F72FA20C31DD4F4C997B91C5B3690A0950557D@hqemmail07.nvidia.com>
 <477C2A99.9010208@shaw.ca> <477C61D3.30009@rtr.ca> <477C6A85.9020607@shaw.ca>
 <F72FA20C31DD4F4C997B91C5B3690A09505598@hqemmail07.nvidia.com>
 <4782BF75.9040803@shaw.ca> <20080111231813.GB7052@boogie.lpds.sztaki.hu>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabor Gombas wrote:
> On Mon, Jan 07, 2008 at 06:10:29PM -0600, Robert Hancock wrote:
> 
>> Gabor, I just noticed you said that it worked OK in 2.6.20, yet 2.6.22  
>> fails. 2.6.20 had ADMA support as well, so I wonder what change started  
>> causing the problem. Would it be possible for you to do a git bisect (or  
>> at least try 2.6.21 to try and narrow it down)?
> 
> I've now booted 2.6.21.7, we'll see. The problem with the bisection is
> that I can't explicitely trigger the bug so I can't say for sure if a
> kernel is good or it is just needs more time to trigger. The average
> uptime of this machine is just a couple hours a day.
> 
> For example, with 2.6.24-rc6 it took over 3 hours for the first disk to
> trigger the bug and the second disk needed more than 7 hours. This
> machine is seldom turned on for that long.

If you want to try to reproduce the problem more rapidly, you can try 
the recipe I just suggested to the NVIDIA guys:

Run 2 instances of this C program, with different output files as the 
argument, i.e. save this to fsynctest.c, and do
gcc fsynctest.c -o fsynctest
./fsynctest testfile & ./fsynctest testfile2 &

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char* argv[])
{
     int i;
     int fd = open( argv[1], O_WRONLY | O_CREAT | O_TRUNC, S_IRUSR | 
S_IWUSR);
     if(fd == -1)
     {
         perror("open");
         return 1;
     }
     for(i=0;i<1000000;i++)
     {
         int rc = write(fd, "0", 1);
         if( rc != 1 )
         {
             perror("write");
             return 2;
         }
         rc = fsync(fd);
         if(rc)
         {
             perror("fsync");
             return 2;
         }
     }
     return 0;
}

Also run one instance of this:

dd if=/dev/zero of=blankfile bs=512 count=100000 oflag=direct

and one of this:

while /bin/true; do sdparm --command=sync /dev/sdb; done

all at the same time. In my experience, it helps to disable cpufreq (on 
Red Hat/Fedora, /sbin/service cpuspeed stop) to force the CPU to run at 
max frequency all the time. After a few minutes I got this:

ata4: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000 
status 0x400 next cpb count 0x2 next cpb idx 0x0
ata4: CPB 0: ctl_flags 0x1f, resp_flags 0x0
ata4: CPB 1: ctl_flags 0x1f, resp_flags 0x0
ata4: CPB 2: ctl_flags 0x1f, resp_flags 0x0
ata4: timeout waiting for ADMA IDLE, stat=0x400
ata4: timeout waiting for ADMA LEGACY, stat=0x400
ata4.00: exception Emask 0x0 SAct 0x7 SErr 0x0 action 0x2 frozen
ata4.00: cmd 61/08:00:e0:74:64/00:00:0a:00:00/40 tag 0 ncq 4096 out
          res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata4.00: status: { DRDY }
ata4.00: cmd 61/08:08:30:5b:76/00:00:0c:00:00/40 tag 1 ncq 4096 out
          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata4.00: status: { DRDY }
ata4.00: cmd 61/01:10:ba:51:77/00:00:0c:00:00/40 tag 2 ncq 512 out
          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata4.00: status: { DRDY }
ata4: soft resetting link
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: configured for UDMA/133
ata4: EH complete

