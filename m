Return-Path: <linux-kernel-owner+w=401wt.eu-S1751286Ab0AaF3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286Ab0AaF3u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 00:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155Ab0AaF3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 00:29:49 -0500
Received: from mail-pz0-f201.google.com ([209.85.222.201]:59650 "EHLO
	mail-pz0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab0AaF3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 00:29:48 -0500
X-Greylist: delayed 78237 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Jan 2010 00:29:48 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gpzuoPjo4+6AtfisUcrPufHlLTCV/xlJ8DTv4wjDyiH5Wxx8jITyjXT2QIv3onxVpH
         HH0vmlRPUVAtgbpKlxaCTVA3OEGiifRMAAP/BSw3x57iQz5CKpnAGiHIEnBgsOEtWfvI
         JpaUyA1dyzRgLJgjAuI8RflAoasqgd8zMICgs=
Date: Sat, 30 Jan 2010 21:29:42 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: John Kacur <jkacur@gmail.com>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: remove BKL from uinput open function
Message-ID: <20100131052942.GA12320@core.coreip.homeip.net>
References: <1264800197-29523-1-git-send-email-cascardo@holoscopio.com>
 <201001302257.09354.arnd@arndb.de>
 <520f0cf11001301507k20e3cf8dqa73026e12f3a1767@mail.gmail.com>
 <201001310520.55813.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001310520.55813.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31, 2010 at 05:20:55AM +0100, Arnd Bergmann wrote:
> On Sunday 31 January 2010, John Kacur wrote:
> > > Sorry, I should have been clearer, but not implementing llseek
> > > is the problem I was referring to: When a driver has no explicit
> > > .llseek operation in its file operations and does not call
> > > nonseekable_open from its open operation, the VFS layer will
> > > implicitly use default_llseek, which takes the BKL. We're
> > > in the process of changing drivers not to do this, one by one
> > > so we can kill the BKL in the end.
> > >
> > 
> > I know we've discussed this before, but why wouldn't the following
> > make more sense?
> >  .llseek         = no_llseek,
> 
> That's one of the possible solutions. Assigning it to generic_file_llseek
> also gets rid of the BKL but keeps the current behaviour (calling seek
> returns success without having an effect, no_llseek returns -ESPIPE),
> while calling nonseekable_open has the other side-effect of making
> pread/pwrite fail with -ESPIPE, which is more consistent than
> only failing seek.
> 

OK, so how about the patch below (on top of Thadeu's patch)?

-- 
Dmitry

Input: uinput - use nonseekable_open

Seeking does not make sense for uinput so let's use nonseekable_open
to mark the device non-seekable.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/misc/uinput.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)


diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index 18206e1..7089151 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -278,6 +278,7 @@ static int uinput_create_device(struct uinput_device *udev)
 static int uinput_open(struct inode *inode, struct file *file)
 {
 	struct uinput_device *newdev;
+	int error;
 
 	newdev = kzalloc(sizeof(struct uinput_device), GFP_KERNEL);
 	if (!newdev)
@@ -291,6 +292,12 @@ static int uinput_open(struct inode *inode, struct file *file)
 
 	file->private_data = newdev;
 
+	error = nonseekable_open(inode, file);
+	if (error) {
+		kfree(newdev);
+		return error;
+	}
+
 	return 0;
 }
 
