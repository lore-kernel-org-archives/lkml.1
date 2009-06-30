Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbZGAJAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbZGAJAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbZGAI7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:59:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58106 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbZGAI7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:59:51 -0400
Date: Tue, 30 Jun 2009 08:31:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: tridge@samba.org
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090630063102.GB1351@ucw.cz>
References: <19013.8005.541836.436991@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19013.8005.541836.436991@samba.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> When VFAT_FS_DUALNAMES is disabled we avoid the creation of 8.3 short
> filenames for files on VFAT filesystems that require a long name. The
> patch uses a pattern of 11 bytes in the directory entry which contains
> invalid characters such that it cannot be considered to be a valid short
> filename.
> 
> Signed-off-by: Andrew Tridgell <tridge@samba.org>
> Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  fs/fat/Kconfig      |   20 +++++++++++++++++
>  fs/fat/dir.c        |   15 ++++++-------
>  fs/fat/namei_vfat.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 86 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/fat/Kconfig b/fs/fat/Kconfig
> index 182f9ff..907a5de 100644
> --- a/fs/fat/Kconfig
> +++ b/fs/fat/Kconfig
> @@ -74,6 +74,26 @@ config VFAT_FS
>  	  To compile this as a module, choose M here: the module will be called
>  	  vfat.
>  
> +config VFAT_FS_DUALNAMES
> +	bool "VFAT dual names support"
> +	depends on VFAT_FS


Defaults should be back-compatible.

> +
> +	  Users considering enabling this option should consider the implications
> +	  of any patents that may exist on dual filenames in VFAT.
> +
> +	  If unsure, say N

Say Y.

Users considering disabling this should understand that filesystem
they write to will not be valid vfat filesystems, and may trigger bugs
in  some devices.

> +#ifndef CONFIG_VFAT_FS_DUALNAMES
> +/*
> + * build a 11 byte 8.3 buffer which is not a short filename. We want 11
> + * bytes which:
> + *    - will be seen as a constant string to all APIs on Linux and Windows
> + *    - cannot be matched with wildcard patterns
> + *    - cannot be used to access the file
> + *    - has a low probability of collision within a directory
> + *    - has an invalid 3 byte extension
> + *    - contains at least one non-space and non-nul byte
> + */

What happens on collision? With 60000 entries in directory, there will
be 50% chance of collision. BAD.

Why not use something like position in directory instead of random
number?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
