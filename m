Return-Path: <linux-kernel-owner+w=401wt.eu-S1752479AbZHXNVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbZHXNVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 09:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbZHXNVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 09:21:13 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:34148 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbZHXNVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 09:21:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I2hlHywY8021l8DxlCc8l+unZj6GT6vMiUvlqkeHPb5spTW0n7mm2GbEmdJQ4CA4cB
         rl9zFxTL2lQyHaXMD6PL7rI6gPTbz5zH7tbisTH67pVzyzDce5GdCjMGfSteTqnwf7sH
         5hMzQZs9Q7GGMVGFhqsIsmg9TVu7LFLHbCfRU=
MIME-Version: 1.0
In-Reply-To: <20090824093143.GD25591@elf.ucw.cz>
References: <20090312092114.GC6949@elf.ucw.cz>
	 <200903121413.04434.rob@landley.net>
	 <20090316122847.GI2405@elf.ucw.cz>
	 <200903161426.24904.rob@landley.net>
	 <20090323104525.GA17969@elf.ucw.cz>
	 <87ljqn82zc.fsf@frosties.localdomain>
	 <20090824093143.GD25591@elf.ucw.cz>
Date: Mon, 24 Aug 2009 09:21:12 -0400
Message-ID: <87f94c370908240621n32ea310sd24196084c42107a@mail.gmail.com>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is 
	possible
From: Greg Freemyer <greg.freemyer@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com, tytso@mit.edu,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 5:31 AM, Pavel Machek<pavel@ucw.cz> wrote:
>
> Running journaling filesystem such as ext3 over flashdisk or degraded
> RAID array is a bad idea: journaling guarantees no longer apply and
> you will get data corruption on powerfail.
>
> We can't solve it easily, but we should certainly warn the users. I
> actually lost data because I did not understand these limitations...
>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>
> diff --git a/Documentation/filesystems/expectations.txt b/Documentation/filesystems/expectations.txt
> new file mode 100644
> index 0000000..80fa886
> --- /dev/null
> +++ b/Documentation/filesystems/expectations.txt
> @@ -0,0 +1,52 @@
> +Linux block-backed filesystems can only work correctly when several
> +conditions are met in the block layer and below (disks, flash
> +cards). Some of them are obvious ("data on media should not change
> +randomly"), some are less so.
> +
> +Write errors not allowed (NO-WRITE-ERRORS)
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Writes to media never fail. Even if disk returns error condition
> +during write, filesystems can't handle that correctly.
> +
> +       Fortunately writes failing are very uncommon on traditional
> +       spinning disks, as they have spare sectors they use when write
> +       fails.
> +
> +Don't cause collateral damage to adjacent sectors on a failed write (NO-COLLATERALS)
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Unfortunately, cheap USB/SD flash cards I've seen do have this bug,
> +and are thus unsuitable for all filesystems I know.
> +
> +       An inherent problem with using flash as a normal block device
> +       is that the flash erase size is bigger than most filesystem
> +       sector sizes.  So when you request a write, it may erase and
> +       rewrite some 64k, 128k, or even a couple megabytes on the
> +       really _big_ ones.
> +
> +       If you lose power in the middle of that, filesystem won't
> +       notice that data in the "sectors" _around_ the one your were
> +       trying to write to got trashed.
> +
> +       RAID-4/5/6 in degraded mode has same problem.
> +
> +
> +Don't damage the old data on a failed write (ATOMIC-WRITES)
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Either whole sector is correctly written or nothing is written during
> +powerfail.
> +
> +       Because RAM tends to fail faster than rest of system during
> +       powerfail, special hw killing DMA transfers may be necessary;
> +       otherwise, disks may write garbage during powerfail.
> +       This may be quite common on generic PC machines.
> +
> +       Note that atomic write is very hard to guarantee for RAID-4/5/6,
> +       because it needs to write both changed data, and parity, to
> +       different disks. (But it will only really show up in degraded mode).
> +       UPS for RAID array should help.

Can someone clarify if this is true in raid-6 with just a single disk
failure?  I don't see why it would be.

And if not can the above text be changed to reflect raid 4/5 with a
single disk failure and raid 6 with a double disk failure are the
modes that have atomicity problems.

Greg
