Return-Path: <linux-kernel-owner+w=401wt.eu-S1760513AbYGOBDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760513AbYGOBDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 21:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbYGOBDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 21:03:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753029AbYGOBDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 21:03:04 -0400
Date: Mon, 14 Jul 2008 18:02:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: david@lang.hm
cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm>
Message-ID: <alpine.LFD.1.10.0807141756361.3017@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141729200.3017@woody.linux-foundation.org>
 <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, david@lang.hm wrote:
> > 
> > Does it waste some ram? Sure. Tough.
> 
> I agree with this, but the proponents of the seperate firmware are listing the
> fact that the firmware doesn't tie up ram as one of the big reasons for making
> the change.

That's a totally bogus argument.

The fact is, if you build it into your module, you'll waste at _least_ as 
much ram as if you just load it once at module load time.

So there is no actual valid reason to object to "request_firmware()".

I don't know why people get confused about this. I suspect that people 
kind of expect that since they need to reload the firmware when resuming 
the device, they should also do the "request_firmware()" at resume time.

Maybe it's worth explicitly documenting that request_firmware()/release() 
should be done as a module init/exit (or a device detect-eject) time 
option. Quite frankly, I think the current firmware docs are actually 
actively misleading, because they link the request_firmware() with the 
copying to device: quoting from Documentation/firmware_class/README:

	 High level behavior (driver code):
	 ==================================
	
	         if(request_firmware(&fw_entry, $FIRMWARE, device) == 0)
	                copy_fw_to_device(fw_entry->data, fw_entry->size);
	         release(fw_entry);

and that is a fundamentally broken world-view.

The logic _should_ be that the firmware is requested at module init or 
device discovery, and the release is done at module exit or device eject. 

The "request_firmware()" should absolutely *not* be mentally tied to 
"copy_fw_to_device" at all. They are very distinct issues, and in fact 
must be totally separate for any driver that supports hotplug.

		Linus
