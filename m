Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbZAIVOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbZAIVOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbZAIVOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:14:17 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43624 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbZAIVOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:14:16 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4967BE13.6070003@s5r6.in-berlin.de>
Date: Fri, 09 Jan 2009 22:13:55 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Jay Fenlason <fenlason@redhat.com>
Subject: Re: post 2.6.28 regression: device_initialize() now sleeps, and	may
 fail without recovery strategy
References: <496798FE.8030900@s5r6.in-berlin.de> <20090109205633.GB19904@suse.de>
In-Reply-To: <20090109205633.GB19904@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Jan 09, 2009 at 07:35:42PM +0100, Stefan Richter wrote:
>> We can fix the bug by changing firewire-core, but
>>   a) it'd be more than a one-liner,
>>   b) who knows which other subsystems are affected.
> 
> I agree.
> 
> I originally looked at changing this to be at device_add time, but I
> think there are some code paths that do device_initialize and then do
> some operations on the device before calling device_add.

get_device() and put_device() seem to be about the only things that are
interesting before device_add().

Don't know if a final put_device() in this situation

> But I could be
> wrong, let me do some testing first before forcing you to make that big
> change to the firewire core.

It isn't actually that big.  And the added complication could hopefully
be covered by comments about the caveats.

Actually, maybe it would be better for the firewire stack to move the
concerned stuff into a non-atomic context.  There are other things we do
in there and atomic context isn't very comfortable for all this.  But
that would be a much bigger change.

>> Next, the above code is bogus.  In 2.6.28, device_initialize() could
>> never fail and was thus safe to use as a void-valued function.
>>
>> How does driver core handle dev->p == NULL in subsequent usages of dev now?
> 
> It dies a flaming horrible death, pretty much like the whole rest of the
> system if allocating such a small ammount of memory is causing failures
> :)

Well, at least code which allocates struct device can check for failure
and handle it, while the allocator of dev->p can't even check.  Unless
you change device_initialize() to return error status and add error
handling all over the place...
-- 
Stefan Richter
-=====-==--= ---= -=--=
http://arcgraph.de/sr/
