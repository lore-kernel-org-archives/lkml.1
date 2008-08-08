Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbYHHEK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbYHHEK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 00:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbYHHEKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 00:10:50 -0400
Received: from smtp.knology.net ([24.214.63.101]:53260 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbYHHEKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 00:10:49 -0400
Subject: Re: [GIT PULL]: firmware patches for building firmware into kernel
From: David Dillow <dave@thedillows.org>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1218166270.2540.9.camel@jaswinder.satnam>
References: <1218128219.14483.7.camel@jaswinder.satnam>
	 <1218130222.18118.7.camel@lap75545.ornl.gov>
	 <1218130475.14483.16.camel@jaswinder.satnam>
	 <1218133288.18118.20.camel@lap75545.ornl.gov>
	 <1218166270.2540.9.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 00:10:46 -0400
Message-Id: <1218168646.17642.27.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-08 at 09:01 +0530, Jaswinder Singh wrote:
> On Thu, 2008-08-07 at 14:21 -0400, David Dillow wrote:
> > I just looked at the tree; it still has locking issues, and needs
> > further review. You must protect the list from modification while you
> > iterate it looking for an match on the requested firmware. 
> 
> So here is updated patch:

I'll take a closer look when I'm awake, but there are some nitpicky
style issues remaining:

> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 6074321..71ec20d 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c

> @@ -568,19 +569,22 @@ void release_firmware(const struct firmware *fw)
>  {
>  	struct firmware_list *flst;
>  
> +	mutex_lock(&fw_lock);
>  	if (fw)
>  		list_for_each_entry(flst, &firmwarelist, list)
>  			if (fw == flst->fw) {
>  				printk(KERN_INFO
>  				       "firmware: releasing %s count %d\n",
>  				       flst->name, flst->count);
> -				mutex_lock(&fw_lock);
>  				flst->count--;
> -				mutex_unlock(&fw_lock);
> -				if (flst->count == 0)
> -					__release_firmware(fw, flst);
> -				return;
> +				if (flst->count == 0) {
> +					mutex_unlock(&fw_lock);
> +					return __release_firmware(fw, flst);
> +				}
> +				goto out;
>  			}
> +out:
> +	mutex_unlock(&fw_lock);
>  }

You don't need the 'goto out', a break will work fine. And you'll not be
pressed up against the right side of the screen if you just do
	if (!fw)
		return;
at the top of the function.
 
> @@ -598,6 +602,7 @@ void release_firmware_all(const struct firmware *fw)

I still don't like this exception to the get/put ref-counting. Is this
used anywhere else in your series, or was typhoon the only one?

> > Also, was it legal to call release_firmware() from an atomic context? It can now
> > sleep, which may be an issue...
>
> yes, release_firmware can sleep. 
> So now release_firmware also joined the family of request_firmware.

The question wasn't if it can sleep now, it was if it could sleep before
you started changing it. I now know that it has always called vfree(),
so it has always needed to be able to sleep.

> Any how release_firmware will be called below request_firmware or during
> exit, I do not think this will make any issue.

I need to run down code to see if my thoughts are realistic, but say
eth0 was a typhoon:

modprobe typhoon
ip link set eth0 up
rmmod typhoon
<firmware unloaded>
<sleep in typhoon_remove_one() waiting for 'ip link set eth0 down'>
<Tx timeout, needing to reset and reload firmware>
Boom.

Dave

