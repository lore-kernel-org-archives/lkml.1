Return-Path: <linux-kernel-owner+w=401wt.eu-S1752532AbYJTDtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbYJTDtK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 23:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbYJTDs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 23:48:56 -0400
Received: from kroah.org ([198.145.64.141]:39961 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751321AbYJTDsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 23:48:55 -0400
Date: Sun, 19 Oct 2008 20:46:39 -0700
From: Greg KH <greg@kroah.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net, linux-usb@vger.kernel.org
Subject: Re: [PATCH] Fix debugfs_create_file's error checking method for
	usb/gadget/
Message-ID: <20081020034639.GB26650@kroah.com>
References: <Pine.LNX.4.44L0.0810171114500.2178-100000@iolanthe.rowland.org> <4F580DA88E8146FC8BDA0789613AB813@zhaoleiwin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F580DA88E8146FC8BDA0789613AB813@zhaoleiwin>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 09:15:16AM +0800, Zhaolei wrote:
> From: "Alan Stern" <stern@rowland.harvard.edu>
> To: "Zhaolei" <zhaolei@cn.fujitsu.com>
> Cc: <linux-kernel@vger.kernel.org>; <dbrownell@users.sourceforge.net>; <linux-usb@vger.kernel.org>
> Sent: Friday, October 17, 2008 11:18 PM
> Subject: Re: [PATCH] Fix debugfs_create_file's error checking method for usb/gadget/
> 
> 
> > On Fri, 17 Oct 2008, Zhaolei wrote:
> > 
> >> Hi,
> >> 
> >> debugfs_create_file() returns NULL if an error occurs, returns -ENODEV
> >> when debugfs is not enabled in the kernel.
> >> 
> >> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> >> ---
> >>  drivers/usb/gadget/s3c2410_udc.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >> 
> >> diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
> >> index 29d13eb..4ba50ef 100644
> >> --- a/drivers/usb/gadget/s3c2410_udc.c
> >> +++ b/drivers/usb/gadget/s3c2410_udc.c
> >> @@ -1894,7 +1894,7 @@ static int s3c2410_udc_probe(struct platform_device *pdev)
> >>  udc->regs_info = debugfs_create_file("registers", S_IRUGO,
> >>  s3c2410_udc_debugfs_root,
> >>  udc, &s3c2410_udc_debugfs_fops);
> >> - if (IS_ERR(udc->regs_info)) {
> >> + if (IS_ERR(udc->regs_info) || !udc->regs_info) {
> >>  dev_warn(dev, "debugfs file creation failed %ld\n",
> >>  PTR_ERR(udc->regs_info));
> >>  udc->regs_info = NULL;
> > 
> > In fact the original code and your patch are both wrong.  The test 
> > should simply be:
> > 
> > if (!udc->regs_info) {
> > dev_warn(dev, "debugfs file creation failed\n");
> > 
> Hello, Alan Stern
> 
> If we only check if (!udc->regs_info), that is no problem except that we
> can't see dev_warn when debugfs isn't enabled in the kernel.
> It this warning message is not necessary, I agree with you.

Why would you want to see that message if debugfs wasn't selected?  You
shouldn't need to see it, that is why the debugfs code doesn't return
NULL if it is compiled out.  I did it that way to make all callers much
simpler :)

thanks,

greg k-h
