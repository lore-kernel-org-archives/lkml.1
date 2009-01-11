Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbZAKVF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbZAKVF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 16:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbZAKVFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 16:05:15 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:42470 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbZAKVFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 16:05:14 -0500
Date: Mon, 12 Jan 2009 00:05:32 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Daniel Drake <dsd@gentoo.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, klausman@gentoo.org,
       rth@twiddle.net
Subject: Re: cant compile on alpha with gcc-4.3 and CONFIG_ALPHA_NAUTILUS
Message-ID: <20090111210532.GA1641@jurassic.park.msu.ru>
References: <49688C67.5050502@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49688C67.5050502@gentoo.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 11:54:15AM +0000, Daniel Drake wrote:
> To fix this, we could remove -Werror or we could restructure the irq_srm
> code so that it is only compiled on systems that use it. One small
> function (srm_device_interrupt) is used all over the place so would have
> to be separated. Patch attached, which has been compile-tested on nautilus. 
> The disadvantage is that srm_device_interrupt() is now built on all alpha 
> sys types, but it is so small that it doesn't seem worth creating its own 
> file or creating ifdef spaghetti.
>
> Thoughts?

Your patch looks fine, but there is simpler fix which makes the compiler
to optimize problematic code away on systems with NR_IRQS <= 16.

Ivan.

diff --git a/arch/alpha/kernel/irq_srm.c b/arch/alpha/kernel/irq_srm.c
index 3221201..a03fbca 100644
--- a/arch/alpha/kernel/irq_srm.c
+++ b/arch/alpha/kernel/irq_srm.c
@@ -63,6 +63,8 @@ init_srm_irqs(long max, unsigned long ignore_mask)
 {
 	long i;
 
+	if (NR_IRQS <= 16)
+		return;
 	for (i = 16; i < max; ++i) {
 		if (i < 64 && ((ignore_mask >> i) & 1))
 			continue;
