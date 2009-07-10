Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817AbZGJHYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbZGJHYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 03:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbZGJHXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 03:23:52 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:32305 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbZGJHXu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 03:23:50 -0400
Message-Id: <4A57089B0200007800009C0E@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 10 Jul 2009 08:23:39 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>, "Michal Marek" <mmarek@suse.cz>
Cc: "Ingo Molnar" <mingo@elte.hu>, <tony.luck@intel.com>,
       "Jon Masters" <jonathan@jonmasters.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, <linux-arch@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <linux-modules@vger.kernel.org>,
       <hpa@zytor.com>
Subject: Re: [PATCH] reduce export symbol CRC table size on 64-bit
	 archs
References: <4A4A18780200007800008345@vpn.id2.novell.com>
 <4A4E671C.2090201@suse.cz> <4A51C71B0200007800008EE2@vpn.id2.novell.com>
 <200907092044.22108.rusty@rustcorp.com.au>
In-Reply-To: <200907092044.22108.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Rusty Russell <rusty@rustcorp.com.au> 09.07.09 13:14 >>>
>On Mon, 6 Jul 2009 05:12:51 pm Jan Beulich wrote:
>> >Jan Beulich napsal(a):
>> >> Since these CRCs are really only 32-bit quantities, there's no need to
>> >> store them in 64-bit slots. Since, however, gcc doesn't allow
>> >> respective initializations, asm() constructs get used to create the CRC
>> >> tables (and its for that reason that the patch only makes x86-64 and
>> >> ia64 utilize that functionality, as I can't verify this doesn't break
>> >> in some subtle way elsewhere).
>> >
>> >...
>> >
>> >>  struct modversion_info
>> >>  {
>> >> -	unsigned long crc;
>> >> +	ksym_crc_t crc;
>> >>  	char name[MODULE_NAME_LEN];
>> >>  };
>> >
>> >This change breaks module-init-tools:
>> >Before:
>> >$ /sbin/modprobe --dump-modversions _build/drivers/usb/core/usbcore.ko
>> >
>> >| head
>> >
>> >0xb49b735a      module_layout
>> >0xdb7e6a70      bus_register
>> >...
>> >After:
>> >$ /sbin/modprobe --dump-modversions
>> >_build-crc-int/drivers/usb/core/usbcore.ko  | head
>> >0x75646f6d91ea7b5c      le_layout
>> >0x5f7375623e215f43      register
>> >...
>> >It also breaks the newly added depmod -E option (check symbol versions),
>> >which also reads the struct modversion_info array (*). Is it possible
>> >name the section differently (__versions2?) on those architectures where
>> >the size changes, so that it is possible to fix m-i-t in a
>> >backwards-compatible manner?
>>
>> First of all I'd view it as a design bug if user mode code assumptions
>> prevent changes to the kernel.
>
>Yes, but unfortunately it happens.  We do it much less than we used to, but 
>there are limits.
>
>> But taking this as an uncorrectable fact, I'd think that renaming the
>> section would certainly be an option (though I'm unsure whether that would
>> have other consequences - Rusty?), however I could also imagine other means
>> to communicate to user land the width of a CRC value (e.g. adding an
>> absolute symbol during the .ko linking stage).
>
>No, just break it once.  And I still like the idea that we should do something 
>more radical if we're going to break this anyway, rather than these nasty asm 
>hacks.

Actually I meanwhile think that module-init-tools can easily detect the changed
layout without any further kernel side adjustments: Since it is known that a
CRC always is a 32-bit value, simply checking whether the so-far-used 64-bit
value has more than 32 significant bits should suffice: If so, the new layout
is being used (with the symbol name starting at offset 4), else the old one is
in effect (name at offset 8). This ought to be a pretty trivial change to that
code.

Jan

