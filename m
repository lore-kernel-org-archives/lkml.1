Return-Path: <linux-kernel-owner+w=401wt.eu-S964852AbXCFUkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964852AbXCFUkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965069AbXCFUku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:40:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:60549 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964852AbXCFUks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:40:48 -0500
Date: Tue, 6 Mar 2007 21:40:19 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Jean Delvare <khali@linux-fr.org>
cc: Bodo Eggert <7eggert@gmx.de>, David Hubbard <david.c.hubbard@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org,
       linux-acpi@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>,
       Rudolf@atrpms.net
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
In-Reply-To: <20070306161935.025a3ec1.khali@linux-fr.org>
Message-ID: <Pine.LNX.4.58.0703061804360.2988@be1.lrz>
References: <7PvLN-1cj-3@gated-at.bofh.it> <7TEGV-6Jy-39@gated-at.bofh.it>
 <7TUBX-6TN-5@gated-at.bofh.it> <7UeqX-4QO-17@gated-at.bofh.it>
 <7UeqZ-4QO-27@gated-at.bofh.it> <7UgM5-np-1@gated-at.bofh.it>
 <7UgM8-np-11@gated-at.bofh.it> <7UnaS-2xP-9@gated-at.bofh.it>
 <7UnkC-2JB-9@gated-at.bofh.it> <7Uzcd-49u-3@gated-at.bofh.it>
 <7UEEN-4xi-3@gated-at.bofh.it> <E1HODgC-0000h8-Vc@be1.lrz>
 <20070306161935.025a3ec1.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9b3b2cc444a07783f194c895a09f1de9
X-Provags-ID2: V01U2FsdGVkX1/lJMQi/NOw3ukyD6k6le0QZw/NZhkBIHmFhNo
 a5vO6aOa0c/DhcKyASy2HsKXcHWeqDftjywpgXFaQpT5KeXGj8
 79TrOEYH1pb6RnhaNn+Xg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007, Jean Delvare wrote:
> On Mon, 05 Mar 2007 14:56:44 +0100, Bodo Eggert wrote:

> > 2) make ACPI take this lock whenever it touches ports not allocated by itself
> >    and release it on function return.
> 
> This is costly.

TANSTAAFL. You'll need to take some lock, and if you want port emulation 
or per-device-mutex, you'll have to pay the price.

> > 3) Make ACPI callback the allocating device if it touches allocated ranges,
> >    and on function return.
> 
> By callback, do you mean port forwarding as Rudolf Marek did, or more
> simple "stop touching the device" and "you can touch the device again"
> sort of signals? If the latter, this is no different from a mutex.

It may be the described port emulation callback (which is very nice and
possibly desired for some devices), but if you add an "I am done tampering
with your hardware" callback, the driver can also implement the mutex.

Some drivers will not understand all possible access patterns, they may 
try to emulate first, and if they fail, fall back to taking the mutex and 
passing the raw port access.

> > 1 + 2 will replace allocating single ports and freeing them again (so ACPI won't
> > prevent e.g. the display driver from loading just because it turned on the
> > backlight) while preventing races with newly allocated ranges, and 3 allows
> > coexistence with other drivers.
> 
> What benefit do you see compared to a lock taken by both AML and the
> hardware monitoring drivers?

1) I asume port allocations or ACPI foreign port acces to be rare, so
   there would be little impact on (un)registering hardware. Off cause
   there are some long ACPI calls (like reading the battery?), in these
   cases it might be beneficial to release the global allocation lock
   after gaining exclusive access to the driver's port range. (This can
   only be done if the device driver is loaded.)

2) If there is a global lock for accessing ACPI-tampered hardware, each
   driver that *might* conflict with ACPI _must_ take it on each access.  
   This would seialize unrelated sensor busses, IDE, graphics ...  (AFAI
   can imagine.)  A callback allows using a per-(device|bus)-mutex instead.

> Care to submit a sample implementation?

I think somebody experienced with the internals should do this.

Rudolph's implementation is close enough to imagine what would be done,
the changes would be:

- Add a "done" call to resource_ops

in ACPI:
- Check for own region first and do raw access there
- get the lock before __request_region
- s/__request/__check/

in driver:
- If emulation fails, get the local lock and switch to passthrough mode
- if in passthrough mode and done is called, release the lock
-- 
Those who hesitate under fire usually do not end up KIA or WIA. 
