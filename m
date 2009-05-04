Return-Path: <linux-kernel-owner+w=401wt.eu-S1757841AbZEDW0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbZEDW0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 18:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbZEDW0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 18:26:30 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:46738 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbZEDW03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 18:26:29 -0400
Message-ID: <49FF6B94.2080008@msgid.tls.msk.ru>
Date: Tue, 05 May 2009 02:26:28 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Andi Kleen <andi@firstfloor.org>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: compat ioctl32 for /dev/snapshot?
References: <49FEB572.4010909@msgid.tls.msk.ru> <87prepgqhc.fsf@basil.nowhere.org> <49FEC98E.4050906@msgid.tls.msk.ru> <200905041352.18428.arnd@arndb.de>
In-Reply-To: <200905041352.18428.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Monday 04 May 2009, Michael Tokarev wrote:
>> Is the following patch ok?  I just pulled all the SNAPSHOT_* stuff from
>> include/linux/suspend_ioctls.h and added them into fs/compat_ioctl.c.
[]

> You are however missing support for deprecated ioctls in your
> code: SNAPSHOT_SET_SWAP_FILE and SNAPSHOT_PMOPS are trivial
> (COMPATIBLE_IOCTL), but you also need to add support for
> these

Well, as comments in that file (kernel/power/user.c) states, those
ioctls are obsolete and will be removed and are only preserved for
compatibility etc.  Since no one complained so far (well, no one
complained about whole /dev/snapshot thing at all ;), maybe there's
no need to define those and the following ones too?

> #define SNAPSHOT_ATOMIC_SNAPSHOT32 _IOW(SNAPSHOT_IOC_MAGIC, 3, compat_uptr_t)
> #define SNAPSHOT_SET_IMAGE_SIZE32 _IOW(SNAPSHOT_IOC_MAGIC, 6, compat_ulong)
> #define SNAPSHOT_AVAIL_SWAP32 _IOR(SNAPSHOT_IOC_MAGIC, 7, compat_uptr_t)
> #define SNAPSHOT_GET_SWAP_PAGE32 _IOR(SNAPSHOT_IOC_MAGIC, 8, compat_uptr_t)
> 
>> I can't test it so far, because uswsusp tools are broken in mixed
>> 32/64bit case in other places.  But at least it compiles fine and
>> does not complain anymore.
> 
> I try to reduce the size of compat_ioctl.c. A better implementation
> would be to add a ->compat_ioctl() operation to the file_operations
> and list the compatible ioctl numbers as well.

Well, your way is definitely a lot cleaner.  But I didn't know about
either of them anyway :)

> Please try this patch instead:

Ok.  Your patch was garbled by your MUA (inserting =3D =20 and breaking
lines), but that's ok.  After de-garbling it now complains about
undefined compat_uptr_t.  For that, I've added

#ifdef CONFIG_COMPAT
#include <linux/compat.h>
#endif

at the end of the file.  Also there was a typo (duplicated above),
compat_ulong should be compat_ulong_t.  After all that it finally
compiles.  As of "works" -- the above my comment still applies,
uswsusp for one is badly broken on 32/64 bits.  I'm trying to
create a simpler test-case, as time permits.

Thanks!

/mjt
