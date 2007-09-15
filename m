Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbXIOMpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbXIOMpA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 08:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbXIOMox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 08:44:53 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38631 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbXIOMow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 08:44:52 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46EBD3BA.9020306@s5r6.in-berlin.de>
Date: Sat, 15 Sep 2007 14:44:42 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: sysfs: spit a warning to users when they try to create a duplicate
 sysfs file
References: <20070913233751.GA10856@kroah.com> <20070913234118.GH10856@kroah.com>
In-Reply-To: <20070913234118.GH10856@kroah.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> We want to let people know when we create a duplicate sysfs file, as
> they need to fix up their code.
> 
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  fs/sysfs/dir.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -428,8 +428,12 @@ void sysfs_addrm_start(struct sysfs_addr
>   */
>  int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
>  {
> -	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name))
> +	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name)) {
> +		printk(KERN_WARNING, "sysfs: duplicate filename '%s' "
> +		       "can not be created\n", sd->s_name);
> +		WARN_ON(1);
>  		return -EEXIST;
> +	}
>  
>  	sd->s_parent = sysfs_get(acxt->parent_sd);
>  

As a side story:

I've got code which has checks for device_create_file != 0 but keeps
quiet if it got -EEXIST.  I rewrote it now so that it does not rely on
the driver core to skip over already existing files.  Doing this
revealed a group of old refcounting bugs. :-)  Thanks,
-- 
Stefan Richter
-=====-=-=== =--= -====
http://arcgraph.de/sr/
