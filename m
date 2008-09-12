Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbYILSky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbYILSky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 14:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYILSko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 14:40:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49807 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753448AbYILSkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 14:40:43 -0400
Date: Fri, 12 Sep 2008 14:40:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
       <bogdano@mandriva.com.br>,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Abdel Benamrouche <draconux@gmail.com>,
       Damien Lallement <dlallement@mandriva.com>
Subject: Re: Partition check considered as error is breaking mounting in
 2.6.27
In-Reply-To: <200809121502.49644.herton@mandriva.com.br>
Message-ID: <Pine.LNX.4.44L0.0809121423030.14509-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2008, Herton Ronaldo Krzesinski wrote:

> > > After formatting the camera is this you get from fdisk (display units in
> > > sectors):
> > >
> > > Disk /dev/sdb: 21 MB, 21544448 bytes
> > > 6 heads, 16 sectors/track, 438 cylinders, total 42079 sectors
> > > Units = sectors of 1 * 512 = 512 bytes
> > > Disk identifier: 0x00000000
> > >
> > >    Device Boot      Start         End      Blocks   Id  System
> > > /dev/sdb1   *           1       42079       21039+   1  FAT12
> > > Partition 1 has different physical/logical endings:
> > >      phys=(328, 5, 16) logical=(438, 1, 16)

> > > (after zeroing out the partition table I only run fdisk on the device,
> > > created the a new partition with maximum size allowed and change the type
> > > to FAT12)
> >
> > That is not a valid procedure.  You have to go into Expert mode and set
> > the number of sectors, heads, and tracks first.  Most likely you'll
> > want to set them to the same values used by the firmware; it looks like
> > the firmware thinks there are 16 sectors/track, 8 heads, and 329
> > tracks.
> 
> 8 heads? it reports 6 from the fdisk output:
> phys=(328, 5, 16) logical=(438, 1, 16)

No.  phys=(328, 5, 16) doesn't mean that the device has 329 tracks, 6
heads, and 16 sectors.  It means that the last sector of the partition
(as recorded in the table) is track 328, head 5, sector 16.  
Note that partitions don't have to end on cylinder boundaries.

Guessing that the firmware intends there to be 16 sectors per track,
and also guessing that the 42079 value is too low by one, we get a
total of 42080 / 16 = 2630 as the product of heads and tracks.  Since
2630 = 8 * 328.75 this seems to say that the firmware thinks there are
approximately 329 tracks and 8 heads.  That explains the "328" above.

Continuing this reasoning, the physical end (328,5,16) corresponds to
sector (328*8*16) + (5*16) + 15 = 42079 (the 15 is because sector
numbers start at 1 instead of at 0).  Which would be valid if the first
sector of the partition was sector 1, or phys=(0,0,2), and if the
capacity was 42080.  However you didn't tell us what value was stored
in the table for the start of the partition.

> > Adding quirks to alter partition sizes sounds very dangerous.  Your
> > best bet is simply to write a valid partition table.
> 
> Yes, but this is breaking other devices, not only this olympus camera. Bogdano 
> reported what could be the same case with his cel. phone (Bogdano can you 
> give more details?), also on IRC today Damien Lallement complained about what 
> looks the same issue of "p* exceeds device capacity" (Damien can you give 
> more info too?). But I'm afraid of how much devices this partition error 
> fatal check now can affect, after all it's not "user friendly" to instruct 
> the user to use hexedit or fdisk to fix the device's partitions.

You should complain to the people who wrote and accepted the
troublesome commit.  Tell them it caused a regression; that always gets
people's attention!

Alan Stern

