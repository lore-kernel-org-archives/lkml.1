Return-Path: <linux-kernel-owner+w=401wt.eu-S932438AbXCJG5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbXCJG5r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 01:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932787AbXCJG5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 01:57:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43255 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932438AbXCJG5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 01:57:46 -0500
Date: Fri, 9 Mar 2007 22:55:56 -0800
From: Greg KH <gregkh@suse.de>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use attribute groups in struct device_type
Message-ID: <20070310065556.GB20302@suse.de>
References: <200703100137.35203.dtor@insightbb.com> <20070310065443.GA20302@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070310065443.GA20302@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 10:54:43PM -0800, Greg KH wrote:
> On Sat, Mar 10, 2007 at 01:37:34AM -0500, Dmitry Torokhov wrote:
> > Greg,
> > 
> > Please consider applying the patch below. It switches struct device_type
> > to using attribute groups which os more flexible. I am using it in my
> > input class_device -> device conversion (which is 99% done btw).
> 
> Argh, I never sent you my version of that, did I?  Very sorry about
> that, I was working on fixing up the device namespace issue first, which
> isn't done yet :(
> 
> Anyway, my patch that did that is below, feel free to use it or not if
> you want.
> 
> > I looked through -mm and the latest git and there does not seem to be
> > any users of struct device_type yet...
> 
> Yes, the input patch below uses it and I have a block-device patch from
> Kay in my tree that Andrew doesn't pull from (as it's usually really
> messed up and I know to hide this kind of breakage from him...)

Oops, that patch didn't use it, this follow-on patch from Kay uses them.

thanks,

greg k-h

------------

>From kay.sievers@novell.com Sat Oct  7 13:11:36 2006
From: Kay Sievers <kay.sievers@novell.com>
Date: Sat, 07 Oct 2006 21:54:55 +0200
Subject: Driver core: swich input_device to device_type
Message-Id: <1160250895.4235.23.camel@localhost>


Signed-off-by: Kay Sievers <kay.sievers@novell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/input.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -853,16 +853,10 @@ static int input_add_uevent_modalias_var
 static int input_dev_uevent(struct device *d, char **envp,
 			    int num_envp, char *buffer, int buffer_size)
 {
-	struct input_dev *dev;
+	struct input_dev *dev = to_input_dev(d);
 	int i = 0;
 	int len = 0;
 
-	/* input is a single class, this is only valid for input_dev's */
-	if (strncmp("input", kobject_name(&d->kobj), 5) != 0)
-		return 0;
-
-	dev = to_input_dev(d);
-
 	INPUT_ADD_HOTPLUG_VAR("PRODUCT=%x/%x/%x/%x",
 				dev->id.bustype, dev->id.vendor,
 				dev->id.product, dev->id.version);
@@ -898,10 +892,13 @@ static int input_dev_uevent(struct devic
 	return 0;
 }
 
+struct device_type input_dev_type = {
+	.uevent 		= input_dev_uevent,
+	.release 		= input_dev_release,
+};
+
 struct class input_class = {
 	.name			= "input",
-	.dev_release		= input_dev_release,
-	.dev_uevent		= input_dev_uevent,
 };
 EXPORT_SYMBOL_GPL(input_class);
 
@@ -922,6 +919,7 @@ struct input_dev *input_allocate_device(
 	if (dev) {
 		device_initialize(&dev->d);
 		dev->d.class = &input_class;
+		dev->d.type = &input_dev_type;
 		mutex_init(&dev->mutex);
 		INIT_LIST_HEAD(&dev->h_list);
 		INIT_LIST_HEAD(&dev->node);
