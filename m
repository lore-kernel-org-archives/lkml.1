Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbZEDKz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbZEDKz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 06:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbZEDKzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 06:55:14 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:34536 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbZEDKzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 06:55:12 -0400
Message-ID: <49FEC98E.4050906@msgid.tls.msk.ru>
Date: Mon, 04 May 2009 14:55:10 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: compat ioctl32 for /dev/snapshot?
References: <49FEB572.4010909@msgid.tls.msk.ru> <87prepgqhc.fsf@basil.nowhere.org>
In-Reply-To: <87prepgqhc.fsf@basil.nowhere.org>
Content-Type: multipart/mixed;
 boundary="------------090604020208010303050009"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090604020208010303050009
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andi Kleen wrote:
> Michael Tokarev <mjt@tls.msk.ru> writes:
> 
>> Is there any reason why 32-bit uswsusp &Friends does not work
>> on 64bits kernel?
>>
>> For one, 32bits s2disk produces the following when trying to
>> suspend:
>>
>>  ioctl32(s2disk:4134): Unknown cmd fd(4) cmd(400c330d){t:'3';sz:12} arg(ff853554) on /dev/snapshot
>>  ioctl32(s2disk:4134): Unknown cmd fd(4) cmd(4004330a){t:'3';sz:4} arg(00000805) on /dev/snapshot
>>
[]
> It's probably just that nobody has written the code yet. In general all
> missing compat_ioctls are bugs.

Oh well.

Is the following patch ok?  I just pulled all the SNAPSHOT_* stuff from
include/linux/suspend_ioctls.h and added them into fs/compat_ioctl.c.
The ioctls are:
  o argument-less (most of them are)
  o have single loff_t argument (other ioctls with the same argument are
    marked as COMPAT_IOCTL
  o have single int argument - they's also marked as COMPAT_IOCTL,
  o and one othem, SNAPSHOT_SET_SWAP_AREA, has argument pointing to
    the following structure (include/linux/suspend_ioctls.h):
     struct resume_swap_area {
         loff_t offset;
         u_int32_t dev;
     } __attribute__((packed));
    so I think it also does not need any translation layer.

I can't test it so far, because uswsusp tools are broken in mixed
32/64bit case in other places.  But at least it compiles fine and
does not complain anymore.

I never touched this area before so I may be wrong... but if it's ok...

Signed-Off-By: Michael Tokarev <mjt@tls.msk.ru>

Thanks!

/mjt

--------------090604020208010303050009
Content-Type: text/x-patch;
 name="snapshot-compat-ioctl.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="snapshot-compat-ioctl.patch"

Signed-Off-By: Michael Tokarev <mjt@tls.msk.ru>

--- linux-2.6.29/fs/compat_ioctl.c.orig	2009-03-24 02:12:14.000000000 +0300
+++ linux-2.6.29/fs/compat_ioctl.c	2009-05-04 14:46:49.906169841 +0400
@@ -112,2 +112,4 @@
 
+#include <linux/suspend_ioctls.h>
+
 #ifdef CONFIG_SPARC
@@ -2301,2 +2303,17 @@ COMPATIBLE_IOCTL(SOUND_MIXER_SETLEVELS)
 COMPATIBLE_IOCTL(OSS_GETVERSION)
+/* SNAPSHOT */
+COMPATIBLE_IOCTL(SNAPSHOT_FREEZE)
+COMPATIBLE_IOCTL(SNAPSHOT_UNFREEZE)
+COMPATIBLE_IOCTL(SNAPSHOT_ATOMIC_RESTORE)
+COMPATIBLE_IOCTL(SNAPSHOT_FREE)
+COMPATIBLE_IOCTL(SNAPSHOT_FREE_SWAP_PAGES)
+COMPATIBLE_IOCTL(SNAPSHOT_S2RAM)
+COMPATIBLE_IOCTL(SNAPSHOT_SET_SWAP_AREA)	/* struct resume_swap_area */
+COMPATIBLE_IOCTL(SNAPSHOT_GET_IMAGE_SIZE)
+COMPATIBLE_IOCTL(SNAPSHOT_PLATFORM_SUPPORT)
+COMPATIBLE_IOCTL(SNAPSHOT_POWER_OFF)
+COMPATIBLE_IOCTL(SNAPSHOT_CREATE_IMAGE)
+COMPATIBLE_IOCTL(SNAPSHOT_PREF_IMAGE_SIZE)
+COMPATIBLE_IOCTL(SNAPSHOT_AVAIL_SWAP_SIZE)
+COMPATIBLE_IOCTL(SNAPSHOT_ALLOC_SWAP_PAGE)
 /* AUTOFS */

--------------090604020208010303050009--
