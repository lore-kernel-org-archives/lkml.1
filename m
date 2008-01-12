Return-Path: <linux-kernel-owner+w=401wt.eu-S1763347AbYALLLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763347AbYALLLV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 06:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761651AbYALLLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 06:11:12 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:59488 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762361AbYALLLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 06:11:10 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4788A039.4090802@s5r6.in-berlin.de>
Date: Sat, 12 Jan 2008 12:10:49 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: gregkh@suse.de, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] ieee1394 : use class iteration api
References: <20080112095008.GB2893@darkstar.te-china.tietoenator.com>
In-Reply-To: <20080112095008.GB2893@darkstar.te-china.tietoenator.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young wrote:
> +++ linux.new/drivers/ieee1394/nodemgr.c	2008-01-12 15:20:27.000000000 +0800
...
>  static void nodemgr_remove_uds(struct node_entry *ne)
>  {
>  	struct device *dev;
> -	struct unit_directory *tmp, *ud;
> +	struct unit_directory *ud;
>  
> -	/* Iteration over nodemgr_ud_class.devices has to be protected by
> -	 * nodemgr_ud_class.sem, but device_unregister() will eventually
> -	 * take nodemgr_ud_class.sem too. Therefore pick out one ud at a time,
> -	 * release the semaphore, and then unregister the ud. Since this code
> -	 * may be called from other contexts besides the knodemgrds, protect the
> -	 * gap after release of the semaphore by nodemgr_serialize_remove_uds.
> +	/* Use class_find device to iterate the devices. Since this code
> +	 * may be called from other contexts besides the knodemgrds,
> +	 * protect it by nodemgr_serialize_remove_uds.
>  	 */
>  	mutex_lock(&nodemgr_serialize_remove_uds);
> -	for (;;) {
> -		ud = NULL;
> -		down(&nodemgr_ud_class.sem);
> -		list_for_each_entry(dev, &nodemgr_ud_class.devices, node) {
> -			tmp = container_of(dev, struct unit_directory,
> -					   unit_dev);
> -			if (tmp->ne == ne) {
> -				ud = tmp;
> -				break;
> -			}
> -		}
> -		up(&nodemgr_ud_class.sem);
> -		if (ud == NULL)
> -			break;
> -		device_unregister(&ud->unit_dev);
> -		device_unregister(&ud->device);
> +	dev = class_find_device(&nodemgr_ud_class, ne, __match_ne);
> +	if (!dev) {
> +		mutex_unlock(&nodemgr_serialize_remove_uds);
> +		return;
>  	}
> +	ud = container_of(dev, struct unit_directory, unit_dev);
> +	device_unregister(&ud->unit_dev);
> +	device_unregister(&ud->device);
>  	mutex_unlock(&nodemgr_serialize_remove_uds);
>  }

A quick response on this change, without having checked the rest yet:

This doesn't work.  Each "ne" may have zero or more "ud".  The purpose
of nodemgr_remove_uds is to kill all of the uds of one ne.  After your
change, only the first ud of a ne would be gone.

You need to keep the loop which takes care that all of the uds of the ne
are removed.

Furthermore, I usually try to use "goto" or "break" constructs with
single unlock + return path instead of multiple unlock + return paths.
However, if these unlock + return paths are as visually close together
as they are here, it doesn't really matter (to me) which of the styles
is used.

BTW, you don't need to CC <krh@redhat.com> on drivers/ieee1394/ patches
(CONFIG_IEEE1394).  He only looks after drivers/firewire/
(CONFIG_FIREWIRE).  I know, these are details, and everybody confuses
them.  :-)  I should try to clarify this in MAINTAINERS.
-- 
Stefan Richter
-=====-==--- ---= -==--
http://arcgraph.de/sr/
