Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbYA0Tcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbYA0Tcd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 14:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbYA0TcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 14:32:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:9237 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbYA0TcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 14:32:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=U2v0MBPQW8jS9IjSjVqK6kE4LoHwuJ6IZDwDiRRMjp7+ejm+0f6srtPweKm9ln+qQHuDB6kWKkhmAIapKMzHAwV1VskBrjzSwwmL9ukc7BQAX9ElYGZsxDMotEBKrDr9fY9u0/EumJRpgF3wuyP4Yw9/sVZYlt4S/p7m7/aRlGY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [PATCH 3/32] ide-tape: remove struct idetape_request_sense_result_t
Date: Sun, 27 Jan 2008 16:19:05 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1201423312-2460-1-git-send-email-bbpetkov@yahoo.de> <1201423312-2460-4-git-send-email-bbpetkov@yahoo.de>
In-Reply-To: <1201423312-2460-4-git-send-email-bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801271619.06013.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008, Borislav Petkov wrote:
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> ---
>  drivers/ide/ide-tape.c |   83 +++++++++++++++--------------------------------
>  1 files changed, 27 insertions(+), 56 deletions(-)

applied with minor changes

> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index 3bedeb8..173ac0d 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c

[...]

>  	/*
> -	 * If error was the result of a zero-length read or write command,
> -	 * with sense key=5, asc=0x22, ascq=0, let it slide.  Some drives
> -	 * (i.e. Seagate STT3401A Travan) don't support 0-length read/writes.
> +	 * If error was the result of a zero-length read or write command, with
> +	 * sense key=5, asc=0x22, ascq=0, let it slide.  Some drives (i.e.
> +	 * Seagate STT3401A Travan) don't support 0-length read/writes.
>  	 */

This chunk is unnecessary, I dropped it.

>  	if ((pc->c[0] == IDETAPE_READ_CMD || pc->c[0] == IDETAPE_WRITE_CMD)
> -	    && pc->c[4] == 0 && pc->c[3] == 0 && pc->c[2] == 0) { /* length==0 */
> -		if (result->sense_key == 5) {
> +		/* length==0 */
> +		&& pc->c[4] == 0 && pc->c[3] == 0 && pc->c[2] == 0) {
> +		if (tape->sense_key == 5) {
>  			/* don't report an error, everything's ok */
>  			pc->error = 0;
>  			/* don't retry read/write */
>  			set_bit(PC_ABORT, &pc->flags);
>  		}
>  	}
> -	if (pc->c[0] == IDETAPE_READ_CMD && result->filemark) {
> +	if (pc->c[0] == IDETAPE_READ_CMD && !!(sense[2] & 0x80)) {

needless "!!" removed

>  		pc->error = IDETAPE_ERROR_FILEMARK;
>  		set_bit(PC_ABORT, &pc->flags);
>  	}
>  	if (pc->c[0] == IDETAPE_WRITE_CMD) {
> -		if (result->eom ||
> -		    (result->sense_key == 0xd && result->asc == 0x0 &&
> -		     result->ascq == 0x2)) {
> +		if (!!(sense[2] & 0x40) ||

ditto
