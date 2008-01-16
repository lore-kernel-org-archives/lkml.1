Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbYAPCtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbYAPCtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 21:49:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758312AbYAPCsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 21:48:39 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:57604 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758136AbYAPCse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 21:48:34 -0500
Date: Tue, 15 Jan 2008 18:48:08 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org, daniel.ritz-ml@swissonline.ch,
       jeff@garzik.org, linux-ide@vger.kernel.org
Subject: Re: [PATCHSET] printk: implement printk_header() and merging printk
Message-Id: <20080115184808.e64aed5e.randy.dunlap@oracle.com>
In-Reply-To: <1200445210549-git-send-email-htejun@gmail.com>
References: <1200445210549-git-send-email-htejun@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2008 10:00:06 +0900 Tejun Heo wrote:

> Hello, all.
> 
> This patchset implements printk_header() and mprintk - merging printk
> - to make printing multiline messages and assembling message
> piece-by-piece easier.
> 
> In a nutshell, printk_header() lets you do the following atomically
> (against other messages).
> 
>  code:
+   printk_header(KERN_INFO "ata1.00: ", "line0\nline1\nline2\n");
> 
>  output:
>   <6>ata1.00: line0
>   <6>         line1
>   <6>         line2
> 
> And mprintk the following.
> 
>  code:
>   DEFINE_MPRINTK(mp, 2 * 80);
> 
>   mprintk_set_header(&mp, KERN_INFO "ata%u.%2u: ", 1, 0);
>   mprintk_push(&mp, "ATA %d", 7);
>   mprintk_push(&mp, ", %u sectors\n", 1024);
>   mprintk(&mp, "everything seems dandy\n");

Looks pretty good to me except that I would change mprintk_push to
mprintk_add or mprintk_append (I think that I prefer _add).

>  output:
>   <6>ata1.00: ATA 7, 1024 sectors
>   <6>         everything seems dandy
> 
> Please read the commit messages and comments for more detail.  If this
> patchset is accepted, I'll write up Documentation/printk.txt which
> contains describtion of the API and guidelines - "don't pack unrelated
> messages into one" kind of stuff.
> 
> This patchset is against the current linux-2.6#master (031f2dcd) and
> contains the following patches.
> 
> 0001-printk-keep-log-level-on-multiline-messages.patch
> 0002-printk-implement-v-printk_header.patch
> 0003-printk-implement-merging-printk.patch
> 0004-libata-make-libata-use-printk_header-and-mprintk.patch
> 
>  drivers/ata/libata-core.c   |  202 +++++++++++++++----------
>  drivers/ata/libata-eh.c     |  150 ++++++++----------
>  drivers/ata/libata-pmp.c    |    5 
>  drivers/ata/libata-scsi.c   |    6 
>  drivers/ata/sata_inic162x.c |    2 
>  drivers/ata/sata_nv.c       |    4 
>  include/linux/kernel.h      |   83 ++++++++++
>  include/linux/libata.h      |   35 ++--
>  kernel/printk.c             |  354 ++++++++++++++++++++++++++++++++++++++++----
>  9 files changed, 630 insertions(+), 211 deletions(-)
> 
> More than half of the code increase in kernel.h are from the dummy
> declarations for !CONFIG_PRINTK.  More than one third of printk.c
> increase are comments.  On my x86-64 configuration, printk.o grows
> from 30152 to 34128.
> 
> libata code grows slightly but the increase is from converting the
> printk wrapper from #define to proper functions.  The converted areas
> - device configuration and EH reporting - were reduced in comlexity
> and size.  With all-y, drivers/ata/built-in.o shrinks from 726509 to
> 717657 mostly due to the conversion away from macros.


---
~Randy
