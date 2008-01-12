Return-Path: <linux-kernel-owner+w=401wt.eu-S932230AbYALBHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbYALBHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 20:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762559AbYALBHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 20:07:35 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:8244 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762582AbYALBHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 20:07:33 -0500
Date: Fri, 11 Jan 2008 19:07:21 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: fixed a bug of adma in rhel4u5 with HDS7250SASUN500G.
In-reply-to: <15F501D1A78BD343BE8F4D8DB854566B1BFE2ABF@hkemmail01.nvidia.com>
To: Kuan Luo <kluo@nvidia.com>
Cc: Tejun Heo <htejun@gmail.com>, Mark Lord <liml@rtr.ca>,
       Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Allen Martin <AMartin@nvidia.com>, Peer Chen <pchen@nvidia.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <478812C9.1000901@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <4781F008.9070404@gmail.com> <4782422C.8020202@rtr.ca>
 <4782B73B.8080309@shaw.ca> <4782BC48.4000309@gmail.com>
 <4782C008.3030902@shaw.ca> <4782CB62.7040901@gmail.com>
 <4782CEF9.3040708@gmail.com> <4782DFFE.50301@shaw.ca>
 <4782E5A8.9010305@gmail.com> <4782E63E.1000606@gmail.com>
 <4782E78F.9050205@shaw.ca> <4782E912.1050204@gmail.com>
 <4783493A.7070800@gmail.com> <47838B57.8020407@shaw.ca>
 <47842A54.2060107@gmail.com> <47842ABA.2060605@gmail.com>
 <47844471.4070705@shaw.ca> <47845708.6060900@gmail.com>
 <478567D8.10601@shaw.ca>
 <15F501D1A78BD343BE8F4D8DB854566B1BFE2ABF@hkemmail01.nvidia.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kuan Luo wrote:
> hi robert,
> 	I have fixed a bug in rhel4u5 2.6.9-55 when running adma mode
> with HDS7250SASUN500G.
> 	Could you check this code and if no problem,  then help me to
> submit to the newest kernel.
> 

What problem does this resolve? I tested it against the cache flush/NCQ 
write switching problem we've been trying to solve, and it doesn't look 
like it fixes that one - if I apply this patch and then remove the 
udelay(20) in sata_nv.c that I added which prevented me from seeing this 
problem before, it shows up.

If you want to try and reproduce that problem, you can take out this 
udelay(20) from the current version:

if (curr_ncq != pp->last_issue_ncq) {
	/* Seems to need some delay before switching between NCQ and
	   non-NCQ commands, else we get command timeouts and such. */
	udelay(20);
	pp->last_issue_ncq = curr_ncq;
}

then run 2 instances of this C program, with different output files as 
the argument:

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char* argv[])
{
	int i;
	int fd = open( argv[1], O_WRONLY | O_CREAT | O_TRUNC, S_IRUSR | S_IWUSR);
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
	
and one instance of this:

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
