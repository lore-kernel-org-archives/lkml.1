Return-Path: <linux-kernel-owner+w=401wt.eu-S935354AbZLPXA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935354AbZLPXA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935398AbZLPXAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:00:17 -0500
Received: from web33007.mail.mud.yahoo.com ([209.191.69.122]:29047 "HELO
	web33007.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935383AbZLPW7q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:59:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=IpZNk155rqq6GxpnL0RmOhsI/kBpOASJt4oWJBnCX8oN8TXBq9ueOnZ3j7D9U0J3I25i/ruL1UtVZ9545uIBwEQXXoPkerU6mSL/g5OASnPevyKe0rmALtWZS8ZsFyUToBtHIcEvSKDFo6c7zI1JSLnaYGhHV3cyMThLzHrxkdA=;
Message-ID: <748125.31172.qm@web33007.mail.mud.yahoo.com>
X-YMail-OSG: FGrreU0VM1lxRdQgu4BbgwGnMWEvp7DSkBwGdjBWJBofVAsgzzAcU_PFtSeIQRgMj3l3rk2iPSlbO9WSj1ivvSsn.ogrGv1qiwh6pJnr1fQD55tVRRBPfU2zxVfTOCH1vjM_C5ZoB8pArAWCUHmTwO9Hi9gyEJ8jIZw2CNRit2F3tWT43JGzF.lbfbu0ReCBjqQ73PwPs23.ZWQwnD3Qh9BLxo8P1fAnfgAPc0_zzgXRisnU.70b_1nwsuPTROU2By83cB9c7EvaFR4Z1miHCeZzVD2vI25sEgPoht8NTTZ4BJKCP6cQ7_ivxmVls10zIm2zUTQpp4VQDc0st7dAyq71cNqcaiitALjb4GwGI8T7tgu3sSQT3wFWpvp5_zPcqg2p344-
X-Mailer: YahooMailClassic/9.0.19 YahooMailWebService/0.8.100.260964
Date: Wed, 16 Dec 2009 14:53:03 -0800 (PST)
From: Stephen Cameron <smcameron@yahoo.com>
Subject: Re: [PATCH 4/5] hpsa: Fix incorrect SCSI status reporting
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org,
       "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com,
       linux-scsi@vger.kernel.org
In-Reply-To: <20091208213827.23493.88533.stgit@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Tue, 12/8/09, Stephen M. Cameron <scameron@beardog.cce.hp.com> wrote:

> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> Subject: [PATCH 4/5] hpsa: Fix incorrect SCSI status reporting
> To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
> Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org, smcameron@yahoo.com
> Date: Tuesday, December 8, 2009, 3:38 PM
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> hpsa: Fix incorrect SCSI status reporting
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
>  drivers/scsi/hpsa.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 0e696ee..380236a 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -930,7 +930,7 @@ static void
> complete_scsi_command(struct CommandList *cp,
>  
>      cmd->result = (DID_OK << 16);
>         /* host byte */
>      cmd->result |= (COMMAND_COMPLETE << 8);    /* msg byte */
> -    cmd->result |= (ei->ScsiStatus);
> +    cmd->result |= (ei->ScsiStatus << 1);

I don't think this is correct.

I got fooled by some code in other drivers (3w-9xxx.c, gdth.c)
which use CHECK_CONDITION, and shift it left 1, but I failed to notice
that CHECK_CONDITION is defined to be 0x01, not 0x02.

Might be nice if there were some macros or helper functions
for setting the status bytes in scsi.h (there are some for 
unpacking, but not for packing, but drivers mainly need to
pack these, not unpack them.)

Will send a patch tomorrow in any case.

-- steve



>  
>      /* copy the sense data whether we need
> to or not. */
>      memcpy(cmd->sense_buffer,
> ei->SenseInfo,
> @@ -991,7 +991,6 @@ static void
> complete_scsi_command(struct CommandList *cp,
>  
>  
>             
> /* Must be some other type of check condition */
> -           
> cmd->result |= (ei->ScsiStatus << 1);
>             
> dev_warn(&h->pdev->dev, "cp %p has check
> condition: "
>             
>         "unknown type: "
>             
>         "Sense: 0x%x, ASC:
> 0x%x, ASCQ: 0x%x, "
> @@ -1013,8 +1012,6 @@ static void
> complete_scsi_command(struct CommandList *cp,
>           * Pass it
> up to the upper layers...
>           */
>          if
> (ei->ScsiStatus) {
> -
> -           
> cmd->result |= (ei->ScsiStatus << 1);
>             
> dev_warn(&h->pdev->dev, "cp %p has status 0x%x "
>             
>     "Sense: 0x%x, ASC: 0x%x, ASCQ: 0x%x, "
>             
>     "Returning result: 0x%x\n",
> 
> 


      
