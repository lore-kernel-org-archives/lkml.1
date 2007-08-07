Return-Path: <linux-kernel-owner+w=401wt.eu-S965101AbXHGU6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965101AbXHGU6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935459AbXHGUtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:49:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56220 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935387AbXHGUtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:49:43 -0400
Date: Tue, 7 Aug 2007 13:44:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@redhat.com>, Mark Salyzyn <mark_salyzyn@adaptec.com>
Subject: [2.6.22.2 review 24/84] aacraid: fix security hole
Message-ID: <20070807204452.GY23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="aacraid-fix-security-hole.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

On the SCSI layer ioctl path there is no implicit permissions check for
ioctls (and indeed other drivers implement unprivileged ioctls). aacraid
however allows all sorts of very admin only things to be done so should
check.

Signed-off-by: Alan Cox <alan@redhat.com>
Acked-by: Mark Salyzyn <mark_salyzyn@adaptec.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/aacraid/linit.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -597,6 +597,8 @@ static int aac_cfg_open(struct inode *in
 static int aac_cfg_ioctl(struct inode *inode,  struct file *file,
 		unsigned int cmd, unsigned long arg)
 {
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
 	return aac_do_ioctl(file->private_data, cmd, (void __user *)arg);
 }
 
@@ -650,6 +652,8 @@ static int aac_compat_ioctl(struct scsi_
 
 static long aac_compat_cfg_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 {
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
 	return aac_compat_do_ioctl((struct aac_dev *)file->private_data, cmd, arg);
 }
 #endif

-- 
