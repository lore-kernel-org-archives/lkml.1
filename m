Return-Path: <linux-kernel-owner+w=401wt.eu-S933712AbZHHJGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933712AbZHHJGG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 05:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933603AbZHHJGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 05:06:05 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:17669 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933645AbZHHJGE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 05:06:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aV4F3IN8aIYN3qnbIXID1gZ7iJb/m/mxSCGan6Cguz9MhZPgwMvkwoxLeH9kh7xovy
         cm294Erq4lGhk8LzYsiocMbZmQ1dVHS+RC6fZ71YDMikGdNsxDUfyMukMC5Bxyg+CPy6
         cJa1D5pjqFlftL46h6x+tNiPTY1xX9CrmV9rA=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0908071154530.3063-100000@iolanthe.rowland.org>
References: <1249657743.32113.733.camel@twins>
	 <Pine.LNX.4.44L0.0908071154530.3063-100000@iolanthe.rowland.org>
Date: Sat, 8 Aug 2009 17:06:04 +0800
Message-ID: <d82e647a0908080206j78a49674i99ba80801398055d@mail.gmail.com>
Subject: Re: [RT] Lockdep warning on boot with 2.6.31-rc5-rt1.1
From: Ming Lei <tom.leiming@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <williams@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "greg@kroah.com" <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Kay Sievers <kay.sievers@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/8 Alan Stern <stern@rowland.harvard.edu>:
> On Fri, 7 Aug 2009, Peter Zijlstra wrote:

>> It used to be that _all_ dev->sem instances were taken on suspend or
>> something like that, I think that got fixed a long while back.
>>
>> I'd have to look at what the current locking requirements for dev->sem
>> are.
>
> It is supposed to be locked whenever the driver core invokes a probe,
> remove, or PM-related callback.  Under some circumstances, the parent's
> semaphore is supposed to be locked as well.  Individual subsystems may
> have their own requirements in addition to these.
>
> The ordering requirement is: Don't try to acquire a device's lock if
> you already hold the lock for a non-ancestor device.  More generally
> (if more obscurely): If you already hold device A's lock, then don't
> try to acquire the lock for device B unless you already hold the lock
> for A & B's most recent common ancestor.
>

It seems that the following case is very common, and A and B have no
common ancestor, but we can hold device A and B's lock at the same
time, can't we?

Thanks.

device A  comes in one bus:
	device_add()
         ->bus_attach_device()
            ->device_attach():drivers/base/dd.c /*holding device A's lock*/
               ->...drv->probe()		/*sleep here some time*/

then device B comes in another bus:
	device_add()
         ->bus_attach_device()
            ->device_attach():drivers/base/dd.c /*holding device B's lock*/
               ->...drv->probe()		/*sleep here some time*/

-- 
Lei Ming
