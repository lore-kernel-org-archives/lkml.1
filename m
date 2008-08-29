Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbYH2Owv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbYH2Owv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 10:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbYH2Owi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 10:52:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:35172 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbYH2Owh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 10:52:37 -0400
Subject: Re: [PATCH 2/2][MTD] Add support for > 2GiB MTD devices
From: David Woodhouse <dwmw2@infradead.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Artem Bityutskiy <dedekind@infradead.org>,
       linux-mtd-bounces@lists.infradead.org,
       "'Bruce Leonard'" <brucle@earthlink.net>, Bruce_Leonard@selinc.com,
       linux-kernel@vger.kernel.org, Tim Anderson <tanderson@mvista.com>,
       linux-mtd@lists.infradead.org,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20080827152534.GB1371@logfs.org>
References: <1219817017.18027.149.camel@sauron>
	 <000201c9080d$0bce0d20$6b01a8c0@mvista.com>
	 <20080827093920.1bdb44c2@lxorguk.ukuu.org.uk>
	 <1219827692.7107.170.camel@pmac.infradead.org>
	 <20080827143416.GA1371@logfs.org> <1219848463.18027.166.camel@sauron>
	 <20080827152534.GB1371@logfs.org>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 29 Aug 2008 13:19:50 +0100
Message-Id: <1220012390.7107.359.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-27 at 17:25 +0200, Jörn Engel wrote:
> On Wed, 27 August 2008 17:47:43 +0300, Artem Bityutskiy wrote:
> > 
> > The plus of sysfs I see is that I can add more files to expose more
> > information in sysfs, while I can not change MEMGETINFO ioctl. E.g., I
> > need to expose sub-page size to user-space, and I cannot do this with
> > MEMGETINFO.
> 
> sysfs makes adding new attributes easier, yes.  But once added you
> cannot remove the attribute again - ever.  Which means that either way
> you need to tread carefully and think twice before making a rash
> decision.

That's not _necessarily_ true, although it should certainly be done with
care. Attributes in sysfs can be optional (in a way that they can't
really be optional if they're part of a binary ioctl payload), and
userspace can cope with them being absent. The sub-page size attribute
is something which wouldn't always be present, and we could happily just
drop it and forget about it in future if we really wanted to.

> > > So what was the reason again why mtd needs two userspace interfaces
> > > instead of just one?
> > 
> > I would like to make udev creating MTD devices, instead of creating them
> > by hands. Adding MTD to LDM would anyway introduce corresponding sysfs
> > files, right? This means we would have one more interface anyway.
> 
> Could be useful, I don't mind you sending a patch.  However, does this
> means that MEMGETINFO64 or some other ioctl should not be done?  Should
> flash_erase open, read and close 8 seperate files instead of doing a
> single ioctl?

It's hardly a fast path. And we don't have to worry about the fact that
it's non-atomic -- these things aren't exactly _changing_ over time.

> And should our support for large devices wait for the sysfs support
> that has been talked about and not done for about two years already?

You whine too much, Jörn. It doesn't take very long, as a proof of
concept, to add some attributes to the existing class support in
mtdchar.c ...

--- drivers/mtd/mtdchar.c~	2008-07-13 22:51:29.000000000 +0100
+++ drivers/mtd/mtdchar.c	2008-08-29 13:15:08.000000000 +0100
@@ -22,12 +22,32 @@
 
 static struct class *mtd_class;
 
+static ssize_t mtd_show_size(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct mtd_info *mtd = dev_get_drvdata(dev);
+	return sprintf(buf, "0x%x\n", mtd->size);
+}
+static ssize_t mtd_show_erasesize(struct device *dev, struct device_attribute *attr,
+				  char *buf)
+{
+	struct mtd_info *mtd = dev_get_drvdata(dev);
+	return sprintf(buf, "0x%x\n", mtd->erasesize);
+}
+
+static DEVICE_ATTR(size, S_IRUGO, mtd_show_size, NULL);
+static DEVICE_ATTR(erasesize, S_IRUGO, mtd_show_erasesize, NULL);
+
 static void mtd_notify_add(struct mtd_info* mtd)
 {
+	struct device *dev;
 	if (!mtd)
 		return;
 
-	device_create(mtd_class, NULL, MKDEV(MTD_CHAR_MAJOR, mtd->index*2), "mtd%d", mtd->index);
+	dev = device_create(mtd_class, NULL, MKDEV(MTD_CHAR_MAJOR, mtd->index*2), "mtd%d", mtd->index);
+	dev_set_drvdata(dev, mtd);
+	device_create_file(dev, &dev_attr_size);
+	device_create_file(dev, &dev_attr_erasesize);
 
 	device_create(mtd_class, NULL,
 		      MKDEV(MTD_CHAR_MAJOR, mtd->index*2+1), "mtd%dro", mtd->index);


Ok, so it shouldn't be only for mtdchar -- it should be generic, so we
should shift some of that into the mtd core code. And we should let
people hook up the 'parent' correctly, and there are a few other things
we should do to tidy it up. But it isn't exactly hard.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



