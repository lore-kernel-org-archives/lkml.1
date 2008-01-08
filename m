Return-Path: <linux-kernel-owner+w=401wt.eu-S1753466AbYAHT6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbYAHT6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYAHT6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:58:11 -0500
Received: from nz-out-0506.google.com ([64.233.162.231]:27013 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbYAHT6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:58:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NXo4F9D+En8evrlBXlZgMJIHt8GYerIeRcEZxO/PvDrQ2wmiFWdBbzhIP8prOtWtE4B5rv1WClXaeswptCN8F749+9CRClu05XxhQGhfR4XP1ROVD2tD19/Qnp2iAm3avB3v4PbBlULh12dQjdBQXPIYp8w44A6P4NHHHc6ls44=
Message-ID: <4d8e3fd30801081158j3e7292d0i939776342015b12d@mail.gmail.com>
Date: Tue, 8 Jan 2008 20:58:04 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       gorcunov@gmail.com
In-Reply-To: <20080108164015.GC31504@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080108164015.GC31504@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 8, 2008 5:40 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> Here's a proposal for some useful code transformations the kernel janitors
> could do as opposed to running checkpatch.pl.
>
> Most ioctl handlers still running implicitely under the big kernel
> lock (BKL). But long term Linux is trying to get away from that. There is a new
> ->unlocked_ioctl entry point that allows ioctls without BKL, but the code
> needs to be explicitely converted to use this.
>
> The first step of getting rid of the BKL is typically to make it visible
> in the source. Once it is visible people will have incentive to eliminate it.
> That is how the BKL conversion project for Linux long ago started too.
> On 2.0 all system calls were still implicitely BKL and in 2.1 the
> lock/unlock_kernel()s were moved into the various syscall functions and then
> step by step eliminated.
>
> And now it's time to do the same for all the ioctls too.
>
> So my proposal is to convert the ->ioctl handlers all over the tree
> to ->unlocked_ioctl with explicit lock_kernel()/unlock_kernel.
>
> It is not a completely trivial conversion. You will have to
> at least read the source, although not completely understand it.
> But it is not very difficult.
>
> Rough recipe:
>
> Grep the source tree for "struct file_operations". You should
> fine something like
>
> static int xyz_ioctl(struct inode *i, struct file *f, unsigned cmd, unsigned long arg)
> {
>         switch (cmd) {
>         case IOCTL1:
>                 err = ...;
>                 ...
>                 break;
>         case IOCTL2:
>                 ...
>                 err = ...;
>                 break;
>         default:
>                 err = -ENOTTY;
>         }
>         return err;
> }
> ...
>
> struct file_operations xyz_ops = {
>         ...
>         .ioctl = xyz_ioctl
> };
>
> The conversion is now to change the prototype of xyz_ioctl to
>
> static long xyz_ioctl(struct file *f, unsigned cmd, unsigned long arg)
> {
> }
>
> This means return type from int to long and drop the struct inode * argument
>
> Then add lock_kernel() to the entry point and unlock_kernel() to all exit points.
> So you should get
>
> static long xyz_ioctl(struct file *f, unsigned cmd, unsigned long arg)
> {
>         lock_kernel();
>         ...
>         unlock_kernel();
>         return err;
> }
>
> The only thing you need to watch out for is that all returns get an unlock_kernel.
> so e.g. if the ioctl handler has early error exits they all need an own unlock_kernel()
> (if you prefer it you can also use a goto to handle this, but just adding own
> unlock_kernels is easier)
>
> so e.g. if you have
>
> case IOCTL1:
>
>         ...
>         if (something failed)
>                 return -EIO;
>
> you would convert it to
>
>         if (something failed) {
>                 unlock_kernel();
>                 return -EIO;
>         }
>
> It is very important that all returns have an unlock_kernel(), please always
> double and triple check that!
>
> Then change
>
>         .ioctl = xyz_ioctl
>
> to
>
>         .unlocked_ioctl = xyz_ioctl
>
> Then compile ideally test the result and submit it.

Hi Andi,
I grepped and tried to do what you suggested.
The first file that git grep reported was:
arch/arm/common/rtctime.c:static const struct file_operations rtc_fops = {

So I cooked up the following patch (probably mangled, just to give you
a rough idea of what I did):
diff --git a/arch/arm/common/rtctime.c b/arch/arm/common/rtctime.c
index bf1075e..19dedb5 100644
--- a/arch/arm/common/rtctime.c
+++ b/arch/arm/common/rtctime.c
@@ -189,13 +189,16 @@ static int rtc_ioctl(struct inode *inode, struct
file *file, unsigned int cmd,
 		if (ret)
 			break;
 		ret = copy_to_user(uarg, &alrm.time, sizeof(tm));
-		if (ret)
+		if (ret) {
+			unlock_kernel();
 			ret = -EFAULT;
+		}
 		break;

 	case RTC_ALM_SET:
 		ret = copy_from_user(&alrm.time, uarg, sizeof(tm));
 		if (ret) {
+			unlock_kernel();
 			ret = -EFAULT;
 			break;
 		}
@@ -215,8 +218,10 @@ static int rtc_ioctl(struct inode *inode, struct
file *file, unsigned int cmd,
 		if (ret)
 			break;
 		ret = copy_to_user(uarg, &tm, sizeof(tm));
-		if (ret)
+		if (ret) {
+			unlock_kernel();
 			ret = -EFAULT;
+		}
 		break;

 	case RTC_SET_TIME:
@@ -226,6 +231,7 @@ static int rtc_ioctl(struct inode *inode, struct
file *file, unsigned int cmd,
 		}
 		ret = copy_from_user(&tm, uarg, sizeof(tm));
 		if (ret) {
+			unlock_kernel();
 			ret = -EFAULT;
 			break;
 		}
@@ -238,10 +244,12 @@ static int rtc_ioctl(struct inode *inode, struct
file *file, unsigned int cmd,
 		 * There were no RTC clocks before 1900.
 		 */
 		if (arg < 1900) {
+			unlock_kernel();
 			ret = -EINVAL;
 			break;
 		}
 		if (!capable(CAP_SYS_TIME)) {
+			unlock_kernel();
 			ret = -EACCES;
 			break;
 		}
@@ -257,6 +265,7 @@ static int rtc_ioctl(struct inode *inode, struct
file *file, unsigned int cmd,
 	case RTC_WKALM_SET:
 		ret = copy_from_user(&alrm, uarg, sizeof(alrm));
 		if (ret) {
+			unlock_kernel();
 			ret = -EFAULT;
 			break;
 		}
@@ -268,8 +277,10 @@ static int rtc_ioctl(struct inode *inode, struct
file *file, unsigned int cmd,
 		if (ret)
 			break;
 		ret = copy_to_user(uarg, &alrm, sizeof(alrm));
-		if (ret)
+		if (ret) {
+			unlock_kernel();
 			ret = -EFAULT;
+		}
 		break;

 	default:
@@ -329,15 +340,18 @@ static int rtc_fasync(int fd, struct file *file, int on)
 	return fasync_helper(fd, file, on, &rtc_async_queue);
 }

-static const struct file_operations rtc_fops = {
+static long rtc_fioctl(struct file_operations rtc_fops)
+{
+	lock_kernel();
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.read		= rtc_read,
 	.poll		= rtc_poll,
-	.ioctl		= rtc_ioctl,
+	.unlocked_ioctl	= rtc_ioctl,
 	.open		= rtc_open,
 	.release	= rtc_release,
 	.fasync		= rtc_fasync,
+	unlock_kernel();
 };

 static struct miscdevice rtc_miscdev = {

Unforunately, after I wrote the patch I noticed that on a vanilla
kernel that file doesn't compile
so I cannot verify the work I did.

Am I'm working in the right direction or should I completely redo the patch?

Thanks.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
