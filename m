Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbYHFWxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbYHFWxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 18:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754933AbYHFWxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 18:53:16 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:50244 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851AbYHFWxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 18:53:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=Rj+e8gTIywi1Rgacsyrc1iQSSLW4ds090SZYhNwQohC20mEh1khg1DoIhnKOToQtkzLBDQXWUnuEQ4RRJAaXW9OAaGoMqvOe7zXiVT9AAfjrpc9ZrmDgIdZUas8YlK3s;
Message-ID: <489A2B52.6090605@simon.arlott.org.uk>
Date: Wed, 06 Aug 2008 23:53:06 +0100
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
References: <Pine.LNX.4.44L0.0808061828010.2145-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808061828010.2145-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/08 23:34, Alan Stern wrote:
> On Wed, 6 Aug 2008, Simon Arlott wrote:
> 
>> > Doing the HCD initcalls last certainly ought to work.
>> 
>> Right - so then all that's needed is to move usb/ before most other things that 
>> take a while to init, and it has some time to initialise usb devices in the 
>> background.
> 
> Not exactly -- you should move most of usb/ forward so that it comes
> before usb/host/.  Or alternatively move usb/host/ later so that it 
> comes after the rest of usb/.

Well, putting usb/ before net/ etc. requires that usb/host/ is the usb/stuff/ or 
they'll all wait until they can probe for devices.

>> > So what exactly do you recommend?
>> 
>> I'm not an expert on what can be done with the Makefile process, perhaps there's 
>> an easier way to move things around based on a config option. If host init is 
>> moved before device init for everyone, wouldn't there be too many side effects?
> 
> Doesn't the host init _already_ come before device init?  If host init 
> were moved _after_ device init, I don't think there would be a lot of 
> side effects.  But it's hard to be sure without trying it.

Host init is before device init, as that's the Makefile link order. Any device 
init causes it to wait for *all* devices, so swapping them around means devices 
are going to appear at any time after that - there's no device initcall to make 
it block. Presumably it would be possible to have a late_initcall (which would 
be early in that list if usb was earlier) that could ensure khubd had finished 
[its current queue] before continuing - as if there was a device driver initcall?

If someone currently has HCD init compiled in but nothing else, then the boot 
process would block unnecessarily... the initcall would need to be disabled 
in that case to maintain existing behaviour - which is why it probably needs 
to be a config option, which requires some mess in the Makefile or a new 
initcall type.

>> Lack of a keyboard makes it impossible to do anything if the module fails to 
>> load... as I understand it when the HCD init runs, any BIOS emulation stops?
> 
> That's right.  The host driver kicks the BIOS off the hardware.

It seems like there's always going to be a stage where there's no keyboard...

>> Although if HCD is a module too...
>> 
>> >> If even one device driver and the hcd is compiled in, they'd need to 
>> >> wait for every USB device to finish init before the usbhid probe could complete.
>> > 
>> > What if usbhid is the one device driver that is compiled in?  :-)
>> 
>> That was the situation I was thinking of - surely that would be compiled in 
>> if the HCDs were?
> 
> I noticed in your logs earlier that some of your USB drivers were 
> compiled in and others weren't.  Maybe if _all_ of them were compiled 
> in you wouldn't experience as much contention and the init delays would 
> be shorter.

I don't know where you got that from - they're definitely all compiled in. 
Whichever is first to have its initcall run is blocked, and the logs may have 
been from a test of that.

-- 
Simon Arlott
