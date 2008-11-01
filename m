Return-Path: <linux-kernel-owner+w=401wt.eu-S1752983AbYKANk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbYKANk1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 09:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbYKANkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 09:40:15 -0400
Received: from rtr.ca ([76.10.145.34]:35650 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbYKANkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 09:40:14 -0400
Message-ID: <490C5C64.2060609@rtr.ca>
Date: Sat, 01 Nov 2008 09:40:52 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Sarangi_Santosh@emc.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: ioctl (HDIO_GETGEO) on partition
References: <A68C75D82BABF64AB13A6AC1875BF275052D707A@CORPUSMX10B.corp.emc.com>
In-Reply-To: <A68C75D82BABF64AB13A6AC1875BF275052D707A@CORPUSMX10B.corp.emc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sarangi_Santosh@emc.com wrote:
> Hi,
> I am into a problem where the ioctl (HDIO_GETGEO) if failing on a device
> partition(ex: /dev/emcpowerg1), which is working fine for full device (
> ex: /dev/emcpowerg).
> Basically I am trying to get start offset of the device partition
> (hd_geometry.start).
> The host information where I am seeing the above problem is as follows:
> 
> Linux ampersandmex01 2.6.18-53.el5PAE #1 SMP Wed Oct 10 16:48:18 EDT
> 2007 i686 i686 i386 GNU/Linux 
> 
> Red Hat Enterprise Linux Server release 5.1 (Tikanga)
> 
> 
> Can anyone suggest if there is any patch available, so that the problem
> can be resolved ?
> If the patch is not available, then is there any other way, I can get
> the above information without using  the ioctl (HDIO_GETGEO) ?
> 
> I am pasting the code snip set below for your reference.
> 
> Thanks,
> -Santosh
> 
> <code snip>
>   int                  fd;
>   int                  sts;
>   struct hd_geometry   hd_geometry_rec;
>   unsigned int                offset;
> 
>   
>   if ((fd = open(p_ppdevname, O_RDONLY | O_NONBLOCK)) < 0)
>     {
>         return OS_SYSTEM_CALL_FAILED;
>     }
>   if ((sts = ioctl(fd, HDIO_GETGEO, &hd_geometry_rec)) < 0) ------->
> ioctl((HDIO_GETGEO)  is failing for device partition (/dev/emcpowerg1)
>     {
>       close(fd);
>       return OS_SYSTEM_CALL_FAILED;
>     }
>   offset = (unsigned int) hd_geometry_rec.start;
..

The code should try HDIO_GETGEO_BIG before falling back to HDIO_GETGEO.
But neither will work for LARGE drives (>= 2TB) on 32-bit systems,
so the code really should try sysfs for this info before using the ioctls.

Sample code to do this correctly is in the geom.c file of recent hdparm
source code packages from sourceforge.

Cheers
