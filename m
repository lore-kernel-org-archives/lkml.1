Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbYGJHyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbYGJHyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 03:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbYGJHx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 03:53:59 -0400
Received: from queueout01-winn.ispmail.ntl.com ([81.103.221.31]:8728 "EHLO
	queueout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030AbYGJHx6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 03:53:58 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <200807100655.00857.elendil@planet.nl>
References: <200807100655.00857.elendil@planet.nl>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 10 Jul 2008 08:47:41 +0100
Message-Id: <1215676061.3452.29.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8BIT
X-SA-Exim-Connect-IP: 192.168.1.1
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [regression?] 2.6.26 floppy boot failure with kernel packed
	using 'upx'
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-10 at 06:54 +0200, Frans Pop wrote:
> The issue can also be reproduced using qemu without booting the floppy
> itself. For the "bad" image:
> # Boots correctly (but fails when mounting root fs):
> $ qemu -kernel vmlinuz -hda /dev/zero
> # Fails:
> $ qemu -kernel vmlinuz.upx -hda /dev/zero

I can repro this.

> So, the primairy question here is:
> - is this a kernel regression because whatever changed is no longer valid
>   conform "kernel format specs", or
> - is this a latent issue in upx that somehow creates an invalid image, or
> - does this change effectively create a new "type" of image that upx
>   just doesn't yet know how to handle correctly?

This is the first time I've looked at UPX but from glancing through the
code it certainly appears to make a lot of assumptions about the
structure of the bzImage (to the point that it looks for specific code
sequences within the binary).
﻿
It seems that the way UPX works is that it extracts the compressed image
from the bzImage, recompresses it and rebuilds a new bzImage replacing
the decompression stage (and possibly some of the other 16 bit startup,
I'm not quite sure yet) with its own. The issue is that its new
decompressor does not understand the ELF format and expects a raw
binary.

I think that UPX probably has gone a bit beyond the documented
interfaces, but it's not unreasonable way. In fact the changeset which
you referenced (or one of the ones around it) actually adds further
documentation (﻿in Documentation/x86/i386/boot.txt) and header fields to
aid in doing the sort of extraction UPX wants to do and documents more
explicitly the formats which can be expected to be found there. Also
around the same time a checksum field was defined which is invalidated
by the repacking.
﻿
All in all I'd say it should be treated as a new subtype/variant which
UPX should support. I'd say adding support for bzImage v2.08 to UPX
would be pretty easy for someone who knows the code base (I couldn't
even find the decompressor code, but then it's pre-coffee time here..).

Ian.
-- 
Ian Campbell

Fame lost its appeal for me when I went into a public restroom and an
autograph seeker handed me a pen and paper under the stall door.
		-- Marlo Thomas

