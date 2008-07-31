Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbYGaLxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbYGaLxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 07:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbYGaLxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 07:53:18 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:38904 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbYGaLxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 07:53:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Received:Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance;
	b=BWXMzcrT+93ueW6LVGrzFsMd1cEaeg+jMPDRDEXrYyH711HPlyEdjlgPtOmjAVFc3f/ltJ4jz9qIZfuR2cFWkfQktE/Qum8fqIbUArxR49qis+pHy2xsiXzP1MSnizu7;
Message-ID: <5b329c74610e4f3332133acddab64262b7c0fc7a@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
In-Reply-To: <Pine.LNX.4.44L0.0807301522230.2322-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0807301522230.2322-100000@iolanthe.rowland.org>
Date: Thu, 31 Jul 2008 12:49:15 +0100
Subject: Re: [patch 5/3] fastboot: sync the async execution before 
     late_initcall and move level 6s (sync) first
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Rene Herman" <rene.herman@keyaccess.nl>,
       "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, "Daniel Walker" <dwalker@mvista.com>,
       "USB list" <linux-usb@vger.kernel.org>
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, July 30, 2008 20:41, Alan Stern wrote:
> The timings in the boot log agree with your "Without fastboot:"
> figures, so I assume that's the log you attached.  The only timings at
> issue here are ehci_hcd_init and ohci_hcd_mod_init.  It's not clear
> that the with-fastboot and without-fastboot values are directly
> comparable; during startup there's a lot of activity, and interrupt
> handlers can throw the timings off.

I wasn't suggesting comparing ehci_hcd_init/ohci_hcd_mod_init times,
with fastboot I'm assuming it may manage to take a lock those need in
the main initcall process and delay hcd inits.

>> It looks like usb device driver init requires it to immediately block and
>> wait for all devices to have completed init
>
> Which USB device driver init are you talking about?  Your log includes
> usblp_init, usb_stor_init, usb_usual_init, hid_init (for a USB mouse),
> and snd_usb_audio_init.  Each one completed before the next one
> started; none of them blocked waiting for any devices (other than their
> own, of course) to finish initializing.

Yes - and that's the point. The initcall process when it reaches usb/ is
this:
1. ehci_hcd_init
2. ohci_hcd_mod_init
3. usblp_init

There is nothing else to run between 1-2 and 3, so there is no opportunity
to initialise devices in the background and usblp_init blocks for a while.

If ehci_hcd_init and ohci_hcd_mod_init were moved up to before sata/ide/net
but usblp_init was kept after these then the devices should be ready by the
time it gets there.

>>  - so regardless of where we
>> put the usb/ directory in the initcall order, it will always wait a while
>> because the drivers will be immediately after the hcd init...
>
> No, you're wrong.  To prove it, try patching the start of hub_events()
> in drivers/usb/core/hub.c like this:
>
>  	 * Not the most efficient, but avoids deadlocks.
>  	 */
>  	while (1) {
> +		ssleep(5);
>
>  		/* Grab the first entry at the beginning of the list */
>  		spin_lock_irq(&hub_event_lock);
>
> Then see what happens.

I'll try this tonight, but all I'd expect to see is the background thread
take longer to do anything?

>> perhaps
>> if we moved the hcd init to before net/, sata/, ide/ etc. (all the things
>> that take time themselves) but left usb device drivers to the end it
>> would actually get the benefit of that separate thread.
>
> They are already running in a separate thread.  Of course, the
> different threads will contend for CPU resources -- just putting things
> into multiple threads doesn't mean they will necessarily run
> concurrently.

There's a lot of delays going on during sata/ide/net init, waiting for
the device to do something - usb init continues concurrently.

>> I don't have the time to rework how usb/ is linked in order to try that,
>> but moving usb/ to before net/ and sata/ while making all the usb device
>> drivers that get used be late initcalls could be used to test it.
>
> You seem to have a completely mixed-up idea of how the USB stack works.
> All the device drivers you're worried about are initialized within the
> khubd kernel thread.

The usb device driver initcalls aren't initialised by khubd and they're
definitely blocking on the khubd device initialisation [for that device,
as you said earlier] being completed.

-- 
Simon Arlott
