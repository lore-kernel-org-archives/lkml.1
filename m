Return-Path: <linux-kernel-owner+w=401wt.eu-S1762780AbXE1XDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762780AbXE1XDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 19:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbXE1XDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 19:03:32 -0400
Received: from fed1rmmtao107.cox.net ([68.230.241.39]:32903 "EHLO
	fed1rmmtao107.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbXE1XDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 19:03:31 -0400
From: Junio C Hamano <junkio@cox.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 3/3] Make ide dma blacklist handling a bit saner.
References: <20070521145042.GA6957@redhat.com>
	<7v3b1pbgeo.fsf_-_@assigned-by-dhcp.cox.net>
	<7vps4ta1iy.fsf_-_@assigned-by-dhcp.cox.net>
	<200705282141.42507.bzolnier@gmail.com>
Date: Mon, 28 May 2007 16:03:29 -0700
In-Reply-To: <200705282141.42507.bzolnier@gmail.com> (Bartlomiej
	Zolnierkiewicz's message of "Mon, 28 May 2007 21:41:42 +0200")
Message-ID: <7vfy5ga6v2.fsf@assigned-by-dhcp.cox.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> writes:

> The change itself looks good but IMO it is worth doing it before patch #2/3
> (it would also make it possible for me to merge this patch immediately).

Yes, I should have considered that the earlier #2/3 needs
coordination between you and Jeff.

> When it comes to patch #2 - Alan's comment may be a bit harsh but he seems
> to be right - there should be a common library-like file (ata-blacklist.c
> or ata-quirks.c or whatever name you like) containing ata_device_blacklist[].
>
> This would require slight modification of ide_in_drive_list() to teach
> it about ATA_HORKAGE_DMA ... Please also note that <linux/ata.h> is used by both
> IDE and libata so it should be a good place to put struct ata_blacklist_entry
> and ATA_HORKAGE_* macros.

Thanks for the hint.  Alan is correct to point out that I
cheated. ;-)  If I understand correctly, the change would
involve:

 - create a new file that has ata_device_blacklist[] whose type
   is "struct ata_blacklist_entry" (i.e. matches libata-core),
   by separating the table out of ata/libata-core.c.

   Q1. should that file go to drivers/ata/ or drivers/ide/?

 - make that file depended on when either libata and/or IDE is
   selected.

   Q2. Kconfig dependency rule is needed for this, perhaps.  How
   should that look like?

 - some out-of-tree drivers might be using ide_in_drive_list()
   and relying on it to take "struct drive_list_entry"; create a
   new function, ide_in_device_list(), that takes "struct
   ata_blacklist_entry" as its parameter.

   Q3. Is the 'out-of-tree drivers' a real issue, and if so, is
   the above a reasonable avenue to take?

 - convert in-tree callers to use ide_in_device_list() instead,
   feeding it ata_device_blacklist[], and remove drive_blacklist[]
   from drivers/ide/ide-dma.c.

   Q4. What would you like to do for drive_whitelist[]?

> Care to respin both patches?

Before the questions are answered I cannot respin the earlier
#2/3, but I can certainly respin #3/3.




