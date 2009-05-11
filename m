Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbZEKQkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbZEKQkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 12:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbZEKQkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 12:40:36 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35388 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbZEKQkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 12:40:35 -0400
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] devtmpfs patches
References: <20090509143742.GA27663@kroah.com>
	<20090509150853.GA32394@suse.de>
	<20090509082233.32cbb8e4@infradead.org> <20090509161923.GA942@suse.de>
	<20090509223454.4642753d.akpm@linux-foundation.org>
	<20090510152005.GA9461@suse.de> <1241980263.9562.380.camel@laptop>
	<20090510221901.30c1c5a5@lxorguk.ukuu.org.uk>
	<ac3eb2510905101647k12a1b9ck71d43933037bac48@mail.gmail.com>
	<20090510170016.1e3a4d97@infradead.org>
	<ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 11 May 2009 09:40:26 -0700
In-Reply-To: <ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com> (Kay Sievers's message of "Mon\, 11 May 2009 03\:22\:53 +0200")
Message-ID: <m1k54nfv9h.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, greg@kroah.com, fabio.comolli@gmail.com, akpm@linux-foundation.org, gregkh@suse.de, peterz@infradead.org, alan@lxorguk.ukuu.org.uk, arjan@infradead.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> writes:

> Maybe you should just give it a try, apply the patch, and bring it up
> on a box with init=/bin/sh, look at /dev, load some modules and look
> at /dev again - and see the beauty. I'm pretty sure, when you've seen
> it for real, you never want to go back to static nodes or whatever
> other bad hacks to bootstrap /dev.

After it sunk in what you had said I had to go look at your patch.
You do magically and backwards incompatibly mount on top of /dev.

That part does not work, and who knows what static /dev setup you break.

The goal for kernel compile options is that they do not affect the
kernels behavior.  The behavior in devmtmpfs clearly does not match
that rule.  The kernel acts very different with it compiled in
and with it not compiled in. So that section of the code deserves.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

+/* After the root filesystem is mounted by the kernel at /root, or the
+ * initramfs in extracted at /root, this tmpfs will be mounted at /root/dev.
+ */
+int devtmpfs_mount(const char *mountpoint)
+{
+	struct path path;
+	int err;
+
+	if (!dev_mnt)
+		return 0;
+
+	err = kern_path(mountpoint, LOOKUP_FOLLOW, &path);
+	if (err)
+		return err;
+	err = do_add_mount(dev_mnt, &path, 0, NULL);
+	if (err)
+		printk(KERN_INFO "devtmpfs: error mounting %i\n", err);
+	else
+		printk(KERN_INFO "devtmpfs: mounted\n");
+	path_put(&path);
+	return err;
+}
+

--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -414,7 +414,7 @@ void __init prepare_namespace(void)
 
 	mount_root();
 out:
+	devtmpfs_mount("dev");
 	sys_mount(".", "/", NULL, MS_MOVE, NULL);
 	sys_chroot(".");
 }
-
