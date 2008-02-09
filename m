Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbYBIGll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbYBIGll (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 01:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYBIGle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 01:41:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35774 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbYBIGlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 01:41:32 -0500
Date: Fri, 8 Feb 2008 22:45:31 -0800
From: Greg KH <greg@kroah.com>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 1/8] LinuxPPS core support.
Message-ID: <20080209064531.GA29926@kroah.com>
References: <1202493644764-git-send-email-giometti@linux.it> <120249364418-git-send-email-giometti@linux.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <120249364418-git-send-email-giometti@linux.it>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 07:00:37PM +0100, Rodolfo Giometti wrote:
> This patch adds the kernel side of the PPS support currently named
> "LinuxPPS".
> 
> PPS means "pulse per second" and a PPS source is just a device which
> provides a high precision signal each second so that an application
> can use it to adjust system clock time.
> 
> Common use is the combination of the NTPD as userland program with a
> GPS receiver as PPS source to obtain a wallclock-time with
> sub-millisecond synchronisation to UTC.
> 
> To obtain this goal the userland programs shoud use the PPS API
> specification (RFC 2783 - Pulse-Per-Second API for UNIX-like Operating
> Systems, Version 1.0) which in part is implemented by this patch. It
> provides a set of chars devices, one per PPS source, which can be used
> to get the time signal. The RFC's functions can be implemented by
> accessing to these char devices.
> 
> Signed-off-by: Rodolfo Giometti <giometti@linux.it>
> ---
>  MAINTAINERS          |    7 +
>  drivers/Kconfig      |    2 +
>  drivers/Makefile     |    1 +
>  drivers/pps/Kconfig  |   32 +++++
>  drivers/pps/Makefile |   10 ++
>  drivers/pps/kapi.c   |  272 +++++++++++++++++++++++++++++++++++++++
>  drivers/pps/pps.c    |  342 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/pps/sysfs.c  |  142 +++++++++++++++++++++

As you are adding sysfs files, please also describe them in
Documentation/ABI/ in this same series of patches.

> +void pps_sysfs_remove_source_entry(struct pps_device *pps)
> +{
> +	/* Delete info files */
> +	if (pps->info.mode & PPS_CAPTUREASSERT)
> +		device_remove_file(pps->dev, &dev_attr_assert);
> +
> +	if (pps->info.mode & PPS_CAPTURECLEAR)
> +		device_remove_file(pps->dev, &dev_attr_clear);
> +
> +	device_remove_file(pps->dev, &dev_attr_mode);
> +	device_remove_file(pps->dev, &dev_attr_echo);
> +	device_remove_file(pps->dev, &dev_attr_name);
> +	device_remove_file(pps->dev, &dev_attr_path);
> +}
> +
> +int pps_sysfs_create_source_entry(struct pps_device *pps)
> +{
> +	int ret;
> +
> +	/* Create file "assert" and "clear" according to source capability */
> +	if (pps->info.mode & PPS_CAPTUREASSERT) {
> +		ret = device_create_file(pps->dev, &dev_attr_assert);
> +		if (ret)
> +			dev_err(pps->dev, "unable to create \"assert\" "
> +					"sysfs entry");
> +	}
> +
> +	if (pps->info.mode & PPS_CAPTURECLEAR) {
> +		ret = device_create_file(pps->dev, &dev_attr_clear);
> +		if (ret)
> +			dev_err(pps->dev, "unable to create \"clear\" "
> +					"sysfs entry");
> +	}
> +
> +	ret = device_create_file(pps->dev, &dev_attr_mode);
> +	if (ret)
> +		dev_err(pps->dev, "unable to create \"mode\" sysfs entry");
> +	ret = device_create_file(pps->dev, &dev_attr_echo);
> +	if (ret)
> +		dev_err(pps->dev, "unable to create \"echo\" sysfs entry");
> +	ret = device_create_file(pps->dev, &dev_attr_name);
> +	if (ret)
> +		dev_err(pps->dev, "unable to create \"name\" sysfs entry");
> +	ret = device_create_file(pps->dev, &dev_attr_path);
> +	if (ret)
> +		dev_err(pps->dev, "unable to create \"path\" sysfs entry");

Why not use a default attribute group?

That way the files are created before the uevent is issued, and the
amount of code you have to write is much smaller.

thanks,

greg k-h
