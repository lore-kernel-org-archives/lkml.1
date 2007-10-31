Return-Path: <linux-kernel-owner+w=401wt.eu-S1760765AbXJaWEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765AbXJaWEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760326AbXJaWBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:01:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760788AbXJaWBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:01:09 -0400
Date: Wed, 31 Oct 2007 15:01:07 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: vitalivanov@gmail.com
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb-devel@lists.sourceforge.net,
       greg@kroah.com, linux-kernel@vger.kernel.org, netwiz@crc.id.au,
       zaitcev@redhat.com
Subject: Re: USB: FIx locks and urb->status in adutux
Message-Id: <20071031150107.206892a4.zaitcev@redhat.com>
In-Reply-To: <1193831694.2226.35.camel@dell1.softservecom.com>
References: <20071022203447.db6d7950.zaitcev@redhat.com>
	<200710231138.38266.oliver@neukum.org>
	<20071023185302.5ce9d187.zaitcev@redhat.com>
	<1193234987.13750.21.camel@dell1.softservecom.com>
	<20071024202555.4f1cd215.zaitcev@redhat.com>
	<1193681097.20985.31.camel@dell1.softservecom.com>
	<20071029212433.c9837c4b.zaitcev@redhat.com>
	<1193749794.27085.15.camel@dell1.softservecom.com>
	<20071030145421.f1f0aa53.zaitcev@redhat.com>
	<1193831694.2226.35.camel@dell1.softservecom.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007 13:54:54 +0200, Vitaliy Ivanov <vitalivanov@gmail.com> wrote:
> On Tue, 2007-10-30 at 23:54, Pete Zaitcev wrote:
> 
> > One other small thing. I see you dropped the dev->mtx bracket that
> > I added around the initialization and submission. Notice that the
> > dev->udev is zeroed under dev->mtx, not the static lock. This is because
> > it has to be seen in read and write paths. If you don't like taking
> > across the submission, how about testing for it ahead of time?
> 
> I thought it can be managed under static lock.

The paragraph you quoted above explains why dev->udev cannot be managed
under the static lock: because dev->udev is accessed by read/write methods,
which do not take the static lock.

> I'm not sure what kind of testing do you mean by "ahead of time".

No, I meant testing before the rest of the ->open method is executed,
sorry. This part is "ahead of" the rest:

@@ -267,54 +290,54 @@ static int adu_open(struct inode *inode, struct file *file)
 	}
 
 	dev = usb_get_intfdata(interface);
-	if (!dev) {
+	if (!dev || !dev->udev) {
 		retval = -ENODEV;
 		goto exit_no_device;
 	}

Sorry about that. I'll try to be more explicit in the future.

> I just tried the latest patch and all seems to be good.
> BTW, slab corruption issue that I saw on the original driver we started fixing on is not an issue any more.

Very well, I'll post this for Greg anew today.

Do you still want to go ahead with a 2.4 backport?

-- Pete
