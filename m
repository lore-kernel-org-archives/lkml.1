Return-Path: <linux-kernel-owner+w=401wt.eu-S1763328AbXGVTik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763328AbXGVTik (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 15:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbXGVTic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 15:38:32 -0400
Received: from lazybastard.de ([212.112.238.170]:55266 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbXGVTib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 15:38:31 -0400
Date: Sun, 22 Jul 2007 21:34:50 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: drivers/mtd/devices/doc2000.c - address of 'eccbuf' will always evaluate as 'true' , warnings
Message-ID: <20070722193449.GA11479@lazybastard.org>
References: <46A349E6.3030207@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46A349E6.3030207@googlemail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 July 2007 14:13:26 +0200, Gabriel C wrote:
> 
> I noticed this warnings on current git with gcc 4.2.1
> 
> ....
> 
> drivers/mtd/devices/doc2000.c: In function 'doc_read':
> drivers/mtd/devices/doc2000.c:635: warning: the address of 'eccbuf' will always evaluate as 'true'
> drivers/mtd/devices/doc2000.c: In function 'doc_write':
> drivers/mtd/devices/doc2000.c:899: warning: the address of 'eccbuf' will always evaluate as 'true'
> 
> ....
> 
> This patch fixes it but maybe there is a better way to do it.
> 
> 
> Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
> ---
> 
> 
> diff --git a/drivers/mtd/devices/doc2000.c b/drivers/mtd/devices/doc2000.c
> index c73e96b..ce8fbf5 100644
> --- a/drivers/mtd/devices/doc2000.c
> +++ b/drivers/mtd/devices/doc2000.c
> @@ -632,7 +632,7 @@ static int doc_read(struct mtd_info *mtd, loff_t from, size_t len,
>  			len = ((from | 0x1ff) + 1) - from;
>  
>  		/* The ECC will not be calculated correctly if less than 512 is read */
> -		if (len != 0x200 && eccbuf)
> +		if (len != 0x200 && eccbuf != NULL)
>  			printk(KERN_WARNING
>  			       "ECC needs a full sector read (adr: %lx size %lx)\n",
>  			       (long) from, (long) len);
> @@ -896,7 +896,7 @@ static int doc_write(struct mtd_info *mtd, loff_t to, size_t len,
>  		/* Let the caller know we completed it */
>  		*retlen += len;
>  
> -		if (eccbuf) {
> +		if (eccbuf != NULL) {
>  			unsigned char x[8];
>  			size_t dummy;
>  			int ret;

The patches doesn't fix anything.  If you take a look at git history for
the file, you may find this:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7f8a894066b826a4baea49c2a3adbba0a56a192f

And if I read the patch correctly, Thomas merely forgot to remove these
two checks on eccbuf.  So the correct patch would remove '&& eccbuf'
from one conditional and nuke the other completely.

Care to send such a patch?

Jörn

-- 
ticks = jiffies;
while (ticks == jiffies);
ticks = jiffies;
-- /usr/src/linux/init/main.c
