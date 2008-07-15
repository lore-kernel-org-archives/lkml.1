Return-Path: <linux-kernel-owner+w=401wt.eu-S1763121AbYGOT2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763121AbYGOT2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758986AbYGOT2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:28:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48892 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532AbYGOT2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:28:05 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080715185801.GH8185@mit.edu>
References: <alpine.LFD.1.10.0807141903260.3017@woody.linux-foundation.org>
	 <487C585C.2060002@garzik.org>
	 <alpine.LFD.1.10.0807150803580.3017@woody.linux-foundation.org>
	 <487CD7FE.9010209@garzik.org>
	 <alpine.LFD.1.10.0807151008450.3017@woody.linux-foundation.org>
	 <487CDEC0.3090004@garzik.org>
	 <alpine.LFD.1.10.0807151041080.3017@woody.linux-foundation.org>
	 <487CEA73.9000408@garzik.org>
	 <alpine.LFD.1.10.0807151124510.3017@woody.linux-foundation.org>
	 <487CF01E.6000208@garzik.org>  <20080715185801.GH8185@mit.edu>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 12:27:52 -0700
Message-Id: <1216150072.27455.366.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 14:58 -0400, Theodore Tso wrote:
> On Tue, Jul 15, 2008 at 02:44:46PM -0400, Jeff Garzik wrote:
> > All of the regressions examples I am citing are cured by  
> > firmware-in-module, because they are all examples of problems that occur  
> > when you remove the ability to reproduce the same functional pieces as  
> > 2.6.26.
> 
> Jeff,
> 
> 	I think you've said this before, but let me try to help you
> cut to the chase.  You are willing to *implement*
> firmware-in-the-module for request_firmware(), but you want a
> commitment that David Woodhouse and Linus will accept such a patch
> before you go off and write it.  Is that right?

The more important question is whether _Linus_ will take it, and of
course I can't answer for him.

Personally I think it's pointless. But since it's only _mildly_
counterproductive, if you really want to do it then I wouldn't actively
oppose it unless it turns out to be a mess to implement, or unless it's
limited to working only with the in-tree firmware.

If you implement it cleanly and optionally (and defaulting off), and if
it works properly with out-of-tree firmware too (so I can build a
libertas usb8xxx.ko module with the firmware included, for example),
then I certainly wouldn't throw my toys out of the pram over it.
Ideally, it would work for out-of-tree drivers (make M=... modules) too.

I was thinking that we could maybe post-process .ko files (which we do
already for other reasons), and add a special section in them containing
the firmware which is mentioned in MODULE_FIRMWARE() tags. The special
section is how we do it for the kernel too. That would take a little bit
of code in module.c to keep track of those sections and add them to a
list somewhere that firmware_class.c can see them, and then you have to
think about lifetime and locking issues.

But those were just preliminary thoughts -- I wasn't really planning to
implement it so I didn't go through it in detail.

An alternative approach might be to turn firmware blobs into actual
modules, which just register themselves with the firmware loader in
module_init(). I'm not sure I like that approach though, and depmod
wouldn't 'notice' them automatically so it wouldn't work with current
userspace. I've tried to be very careful to ensure that anything we do
here is entirely compatible with existing userspace.

-- 
dwmw2

