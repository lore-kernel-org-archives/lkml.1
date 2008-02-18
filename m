Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbYBRP7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbYBRP7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbYBRP7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:59:23 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:28058 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbYBRP7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:59:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wTsIzLzbSgWzJQHH4GPTp77/dy1sftHrMsHETmLhQZ4PW4H7mhdzfwxPRQkSCEPriubYARFhl/8XmQtOS+Iz/gV/ya0XflLC8VFgCcPwY6vtISlybhmzx91qCckK7jzxa+PmVFfzjwfGZIzQLeyMWvZWPauO7i88HDIHCyVIFX8=
Message-ID: <58cb370e0802180759h4d44b9bci86f02919a48c7979@mail.gmail.com>
Date: Mon, 18 Feb 2008 16:59:20 +0100
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: "Andreas Schwab" <schwab@suse.de>
Subject: Re: 2.6.25-rc1/2 CD/DVD burning broken
Cc: linux-kernel@vger.kernel.org, "Kiyoshi Ueda" <k-ueda@ct.jp.nec.com>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Borislav Petkov" <petkovbb@gmail.com>
In-Reply-To: <jelk5k62uy.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <jelk5k62uy.fsf@sykes.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Feb 16, 2008 9:52 PM, Andreas Schwab <schwab@suse.de> wrote:
> Since commit aaa04c28cb9a1efd42541fdb7ab648231c2a2263 [blk_end_request:
> changing ide-cd (take 4)] I cannot burn any CD/DVD any more, getting the
> following error from wodim:
>
> Errno: 0 (Success), write_g1 scsi sendcmd: no error
> CDB:  2A 00 00 00 00 00 00 00 1F 00
> status: 0x2 (CHECK CONDITION)
> Sense Bytes: 70 00 05 00 00 00 00 0E 00 00 00 00 21 02 00 00
> Sense Key: 0x5 Illegal Request, Segment 0
> Sense Code: 0x21 Qual 0x02 (invalid address for write) Fru 0x0
> Sense flags: Blk 0 (not valid)
> resid: 63488

blk_end_request: changing ide-cd (take 4)

This patch converts ide-cd (cdrom_newpc_intr()) to use blk_end_request
interfaces.  Related 'uptodate' arguments are converted to 'error'.

In PIO mode, ide-cd (cdrom_newpc_intr()) needs to defer
end_that_request_last() until the device clears DRQ_STAT and raises
an interrupt after end_that_request_first().
So blk_end_request() has to return without completing request
even if no leftover in the request.

ide-cd uses blk_end_request_callback() and a dummy callback function,
which just returns value '1', to tell blk_end_request_callback()
about that.

Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

[...]

I looked at the commit again but nothing seems obviously wrong (probably there
was a silent change in the behavior of block layer API that upsets ide-cd)...

Kiyoshi/Jens: please follow up on this bug.

Thanks,
Bart
