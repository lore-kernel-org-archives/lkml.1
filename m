Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbYFYWQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbYFYWQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 18:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYFYWPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 18:15:53 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51715 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbYFYWPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 18:15:52 -0400
Date: Thu, 26 Jun 2008 00:15:29 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pcmcia@lists.infradead.org,
       bzolnier@gmail.com, linux-ide@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [regression] Re: 2.6.26-rc6: pcmcia stopped working
Message-ID: <20080625221529.GA1600@elf.ucw.cz>
References: <20080622224022.GA2066@elf.ucw.cz> <20080623081309.GA10820@isilmar.linta.de> <20080623081811.GA1850@elf.ucw.cz> <20080623083046.GA12849@isilmar.linta.de> <20080625102347.GA2011@elf.ucw.cz> <20080625110105.GA1551@elf.ucw.cz> <20080625215324.GA1562@elf.ucw.cz> <20080625220946.GA1587@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080625220946.GA1587@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Hmm, hitting sysrq-w produces no blocked task until I eject pcmcia
> > card. Backtrace there is:
> > 
> > Greg, I believe some traces lead to sysfs, can you help here?
> 
> ide_unregister() does not complete :-(.
> 
>         device_unregister(&hwif->gendev);
> +       printk("ide_unregister: waiting for rel_comp\n");
>         wait_for_completion(&hwif->gendev_rel_comp);
> 
> ...that wait_for_completion never returns.

...and this fixes PCMCIA/IDE for me... (Pseudopatch)

								Pavel

diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -336,29 +341,38 @@ void ide_unregister(ide_hwif_t *hwif)
 			++irq_count;
 		g = g->next;
 	} while (g != hwgroup->hwif);
 	if (irq_count == 1)
 		free_irq(hwif->irq, hwgroup);
 
 	ide_remove_port_from_hwgroup(hwif);
 
 	device_unregister(hwif->portdev);
 	device_unregister(&hwif->gendev);
-	wait_for_completion(&hwif->gendev_rel_comp);
+//	wait_for_completion(&hwif->gendev_rel_comp);
+	msleep(1000);
 
 	/*
 	 * Remove us from the kernel's knowledge
 	 */

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
