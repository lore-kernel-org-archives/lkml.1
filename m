Return-Path: <linux-kernel-owner+w=401wt.eu-S1764150AbYART3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764150AbYART3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 14:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760575AbYART3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 14:29:05 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35669 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758103AbYART3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 14:29:04 -0500
Date: Fri, 18 Jan 2008 19:28:35 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Byron Bradley <byron.bbradley@gmail.com>, Nick Piggin <npiggin@suse.de>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Russell King <rmk@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ramdisk driver: make rd_size non-static
Message-ID: <20080118192835.GA9367@flint.arm.linux.org.uk>
References: <1200621737-1458-1-git-send-email-byron.bbradley@gmail.com> <20080117182851.f9177571.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117182851.f9177571.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 06:28:51PM -0800, Andrew Morton wrote:
> On Fri, 18 Jan 2008 02:02:17 +0000 Byron Bradley <byron.bbradley@gmail.com> wrote:
> 
> > In arch/arm/kernel/setup.c:setup_ramdisk(), rd_size is set from the
> > boot tags. The replacement ramdisk driver has rd_size as static
> > which causes linking to fail when ramdisk is built-in.
> > 
> 
> but...
> 
> > diff --git a/drivers/block/brd.c b/drivers/block/brd.c
> > index 5ef1d26..8536480 100644
> > --- a/drivers/block/brd.c
> > +++ b/drivers/block/brd.c
> > @@ -385,7 +385,7 @@ static struct block_device_operations brd_fops = {
> >   * And now the modules code and kernel interface.
> >   */
> >  static int rd_nr;
> > -static int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
> > +int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
> >  module_param(rd_nr, int, 0);
> >  MODULE_PARM_DESC(rd_nr, "Maximum number of brd devices");
> >  module_param(rd_size, int, 0);
> 
> rd_size is a module parameter so it is settable via the
> syntax-which-i-can-never-remember.  rd.rd_size=1024 or something like that.
> 
> If that's all sane, do we have some back-compat reason to continue to
> support the special and duplicative rd_size parameter?
> 
> 
> (If we never did crap like this:
> 
> arch/arm/kernel/setup.c:        extern int rd_size, rd_image_start, rd_prompt, rd_doload;
> 
> then this sort of problem wouldn't occur so often)

We do "crap like this" because x86 did, and people wanted to set these
parameters at boot time, and in the old days of Linux (eg, 2.0), these
parameters were never available as command line arguments.  So the only
way to set them from boot loaders via architecture code is for architecture
code to reference the variable directly.

It looks like things have moved on in x86 land, but because there's an
utter lack of communication about these changes, the "planned obsolescence"
of rd_size hasn't been noticed.  So, I recommend that we keep rd_size
visible and take it through the now established feature-removal cycle,
including issuing kernel warnings about it if it gets used.

