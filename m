Return-Path: <linux-kernel-owner+w=401wt.eu-S934409AbYCFSAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934409AbYCFSAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbYCFSAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:00:10 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:38978 "EHLO
	mk-filter-3-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754725AbYCFSAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:00:07 -0500
X-Trace: 692958137/mk-filter-3.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CALK/z0dRAVlC/2dsb2JhbACBVqsJ
Message-ID: <29795.85.118.17.158.1204825872.squirrel@newgolddream.dyndns.info>
In-Reply-To: <20080306163032.GA12982@kroah.com>
References: <8b67d60803051525g3aca775dmc14d1c2450b34168@mail.gmail.com>
    <20080305234653.GA5904@kroah.com>
    <8031.85.118.17.158.1204806681.squirrel@newgolddream.dyndns.info>
    <20080306163032.GA12982@kroah.com>
Date: Thu, 6 Mar 2008 17:51:12 -0000 (UTC)
Subject: Re: Behaviour of device_register
From: "Adrian McMenamin" <adrian@newgolddream.dyndns.info>
To: "Greg KH" <greg@kroah.com>
Cc: "Adrian McMenamin" <lkmladrian@gmail.com>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "linux-sh" <linux-sh@vger.kernel.org>
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, March 6, 2008 4:30 pm, Greg KH wrote:
> On Thu, Mar 06, 2008 at 12:31:21PM -0000, Adrian McMenamin wrote:
>> On Wed, March 5, 2008 11:46 pm, Greg KH wrote:
>> > On Wed, Mar 05, 2008 at 11:25:48PM +0000, Adrian McMenamin wrote:
>> >> The observed behaviour for me is that it appears to be blocking the
>> >> vblank interrupt on my box (or more accurately stopping the workqueue
>> >> that the interrupt handler calls from running). And without the
>> vblank
>> >> my bus won't process dma and so therefore the attempt to register the
>> >> device in question fails.
>> >>
>> >> But I can see no reason from a glance over the code why that (vblanks
>> >> being blocked) would be the case - have I missed something and the
>> >> vblanks will be blocked, or should I be looking elsewhere for the
>> root
>> >> cause of this problem?
>> >
>> > device_register(), on it's own, does not touch any hardware, nor
>> prevent
>> > anything else in the kernel from happening.
>> >
>> > So I think you need to look elsewhere, like into the bus that is doing
>> > the device_register() call :)
>> >
>>
>>
>> It turns out this is a lock contention issue.
>>
>> The code blocks waiting for a lock that will never be freed.
>
> The device_register() code blocks?  Or something else?
>

No my code. The hotplug event results in a message which is stored in a
linked list which is protected by a lock. To query the device I need to
queue a message in that linked list which is obviously locked. So
everything is timed out.

I need to make the device query asychronous from the hotplug. Not perfect,
but the only memory safe way of doing it I think.


