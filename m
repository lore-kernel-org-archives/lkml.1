Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbZFZWxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbZFZWxD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 18:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbZFZWwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 18:52:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52594 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750875AbZFZWww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 18:52:52 -0400
Date: Fri, 26 Jun 2009 23:53:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alberto Bertogli <albertito@blitiri.com.ar>
Cc: SandeepKsinha <sandeepksinha@gmail.com>,
       Goswin von Brederlow <goswin-v-b@web.de>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com,
       neilb@suse.de
Subject: Re: [RFC PATCH] dm-csum: A new device mapper target that checks
 data integrity
Message-ID: <20090626235357.7bec63a8@lxorguk.ukuu.org.uk>
In-Reply-To: <20090626223634.GG5913@blitiri.com.ar>
References: <20090521161317.GU1376@blitiri.com.ar>
	<87my91qsn4.fsf@frosties.localdomain>
	<20090525174630.GI1376@blitiri.com.ar>
	<8763fop31e.fsf@frosties.localdomain>
	<20090526125252.GL1376@blitiri.com.ar>
	<878wkhyqj3.fsf@frosties.localdomain>
	<37d33d830906260026t60ae1c71h981b6f3bc0165053@mail.gmail.com>
	<20090626223634.GG5913@blitiri.com.ar>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If it returns success but writes the wrong data to the disk, then there will
> be a mismatch between the checksum and the data at the destination, which will
> be detected when it is read.

(or to the wrong place on the disk which for pre SATA is actually
possibly more likely as the command transfers are not CRC protected on
the cable - just slower, while the data is CRC protected). SATA fixes
this.

> If a write returns success but no write ever takes place on the disk, then
> dm-csum (as it is now) will not detect it; although I'm not sure if that
> qualifies as on-disk data corruption or is it a disk controller issue.

Does it matter to the poor victim ? At this point you get into putting
mirrors on disks A & B with their integrity on the opposite pair so if
one forgets to do I/O hopefully both won't.

To be honest if you are really really paranoid you don't do link layer
checksumming anyway (which is what this is) you checksum in the apps using
the data set. That protects you against lots of error cases in the
memory/cache system and on network transmissions. On big clusters
crunching enormous amounts of data all those 1 in 10^lots bit error rates
become such that it's worth the effort.

> It's per IMD sector. More specifically, struct imd_sector_header's
> last_updated contains the generation count for the entire IMD sector, which is
> used to determine which one is younger for updating purposes.
> 
> On reads, both IMD sectors are loaded and CRCs are verified against both.

Seems reasonably paranoid - drives will do things under you like commit
data to disk out in a different order to the commands unless the cache
gets flushed between them but the barrier code should do that bit.

Alan
