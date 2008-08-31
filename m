Return-Path: <linux-kernel-owner+w=401wt.eu-S1759355AbYHaMf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355AbYHaMf2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 08:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758380AbYHaMfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 08:35:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:24497 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757715AbYHaMfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 08:35:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=NYeWPV8FZ+EqFo1eRpq2f0LEjhrj8YYqZTEPkn9mf3hD3/p2Jddg5xraZz2/GQMSA9
         dczbkaeI3NGAYZNKjii0KHHh/5yEal23BR44ep2jAIy+By3x+OobyujLmSfuh9z8nIRz
         rD4xRGr8crRVJ8CKk2QBrGJvBNBIuyyEkwHdA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for August 29
Date: Sun, 31 Aug 2008 14:32:30 +0200
User-Agent: KMail/1.9.9
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@redhat.com>
References: <20080829194010.5ca53e33.sfr@canb.auug.org.au>
In-Reply-To: <20080829194010.5ca53e33.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808311432.30496.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday 29 August 2008, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since next-20080828:

All block issuses have been fixed now (thanks guys!)
but the new warning emerged:

sysctl table check failed: /kernel/pty/nr .1.62.2 No data
Pid: 1, comm: swapper Not tainted 2.6.27-rc3-00458-g0ea12ec-dirty #196
 [<c012e004>] set_fail+0x30/0x39
 [<c012e436>] sysctl_check_table+0x429/0x467
 [<c012e44d>] sysctl_check_table+0x440/0x467
 [<c012e44d>] sysctl_check_table+0x440/0x467
 [<c01206d3>] __register_sysctl_paths+0xab/0x23c
 [<c02f8fb9>] mutex_lock+0x15/0x23
 [<c015f0ed>] exact_lock+0x0/0xd
 [<c012087e>] register_sysctl_paths+0x1a/0x1c
 [<c03d8106>] pty_init+0x215/0x293
 [<c0101122>] _stext+0x3a/0x12a
 [<c03d7ef1>] pty_init+0x0/0x293
 [<c018a1a8>] create_proc_entry+0x72/0x84
 [<c013ea0d>] register_irq_proc+0x6b/0x84
 [<c03c443b>] kernel_init+0x6d/0xb9
 [<c03c43ce>] kernel_init+0x0/0xb9
 [<c01037f3>] kernel_thread_helper+0x7/0x10
 =======================

git bisect points at:

commit 0ea12ecc2f11ab28478939a5902505bd47f9b765
Author: Alan Cox <alan@redhat.com>
Date:   Fri Aug 29 09:28:10 2008 +1000

    tty-driver-kref

and somehow the following chunk looks suspicious:

--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -571,8 +571,11 @@ static void __init unix98_pty_init(void)
        if (tty_register_driver(pts_driver))
                panic("Couldn't register Unix98 pts driver");

+       /* FIXME: WTF */
+#if 0
        pty_table[1].data = &ptm_driver->refcount;
-       register_sysctl_table(pty_root_table);
+#endif
+       register_sysctl_table(pty_root_table);

        /* Now create the /dev/ptmx special device */
        tty_default_fops(&ptmx_fops);

Unfortunately it cannot be simply reverted so it seems
like WTF part will need some work after all... ;)
