Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab0CIMUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 07:20:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab0CIMUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 07:20:00 -0500
Date: Tue, 9 Mar 2010 13:18:59 +0100
From: Karel Zak <kzak@redhat.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Mike Snitzer <snitzer@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de, Jim Meyering <jim@meyering.net>,
       Neil Brown <neilb@suse.de>
Subject: Re: ATA 4 KiB sector issues.
Message-ID: <20100309121858.GA2020@nb.net.home>
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net> <170fa0d21003081134g491034e5v4aad4d43853e48ec@mail.gmail.com> <4B95F071.3070400@msgid.tls.msk.ru> <20100309100153.GD18077@nb.net.home> <4B961FE1.5040105@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B961FE1.5040105@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 01:16:01PM +0300, Michael Tokarev wrote:
> Karel Zak wrote:
> >  # mdadm --create /dev/md8 --level=5 --raid-devices=4 /dev/sdb{1,2,3,4}
> 
> That's 3-disk stripe size with default 64Kb chunk size, which makes
> 3x64=320KiB - the number to which everything should be aligned.
> 
> >  # fdisk -lcu /dev/md8
> > 
> >  Disk /dev/md8: 1572 MB, 1572667392 bytes
> >  2 heads, 4 sectors/track, 383952 cylinders, total 3071616 sectors
> >  Units = sectors of 1 * 512 = 512 bytes
> >  Sector size (logical/physical): 512 bytes / 4096 bytes
> >  I/O size (minimum/optimal): 65536 bytes / 65536 bytes
> 
> And here we go: fdisk does not see the right number: nothing
> is dividable by 3.

 Well, the same setup with 2.6.34-0.9.rc0.git13.fc14.x86_64:

 # fdisk -luc /dev/sdb

 Disk /dev/sdb: 2621 MB, 2621440000 bytes
 255 heads, 63 sectors/track, 318 cylinders, total 5120000 sectors
 Units = sectors of 1 * 512 = 512 bytes
 Sector size (logical/physical): 512 bytes / 4096 bytes
 I/O size (minimum/optimal): 4096 bytes / 32768 bytes
 Disk identifier: 0x77fbab55

 Device Boot         Start         End      Blocks   Id  System
 /dev/sdb1            2048     1026047      512000   83  Linux
 /dev/sdb2         1026048     2050047      512000   83  Linux
 /dev/sdb3         2050048     3074047      512000   83  Linux
 /dev/sdb4         3074048     4098047      512000   83  Linux


 # mdadm --create /dev/md8 --level=5 --raid-devices=4 /dev/sdb{1,2,3,4}


 # fdisk -luc /dev/md8

 Disk /dev/md8: 1572 MB, 1572667392 bytes
 2 heads, 4 sectors/track, 383952 cylinders, total 3071616 sectors
 Units = sectors of 1 * 512 = 512 bytes
 Sector size (logical/physical): 512 bytes / 4096 bytes
 I/O size (minimum/optimal): 65536 bytes / 65536 bytes


 # cat /sys/block/md8/queue/{minimum,optimal}_io_size 
 65536
 65536

> >  # cat /sys/block/md8/md8p{1,2}/alignment_offset
> >  0
> >  0
> 
> And that's where the issue is.  md does not {sup,re}port all
> this stuff yet.

 Hmm...

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
