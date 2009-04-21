Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbZDUXDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbZDUXDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 19:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZDUXDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 19:03:12 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:42779 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbZDUXDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 19:03:11 -0400
Date: Tue, 21 Apr 2009 17:03:09 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, mdharm-usb@one-eyed-alien.net,
       linux-usb <linux-usb@vger.kernel.org>,
       usb-storage@lists.one-eyed-alien.net,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>, viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2] fix sign extension with 1.5TB usb-storage LBD=y
Message-ID: <20090421230309.GC1926@parisc-linux.org>
References: <1240347174.10627.20.camel@nimitz> <20090421211858.GA1926@parisc-linux.org> <1240351210.10627.30.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240351210.10627.30.camel@nimitz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 03:00:10PM -0700, Dave Hansen wrote:
> Here's a patch implementing Al's suggestion.  Not quite as trivial as
> Matthew's, but even nicer aesthetically.  (Description stolen from
> Matthew's patch).  I have verified that this fixes my issue.

I prefer this approach, but I'm equally happy with whichever patch
James chooses.

> Shifting an unsigned char implicitly casts it to a signed int.  This
> caused 'lba' to sign-extend and Linux would then try READ CAPACITY 16
> which was not supported by at least one drive.  Using the
> get_unaligned_be*() helpers keeps us from having to worry about how the
> extension might occur.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

> @@ -1344,12 +1345,8 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>  		return -EINVAL;
>  	}
>  
> -	sector_size =	(buffer[8] << 24) | (buffer[9] << 16) |
> -			(buffer[10] << 8) | buffer[11];
> -	lba =  (((u64)buffer[0] << 56) | ((u64)buffer[1] << 48) |
> -		((u64)buffer[2] << 40) | ((u64)buffer[3] << 32) |
> -		((u64)buffer[4] << 24) | ((u64)buffer[5] << 16) |
> -		((u64)buffer[6] << 8) | (u64)buffer[7]);
> +	sector_size = get_unaligned_be32(&buffer[8]);
> +	lba =  get_unaligned_be64(&buffer[0]);

The smallest of quibbles ... you have an excess space after the = ...

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
