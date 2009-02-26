Return-Path: <linux-kernel-owner+w=401wt.eu-S1756260AbZBZMgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbZBZMgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 07:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbZBZMgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 07:36:36 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:47617 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbZBZMgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 07:36:35 -0500
Date: Thu, 26 Feb 2009 05:36:17 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
Message-ID: <20090226123617.GB16891@parisc-linux.org>
References: <1235600698-6446-1-git-send-email-matthew@wil.cx> <49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net> <20090226025043.GJ1363@mit.edu> <20090226030735.GA16891@parisc-linux.org> <yq1eixlg4mn.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1eixlg4mn.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 12:16:00AM -0500, Martin K. Petersen wrote:
> >>>>> "Matthew" == Matthew Wilcox <matthew@wil.cx> writes:
> 
> Matthew> Lowest aligned logical block address=0
> 
> Matthew> This disagrees with Martin's assertion.
> 
> Quick answer from one of my contacts.  Desktop drives will indeed ship
> with an alignment of 1(*).  The alignment is hardwired at time of
> manufacture and can't be changed.

Hm.  I'll have to poke my contacts about this drive they've given me then.
I just checked (with hdparm --Istdout) and word 209 is 0x4000 with
this drive.

> (*) I had to go back and reread the ATA spec to grok this.  READ
> CAPACITY(16) indicates the lowest naturally aligned LBA.  With LBA 63
> offset in play that would be LBA 7.
> 
> ATA, on the other hand, indicates how much LBA 0 is offset from the
> beginning of the first physical sector.  If LBA 63 is naturally aligned
> that means that LBA 0 is offset 512 bytes (physical sector 0 starts at
> LBA -1 if you will). Hence IDENTIFY DEVICE word 209 will contain 0x4001.
> 
> So you need to tweak your RC16 response a bit...

You're right.  I think I want something like:

((1 << log_per_phys) - first_sector_offset) % (1 << log_per_phys);

If you have 8 logical sectors per physical, and ATA reports 0x4001, SCSI
wants to hear 7.  The only corner case is ATA reporting 0x4000 and SCSI
wanting to hear 0, not 8, hence the % (1 << log_per_phys).

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
