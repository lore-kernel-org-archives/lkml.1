Return-Path: <linux-kernel-owner+w=401wt.eu-S964861AbXBTHlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964861AbXBTHlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 02:41:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964865AbXBTHlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 02:41:12 -0500
Received: from weequay.is.scarlet.be ([193.74.71.24]:51155 "EHLO
	weequay.is.scarlet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964861AbXBTHlH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 02:41:07 -0500
Date: Tue, 20 Feb 2007 08:40:54 +0100
Message-Id: <JDR406$F2DDC514B02CA9EE77B2C4EEBE226DE8@scarlet.be>
Subject: Re: 2.6.20-rc6 libata PATA ATAPI CDROM is not working
MIME-Version: 1.0
X-Sensitivity: 3
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
From: "Joel Soete" <soete.joel@scarlet.be>
To: "lsorense" <lsorense@csclub.uwaterloo.ca>
Cc: "htejun" <htejun@gmail.com>, "luming\.yu" <luming.yu@gmail.com>,
       "alan" <alan@redhat.com>, "opslynx" <opslynx@gmail.com>,
       "alan" <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "jgarzik" <jgarzik@pobox.com>
X-XaM3-API-Version: 4.1 (B54)
X-type: 0
X-SenderIP: 57.67.177.33
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> [snip]
> > 
> > Hmm, readcd was trying to read 279884 blocks, while cdrecord said it
> > wrote 279882 blocks.
> > 
> yes and seems to be always the same:
> with new burned cd I got:
> # ll /MultiCd/cd060213.iso
> -rwxr-xr-x 1 root root 3213312 Feb 13  2006 /MultiCd/cd060213.iso
> 
> i.e. 3213312/2048 == 1569
> 
> while:
> readcd dev=/dev/hdd f=- | md5sum
> Read  speed:  1059 kB/s (CD   6x, DVD  0x).
> Write speed:   353 kB/s (CD   2x, DVD  0x).
> Capacity: 1571 Blocks = 3142 kBytes = 3 MBytes = 3 prMB
> Sectorsize: 2048 Bytes
> Copy from SCSI (1,1,0) disk to file '-'
> end:      1571
> Errno: 0 (Success), read_g1 scsi sendcmd: no error
> CDB:  28 00 00 00 06 00 00 00 23 00
> status: 0x2 (CHECK CONDITION)
> Sense Bytes:
> Sense Key: 0xFFFFFFFF [], Segment 0
> Sense Code: 0x00 Qual 0x00 (no additional sense information) Fru 0x0
> Sense flags: Blk 0 (not valid)
> cmd finished after 0.014s timeout 40s
> readcd: Success. Cannot read source disk
> readcd: Retrying from sector 1536.
> 
> so always Capacity == original image size + 2 ?
> 
> [snip]
> > 
> > There always seems to have been any issue with reading blocks from a cd
> > getting broken by the kernel doing readahead and getting failures by
> > trying to read past the end of the disc even though the user never asked
> > it to.  Sometimes your size just happens to hit a safe block size so the
> > readahead doesn't break.
> > 
> btw this tips:
> readcd dev=/dev/hdd sectors=0-1569 f=- | md5sum
> Read  speed:  1059 kB/s (CD   6x, DVD  0x).
> Write speed:   353 kB/s (CD   2x, DVD  0x).
> Capacity: 1571 Blocks = 3142 kBytes = 3 MBytes = 3 prMB
> Sectorsize: 2048 Bytes
> Copy from SCSI (1,1,0) disk to file '-'
> end:      1569
> addr:     1569 cnt: 33
> Time total: 5.436sec
> Read 3138.00 kB at 577.3 kB/sec.
> 6a1248783a21722816b972aa9bae9d5e  -
> 
> (adding sectors=0-1569 : 1569 being the size of the original image)
> 
> seems to work fine
> # md5sum /MultiCd/cd060213.iso
> 6a1248783a21722816b972aa9bae9d5e  /MultiCd/cd060213.iso
> 
> >> is the same wrong results.
> >>
> >> mmm I always used successfully dd method at my office with scsi cdrom drive 
> >> (even for bootable disk).
> > 
> > Well it seems some disks can be read that way, others can not.
> > 
> I would be curious to read same cd on scsi cdrom (at the office)?
> 
well here are the results with the cd I burned at home and in a scsi cd rw drive:
# dd if=/dev/rdsk/c1t4d0 bs=2048 | md5sum
1569+0 records in
1569+0 records out
6a1248783a21722816b972aa9bae9d5e  -

and also with readcd but an older release:

# readcd -version
readcd 1.11a19 (hppa1.1-hp-hpux11.00) Copyright (C) 1987, 1995-2002 Jörg Schilling

# readcd dev=1,4,0 f=- | md5sum           
Capacity: 1569 Blocks = 3138 kBytes = 3 MBytes = 3 prMB
Sectorsize: 2048 Bytes
Copy from SCSI (1,4,0) disk to file '-'
end:      1569
addr:     1569 cnt: 19
Time total: 6.239sec
Read 3138.00 kB at 503.0 kB/sec.
6a1248783a21722816b972aa9bae9d5e  -

I am very confused: cdrecord finaly do well its job on ide drive but what went
wrong for the check (cdrom drive? (but I don't have another model to test) or
some code in the kernel? (I don't think to have a small chance to put this ide
drive on a *nix system which could support ide and scsi hw)).

Any idea?

Cheers,
 	Joel	
> 
> 
---
Scarlet One Unlimited
Free national calls, surf up to 6 Mbit/s, 50 GB download volume
For only EUR 49,95 per month. No Belgacom subscription needed.  All in!
http://www.scarlet.be

