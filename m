Return-Path: <linux-kernel-owner+w=401wt.eu-S1760918AbYHFUHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918AbYHFUHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbYHFUHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:07:11 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:50498 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbYHFUHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:07:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=AL867Goa8uMV4oE3QsDMvZgq/n3FhUjtxFJEjXCoTZeXoOXTmgEKi6/6Vzbn0QT7O1eb6B5t0yD+8Abofs5CA0h8NWAm8fELis2FBxzI+Pj2o0Xul2wVlREyUQTiZfJk;
Message-ID: <489A0467.1060607@simon.arlott.org.uk>
Date: Wed, 06 Aug 2008 21:07:03 +0100
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
References: <Pine.LNX.4.44L0.0808061543340.2138-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808061543340.2138-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/08 20:49, Alan Stern wrote:
> On Wed, 6 Aug 2008, Simon Arlott wrote:
> 
>> > Wouldn't it be much simpler, and less objectionable, to do what I
>> > suggested earlier?  That is, add a 5-second delay at the start of
>> > hub_thread() in drivers/usb/core/hub.c.  No messing with Makefiles, no
>> > changes to the initcall scheduling.
>> 
>> Aside from 5 seconds being too long, and anything less being a race between 
>> hub_thread() and driver initcalls, it doesn't improve anything because it'll 
>> still have to wait for the devices to finish initialising in userspace instead.
> 
> Why is 5 seconds too long?  Too long for what?
> 
> What you're doing is already a race between hub_thread() and driver 
> initcalls.  My suggestion is no worse.

No, by adding a 5 second delay you're intending for the device driver initcalls 
to complete within that 5 seconds. If they take too long then the last one 
blocks everything (I realise that's ridiculous, these initcalls take <1ms when 
there are no devices yet). The best way to do is to make the driver initcalls 
before the host ones, like you suggested.

> "it'll still have to wait..."  If by "it" you mean the initcall
> thread, you're wrong.  If by "it" you mean the user, you still aren't
> necessarily correct; the user can do plenty of other things while
> waiting for USB devices to initialize.

Assuming userspace doesn't wait for all devices to settle and appear in /dev etc. 
before continuing.

> I suppose you could make the hub_thread delay time a module parameter 
> for usbcore, defaulting to 0.  Then it could be set by just the people 
> who want to use it -- many (most?) people keep their drivers in 
> modules, and it wouldn't do them any good.

It really needs to have hcd initcalls done very early so that device init 
has the rest of the (kernel and userspace) boot process to complete in the 
background. This is negated by having device drivers initialised immediately 
afterwards. Re-ordering initcalls and doing more of the init process 
asynchronously is likely to expose bugs and cause inconsistent device order 
on some systems, so if the makefile mess could be reduced then it can be a 
Kconfig option.

How many people have *all* their USB components (hcd, drivers) as modules?
What do they do with their USB keyboards in the period between init and module 
load? If even one device driver and the hcd is compiled in, they'd need to 
wait for every USB device to finish init before the usbhid probe could complete.

-- 
Simon Arlott
