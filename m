Return-Path: <linux-kernel-owner+w=401wt.eu-S1030797AbXCGJS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030797AbXCGJS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030799AbXCGJS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:18:58 -0500
Received: from smtp-103-wednesday.noc.nerim.net ([62.4.17.103]:1975 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030797AbXCGJSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:18:55 -0500
Date: Wed, 7 Mar 2007 10:17:58 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Bodo Eggert <7eggert@gmx.de>
Cc: David Hubbard <david.c.hubbard@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org,
       linux-acpi@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>,
       Rudolf@atrpms.net
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-Id: <20070307101758.8cf2c53d.khali@linux-fr.org>
In-Reply-To: <Pine.LNX.4.58.0703061804360.2988@be1.lrz>
References: <7PvLN-1cj-3@gated-at.bofh.it>
	<7TEGV-6Jy-39@gated-at.bofh.it>
	<7TUBX-6TN-5@gated-at.bofh.it>
	<7UeqX-4QO-17@gated-at.bofh.it>
	<7UeqZ-4QO-27@gated-at.bofh.it>
	<7UgM5-np-1@gated-at.bofh.it>
	<7UgM8-np-11@gated-at.bofh.it>
	<7UnaS-2xP-9@gated-at.bofh.it>
	<7UnkC-2JB-9@gated-at.bofh.it>
	<7Uzcd-49u-3@gated-at.bofh.it>
	<7UEEN-4xi-3@gated-at.bofh.it>
	<E1HODgC-0000h8-Vc@be1.lrz>
	<20070306161935.025a3ec1.khali@linux-fr.org>
	<Pine.LNX.4.58.0703061804360.2988@be1.lrz>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bodo,

On Tue, 6 Mar 2007 21:40:19 +0100 (CET), Bodo Eggert wrote:
> On Tue, 6 Mar 2007, Jean Delvare wrote:
> > On Mon, 05 Mar 2007 14:56:44 +0100, Bodo Eggert wrote:
> 
> > > 2) make ACPI take this lock whenever it touches ports not allocated by itself
> > >    and release it on function return.
> > 
> > This is costly.
> 
> TANSTAAFL. You'll need to take some lock, and if you want port emulation 
> or per-device-mutex, you'll have to pay the price.

True, but precisely, I wonder what will perform the best in practice, a
single semaphore that is unconditionally taken by ACPI/AML, or your
finer-grained approach and its many additional tests.

> 
> > > 3) Make ACPI callback the allocating device if it touches allocated ranges,
> > >    and on function return.
> > 
> > By callback, do you mean port forwarding as Rudolf Marek did, or more
> > simple "stop touching the device" and "you can touch the device again"
> > sort of signals? If the latter, this is no different from a mutex.
> 
> It may be the described port emulation callback (which is very nice and
> possibly desired for some devices), but if you add an "I am done tampering
> with your hardware" callback, the driver can also implement the mutex.
> 
> Some drivers will not understand all possible access patterns, they may 
> try to emulate first, and if they fail, fall back to taking the mutex and 
> passing the raw port access.

Good point.

> 
> > > 1 + 2 will replace allocating single ports and freeing them again (so ACPI won't
> > > prevent e.g. the display driver from loading just because it turned on the
> > > backlight) while preventing races with newly allocated ranges, and 3 allows
> > > coexistence with other drivers.
> > 
> > What benefit do you see compared to a lock taken by both AML and the
> > hardware monitoring drivers?
> 
> 1) I asume port allocations or ACPI foreign port acces to be rare, so
>    there would be little impact on (un)registering hardware. Off cause
>    there are some long ACPI calls (like reading the battery?), in these
>    cases it might be beneficial to release the global allocation lock
>    after gaining exclusive access to the driver's port range. (This can
>    only be done if the device driver is loaded.)

The problem is that the rarity of ACPI foreign port access doesn't
matter much, as you have to do all the tests first to find out that it
was a foreign port, and I suspect that these tests will cost more than
taking the lock itself.

> 2) If there is a global lock for accessing ACPI-tampered hardware, each
>    driver that *might* conflict with ACPI _must_ take it on each access.  
>    This would seialize unrelated sensor busses, IDE, graphics ...  (AFAI
>    can imagine.)  A callback allows using a per-(device|bus)-mutex instead.

True, this is the problem with having a single mutex: everything gets
serialized. I have no idea how often we are running AML code though, so
I don't know if this is a real problem in practice.

We may be able to workaround the inter-driver exclusion though, if we
use a semaphore initialized to N, have ACPI take N, but other drivers
take just one. This would let ACPI be exclusive with all the other
drivers, but drivers themselves could otherwise run concurrently. That
being said, we do not appear to have the required primitives to take
more than 1 semaphore resource at once at the moment, so we'd need to
do that first.

OTOH, I certainly hope that not that many drivers are affected on a
given system, so maybe serialization is acceptable. We'll need some
field experimentation to find out.

> Rudolph's implementation is close enough to imagine what would be done,
> the changes would be:
> 
> - Add a "done" call to resource_ops
> 
> in ACPI:
> - Check for own region first and do raw access there
> - get the lock before __request_region
> - s/__request/__check/
> 
> in driver:
> - If emulation fails, get the local lock and switch to passthrough mode
> - if in passthrough mode and done is called, release the lock

Yep, that's a bit complex, but should work, thanks for sketching this.

-- 
Jean Delvare
