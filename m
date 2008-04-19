Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbYDSGA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbYDSGA0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 02:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYDSGAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 02:00:16 -0400
Received: from dtp.xs4all.nl ([80.126.206.180]:17806 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751922AbYDSGAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 02:00:14 -0400
Date: Sat, 19 Apr 2008 08:00:11 +0200
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Jeff Garzik <jeff@garzik.org>
Cc: alan@redhat.com, R.E.Wolff@BitWizard.nl,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/15] drivers/char: minor irq handler cleanups
Message-ID: <20080419060011.GA29321@bitwizard.nl>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com> <e3b010fa8e3bc3a5e386759f01f69c80918923e7.1208559659.git.jgarzik@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3b010fa8e3bc3a5e386759f01f69c80918923e7.1208559659.git.jgarzik@redhat.com>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 07:22:51PM -0400, Jeff Garzik wrote:
> This change's main purpose is to prepare for the patchset in
> jgarzik/misc-2.6.git#irq-remove, that explores removal of the
> never-used 'irq' argument in each interrupt handler.

The changes look sane, (for the drivers that I'm involved with). 

However, you're now adding a second parameter to my interrupt
routines: "polled" to replace the "never used" irq parameter. (which
/was/ used to determine wether we were called polled or not... 

On the other hand, most hardware should work if you remove the if
(!polled).


You added a "XXX Using free_irq in the interrupt is not wise!". When I
wrote that code, I didn't know about this. These lines triggered when
the level-triggered PCI interrupt stuck "active" this would mean that
NO userspace code would get executed anymore: Hard lock up. Difficult
to debug. This happend a few times during development when the code
behind the "if (!polled)": "tell the hardware we've seen the
interrupt" didn't work. On the other hand, some failures in the field
have triggered this. So I think it's wise to keep it in. Disabling the
interrupt on the card is not an option, because that's exactly what
this is supposed to catch: We're unable to make the card stop
interrupting the CPU.

Note that it also doesn't work (i.e. hard lock of the machine) if some
other driver is using the same interupt.

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
