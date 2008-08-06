Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbYHFVud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbYHFVud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbYHFVt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:49:57 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:49143 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957AbYHFVt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:49:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=Dm4WGTey6LMbY6FiCaU7dY7PH4r4LNnJD/L262k4W74AQjxHoIa08TzMNmmp8Mknk9y+CBISJnxQjWobeUuwmeKuB/A1MAg35A8VmR6w6VESHS3oTUJVVOEU/dO7MObX;
Message-ID: <489A1C68.3000905@simon.arlott.org.uk>
Date: Wed, 06 Aug 2008 22:49:28 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Rene Herman <rene.herman@keyaccess.nl>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH RFC] USB: Add HCD fastboot
References: <Pine.LNX.4.44L0.0808061616450.2145-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808061616450.2145-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/08 21:26, Alan Stern wrote:
> On Wed, 6 Aug 2008, Simon Arlott wrote:
> 
>> No, by adding a 5 second delay you're intending for the device driver initcalls 
>> to complete within that 5 seconds. If they take too long then the last one 
>> blocks everything (I realise that's ridiculous, these initcalls take <1ms when 
>> there are no devices yet). The best way to do is to make the driver initcalls 
>> before the host ones, like you suggested.
> 
> Doing the HCD initcalls last certainly ought to work.

Right - so then all that's needed is to move usb/ before most other things that 
take a while to init, and it has some time to initialise usb devices in the 
background.

>> > "it'll still have to wait..."  If by "it" you mean the initcall
>> > thread, you're wrong.  If by "it" you mean the user, you still aren't
>> > necessarily correct; the user can do plenty of other things while
>> > waiting for USB devices to initialize.
>> 
>> Assuming userspace doesn't wait for all devices to settle and appear in /dev etc. 
>> before continuing.
> 
> Whatever that involves...  /dev never truly settles; it's always 
> possible to plug in a new device or remove an old one.

Yes... I'm not sure how that part would work.

>> > I suppose you could make the hub_thread delay time a module parameter 
>> > for usbcore, defaulting to 0.  Then it could be set by just the people 
>> > who want to use it -- many (most?) people keep their drivers in 
>> > modules, and it wouldn't do them any good.
>> 
>> It really needs to have hcd initcalls done very early so that device init 
> 
> Please stop using the word "it" with no antecedent!  Do you mean "we"?

Yes. I'll try to avoid doing that.

>> has the rest of the (kernel and userspace) boot process to complete in the 
>> background. This is negated by having device drivers initialised immediately 
>> afterwards. Re-ordering initcalls and doing more of the init process 
>> asynchronously is likely to expose bugs and cause inconsistent device order 
>> on some systems, so if the makefile mess could be reduced then it can be a 
>> Kconfig option.
> 
> So what exactly do you recommend?

I'm not an expert on what can be done with the Makefile process, perhaps there's 
an easier way to move things around based on a config option. If host init is 
moved before device init for everyone, wouldn't there be too many side effects?

I've not tried to use usb-storage as root but presumably that works. If that 
already uses a hack of making the kernel wait X seconds before trying to mount 
root then it'll still work.

>> How many people have *all* their USB components (hcd, drivers) as modules?
> 
> All the major distributions do, as far as I know.  (I haven't actually 
> checked them all to be certain.)
> 
>> What do they do with their USB keyboards in the period between init and module 
>> load?
> 
> Probably nothing.  What do you do on your keyboard while waiting for
> system initialization to complete?

Lack of a keyboard makes it impossible to do anything if the module fails to 
load... as I understand it when the HCD init runs, any BIOS emulation stops?
Although if HCD is a module too...

>> If even one device driver and the hcd is compiled in, they'd need to 
>> wait for every USB device to finish init before the usbhid probe could complete.
> 
> What if usbhid is the one device driver that is compiled in?  :-)

That was the situation I was thinking of - surely that would be compiled in 
if the HCDs were?

-- 
Simon Arlott
