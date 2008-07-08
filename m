Return-Path: <linux-kernel-owner+w=401wt.eu-S1756469AbYGHThx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469AbYGHThx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 15:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbYGHThm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 15:37:42 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:35706 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbYGHThm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 15:37:42 -0400
Date: Tue, 8 Jul 2008 15:37:41 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: kyle@mcmartin.ca, kmcmartin@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padlock: don't whinge when loaded on a non-VIA cpu
Message-ID: <20080708193741.GB28899@phobos.i.cabal.ca>
References: <20080708190427.GA28899@phobos.i.cabal.ca> <20080708195211.1565f3d1@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080708195211.1565f3d1@the-village.bc.nu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2008 at 07:52:11PM +0100, Alan Cox wrote:
> On Tue, 8 Jul 2008 15:04:27 -0400
> Kyle McMartin <kmcmartin@redhat.com> wrote:
> 
> > I've become seriously tired of seeing these messages on every machine
> > running an i386 Fedora kernel...
> > 
> > padlock: VIA PadLock not detected.
> > padlock: VIA PadLock Hash Engine not detected.
> > 
> > So let's eliminate them!
> 
> Silly question - but why are they being printed even for older VIA
> processors. We don't see the following on boot
> 
> i386: no CMOV instruction detected
> i386: no SSE3 instruction detected
> 
> So I think your patch should be a bit more brutal ;)
> 

I completely agree, but I don't know anything about Centaur cpuids...

Something like this might suffice:

diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index bb30eb9..0192de4 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -384,6 +384,10 @@ static int __init padlock_init(void)
 {
 	int ret;
 
+	if (!((boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR) &&
+	     (boot_cpu_data.x86 >= 6)))	/* only on VIA C3 and above */
+		return -ENODEV;
+
 	if (!cpu_has_xcrypt) {
 		printk(KERN_ERR PFX "VIA PadLock not detected.\n");
 		return -ENODEV;
diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index c666b4e..70ec14b 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -253,6 +253,10 @@ static int __init padlock_init(void)
 {
 	int rc = -ENODEV;
 
+	if (!((boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR) &&
+	     (boot_cpu_data.x86 >= 6)))	/* only on VIA C3 and above */
+		return -ENODEV;
+
 	if (!cpu_has_phe) {
 		printk(KERN_ERR PFX "VIA PadLock Hash Engine not detected.\n");
 		return -ENODEV;
