Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbZCUPSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbZCUPSn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 11:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZCUPSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 11:18:33 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60393 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399AbZCUPSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 11:18:32 -0400
Subject: Re: Overagressive failing of disk reads, both LIBATA and IDE
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mark Lord <liml@rtr.ca>, Norman Diamond <n0diamond@yahoo.co.jp>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20090321151028.2ac4101f@lxorguk.ukuu.org.uk>
References: <F79C774361EF45A6A68BC08F8621E406@DIAMOND8600>
	 <49C30E67.4060702@rtr.ca> <1237645333.4600.9.camel@localhost.localdomain>
	 <20090321151028.2ac4101f@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Sat, 21 Mar 2009 10:18:22 -0500
Message-Id: <1237648702.4600.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-21 at 15:10 +0000, Alan Cox wrote:
> > Using the disk supplied data about where the error occurred (provided
> > the disk returns it) eliminates all the readahead problems like the one
> 
> ATA disks do provide sector information generally, as do CD-ROMs, in fact
> we actually decode it for error reporting so probably all the bits are
> there to improve any reporting for most read side cases.
> 
> >From some of the traces I have been debugging I am not convinced the scsi
> mid layer does the right thing any more. It uses to be handling CD-R
> media (where the end of media is not well defined) but nowdays seems to
> be reporting errors even when told that the I/O partly succeeded. I need
> to debug that case further however but as I don't have one of the problem
> drives its a bit tricky.

OK, so in modern kernels, this is done in the ULD ... specifically for
disks in sd.c:sd_done and for CD/DVD in sr.c:sr_done().

The sr.c one looks crufty in that I don't think it handles descriptor
sense at all, so perhaps it should be updated to match the sd one?

> > above.  Perhaps just turning of readahead for disks that don't supply
> > error location information would be a reasonable workaround?
> 
> Not really. From a performance perspective Mark's patch is vastly
> superior because it punishes the incredibly rare error case not the
> routine working performance. Avoiding the need to do either would be even
> better - as would fixing the block layer not to mess up retries in this
> situation.
> 
> For low speed devices like MMC cards and flash it might make sense not to
> merge unrelated requests however so that only the relevant one fails.

See other email for suggestion how to do this at the block level.

James


