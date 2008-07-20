Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbYGTOSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbYGTOSP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 10:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757097AbYGTOSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 10:18:00 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:49045 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464AbYGTOR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 10:17:59 -0400
Message-ID: <48834996.9060804@keyaccess.nl>
Date: Sun, 20 Jul 2008 16:20:06 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Paul Diefenbaugh <paul.s.diefenbaugh@intel.com>,
       Andy Grover <andrew.grover@intel.com>, Len Brown <lenb@kernel.org>
Subject: Re: [patch 1/3] fastboot: Create a "asynchronous" initlevel
References: <20080718151524.5ef9e29b@infradead.org>	<20080718151608.46dc17c0@infradead.org>	<48819D92.8050904@keyaccess.nl>	<4881A161.7050902@keyaccess.nl>	<20080719084448.7859afd0@infradead.org>	<4882E7F3.8060605@keyaccess.nl> <20080720041039.275c57f9@infradead.org>
In-Reply-To: <20080720041039.275c57f9@infradead.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20-07-08 13:10, Arjan van de Ven wrote:

> On Sun, 20 Jul 2008 09:23:31 +0200
> Rene Herman <rene.herman@keyaccess.nl> wrote:
> 
>> Yes, I see. Unfortunately, WITH your patches, driver_probe_done()
>> would also no longer be safe when run from a late_initcall() it would
>> appear.
> 
> true for now (but see below)
> 
>> I have the sneaking suspicion that this is a bit of a fundamental
>> issue. Turning some of the driver level (6) async basicaly removes
>> the ordering between drivers and late_initcall (level 7).
> 
> I was hoping to not need this ordering. 

May have found an issue with 3/3 for this same reason. You make the ACPI 
button driver async but acpi_wakeup_device_init() is a late_initcall and 
comments that it interacts with the button driver.

The button driver could be a module so a complete reversal of ordering 
between acpi_wakeup_device() and acpi_button_init() might in itself not 
be a problem (undeterministic order even with the button driver builtin 
might be undesireable I guess) but ...

Correct me if I'm wrong but I believe your patch implies that we could 
be racing between acpi_wakeup_device() and acpi_button_init()? If yes, 
do bad things happen when we race checking dev->wakeup.state.enabled?

As far as I can see, the acpi_device_lock isn't serialising here so if 
we have just done the acpi_enable_gpe() in acpi_button_add() but haven't 
set the enabled flag yet we could do it again here it seems.

The ACPI button driver doesn't appear to have a specific maintainer and 
Len Brown was on vacation I believe but this would ideally like a 
comment from that side...

>> I trust it will completely and utterly destroy the point of this
>> patch to flush level 6a before starting level 7?
> 
> Thankfully it doesn't destroy it, the reason for this is that level 6
> itself tends to take long enough to get benefits. It's just that if we
> can get both 6 and 7 it's nicer. But if we end up needing to sync, so
> be it.

I worry...

> Note: syncing on a driver_probe_done() from level 7 is not going to be
> pretty (think "multi-second extra boot time). 
> Part of me wants to only sync level 6a from the first
> driver_probe_done() so that only people who already pay these extra
> seconds suffer this one as well ;-)

Makes sense in this specific case. Generally, utility of late_initcall() 
does seem to be impacted by this. Unless you can be sure that every 
device you depend on is and always will be sync you might as well be 
device_initcall() yourself after all.

Yes, I did note the bit about the endpoint probing already being async 
for example for USB but now you can't even be sure that it _started_ 
meaning you also couldn't really devise some private synchronization 
mechanism either.

Rene.



