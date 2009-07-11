Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbZGKATg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbZGKATg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 20:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757520AbZGKAT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 20:19:29 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:48346 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833AbZGKAT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 20:19:28 -0400
Subject: Re: No more vcs1 and vcsa1 in 2.6.30.N
From: Kay Sievers <kay.sievers@vrfy.org>
To: Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4A57A62C.2030302@yahoo.com.ar>
References: <4A57A62C.2030302@yahoo.com.ar>
Content-Type: text/plain
Date: Sat, 11 Jul 2009 02:19:24 +0200
Message-Id: <1247271564.32205.2.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-10 at 17:35 -0300, Gerardo Exequiel Pozzi wrote:
> Since upgrade my system to 2.6.30[.1]. I don't have anymore
> /sys/devices/virtual/vc/vcs1 and /sys/devices/virtual/vc/vcs1 in
> consequence not have anymore the corresponding char devs in /dev.

Seems we missed the consoles, which are always pre-allocated, and not
created on demand. Does this help?

Thanks,
Kay

diff --git a/drivers/char/vc_screen.c b/drivers/char/vc_screen.c
index d94d25c..c1791a6 100644
--- a/drivers/char/vc_screen.c
+++ b/drivers/char/vc_screen.c
@@ -495,11 +495,15 @@ void vcs_remove_sysfs(int index)
 
 int __init vcs_init(void)
 {
+	unsigned int i;
+
 	if (register_chrdev(VCS_MAJOR, "vcs", &vcs_fops))
 		panic("unable to get major %d for vcs device", VCS_MAJOR);
 	vc_class = class_create(THIS_MODULE, "vc");
 
 	device_create(vc_class, NULL, MKDEV(VCS_MAJOR, 0), NULL, "vcs");
 	device_create(vc_class, NULL, MKDEV(VCS_MAJOR, 128), NULL, "vcsa");
+	for (i = 0; i < MIN_NR_CONSOLES; i++)
+		vcs_make_sysfs(i);
 	return 0;
 }


