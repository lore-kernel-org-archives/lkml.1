Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab0CJQTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 11:19:53 -0500
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:61985 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755391Ab0CJQTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 11:19:51 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
X-IronPort-AV: E=Sophos;i="4.49,614,1262559600";   d="scan'208";a="48440209"
Message-id: <4B97C6A5.4010209@tvk.rwth-aachen.de>
Date: Wed, 10 Mar 2010 17:19:49 +0100
From: Damian Lukowski <damian@tvk.rwth-aachen.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100307
 Thunderbird/3.0.3
To: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       James Bottomley <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Mark Lord <kernel@teksavvy.com>,
       tytso@mit.edu, "H. Peter Anvin" <hpa@zytor.com>,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       aschnell@suse.de, knikanth@suse.de, jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org>
 <1268031640.4389.11.camel@mulgrave.site> <yq1vdd6bzgz.fsf@sermon.lab.mkp.net>
 <yq1mxyibz7o.fsf@sermon.lab.mkp.net> <yq1iq96bz22.fsf@sermon.lab.mkp.net>
 <20100310075334.GA26763@parisc-linux.org> <4B97A2DE.2030901@garzik.org>
In-reply-to: <4B97A2DE.2030901@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> S-2. The proper solution.
> 
>   Correct alignments for all partitions can't be achieved by the
>   firmware alone.  The system utilities should be informed about the
>   alignment requirements and align partitions accordingly.
> 
>   The above firmware workaround complicates the situation because the
>   two different configurations require different offsets to achieve
>   the correct alignments.  ATA/ATAPI-8 specifies a way for a drive to
>   export the physical and logical sector sizes and the LBA offset
>   which is aligned to the physical sectors.
> 
>   In Linux, these parameters are exported via the following sysfs
>   nodes.
> 
>     physical sector size	: /sys/block/sdX/queue/physical_block_size
>     logical sector size		: /sys/block/sdX/queue/logical_block_size
>     alignment offset		: /sys/block/sdX/alignment_offset
> 
>   Let the physical sector size be PSS, logical sector size LSS and
>   alignment offset AOFF.  The system software should place partitions
>   such that the starting LBAs of all partitions are aligned on
> 
>     (n * PSS + AOFF) / LSS
> 
>   For 4 KiB physical sector offset-by-one drives, PSS is 4096, LSS 512
>   and AOFF 3584 and with n of 7 the above becomes,
> 
>     (7 * 4096 + 3584) / 512 == 63
> 
>   making sector 63 an aligned LBA where the first partition can be
>   put, but without the offset-by-one mapping, AOFF is zero and LBA 63
>   is not aligned.
> 
>   With the above new alignment requirement in place, it becomes
>   difficult to honor the legacy one - first partition on sector 63 and
>   all other partitions on cylinder boundary (255 * 63 sectors) - as
>   the two alignment requirements contradict each other.  This might be
>   worked around by adjusting how LBA and CHS addresses are mapped but
>   the disk geometry parameters are hard coded everywhere and there is
>   no reliable way to communicate custom geometry parameters.

Hello,
I have practically no knowledge of Linux' block device drivers,
but is this really a partitioning issue? I think the problem is
with the filesystems when clustering multiple blocks without
knowledge of the sector alignment and sector size of the underlying
block device. Maybe it is a better solution to adapt the filesystem
buffer routine which reads/writes data from/to the block device?

Best regards
 Damian
