Return-Path: <linux-kernel-owner+w=401wt.eu-S1760795AbYGOBRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760795AbYGOBRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 21:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757891AbYGOBRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 21:17:24 -0400
Received: from mail.lang.hm ([64.81.33.126]:37274 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757864AbYGOBRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 21:17:23 -0400
Date: Mon, 14 Jul 2008 18:18:24 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <alpine.LFD.1.10.0807141756361.3017@woody.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0807141805300.14223@asgard.lang.hm>
References: <1216077806.27455.85.camel@shinybook.infradead.org> <20080714164119.99c33d5b.akpm@linux-foundation.org> <20080714165956.7fe2d4ee@infradead.org> <alpine.DEB.1.10.0807141704120.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141729200.3017@woody.linux-foundation.org>
 <alpine.DEB.1.10.0807141750290.14223@asgard.lang.hm> <alpine.LFD.1.10.0807141756361.3017@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008, Linus Torvalds wrote:

> On Mon, 14 Jul 2008, david@lang.hm wrote:
>>>
>>> Does it waste some ram? Sure. Tough.
>>
>> I agree with this, but the proponents of the seperate firmware are listing the
>> fact that the firmware doesn't tie up ram as one of the big reasons for making
>> the change.
>
> That's a totally bogus argument.
>
> The fact is, if you build it into your module, you'll waste at _least_ as
> much ram as if you just load it once at module load time.
>
> So there is no actual valid reason to object to "request_firmware()".

you misunderstood me. the people pushing request_firmware() are doing so 
on the basis that they won't have to use kernel ram to hold the firmware. 
the people pushing for having the option of building the firmware into the 
module are acknowleding that this may use a little more ram, but they see 
it as being more reliable.

> I don't know why people get confused about this. I suspect that people
> kind of expect that since they need to reload the firmware when resuming
> the device, they should also do the "request_firmware()" at resume time.

according to David W they would, becouse the driver would not keep the 
firmware in kernel memory after it's initialized, so if you need to 
reinitialize the hardware after a resume you would need to do 
request_firmware() at resume time (the option of doing request_firmware() 
just before going to sleep has been floated as an option to avoid this 
problem)

> Maybe it's worth explicitly documenting that request_firmware()/release()
> should be done as a module init/exit (or a device detect-eject) time
> option. Quite frankly, I think the current firmware docs are actually
> actively misleading, because they link the request_firmware() with the
> copying to device: quoting from Documentation/firmware_class/README:
>
> 	 High level behavior (driver code):
> 	 ==================================
>
> 	         if(request_firmware(&fw_entry, $FIRMWARE, device) == 0)
> 	                copy_fw_to_device(fw_entry->data, fw_entry->size);
> 	         release(fw_entry);
>
> and that is a fundamentally broken world-view.

but that is what David W has been telling everyone is one of the big 
benifits of using request_firmware(), that the memory gets released once 
the device is initialized. (as always, it's possible I have misunderstood 
the argument, but I can't see any other way that it would save memory)

> The logic _should_ be that the firmware is requested at module init or
> device discovery, and the release is done at module exit or device eject.

this would go a long way to satisfying the people who have been objecting 
to the request_firmware() push. It would solve the various 
reinitialization problems (at resume, and at other times for some 
drivers).

the only thing it doesn't satisfy is the people who don't want to be 
forced to have seperate firmware files out on the filesystem.

As I understand the arguments, the reason to not force the firmeware files 
to be seperate is that it adds complexity and introduces the possibility 
that the firmware may be incompatible with the driver, forcing the 
creation of some sort of userspace/filesystem versioning.

the reson to force the firmware files to be seperate is that it avoids 
using kernel memory to hold them and it allows for the firmware to be 
removed from the kernel tree entirely and shipped seperately (apparently 
Fedora is eager to do the latter for perceived licensing reasons)

> The "request_firmware()" should absolutely *not* be mentally tied to
> "copy_fw_to_device" at all. They are very distinct issues, and in fact
> must be totally separate for any driver that supports hotplug.

in the last flamewar it seemed pretty clear that the expectation was that 
a hotplug event would trigger a new request_firmware() call out to 
userspace.

David Lang
