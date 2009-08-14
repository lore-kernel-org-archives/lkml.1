Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbZHNVyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbZHNVyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 17:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbZHNVyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 17:54:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:32028 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbZHNVyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 17:54:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=U9L1JKHzJG5SN6WvDa8QmeJx+tkTs3TlEGr+i+GfYnGY5YVJQfkrzkZopMJLjBK6yk
         cwrLODLc+cpy8CazSkPMInhDWf82sb6PM6qZSvxHW3q+y3rucgDSla+WjXiehHqpoc0q
         2r7mxee01VIPz3Lva9yIpqXNQTF9C6doixBo8=
Date: Fri, 14 Aug 2009 14:54:40 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Samsung backlight driver
References: <20090814194815.GA31474@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090814194815.GA31474@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090814222533.26D94526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Fri, Aug 14, 2009 at 12:48:15PM -0700, Greg KH wrote:
> +
> +static int update_status(struct backlight_device *bd)
> +{
> +	if (!pci_device)
> +		return -ENODEV;
> +	if (!backlight_device)

How is this possible?

> +		return -ENODEV;
> +
> +	current_brightness = bd->props.brightness;
> +	set_brightness();
> +	return 0;
> +}
> +
> +static struct backlight_ops backlight_ops = {
> +	.get_brightness	= get_brightness,
> +	.update_status	= update_status,
> +};
> +
> +static int find_video_card(void)
> +{
> +	struct pci_dev *dev = NULL;
> +
> +	while ((dev = pci_get_device(0x8086, 0x27ae, dev)) != NULL) {
> +		/* Found one, so let's save it off */
> +		if (!pci_device)
> +			pci_device = pci_dev_get(dev);

If you need to iterate all matching devices you need to save them all or
release references to "extras" right here... Or, better yet, just break
after you find the first one.

> +	}
> +
> +	if (!pci_device)
> +		return 0;

Why not -ENODEV? What is the point of having this driver loaded if the
device is not available? Then you could drop all silly "if (!pci_device)"
checks.

-- 
Dmitry
