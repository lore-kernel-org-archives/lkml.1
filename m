Return-Path: <linux-kernel-owner+w=401wt.eu-S1763062AbXG2Nux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763062AbXG2Nux (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 09:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762399AbXG2Nuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 09:50:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56969 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762292AbXG2Nup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 09:50:45 -0400
Message-ID: <46AC9B28.6060906@zytor.com>
Date: Sun, 29 Jul 2007 06:50:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: bbpetkov@yahoo.de
CC: Xudong Guan <xudong.guan@gmail.com>, linux-kernel@vger.kernel.org,
       Chuck Ebbert <cebbert@redhat.com>
Subject: Re: 2.6.23-rc1: no setup signature found...
References: <20070724112618.GA4431@gollum.tnic> <20070726150854.GA7034@xguan-laptop> <46A8BB6C.6050903@zytor.com> <20070726163053.GA4570@gollum.tnic> <46A8E3F9.5070809@zytor.com> <20070727013615.GC4570@gollum.tnic> <46A9753A.1010206@zytor.com> <20070729085059.GA10758@gollum.tnic> <20070729092402.GA2272@xguan-laptop> <20070729103706.GA16780@gollum.tnic>
In-Reply-To: <20070729103706.GA16780@gollum.tnic>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> 
> Right, this was too easy to be true. I now did:
> 
> qemu -hda /dev/hda -snapshot
> 
> and booted from the hd using the installed grub and the same kernel and it
> _didn't_ boot showing again "no setup signature found... "
> 

Okay, so it's an algorithmic problem.  This is quite important to know.

Is /boot a separate partition on your disk by any chance?  Either way, 
this means we can use qemu to debug this, which will make it a lot easier.

This is what I'd like you to do next:

- run qemu in one window with the -S -s options.
- in another window, do:

	gdb
	target remote localhost:1234
	set architecture i8086
	disp/i ($cs << 4)+$eip
	br *0x10200
	br *0x20200
	br *0x30200
	br *0x40200
	br *0x50200
	br *0x60200
	br *0x70200
	br *0x80200
	br *0x90200
	c

	# ... hopefully you're now stopped at a jump instruction
	p/x $ds
	
	# Hopefully this is showing, say, 0x9000 if you're stopped
	# at 0x90200

	# Where X is the first digit of the address stopped at:
	dump memory setup.dump 0xX0000 0xX8000


Please send me setup.dump plus your vmlinuz file.

Thanks,

	-hpa
