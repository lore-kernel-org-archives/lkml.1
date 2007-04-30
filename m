Return-Path: <linux-kernel-owner+w=401wt.eu-S1946818AbXD3Uzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946818AbXD3Uzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 16:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946819AbXD3Uzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 16:55:36 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38052 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946818AbXD3UzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 16:55:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: virtualization <virtualization@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 09/12] i386/x86_64: EHCI usb debug port early printk support.
References: <m1d51l6f1y.fsf@ebiederm.dsl.xmission.com>
	<m18xc96eyq.fsf@ebiederm.dsl.xmission.com>
	<m14pmx6ewk.fsf_-_@ebiederm.dsl.xmission.com>
	<m1zm4p509a.fsf_-_@ebiederm.dsl.xmission.com>
	<m1vefd4zyj.fsf_-_@ebiederm.dsl.xmission.com>
	<m1r6q14zow.fsf_-_@ebiederm.dsl.xmission.com>
	<m1mz0p4zfc.fsf_-_@ebiederm.dsl.xmission.com>
	<m1irbd4zcm.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ejm14z5f.fsf_-_@ebiederm.dsl.xmission.com>
	<m1abwp4yd9.fsf_-_@ebiederm.dsl.xmission.com>
	<20070430175607.GD25929@bingen.suse.de>
Date: Mon, 30 Apr 2007 14:54:18 -0600
In-Reply-To: <20070430175607.GD25929@bingen.suse.de> (Andi Kleen's message of
	"Mon, 30 Apr 2007 19:56:08 +0200")
Message-ID: <m1fy6h37np.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:

> Thanks for writing that code. It should be an interesting alternative
> on boxes where firescope doesn't work.
>
> I hope I can eventually merge early firewire support code too.
>
> On Mon, Apr 30, 2007 at 10:32:02AM -0600, Eric W. Biederman wrote:
>> 
>> With legacy free systems serial ports have stopped being an option
>> to get early boot traces and other debug information out of a machine.
>
> This needs a CONFIG_* at least. And some documentation on how to set it
> up on both sides.

Besides CONFIG_EARLY_PRINTK I assume.  It is enough code so there is a
case for it.


>> This debug device can be used to replace serial ports for
>> kgdb, kdb, and console support.  And gregkh has a simple usb
>> serial driver for it so user space applications that control
>> serial ports should work unmodified.
>
> But not merged yet, right? I was hoping it could be done from
> user space anyways.

Sorry old comment, that piece has been merged for a while.
It is the usb_debug module.  It creates a tty device that you
can just cat to get the usb debug output.

>> For users the hard part looks like it will be finding cables and
>> finding which is usb debug port 1 and realizing that there is
>> flow control so the kernel boot will not happen if someone is not
>> reading the serial console data.
>
> That's nasty. Any way to work around that?

Maybe.  It has been long enough since I wrote the code
I need to go back and look.


>> index 92213d2..dc097aa 100644
>> --- a/arch/x86_64/kernel/early_printk.c
>> +++ b/arch/x86_64/kernel/early_printk.c
>> @@ -3,9 +3,19 @@
>>  #include <linux/init.h>
>>  #include <linux/string.h>
>>  #include <linux/screen_info.h>
>> +#include <linux/usb/ch9.h>
>> +#include <linux/pci_regs.h>
>> +#include <linux/pci_ids.h>
>> +#include <linux/errno.h>
>
> Can you put it in a separate file please?
> Perhaps with a little abstraction in drivers/usb ? 
>
>> +static void dbgp_breath(void)
>> +{
>> +	/* Sleep to give the debug port a chance to breathe */
>
> But you don't?

Good point.  At least this early I'm not certain there is any
way I can productively do that.  This is before we have calibrated
the tsc's and the like so timeouts are difficult, and as I
recall our default guess isn't.

This lack of a good timeout looks to be the reason ehci_wait_for_port
doesn't timeout in a timely fashion because I don't timeout until
I have wrapped a 32bit number.


>> +static __u32 __init find_dbgp(int ehci_num, unsigned *rbus, unsigned *rslot,
> unsigned *rfunc)
>
> This should be probably merged into the early quirks loop
>
>>   		early_console = &simnow_console;
>>   		keep_early = 1;
>> +	} else if (!strncmp(buf, "dbgp", 4)) {
>
> usb would seem to be more intuitive

Could be.  I was thinking usb debug port. dbgp is at least unique,
and unfortunately it doesn't look like any old usb cable will
do, so a straight usb I expect would be very misleading.

The truth is I don't have a big need for this.  I put it together as
a proof of concept to see how hard it would be, etc.  I can clean
it up a little but I'm really hoping I can get this into one of
the development trees and people who have more use for it then I
do can play with it and improve things.

One persons experience on two machines probably isn't quite enough
of a sample to Document how to use this.  At least beyond what I
did in my changelog.

Eric
