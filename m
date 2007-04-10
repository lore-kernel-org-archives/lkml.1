Return-Path: <linux-kernel-owner+w=401wt.eu-S1030468AbXDJHJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030468AbXDJHJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 03:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030470AbXDJHJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 03:09:20 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33269 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030468AbXDJHJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 03:09:19 -0400
Message-ID: <461B3806.3010103@garzik.org>
Date: Tue, 10 Apr 2007 03:08:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Robin Holt <holt@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>	 <4616CBF0.7090606@garzik.org>	 <20070409172339.48d661d6.akpm@linux-foundation.org>	 <20070410015912.GE1994@redhat.com>	 <20070409193056.6b52c354.akpm@linux-foundation.org> <64bb37e0704092309v49ae1ddbvb22e3f213ccab28e@mail.gmail.com>
In-Reply-To: <64bb37e0704092309v49ae1ddbvb22e3f213ccab28e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Torsten Kaiser wrote:
> One thread per port, not per device.
> 
>  796 ?        S      0:00  \_ [scsi_eh_0]
>  797 ?        S      0:00  \_ [scsi_eh_1]
>  798 ?        S      0:00  \_ [scsi_eh_2]
>  819 ?        S      0:00  \_ [scsi_eh_3]
>  820 ?        S      0:00  \_ [scsi_eh_4]
>  824 ?        S      0:00  \_ [scsi_eh_5]
>  825 ?        S      0:14  \_ [scsi_eh_6]
> 
> bardioc ~ # lsscsi -d
> [0:0:0:0]    disk    ATA      ST3160827AS      3.42  /dev/sda[8:0]
> [1:0:0:0]    disk    ATA      ST3160827AS      3.42  /dev/sdb[8:16]
> [5:0:0:0]    disk    ATA      IBM-DHEA-36480   HE8O  /dev/sdc[8:32]
> [5:0:1:0]    disk    ATA      Maxtor 6L160P0   BAH4  /dev/sdd[8:48]
> [6:0:0:0]    cd/dvd  HL-DT-ST DVDRAM GSA-4081B A100  /dev/sr0[11:0]
> bardioc ~ # lsscsi -H
> [0]    sata_promise
> [1]    sata_promise
> [2]    sata_promise
> [3]    sata_via
> [4]    sata_via
> [5]    pata_via
> [6]    pata_via
> 
> The bad is, that there is always a thread, even if the hardware is not
> even hotplug capable.
> Don't know if the thread is even needed for hotplug...

Nope, it's not.  At least for SATA (your chosen examples), hotplug is 
handled by a libata-specific thread.

The SCSI EH threads are there purely for SCSI exception handling.  For 
the majority of SAS and SATA, we replace the entire SCSI EH handling 
code with our own, making those threads less useful than on older (read: 
majority) of SCSI drivers.

	Jeff


