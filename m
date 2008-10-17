Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbYJQPS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbYJQPS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbYJQPSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:18:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46679 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754177AbYJQPSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:18:16 -0400
Date: Fri, 17 Oct 2008 11:18:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Zhaolei <zhaolei@cn.fujitsu.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       <dbrownell@users.sourceforge.net>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] Fix debugfs_create_file's error checking method for
 usb/gadget/
In-Reply-To: <48F88B22.6010102@cn.fujitsu.com>
Message-ID: <Pine.LNX.4.44L0.0810171114500.2178-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008, Zhaolei wrote:

> Hi,
> 
> debugfs_create_file() returns NULL if an error occurs, returns -ENODEV
> when debugfs is not enabled in the kernel.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  drivers/usb/gadget/s3c2410_udc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
> index 29d13eb..4ba50ef 100644
> --- a/drivers/usb/gadget/s3c2410_udc.c
> +++ b/drivers/usb/gadget/s3c2410_udc.c
> @@ -1894,7 +1894,7 @@ static int s3c2410_udc_probe(struct platform_device *pdev)
>  		udc->regs_info = debugfs_create_file("registers", S_IRUGO,
>  				s3c2410_udc_debugfs_root,
>  				udc, &s3c2410_udc_debugfs_fops);
> -		if (IS_ERR(udc->regs_info)) {
> +		if (IS_ERR(udc->regs_info) || !udc->regs_info) {
>  			dev_warn(dev, "debugfs file creation failed %ld\n",
>  				 PTR_ERR(udc->regs_info));
>  			udc->regs_info = NULL;

In fact the original code and your patch are both wrong.  The test 
should simply be:

		if (!udc->regs_info) {
			dev_warn(dev, "debugfs file creation failed\n");

(The line setting udc->regs_info to NULL can then be removed.)

The driver should be able to work even if debugfs isn't enabled in the 
kernel.

Alan Stern

