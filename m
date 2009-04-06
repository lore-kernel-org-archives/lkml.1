Return-Path: <linux-kernel-owner+w=401wt.eu-S1759272AbZDFVMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272AbZDFVMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbZDFVLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:11:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:28755 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758286AbZDFVLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:11:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=wrOS0wgAZEfqltPh0edoq70uCyhL5kzEfmbBtVuX/LW9f9xxRprBo1TZP7YpaBzSx5
         K800hWv5xGkgVaKrOvfbYhi5+srQUL7xA0TZaMCYS+iFO6mNoKN8DEadlBQPwQKM9E37
         QHv80XaV4o36w7UuVlBI+Z0H+LnZu5TD85H3Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 1/2] ide-cd: reverse NOT_READY sense key logic
Date: Mon, 6 Apr 2009 22:59:15 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090403; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1238922962-19727-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1238922962-19727-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904062259.15556.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 April 2009, Borislav Petkov wrote:
> Make the case of flushing the drive's cache explicit.
> 
> There should be no functional change resulting from this patch.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/ide/ide-cd.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index 2989aa8..2aa13d8 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -341,15 +341,15 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
>  
>  	switch (sense_key) {
>  	case NOT_READY:
> -		if (blk_fs_request(rq) == 0 || rq_data_dir(rq) == READ) {
> +		if (blk_fs_request(rq) && rq_data_dir(rq) == WRITE) {
> +			if (ide_cd_breathe(drive, rq))
> +				return 1;
> +		} else {
>  			cdrom_saw_media_change(drive);
>  
>  			if (blk_fs_request(rq) && !quiet)

Didn't we want to remove this blk_fs_request() while at it?
