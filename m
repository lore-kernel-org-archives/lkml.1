Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbYANVox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbYANVox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYANVoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:44:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:1750 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbYANVoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:44:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=XSXjQh4BZHbr491kAg0J5ApvhofYtfpL0S8yJEzaMP4YzDL8t0JM802d9TiwP0htbx4AhJqt9oNDvhhN4hyBG0DxZIIDNFn26aWxoEw716VC4AY0seBUIqy4voHvypqA7MBKJOH1xYVhkrCPRRsFy3e7qXMqZLsWYXdYPk6a4es=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [PATCH 10/12] ide-floppy: remove atomic test_*bit macros
Date: Mon, 14 Jan 2008 22:50:58 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de> <1200255505-31418-10-git-send-email-bbpetkov@yahoo.de> <1200255505-31418-11-git-send-email-bbpetkov@yahoo.de>
In-Reply-To: <1200255505-31418-11-git-send-email-bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801142250.58201.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 January 2008, Borislav Petkov wrote:
> ..and replace them with flag enums.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> ---
>  drivers/ide/ide-floppy.c |  132 +++++++++++++++++++++++++--------------------
>  1 files changed, 73 insertions(+), 59 deletions(-)

[...]

> @@ -506,14 +516,14 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
>  
>  	debug_log("Reached %s interrupt handler\n", __FUNCTION__);
>  
> -	if (test_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
> +	if (PC_FLAG_DMA_IN_PROGRESS & pc->flags) {

the usual kernel convention is to put flag last, i.e.

pc->flags & PC_FLAG_DMA_IN_PROGRESS

[...]

> @@ -570,7 +581,7 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
>  		printk(KERN_ERR "ide-floppy: CoD != 0 in %s\n", __FUNCTION__);
>  		return ide_do_reset(drive);
>  	}
> -	if (((ireason & IO) == IO) == test_bit(PC_WRITING, &pc->flags)) {
> +	if (((ireason & IO) == IO) == (PC_FLAG_WRITING  & pc->flags)) {

- test_bit() returns 1 or 0 (=> boolean)
- (pc->flags & PC_FLAG_WRITING) is 0x10 or 0

so the above comparison will fail

> @@ -607,7 +618,7 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
>  		xferfunc(drive, pc->current_position, bcount);
>  	else
>  		ide_floppy_io_buffers(drive, pc, bcount,
> -				test_bit(PC_WRITING, &pc->flags));
> +				(PC_FLAG_WRITING & pc->flags));

ditto, this may actually work but '(pc->flags & PC_FLAG_WRITING) ? 1 : 0'
would be much safer from maintainability POV

[...]

> @@ -1720,13 +1731,16 @@ static int idefloppy_media_changed(struct gendisk *disk)
>  {
>  	struct ide_floppy_obj *floppy = ide_floppy_g(disk);
>  	ide_drive_t *drive = floppy->drive;
> +	int ret;
>  
>  	/* do not scan partitions twice if this is a removable device */
>  	if (drive->attach) {
>  		drive->attach = 0;
>  		return 0;
>  	}
> -	return test_and_clear_bit(IDEFLOPPY_MEDIA_CHANGED, &floppy->flags);
> +	ret = IDEFLOPPY_FLAG_MEDIA_CHANGED & floppy->flags;
> +	floppy->flags &= ~IDEFLOPPY_FLAG_MEDIA_CHANGED;
> +	return ret;
>  }

same issue

otherwise looks good, please fix/resubmit
(together with patch #12)
