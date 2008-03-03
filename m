Return-Path: <linux-kernel-owner+w=401wt.eu-S1759487AbYCCQDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487AbYCCQDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 11:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbYCCQDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 11:03:07 -0500
Received: from gv-out-0910.google.com ([216.239.58.191]:40937 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbYCCQDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 11:03:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lvoE1WoPDw01f+WJycwmrq4Y7cTO2Ug6htLGTXWkfjCXtFpsXl6uXUJXzf8Wy5TKaKwM+pL80ftx9qaq8Fkr/rAeZwDMTG3giKq0MkDgVWhk9gYadrC1pkMqs7uYvTLUtLz/tCzxGk9SAlpbRCcbjONxKGHejKNS0fzIzSdFqe0=
Message-ID: <804dabb00803030803v1dbbb33fh6779b8c4d072a908@mail.gmail.com>
Date: Tue, 4 Mar 2008 00:03:00 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: ide_register_hw(): buggy code
Cc: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080302151924.GJ25835@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080302151924.GJ25835@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 2, 2008 at 11:19 PM, Adrian Bunk <bunk@kernel.org> wrote:
> The Coverity checker spotted the following bogus change to
>  ide_register_hw() in commit 9e016a719209d95338e314b46c3012cc7feaaeec:
>
>  <--  snip  -->
>
>  ...
>  +               hwif = ide_deprecated_find_port(hw->io_ports[IDE_DATA_OFFSET]);
>  +               index = hwif->index;
>  +               if (hwif)
>  +                       goto found;
>                 for (index = 0; index < MAX_HWIFS; index++)
>  ...
>
>  <--  snip  -->
>
>  It's impossible to reach the for() loop without Oopsing before.
>
>  Can you either fix this for 2.6.25 or push your patch that removes
>  ide_register_hw() for 2.6.25?
>

My question is:

a.   why is "retry=1", and then the do while loop always end up the
loop being one round executed only?   Why not just remove the while
loop entirely?

b.   not sure if your statement above implied this, but checking for
hwif!=0 should be before index.  ???

c.   "index = hwif->index;" should not be there, but after "found".
Is that correct?

int ide_register_hw(hw_regs_t *hw, void (*quirkproc)(ide_drive_t *),
                    ide_hwif_t **hwifp)
{
        int index, retry = 1;
        ide_hwif_t *hwif;
        u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };

        do {
                hwif = ide_deprecated_find_port(hw->io_ports[IDE_DATA_OFFSET]);
                index = hwif->index;
                if (hwif)
                        goto found;
                for (index = 0; index < MAX_HWIFS; index++)
                        ide_unregister(index, 1, 1);
        } while (retry--);
        return -1;
found:
        if (hwif->present)


The patch I am thinking goes something like this:

--- ide/ide.c   2008-03-03 20:10:28.000000000 +0800
+++ ide/ide_new.c       2008-03-04 00:09:46.000000000 +0800
@@ -661,20 +661,18 @@ EXPORT_SYMBOL_GPL(ide_deprecated_find_po
 int ide_register_hw(hw_regs_t *hw, void (*quirkproc)(ide_drive_t *),
                    ide_hwif_t **hwifp)
 {
-       int index, retry = 1;
+       int index;
        ide_hwif_t *hwif;
        u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };

-       do {
-               hwif = ide_deprecated_find_port(hw->io_ports[IDE_DATA_OFFSET]);
-               index = hwif->index;
-               if (hwif)
-                       goto found;
-               for (index = 0; index < MAX_HWIFS; index++)
-                       ide_unregister(index, 1, 1);
-       } while (retry--);
+       hwif = ide_deprecated_find_port(hw->io_ports[IDE_DATA_OFFSET]);
+       if (hwif)
+               goto found;
+       for (index = 0; index < MAX_HWIFS; index++)
+               ide_unregister(index, 1, 1);
        return -1;
 found:
+       index = hwif->index;
        if (hwif->present)
                ide_unregister(index, 0, 1);
        else if (!hwif->hold)

Please comment.

-- 
Regards,
Peter Teoh
