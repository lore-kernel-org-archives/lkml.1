Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbZDUWt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbZDUWt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 18:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZDUWtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 18:49:14 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46953 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbZDUWtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 18:49:13 -0400
Subject: Re: [RFC][PATCH] fix sign extension with 1.5TB usb-storage LBD=y
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, mdharm-usb@one-eyed-alien.net,
       linux-usb <linux-usb@vger.kernel.org>,
       usb-storage@lists.one-eyed-alien.net,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <20090421211858.GA1926@parisc-linux.org>
References: <1240347174.10627.20.camel@nimitz>
	 <20090421211858.GA1926@parisc-linux.org>
Content-Type: text/plain
Date: Tue, 21 Apr 2009 15:49:10 -0700
Message-Id: <1240354150.10627.36.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-21 at 15:18 -0600, Matthew Wilcox wrote:
> 
> this certainly fixes your problem.  I'd prefer this patch instead, just
> because I find the cast unaesthetic ...
> 
> ----
> 
> Fix READ CAPACITY 10 with drives over 1TB
> 
> Shifting an unsigned char implicitly casts it to a signed int.  This
> caused 'lba' to sign-extend and Linux would then try READ CAPACITY 16
> which was not supported by at least one drive.  Making 'lba' an
> unsigned
> int ensures that sign extension will not occur.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 3fcb64b..c856b1b 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1373,7 +1373,7 @@ static int read_capacity_10(struct scsi_disk
> *sdkp, struct scsi_device *sdp,
>         int sense_valid = 0;
>         int the_result;
>         int retries = 3;
> -       sector_t lba;
> +       unsigned lba;
>         unsigned sector_size;
> 
>         do {
> @@ -1413,7 +1413,7 @@ static int read_capacity_10(struct scsi_disk
> *sdkp, struct scsi_device *sdp,
>                 return -EOVERFLOW;
>         }
> 
> -       sdkp->capacity = lba + 1;
> +       sdkp->capacity = (sector_t)lba + 1;
>         return sector_size;
>  }

That's fine with me too.  This patch fixes my issue as well.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

-- Dave

