Return-Path: <linux-kernel-owner+w=401wt.eu-S935046AbXGMWYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935046AbXGMWYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 18:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbXGMWX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 18:23:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33507 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbXGMWX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 18:23:58 -0400
Message-ID: <4697FB6D.9060700@zytor.com>
Date: Fri, 13 Jul 2007 15:23:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Etienne Lorrain <etienne_lorrain@yahoo.fr>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: x86 setup code rewrite in C - revised
References: <526073.18540.qm@web26902.mail.ukl.yahoo.com> <4697A9E9.3090502@redhat.com>
In-Reply-To: <4697A9E9.3090502@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
>>  - The VGA recalc has the same bug as the assembly version where a VGA write protected
>>    register is written (Overflow register) without setting the enable bit (see VGA docs).

I dug into this, and it turns out you're incorrect.  Both the assembly
code and the C code are, in fact, 100% correct:

The only instance of writing the vertical overflow register is this code
in vga_set_480_scanlines():

	out_idx(0x0c, crtc, 0x11); /* Vertical sync end, unlock CR0-7 */
	out_idx(0x0b, crtc, 0x06); /* Vertical total */
	out_idx(0x3e, crtc, 0x07); /* Vertical overflow */
	out_idx(0xea, crtc, 0x10); /* Vertical sync start */
	out_idx(end,  crtc, 0x12); /* Vertical display end */
	out_idx(0xe7, crtc, 0x15); /* Vertical blank start */
	out_idx(0x04, crtc, 0x16); /* Vertical blank end */

Register 0x11 has the Protect (not enable!) bit in it, it is bit 7.  As
you can see, it is cleared (meaning writable) at the beginning of this
sequence, and the fact that it's being done is even documented.

	-hpa
