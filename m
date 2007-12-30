Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbXL3OGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbXL3OGM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 09:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbXL3OF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 09:05:58 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:34586 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbXL3OF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 09:05:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=Z9CjvJ2llgqZegs6vtEnkn81coAdI3gqWHnf61TDaEMF/rdM25i+zb6QzpCO49FgF5WTBxkQOnlkbYcGKfEq7oPmAvaL4z32dlA+Ezq/y9XE6C6e8YbuA82zgAJKrHgLlu0x80er2V/4uYh003m6lxzfMXJC0y19LYPdCt4iGwk=
Date: Sun, 30 Dec 2007 08:05:52 -0600
From: Josh Boyer <jwboyer@gmail.com>
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org, hidave.darkstar@gmail.com,
       lcapitulino@mandriva.com.br, linux-mtd@lists.infradead.org,
       randy.dunlap@oracle.com
Subject: Re: [PATCH]: 2.6.24-rc5: mtd: PNC-2000 oops
Message-ID: <20071230080552.744d5103@vader.jdub.homelinux.org>
In-Reply-To: <76599944@web.de>
References: <76599944@web.de>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Dec 2007 14:15:13 +0100
devzero@web.de wrote:

> while doing some systematical driver load/unload testing i have also come across this one.
> 
> searched lkml and found/tried this patch - seems to work fine, at least driver now behaves as expected:
> insmod: error inserting 'pnc2000.ko': -1 No such device or address
> 
> if it really _works_ is another story, but how can we know ? have searched the net a while for this hardware, but didn`t find _any_ reference that this hardware either exists or existed at all, so it looks that this hardware is very ancient or being used by japanese secret service, only !? :)

[snip] 
 
> @@ -64,16 +63,29 @@ static struct mtd_info *mymtd;
>  
>  static int __init init_pnc2000(void)
>  {
> +	int err;
> +
>  	printk(KERN_NOTICE "Photron PNC-2000 flash mapping: %x at %x\n", WINDOW_SIZE, \
> WINDOW_ADDR);  
> +	pnc_map.virt = ioremap(WINDOW_ADDR, WINDOW_SIZE);
> +	if (!pnc_map.virt) {
> +		printk("init_pnc2000(): failed to ioremap\n");
> +		return -EIO;
> +	}
> +
>  	simple_map_init(&pnc_map);
>  
>  	mymtd = do_map_probe("cfi_probe", &pnc_map);
>  	if (mymtd) {
>  		mymtd->owner = THIS_MODULE;
> -		return add_mtd_partitions(mymtd, pnc_partitions, 3);
> +		err = add_mtd_partitions(mymtd, pnc_partitions, 3);
> +		if (err) {
> +			printk("init_pnc2000(): add_mtd_partitions failed\n");
> +			iounmap(pnc_map.virt);
> +		}
>  	}
>  
> +	iounmap(pnc_map.virt);
>  	return -ENXIO;

Sorry, but no.  This bit here is bogus.  It will now iounmap and return
an error even if nothing went wrong.

josh
