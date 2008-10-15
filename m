Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbYJOVTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbYJOVTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbYJOVTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:19:09 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:52556 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753367AbYJOVTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:19:08 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhsBAF/79UhR8Vqu/2dsb2JhbAAIwjGBaw
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [Linux-uvc-devel] [BUG] NULL pointer dereference caused by uvcvideo stress test
Date: Wed, 15 Oct 2008 23:19:17 +0200
User-Agent: KMail/1.9.9
Cc: linux-uvc-devel@lists.berlios.de,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
References: <gbiduj$9p3$1@ger.gmane.org> <200810152017.47347.laurent.pinchart@skynet.be> <48F63C4E.3070103@tuffmail.co.uk>
In-Reply-To: <48F63C4E.3070103@tuffmail.co.uk>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_V5l9IffuyycGmcm"
Message-Id: <200810152319.17925.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_V5l9IffuyycGmcm
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Alan,

On Wednesday 15 October 2008, Alan Jenkins wrote:
> Laurent Pinchart wrote:
> > On Wednesday 15 October 2008, Alan Jenkins wrote:
> > > If you look at the trace, it happens as "hald-probe-video" opens the
> > > video device.  This is from Ubuntu 8.04.  Possibly it's significant that
> > > I use the camera first, to make sure it works (I use Kopete, the
> > > settings dialogue includes a video test).
> >
> > The NULL pointer (or rather 0x00000030 pointer) dereference happens in
> > video_open:
> >
> >         file->f_op = fops_get(vfl->fops);
> >         if (file->f_op->open)
> >                 err = file->f_op->open(inode, file);
> >
> > file->f_op ends up being NULL. Either vfl->fops is NULL to begin with, or
> > fops_get failed to get a reference to the file_operations structure.
> >
> > I'd be surprised if vfl->fops was NULL. To rule out that case, can you
> > add a BUG_ON(vfl->fops == NULL) before the call to fops_get ?
> >
> > I'm not too familiar with the module loader, but a quick look at the code
> > shows that the module could be marked as being unloaded
> > (MODULE_STATE_GOING) before its exit function is called. If this is the
> > case video_open would still be called, as the video device would still be
> > registered, but fops_get would fail in try_module_get and return a NULL
> > pointer. It seems the pointer returned by fops_get should be tested in
> > video_open.
> >
> > I've CC'ed the v4l maintainer to get his opinion on this.
>
> I put one before and one after
>
> 134    BUG_ON(vfl->fops == NULL);
> 135    file->f_op = fops_get(vfl->fops);
> 136    BUG_ON(file->f_op == NULL);
>
> and the second one triggered

This confirms my suspicion. Could you please try the attached patch ?

Best regards,

Laurent Pinchart

--Boundary-00=_V5l9IffuyycGmcm
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="fops_get_check.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="fops_get_check.patch"

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 155fdec..7a3c1ed 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -132,6 +132,11 @@ static int video_open(struct inode *inode, struct file *file)
 	}
 	old_fops = file->f_op;
 	file->f_op = fops_get(vfl->fops);
+	if (file->f_op == NULL) {
+		file->f_op = old_fops;
+		err = -ENODEV;
+		goto out;
+	}
 	if (file->f_op->open)
 		err = file->f_op->open(inode, file);
 	if (err) {
@@ -139,6 +144,7 @@ static int video_open(struct inode *inode, struct file *file)
 		file->f_op = fops_get(old_fops);
 	}
 	fops_put(old_fops);
+out:
 	mutex_unlock(&videodev_lock);
 	unlock_kernel();
 	return err;

--Boundary-00=_V5l9IffuyycGmcm--
