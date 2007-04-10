Return-Path: <linux-kernel-owner+w=401wt.eu-S1030367AbXDJGJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030367AbXDJGJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 02:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030369AbXDJGJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 02:09:59 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:38943 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030367AbXDJGJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 02:09:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CjVlTYQB+zMW08dlWHecKvDzO4FHmFxXmFg5xlvLMsUFoFBKdTMa3OVNHsRcr8bKQIC6Uoa3WP/AbyXL/pXc8lMXYgZXGU30jwYeUsG+lLt8qwjgq1Q+8fCIdfk+kjPbGsYyLGeL4EUFC+ngfdlfEkbAVBssw34etqlnb8yhJeo=
Message-ID: <64bb37e0704092309v49ae1ddbvb22e3f213ccab28e@mail.gmail.com>
Date: Tue, 10 Apr 2007 08:09:55 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: init's children list is long and slows reaping children.
Cc: "Dave Jones" <davej@redhat.com>, "Jeff Garzik" <jeff@garzik.org>,
       "Robin Holt" <holt@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Jack Steiner" <steiner@americas.sgi.com>
In-Reply-To: <20070409193056.6b52c354.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>
	 <4616CBF0.7090606@garzik.org>
	 <20070409172339.48d661d6.akpm@linux-foundation.org>
	 <20070410015912.GE1994@redhat.com>
	 <20070409193056.6b52c354.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> : root       299  0.0  0.0      0     0 ?        S    18:51   0:00 [scsi_eh_0]
> : root       300  0.0  0.0      0     0 ?        S    18:51   0:00 [scsi_eh_1]
> : root       305  0.0  0.0      0     0 ?        S    18:51   0:00 [scsi_eh_2]
> : root       306  0.0  0.0      0     0 ?        S    18:51   0:00 [scsi_eh_3]
>
> This machine has one CPU, one sata disk and one DVD drive.  The above is
> hard to explain.

One thread per port, not per device.

  796 ?        S      0:00  \_ [scsi_eh_0]
  797 ?        S      0:00  \_ [scsi_eh_1]
  798 ?        S      0:00  \_ [scsi_eh_2]
  819 ?        S      0:00  \_ [scsi_eh_3]
  820 ?        S      0:00  \_ [scsi_eh_4]
  824 ?        S      0:00  \_ [scsi_eh_5]
  825 ?        S      0:14  \_ [scsi_eh_6]

bardioc ~ # lsscsi -d
[0:0:0:0]    disk    ATA      ST3160827AS      3.42  /dev/sda[8:0]
[1:0:0:0]    disk    ATA      ST3160827AS      3.42  /dev/sdb[8:16]
[5:0:0:0]    disk    ATA      IBM-DHEA-36480   HE8O  /dev/sdc[8:32]
[5:0:1:0]    disk    ATA      Maxtor 6L160P0   BAH4  /dev/sdd[8:48]
[6:0:0:0]    cd/dvd  HL-DT-ST DVDRAM GSA-4081B A100  /dev/sr0[11:0]
bardioc ~ # lsscsi -H
[0]    sata_promise
[1]    sata_promise
[2]    sata_promise
[3]    sata_via
[4]    sata_via
[5]    pata_via
[6]    pata_via

The bad is, that there is always a thread, even if the hardware is not
even hotplug capable.
Don't know if the thread is even needed for hotplug...

> I don't think it's completely silly to object to all this.  Sure, a kernel
> thread is worth 4k in the best case, but I bet they have associated unused
> resources and as we've seen, they can cause overhead.

For me its not the 4k that annoy me, but the clutter in ps or top.

Torsten
