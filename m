Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753047AbYLRUpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbYLRUpu (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbYLRUpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:45:39 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:32849 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbYLRUpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:45:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=TwxsHvXys3OvabbptypOH/jp8T1KpJbH5vW85wUlqusrwwrdgM4jluCXD6dBnAC5EM
         LGVJSnt3B3ju3NvBm9Wreuhl2c9/mJdGHA7Ipsr8uEW6/Enp4k4yNYm0lmUq0rYyVCFh
         RwTNT2uNjg9aohYJJZ0jGmF7iLdjH38kC1vgY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] ide: Fix ata_id_has_dword_io to return DWORD I/O support properly
Date: Thu, 18 Dec 2008 21:42:16 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc8-next-20081218; KDE/4.1.3; i686; ; )
Cc: Jeff Garzik <jeff@garzik.org>, Mario Schwalbe <schwalbe@inf.tu-dresden.de>,
        linux-kernel@vger.kernel.org,
        Linux IDE mailing list <linux-ide@vger.kernel.org>
References: <494A5BBF.8000807@inf.tu-dresden.de> <494A837A.50801@garzik.org> <494A8768.4080100@ru.mvista.com>
In-Reply-To: <494A8768.4080100@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812182142.16533.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 December 2008, Sergei Shtylyov wrote:
> Hello.
> 
> Jeff Garzik wrote:
> 
> >> This patch fixes ata_id_has_dword_io to return 1 (supported) if
> >> the drive is compliant to ATA2 or newer and evaluates the config
> >> word for older drives.
> 
> >> Signed-off-by: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
> 
> >> diff --git a/include/linux/ata.h b/include/linux/ata.h
> >> index a53318b..d0d6a9c 100644
> >> --- a/include/linux/ata.h
> >> +++ b/include/linux/ata.h
> >> @@ -700,12 +700,12 @@ static inline int ata_id_has_tpm(const u16 *id)
> 
> >>  static inline int ata_id_has_dword_io(const u16 *id)
> >>  {
> >> -    /* ATA 8 reuses this flag for "trusted" computing */
> >> -    if (ata_id_major_version(id) > 7)
> >> -        return 0;
> >> -    if (id[ATA_ID_DWORD_IO] & (1 << 0))
> >> -        return 1;
> >> -    return 0;
> >> +    /* This flag is defined up to ATA1 and deprecated since then
> >> +       (ATA 8 reuses this flag for "trusted" computing). */
> >> +    if (ata_id_major_version(id) <= 1)
> >> +        return (id[ATA_ID_DWORD_IO] & (1 << 0)) != 0;
> >> +    /* later revision drives support DWORD I/O just fine */
> >> +    return 1;
> 
> > This seems like a risky assumption...
> 
>     Not at all, I think. It's total mystery how "DWORD I/O" could've been even 
> (not) supported by a *drive* at all. Support of "DWORD I/O" is a property of 
> the PATA controller. Frankly speaking, I don't think that this function is at 
> all useful...

Indeed, this function can be probably removed altogether later...

OTOH the current patch is safe even for 2.6.28 (based on years of experience
with the check that we had in IDE subsystem) and will fix some libata drivers
(pata_legacy, pata_qdi and pata_winbond) to use dword IO on >= ATA-2 devices.

[ In reality this a regression fix for IDE -> libata conversion as it is a
  huge performance improvement for the above mentioned DMA-less drivers. ]

Jeff, I would like to merge it through IDE tree since the other patch depends
on it but if you want to go ahead and push it to Linus earlier feel free to
do it (or I can include it into the next IDE fixes pull request if you like).

Thanks,
Bart
