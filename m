Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752517AbYLRRI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbYLRRI2 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 12:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYLRRIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 12:08:17 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:58176 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbYLRRIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 12:08:16 -0500
Message-ID: <494A837A.50801@garzik.org>
Date: Thu, 18 Dec 2008 12:08:10 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] ide: Fix ata_id_has_dword_io to return DWORD I/O support
 properly
References: <494A5BBF.8000807@inf.tu-dresden.de>
In-Reply-To: <494A5BBF.8000807@inf.tu-dresden.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mario Schwalbe wrote:
> This patch fixes ata_id_has_dword_io to return 1 (supported) if
> the drive is compliant to ATA2 or newer and evaluates the config
> word for older drives.
> 
> Signed-off-by: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
> ---
>  include/linux/ata.h |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/ata.h b/include/linux/ata.h
> index a53318b..d0d6a9c 100644
> --- a/include/linux/ata.h
> +++ b/include/linux/ata.h
> @@ -700,12 +700,12 @@ static inline int ata_id_has_tpm(const u16 *id)
> 
>  static inline int ata_id_has_dword_io(const u16 *id)
>  {
> -	/* ATA 8 reuses this flag for "trusted" computing */
> -	if (ata_id_major_version(id) > 7)
> -		return 0;
> -	if (id[ATA_ID_DWORD_IO] & (1 << 0))
> -		return 1;
> -	return 0;
> +	/* This flag is defined up to ATA1 and deprecated since then
> +	   (ATA 8 reuses this flag for "trusted" computing). */
> +	if (ata_id_major_version(id) <= 1)
> +		return (id[ATA_ID_DWORD_IO] & (1 << 0)) != 0;
> +	/* later revision drives support DWORD I/O just fine */
> +	return 1;


This seems like a risky assumption...

	Jeff


