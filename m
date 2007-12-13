Return-Path: <linux-kernel-owner+w=401wt.eu-S1758667AbXLMII1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbXLMII1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 03:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbXLMIIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 03:08:18 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:55885 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbXLMIIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 03:08:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=M2CYWiIxIzYCx6Ux8d2SUcq48VS3n6S+wBITk7vM2MZcVfJdaPYLT9lIMIiyE4UJ2832FBaIhD3hVNvzaL+J3tlpFv3QLLmfMvOdoj32QyfvBVh1y8ZSYQ9t1PkXmOsYAzJcUXZWpe9Bek59uIPU2V4lF0VzT+MD4yrqC0lzJ+Y=
Message-ID: <9c9fda240712130008s227a77dsbd9333c5227d51eb@mail.gmail.com>
Date: Thu, 13 Dec 2007 17:08:16 +0900
From: "Kyungmin Park" <kmpark@infradead.org>
To: "Pierre Ossman" <drzeus-list@drzeus.cx>
Subject: Re: [PATCH][MMC] Fix wrong EXT_CSD_REV handling
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071213085332.18d2790d@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213071311.GA2970@party>
	 <20071213085332.18d2790d@poseidon.drzeus.cx>
X-Google-Sender-Auth: 39f3dbc36cc5504f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 13, 2007 4:53 PM, Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> On Thu, 13 Dec 2007 16:13:11 +0900
> Kyungmin Park <kyungmin.park@samsung.com> wrote:
>
> > It already checked the ext_csd_struct is less than 2,
> > so it doesn't need to check it.
> > Current code only accepts the revision 1.2.
> >
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>
> It wasn't wrong the last time you brought this up, and it still isn't wrong. Those bits aren't defined until version 1.2 of the EXT_CSD register, hence we do not trust them. If you have some broken card that you feel you must have support for, then start working on some quirks system.

Now see the code.

First, it checks the ext_csd_struct.
       ext_csd_struct = ext_csd[EXT_CSD_REV];
        if (ext_csd_struct > 2) {
                printk(KERN_ERR "%s: unrecognised EXT_CSD structure "
                        "version %d\n", mmc_hostname(card->host),
                        ext_csd_struct);
                err = -EINVAL;
                goto out;
        }
        => here possible values are 0, 1, 2

        => It only accepts the ext_csd 2 but my *broken* card has 1.
so it's failed.
        if (ext_csd_struct >= 2) {
                card->ext_csd.sectors =
                        ext_csd[EXT_CSD_SEC_CNT + 0] << 0 |
                        ext_csd[EXT_CSD_SEC_CNT + 1] << 8 |
                        ext_csd[EXT_CSD_SEC_CNT + 2] << 16 |
                        ext_csd[EXT_CSD_SEC_CNT + 3] << 24;
                if (card->ext_csd.sectors)
                        mmc_card_set_blockaddr(card);
        }

In my MMC Spec. (v4.2), there's no problem to read it even though it's
revision 1.1

Anyway how do it handle this one? Do you have any idea?

Thank you,
Kyungmin Park
