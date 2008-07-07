Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbYGGNEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbYGGNEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 09:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbYGGND4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 09:03:56 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:19733 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbYGGNDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 09:03:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=R2AGuikWsrxdFoCY/QiAoyTgQa2ZteonT7URgZRR6HuuhplpgvlRnEt6AV/ur+Ud+e
         5PV3HjA8DJw+70bBzGKXtFtlaPJsDHP9/WsZCosSJRdIS9h/VKQBx07XlaIY+V5MLrBw
         2M9PpAkRVqR7lhXsyAlMWBUMPuiXY2OnZSMZU=
Message-ID: <19f34abd0807070603p23b30372l5bee26b05b6fa9c7@mail.gmail.com>
Date: Mon, 7 Jul 2008 15:03:53 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Eric Sesterhenn" <snakebyte@gmx.de>
Subject: Re: [Linux-NTFS-Dev] Oops with corrupted NTFS image
Cc: "Anton Altaparmakov" <aia21@cam.ac.uk>,
       linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20080707122450.GC19313@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080706172147.GA19559@alice>
	 <F2EEF4B5-3E11-480A-93E7-9078BDC578EA@cam.ac.uk>
	 <20080707122450.GC19313@alice>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2008 at 2:24 PM, Eric Sesterhenn <snakebyte@gmx.de> wrote:
> (gdb) l *(ntfs_read_locked_inode+0x16c)
> 0xc030adbc is in ntfs_read_locked_inode (fs/ntfs/time.h:90).
> 85      static inline struct timespec ntfs2utc(const sle64 time)
> 86      {
> 87              struct timespec ts;
> 88
> 89              /* Subtract the NTFS time offset. */
> 90              u64 t = (u64)(sle64_to_cpu(time) - NTFS_TIME_OFFSET);
> 91              /*
> 92               * Convert the time to 1-second intervals and the remainder to
> 93               * 1-nano-second intervals.
> 94               */
> (gdb) quit
>
> Not sure why this happens. I checked out a fresh git tree to
> make sure my tree isnt broken or something. Might gcc be bogus
> or the debug information and the bug happens in reality somewhere else?

Are you sure you didn't recompile/relink vmlinux after getting the
error? If not, maybe it's gdb which gets confused (somehow) by the
inlining.

Your 'Code:' line decodes to these instructions:

   0:   8b 58 08                mov    0x8(%eax),%ebx
   3:   8b 70 0c                mov    0xc(%eax),%esi

And I find this in my own compiled vmlinux at:

c025bcc1:       8b 58 08                mov    0x8(%eax),%ebx
c025bcc4:       8b 70 0c                mov    0xc(%eax),%esi

which is at...

    $ addr2line -e vmlinux -i c025bcc1
    fs/ntfs/inode.c:670

which is...

        vi->i_mtime = ntfs2utc(si->last_data_change_time);

which is probably what is causing the NULL pointer dereference.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
