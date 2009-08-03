Return-Path: <linux-kernel-owner+w=401wt.eu-S932197AbZHCOtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197AbZHCOtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 10:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932157AbZHCOto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 10:49:44 -0400
Received: from mail.windriver.com ([147.11.1.11]:51834 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124AbZHCOtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 10:49:43 -0400
Message-ID: <4A76F8A1.3020000@windriver.com>
Date: Mon, 03 Aug 2009 09:48:01 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 07/10] ehci-dbgp,ehci: Allow early or late use of the
 dbgp device
References: <Pine.LNX.4.44L0.0908011144110.20464-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908011144110.20464-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Aug 2009 14:48:02.0360 (UTC) FILETIME=[66D0AB80:01CA1449]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Fri, 31 Jul 2009, Jason Wessel wrote:
>
>   
>> Alan Stern wrote:
>>     
>>> What happens across a system suspend?
>>>
>>>   
>>>       
>> I assume you mean as a test case:
>>
>> echo -n mem > /sys/power/state
>>
>> The dbgp device goes away entirely, when used with
>> earlyprintk=dbgp,keep.  But there is a way to fix it reasonably
>> easily.  Perhaps you might ack this resume patch, if you agree?
>>
>> Jason.
>>
>> ---
>> From: Jason Wessel <jason.wessel@windriver.com>
>> Subject: [PATCH] ehci-dbgp,ehci: Allow dbpg to work with suspend/resume
>>
>> In order for the dbgp driver to survive suspend/resume, on every ehci
>> resume operation the debug controller must get re-initialized.
>>
>> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
>> Cc: Greg KH <gregkh@suse.de>
>> Cc: Alan Stern <stern@rowland.harvard.edu>
>> Cc: dbrownell@users.sourceforge.net
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Yinghai Lu <yinghai@kernel.org>
>> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
>>
>> ---
>>  drivers/usb/host/ehci-hub.c |    6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> --- a/drivers/usb/host/ehci-hub.c
>> +++ b/drivers/usb/host/ehci-hub.c
>> @@ -204,6 +204,13 @@ static int ehci_bus_resume (struct usb_h
>>  		return -ESHUTDOWN;
>>  	}
>>  
>> +	if (unlikely(ehci->debug)) {
>> +		if (ehci->debug && !dbgp_reset_prep())
>> +			ehci->debug = NULL;
>> +		else
>> +			dbgp_external_startup();
>> +	}
>> +
>>  	/* Ideally and we've got a real resume here, and no port's power
>>  	 * was lost.  (For PCI, that means Vaux was maintained.)  But we
>>  	 * could instead be restoring a swsusp snapshot -- so that BIOS was
>>     
>
> It looks fine to me.  Would you perhaps want to make dbgp_reset_prep()
> automatically call dbgp_external_startup() on success so that ehci-hcd
> doesn't have to?
>   

Unfortunately the dbgp_reset_prep() and dbgp_external_startup() have to
be separate for the hcd case because the ehci controller reset comes in
between.  If you don't call dbgp_reset_prep() first, the ehci controller
can hang the system for the "ehci debug controller timeout death
period", or you can end up with undefined behavior if the ehci debug
controller is accessed while the reset code is being processed.

The dbgp_reset_prep() puts the ehci debug controller/driver into a safe
state until after the reset is done, and then the
dbgp_external_startup() re-initializes the ehci debug controller.

For the case of the power suspend, the ehci debug controller appeared to
be usable all the way to the time the power got yanked.  For the resume
operation, the debug controller driver sees that from the resume state
that the enable bit is off and doesn't try to use the device until
dbgp_reset_prep() and dbgp_external_reset() are called in sequence.

The dbgp_reset_prep() has to get called in resume to handle the case
where you remove the dbgp device while suspended and before you resumed
such that it won't hang the kernel.

Jason.
