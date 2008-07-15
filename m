Return-Path: <linux-kernel-owner+w=401wt.eu-S1761031AbYGOThp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761031AbYGOThp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984AbYGOThh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:37:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54226 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbYGOThg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:37:36 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marcel Holtmann <marcel@holtmann.org>, Frans Pop <elendil@planet.nl>,
       jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>
	 <487C0365.5030203@garzik.org>
	 <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
	 <200807151757.10626.elendil@planet.nl>
	 <1216149637.27242.65.camel@violet.holtmann.net>
	 <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 12:36:56 -0700
Message-Id: <1216150616.27455.377.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 12:27 -0700, Linus Torvalds wrote:
> 
> On Tue, 15 Jul 2008, Marcel Holtmann wrote:
> > 
> > using /lib/firmware/`uname -r`/ is actually not a bad idea. You only
> > have to fix udev to actually include this in the list of directories to
> > look for firmware files. Also Ubuntu is already doing this.
> 
> I really don't think we need to even "fix udev".
> 
> Why don't we just load it ourselves? Esepcially as there are probably 
> places that try to avoid udev entirely, or at least use a very 
> cut-down-version.
> 
> We should be fairly trivially able to be _entirely_ backwards compatible 
> with any sane setup (not the _sane_ part! It implies that people don't 
> copy individual modules around by hand!), with no actual breakage or need 
> for distros to even update anything at all - just make the kernel able to 
> look up binary blobs in the same place it installed them.
> 
> That sounds like the RightThing(tm) to do _regardless_ of any other 
> issues, doesn't it? If the kernel installs it in some known place, why 
> should it not just read them from that known place?

I'm unconvinced that the kernel should be setting this kind of policy.

But I suppose if you make it tunable in sysfs and just switch to calling
do_filp_open() directly from firmware_class.c instead of punting to
userspace, that might work.

It leaves you with less flexibility -- it would prevent stuff like the
udev trick I posted a week or so back to fix the Intel microcode loader
by automatically generating the needed binary blob on the fly from
microcode.dat, for example.

We also have a long tradition of pointing and laughing at people who
want to call open() from within the kernel. But it _could_ work,
certainly.

I'm not really convinced it helps though. The script which creates an
initrd still needs to look at the MODULE_FIRMWARE() tag and include the
right firmware file. If that's broken, you're screwed anyway. And that
was true in 2.6.25 too.

-- 
dwmw2

