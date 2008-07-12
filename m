Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbYGLVG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbYGLVG2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 17:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbYGLVGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 17:06:20 -0400
Received: from mercury.realtime.net ([205.238.132.86]:59264 "EHLO
	ruth.realtime.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753088AbYGLVGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 17:06:19 -0400
In-Reply-To: <20080712041137.GA5933@kroah.com>
References: <for-27-patch1-0@bga.com> <for-27-patch9@bga.com> <20080712041137.GA5933@kroah.com>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <e6b3109a0ab047bea58ceecb8734761d@bga.com>
Content-Transfer-Encoding: 7bit
Cc: Michael Ellerman <michael@ellerman.id.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org
From: Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH/RFC] pci: dynids.use_driver_data considered harmful
Date: Sat, 12 Jul 2008 16:08:13 -0500
To: Greg KH <greg@kroah.com>
X-Mailer: Apple Mail (2.624)
X-Originating-IP: 216.126.174.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For those on lkml, I mistyped the address in the first mail.  I just
did a second pass edit on the long debug session prompting this patch
fixed the cc to linux-kernel.  So all those not on linux-pci should
be seeing that shortly, or one can look in mmotm.

On Jul 11, 2008, at 11:11 PM, Greg KH wrote:
> On Thu, Jul 10, 2008 at 04:29:37PM -0500, Milton Miller wrote:
>> The driver flag dynids.use_driver_data is almost consistently not 
>> set, and
>> causes more problems than it solves.  The only use of this flag is to
>> prevent the system administrator from telling a pci driver additional 
>> data
>> when adding a dynamic match table entry via sysfs.
>>
>> We do not as a policy protect the kernel from bad acts by root.
>
> But we can try.
>
> As you found out, this flag should have been set in that specific
> driver, right?  Why not just fix the driver instead of declaring that
> the flag is not useful at all, despite it actually being used properly
> by a number of drivers already?

Its not one driver, its more like 100 to 150.

Why is giving the driver the data it needs to support a card bad?
The debug session shows that not giving it the data it needs
is worse.

Worse, the kernel thinks it superior to the human and actively ignores
input with out even telling the user it did so.

The only argument I can come up with is if the data is a pointer, then
its likely that that root will not be able to find the correct value or
put it in a script that doesn't get updated on the next kernel install
and causes a crash.  Root isn't likely to add driver data unless it
discovers that it is needed, so the existing default of passing 0
should remain.

If you want to argue that being able to tell the driver that it should
treat this card like card X is wrong, you should be arguing that the
whole notion of adding match table entries to the driver is wrong.
When it comes down to it, its the same thing.  Yet, we support adding
ids today.  The feature was added, and is used successfully with many
drivers.   I'm trying to extend the population of drivers where it works
to include those that support more than one similar card but need to
know which one they are dealing with.

You left out:
>> Searching the next-20080709 tree shows the bit is set by exactly 3 pci
>> drivers.  However, the use of per-match-entry driver data is much more
>> prevalent: A boot of allyesconfig on a powerpc64 pseries with a debug 
>> patch
>> shows 27 drivers apparently use the field for a pointer, 14 use it for
>> setting flags, and 98 use it as a table index.  (Pointers are defined 
>> as
>> >PAGE_OFFSET, aka in the 64 bit kernel linear mapping.  Flags are 
>> defined as
>> the maximum value exceeds the number of entries in the match table.  
>> Any
>> other nonzero value is classified as an index).

I did the work to establish the scope of the problem.

So 3 drivers set the flag.  98 + 14 should set it immediately.  The 27 
that
use the value as a pointer probably can be re-written to use it as an 
index.  And
the hundreds of other drivers (I don't have the tree here to count) 
apparently
don't care, as they most likely never look at that field.  (I am 
ingoring
conditional copiles that are not enabled by all-yes-config).

> So no, this patch is not good, it should stay as-is.

Obviously I disagree.

Since we added passing the id table entry to get the driver data from 
the
table entry, we have close to 150 drivers that use it, instead of old 
methods
such has hard coded lists of chips in case statements.  Besides making 
it easier
to maintain the driver, it actually improves the chances that the 
driver can be
used on a new revision or subsystem id of the card.

But we have not been reviewing the setting of the flag with the use in 
the driver.
A usage pattern of storing an index or flags has developed, and I claim 
that the
flag now hurts more than it helps.

milton

