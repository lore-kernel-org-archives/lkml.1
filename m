Return-Path: <linux-kernel-owner+w=401wt.eu-S1761504AbXH0Wbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761504AbXH0Wbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 18:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755466AbXH0Wba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 18:31:30 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:49111 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbXH0Wb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 18:31:28 -0400
Date: Mon, 27 Aug 2007 15:30:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Michael J. Evans" <mjevans1983@comcast.net>
Cc: "Michael Evans" <mjevans1983@gmail.com>, "Neil Brown" <neilb@suse.de>,
       "Ingo Molnar" <mingo@redhat.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch v3 1/1] md: Software Raid autodetect dev list not array
Message-Id: <20070827153020.43788e21.randy.dunlap@oracle.com>
In-Reply-To: <200708271516.21889.mjevans1983@comcast.net>
References: <200708222058.45480.mjevans1983@comcast.net>
	<20070826095651.75e92556.randy.dunlap@oracle.com>
	<4877c76c0708261218r2c1ed2eeg6d604eeb58f6b235@mail.gmail.com>
	<200708271516.21889.mjevans1983@comcast.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007 15:16:21 -0700 Michael J. Evans wrote:

> Note: between 2.6.22 and 2.6.23-rc3-git5
>                 rdev = md_import_device(dev,0, 0);
> became
>                 rdev = md_import_device(dev,0, 90);
> So the patch has been edited to patch around that line. (might be fuzzy)

so you should update the patch to the latest mainline.

It's up to the (RAID) maintainer(s) if they want to merge a patch with fuzz.
Andrew may fix it up.  Linus wouldn't accept it with fuzz.

> Signed-off-by: Michael J. Evans <mjevans1983@gmail.com>
> =============================================================
> --- linux/drivers/md/md.c.orig	2007-08-21 03:19:42.511576248 -0700
> +++ linux/drivers/md/md.c	2007-08-21 04:30:09.775525710 -0700
> @@ -24,4 +24,6 @@
> 
> +   - autodetect dev list not array: Michael J. Evans <mjevans1983@gmail.com>
> +

Nowadays we use an SCM for such comments, not the source file(s).

>     This program is free software; you can redistribute it and/or modify
>     it under the terms of the GNU General Public License as published by
>     the Free Software Foundation; either version 2, or (at your option)
> @@ -5752,13 +5754,26 @@ void md_autodetect_dev(dev_t dev)
>   * Searches all registered partitions for autorun RAID arrays
>   * at boot time.
>   */
> -static dev_t detected_devices[128];
> -static int dev_cnt;
> +
> +static LIST_HEAD(all_detected_devices);
> +struct detected_devices_node {
> +	struct list_head list;
> +	dev_t dev;
> +};
>  
>  void md_autodetect_dev(dev_t dev)
>  {
> -	if (dev_cnt >= 0 && dev_cnt < 127)
> -		detected_devices[dev_cnt++] = dev;
> +	struct detected_devices_node *node_detected_dev;
> +	char strbuf[BDEVNAME_SIZE];
> +
> +	node_detected_dev = kzalloc(sizeof(*node_detected_dev), GFP_KERNEL);\

Drop the trailing '\', as someone has already commented on.

> +	if (node_detected_dev) {
> +		node_detected_dev->dev = dev;
> +		list_add_tail(&node_detected_dev->list, &all_detected_devices);
> +	} else {
> +		printk(KERN_CRIT "md: md_autodetect_dev: kzAlloc node failed"
> +		" (null return), skipping dev(%d,%d)\n", MAJOR(dev), MINOR(dev));

printk() formatting is bad.
Drop the " (null return)" and indent that line more than the
printk line is indented.

> +	}
>  }
>  
>  

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
