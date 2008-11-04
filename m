Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbYKDU02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbYKDU02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 15:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbYKDU0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 15:26:20 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:42361 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbYKDU0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 15:26:19 -0500
Message-ID: <4910AFC1.2080306@natemccallum.com>
Date: Tue, 04 Nov 2008 15:25:37 -0500
From: Nathaniel McCallum <nathaniel@natemccallum.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Loaded driver modalias
References: <491096D7.10808@natemccallum.com> <ac3eb2510811041155s3ef2df93w8fdd7ce7c009e994@mail.gmail.com>
In-Reply-To: <ac3eb2510811041155s3ef2df93w8fdd7ce7c009e994@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Tue, Nov 4, 2008 at 19:39, Nathaniel McCallum
> <nathaniel@natemccallum.com> wrote:
>   
>> Please CC me to responses as I'm not subscribed to LKML.  Also, this is my
>> first kernel patch, advise is certainly welcome.
>>
>> For something I'm working on I have the need to answer the question, "given
>> a hardware ID, does Linux distro X have a driver to support this hardware?"
>> and more specifically, "which drivers support this hardware?" I can,
>> generally speaking, get this data from files like
>> /lib/modules/*/modules.alias.  However, this does not work for drivers built
>> into the kernel.  With that in mind, I've cooked up a little proof of
>> concept. Basically, its a sysfs file
>> /sys/modules/$module/drivers/$driver/modalias that, when read, contains
>> modalias-style filters for this driver.
>>
>> The attached patch only does this for PCI drivers, each subsystem would need
>> a patch like this.  Is this idea crazy?  Is there a better implementation?
>>     
>
> Hmm, what if that gets larger than 4k? It seems not really like
> something for sysfs. There are also drivers which export a modalias
> which matches more devices, than the device it actually would accept
> to bind to. Some driver have logic in the match() function to exclude
> stuff.
>   
In this current patch, an error is returned.  Like I said, this is more 
proof of concept than anything.  I'm trying to ask a running kernel 
"What hardware do you at least pretend to support?" While I would love 
to get only the drivers that would actually bind to the device, I don't 
suspect this is possible since you'd need real or emulated hardware to 
test this.  One of my explicit design requirements is that the hardware 
ids don't represent "real" hardware.  The hardware might exist in real 
life, but I don't have it (and I can't emulate it).  I just want to know 
what Linux would try to do with the hardware *if* I had it.  Thus, I 
don't really care about the logic in the match() function since it would 
require real hardware.

What method would be appropriate for this other than sysfs?
> What's the exact information you need? Would it be sufficient  to ask
> a bus with a modalias string, which driver of that bus matched that
> device?
>   
I want to create a database of this information that exists outside the 
Linux kernel.  This database should contain a map of filters to drivers 
such that, given any hardware id (real or otherwise), I should be able 
to determine which kernel drivers would attempt to "do something" with 
this hardware.

So, first I would snapshot one or more distributions (and perhaps 
different kernels in the same distro).  Then I would compare hardware 
IDs against this snapshot.  Once this driver database is built, you can 
do lots of things with it, including stuff like regression testing.  The 
important thing is that the hardware id is not available at the time the 
snapshot is taken.

One of the possible usages for this, outside of my project, would be to 
create a list of the most common hardware ids out there.  Then, for each 
kernel release, a snapshot could be taken of its hardware support.  
Then, you could test to make sure that all common hardware is supported 
and that no regressions have appeared.  Sure, this doesn't test whether 
the *real* hardware works or not.  However, testing physical hardware 
cannot be easily automated, and this can.

Nathaniel
