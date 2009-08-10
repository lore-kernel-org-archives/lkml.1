Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030AbZHJI4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbZHJI4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 04:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbZHJI4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 04:56:08 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:42257 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbZHJI4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 04:56:07 -0400
MIME-Version: 1.0
In-Reply-To: <4A7FCC42.40809@petalogix.com>
References: <1d3f23370908092328l6e980f3ft2d5a8f8f37c26fcf@mail.gmail.com>
	 <4A7FCC42.40809@petalogix.com>
Date: Mon, 10 Aug 2009 18:56:06 +1000
Message-ID: <1d3f23370908100156q46b9869av5ecdcc8879617be9@mail.gmail.com>
Subject: Re: [microblaze-uclinux] Rethinking MicroBlaze commandline precedence
From: John Williams <john.williams@petalogix.com>
To: microblaze-uclinux@itee.uq.edu.au
Cc: John Linn <John.Linn@xilinx.com>, David DeBonis <david.debonis@xilinx.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Mon, Aug 10, 2009 at 5:29 PM, Michal Simek<michal.simek@petalogix.com> wrote:

> John Williams wrote:

>> Currently, MicroBlaze commandline handling in order of lowest to
>> highest priority, looks like this:
>>
>> 1. pointer in r5 from bootloader
>> 2. CONFIG_CMDLINE=...
>> 3. "chosen" section in DTS/DT
>> 4. CONFIG_CMDLINE=... && CONFIG_CMDLINE_FORCE
>>
>> I'm wondering if a cmdline in r5 should override the DTS.  My thinking
>> is based on two observations:
>>
>> (a) not everyone will use a bootloader like u-boot that can manipulate
>> DTBs easily before kernel boot
>> (b) a custom cmdline string in r5 allows the latest possible binding
>> (runtime), where as the DTB is typically created at compile time.
>>
>> So, how about this order instead:
>>
>> 1. CONFIG_CMDLINE=...
>> 2. "chosen" section in DTS/DT
>> 3. pointer in r5 from bootloader
>> 4. CONFIG_CMDLINE=... and CONFIG_CMDLINE_FORCE
>>
>> Then, apart from CMDLINE_FORCE, the precedence goes from earliest
>> binding (kernel build) to latest (runtime via bootloader/r5).
>>
>> Thoughts?
>
> I see there one big problem which can easily arise. Kernel expect that r5 points to
> NULL string and DTS/DTB and CMDLINE will contain correct string. Kernel just copy it and use
> it. There will be undefined behavior for more cases than for current handling. It will be
> less error prune.

This expectation currently exists anyway,  giving precendence to DTS
cmdline is only less error-prone on the assumption that it's more
common.

What about a move to an ARM-style ATAGs arrangement, where r5 points
not to an ASCIIZ string but instead to some sort of loosely structured
object, with tag codes to signify the commandline etc.

That way, we can error check r5 - if it doesn't have the right tags
then we don't use the (probably bogus) cmdline string?

> Ad observation a)
>
> My expectation is that users will use s.....I.... format (I don't like that name - What about
> renaming it?) with dtb - they setup commandline at once and they don't change it.


Ah what's wrong with simpleImage?  It's simple to boot, and make-fu
makes it simple to build! :)

> Ad observation b) - for final product they will use only one command line. For testing you can setup
> kernel to use only r5.

How?  Do we add CONFIG_CMDLINE_IGNORE_DTB?

Or just remove the commandline section from DTS "chosen" part?

> I understand that you are trying to pass to kernel for example MTD map which could be possible but
> IMHO better to do this in script which one with sed erase/comment/setup command line in DTS before
> compilation.

It's still a very early binding, and I think there are plenty of
reasons to want to override it at boot time.  If there weren't, why do
u-boot and PPC simpleBoot add the capability to tweak at boot time,
the cmdline passed via the DTB?

Setting MAC addresses for example - you don't want to compile a new
DTS for every board you ship, just to provide unique values. You just
want to be able to tweak the cmdline in the config flash or whatever.

Cheers,

John
-- 
John Williams, PhD, B.Eng, B.IT
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663
