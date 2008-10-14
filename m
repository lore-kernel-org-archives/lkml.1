Return-Path: <linux-kernel-owner+w=401wt.eu-S1759065AbYJNJVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbYJNJVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 05:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756307AbYJNJUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 05:20:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:45095 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758836AbYJNJUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 05:20:48 -0400
Subject: Re: pktcdvd -> sysfs warning with 2.6.27
From: Kay Sievers <kay.sievers@vrfy.org>
To: Peter Osterlund <petero2@telia.com>
Cc: Greg KH <greg@kroah.com>, Nix <nix@esperi.org.uk>,
       linux-kernel@vger.kernel.org, a.zummo@towertech.it
In-Reply-To: <ac3eb2510810140138u438b3935ia134fe8e5dbb795a@mail.gmail.com>
References: <87vdvyngni.fsf@hades.wkstn.nix>
	 <20081012181700.GA21072@kroah.com> <87prm4mbgy.fsf@hades.wkstn.nix>
	 <20081013214747.GA15765@kroah.com> <m34p3f926s.fsf@telia.com>
	 <ac3eb2510810140138u438b3935ia134fe8e5dbb795a@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 11:20:41 +0200
Message-Id: <1223976041.5394.6.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-14 at 10:38 +0200, Kay Sievers wrote:
> On Tue, Oct 14, 2008 at 7:27 AM, Peter Osterlund <petero2@telia.com> wrote:
> > Greg KH <greg@kroah.com> writes:
> >
> >> On Mon, Oct 13, 2008 at 10:28:13PM +0100, Nix wrote:
> >>> On 12 Oct 2008, Greg KH uttered the following:
> >>> > Perhaps some other kernel code is registering with that same major/minor
> >>> > number, making it already present in sysfs.  Where does that sysfs file
> >>> > link to before you load your driver?
> >>>
> >>> Exactly so. This is probably *not* a regression after all: the only
> >>> change I made to my 2.6.27 config (weeks before actually rebooting, so I
> >>> forgot) was to build in the CMOS RTC driver, in a hopeless attempt to
> >>> make hrtimers work on this old hardware (I knew it was hopeless but
> >>> tried anyway). (Unsurprisingly it didn't work:
> >>> <http://www.ussg.iu.edu/hypermail/linux/kernel/0810.1/1033.html> worked,
> >>> thank *you* Jeff, I have glitch-free pulseaudio and microsecond sleeps
> >>> and several of my programs are happier!)
> >>>
> >>> And, looky here, a smoking gun:
> >>>
> >>> hades:~# ls -l /sys/dev/char/254:0 /dev/rtc*
> >>> lrwxrwxrwx 1 root root 0 2008-10-13 22:16 /sys/dev/char/254:0 -> ../../devices/platform/rtc_cmos/rtc/rtc0
> >>> hades:~# ls -l
> >>> lrwxrwxrwx 1 root root      4 2008-10-13 21:57 /dev/rtc -> rtc0
> >>> crw-r--r-- 1 root root 254, 0 2008-10-13 21:57 /dev/rtc0
> >>>
> >>> hades:~# pktsetup cdrw /dev/cdrw
> >>> hades:~# ls -l /dev/pktcdvd/
> >>> total 0
> >>> brw-r----- 1 root root  254,  0 2008-10-13 22:23 cdrw
> >>> crw-r--r-- 1 root root   10, 63 2008-10-13 21:57 control
> >>> brw-rw---- 1 root cdrom 254,  0 2008-10-13 22:23 pktcdvd0
> >>>
> >>> Am I right in assuming that this sort of isn't going to work? :)
> >>
> >> Yes, you are right :)
> >
> > I don't think so. One is a character device and the other is a block
> > device. Block devices didn't use to collide with character devices.
> > Has that changed recently?
> 
> No, that's still true.
> 
> >>> Major 254 is listed as LOCAL/EXPERIMENTAL USE in devices.txt. I don't
> >>> consider either pktcdvd or the rtc drivers as LOCAL/EXPERIMENTAL: the
> >>> former in particular has been in the kernel for years.
> >>
> >> Both of those should get "real" majors assigned to them.  It's not ok to
> >> randomly go grabbing major:minor numbers like this for code that is in
> >> mainline.
> >
> > It's not about random grabbing. It's about getting a dynamically
> > assigned number. The pktcdvd driver once had static numbers, but at
> > the time when the driver was merged into the mainline kernel, dynamic
> > numbers were considered better. Therefore I changed the driver to use
> > dynamic numbers.
> 
> The pktcdvd driver allocates a dynamic block major, which is fine. But
> doesn't it use the same number, and now not allocated, for the char
> devices it uses? That looks like something that needs to fixed, right?
> 
>   static void pkt_sysfs_dev_new(struct pktcdvd_device *pd)
>   {
>     if (class_pktcdvd) {
>       pd->dev = device_create_drvdata(class_pktcdvd, NULL,
>                                                 pd->pkt_dev, NULL,
>                                                 "%s", pd->name);

Something similar to this, with error checking, might be needed. It has
two independent majors now in block and char:
  $ grep pkt /proc/devices 
  251 pktcdvd-char
  252 pktcdvd


diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 29b7a64..07dd157 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -86,6 +86,7 @@
 static struct pktcdvd_device *pkt_devs[MAX_WRITERS];
 static struct proc_dir_entry *pkt_proc;
 static int pktdev_major;
+static int pktdev_char_major;
 static int write_congestion_on  = PKT_WRITE_CONGESTION_ON;
 static int write_congestion_off = PKT_WRITE_CONGESTION_OFF;
 static struct mutex ctl_mutex;	/* Serialize open/close/setup/teardown */
@@ -301,9 +302,11 @@ static struct kobj_type kobj_pkt_type_wqueue = {
 
 static void pkt_sysfs_dev_new(struct pktcdvd_device *pd)
 {
+	dev_t devno = MKDEV(pktdev_char_major, MINOR(pd->pkt_dev));
+
 	if (class_pktcdvd) {
 		pd->dev = device_create_drvdata(class_pktcdvd, NULL,
-						pd->pkt_dev, NULL,
+						devno, NULL,
 						"%s", pd->name);
 		if (IS_ERR(pd->dev))
 			pd->dev = NULL;
@@ -320,10 +323,12 @@ static void pkt_sysfs_dev_new(struct pktcdvd_device *pd)
 
 static void pkt_sysfs_dev_remove(struct pktcdvd_device *pd)
 {
+	dev_t devno = MKDEV(pktdev_char_major, MINOR(pd->pkt_dev));
+
 	pkt_kobj_remove(pd->kobj_stat);
 	pkt_kobj_remove(pd->kobj_wqueue);
 	if (class_pktcdvd)
-		device_destroy(class_pktcdvd, pd->pkt_dev);
+		device_destroy(class_pktcdvd, devno);
 }
 
 
@@ -3067,6 +3072,7 @@ static struct miscdevice pkt_misc = {
 static int __init pkt_init(void)
 {
 	int ret;
+	dev_t devno;
 
 	mutex_init(&ctl_mutex);
 
@@ -3083,6 +3089,9 @@ static int __init pkt_init(void)
 	if (!pktdev_major)
 		pktdev_major = ret;
 
+	alloc_chrdev_region(&devno, 0, 255, "pktcdvd-char");
+	pktdev_char_major = MAJOR(devno);
+
 	ret = pkt_sysfs_init();
 	if (ret)
 		goto out;
@@ -3117,6 +3126,8 @@ static void __exit pkt_exit(void)
 	pkt_debugfs_cleanup();
 	pkt_sysfs_cleanup();
 
+	unregister_chrdev_region(MKDEV(pktdev_char_major, 0), 255);
+
 	unregister_blkdev(pktdev_major, DRIVER_NAME);
 	mempool_destroy(psd_pool);
 }



