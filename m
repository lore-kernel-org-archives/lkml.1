Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbYIYDMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbYIYDMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 23:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYIYDMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 23:12:12 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:55918 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbYIYDML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 23:12:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:references:x-google-sender-auth;
        b=cwtnARcvSBpqOsk0xkH9e0Gup6VHKEmW/G681HP7MPAGdtEUEM4EdRBEI/1IRSF1ed
         TpNPG+DOHS8fZ2hcOqwH5cfNniFudWPGfMkVdSgIYN9rDa2bAgx3N1xht+8CVcAY2zW9
         WKPjle2ohimfZhcfLDmBTg228gRPJRmjzuaqE=
Message-ID: <3ae72650809242012r7d144a64l35777f2a7bacbaa0@mail.gmail.com>
Date: Wed, 24 Sep 2008 20:12:09 -0700
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
Subject: Re: Differend udev names with different kernels
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
In-Reply-To: <20080924200127.GA2452@dose.home.local>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_49242_18319996.1222312329883"
References: <20080924200127.GA2452@dose.home.local>
X-Google-Sender-Auth: e5ba3ea78cd3b3cf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_49242_18319996.1222312329883
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Sep 24, 2008 at 13:01, Tino Keitel <tino.keitel@gmx.de> wrote:
> what's the intention of /dev/disk/by-id/?
>
> My firewire hard disk seems to have different names with different
> kernels.
>
> With 2.6.26.3, it's name is
> /dev/disk/by-id/ieee1394-0030e001e0006585:00043c:0000.
>
> With someting after 2.6.27-rc7, merged with Arjan's fastboot branch,
> the disk has the same name.
>
> With 2.6.27-rc7, it is called
> /dev/disk/by-id/scsi-1WDC_WD10EACS-00D6B0_WD-WCAU41668315.

Seems, for some reason, the "ieee1394_id" attribute becomes readable
because of lucky timing, which wasn't the case before.

> One major config difference is that 2.6.26.3 has CONFIG_FIREWIRE and
> CONFIG_FIREWIRE_SBP2 set to "m", whereas the 2.6.27 kernels have set
> them to "y". But that doesn't explain the difference between both
> 2.6.27-rc kernels.

I guess, it's just a not-easy-to-reproduce timing issue with the sysfs
attribute.

> Shouldn't these names be somewhat constant? Otherwise they would be
> totally useless.

Yeah, sure they should not change like this.

We could just drop the ieee1394-* link creation entirely, if they
never worked as expected. Or we can provide it as an additional link
instead of making it skip the scsi-* link creation. Tino, care to try
if something like the attached works for your setup and creates at
least the scsi-links, and, if luckily timed, the ieee1394 links?

Stefan, ieee1394 hooks into scsi logic which, i guess, creates the
attribute _after_ event time, so udev will not see the attribute when
the device is announced. Any idea how to fix that?

Thanks,
Kay

------=_Part_49242_18319996.1222312329883
Content-Type: text/x-patch; name=ieee1394-links-fix.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_flit2q1d0
Content-Disposition: attachment; filename=ieee1394-links-fix.patch

ZGlmZiAtLWdpdCBhL3J1bGVzL3J1bGVzLmQvNjAtcGVyc2lzdGVudC1zdG9yYWdlLnJ1bGVzIGIv
cnVsZXMvcnVsZXMuZC82MC1wZXJzaXN0ZW50LXN0b3JhZ2UucnVsZXMKaW5kZXggNTIxOGIyYy4u
ZGVjODNjZiAxMDA2NDQKLS0tIGEvcnVsZXMvcnVsZXMuZC82MC1wZXJzaXN0ZW50LXN0b3JhZ2Uu
cnVsZXMKKysrIGIvcnVsZXMvcnVsZXMuZC82MC1wZXJzaXN0ZW50LXN0b3JhZ2UucnVsZXMKQEAg
LTMxLDEzICszMSwxNiBAQCBLRVJORUw9PSJoZCpbITAtOV0iLCBJTVBPUlR7cHJvZ3JhbX09ImF0
YV9pZCAtLWV4cG9ydCAkdGVtcG5vZGUiCiBLRVJORUw9PSJoZCpbITAtOV0iLCBFTlZ7SURfU0VS
SUFMfT09Ij8qIiwgU1lNTElOSys9ImRpc2svYnktaWQvYXRhLSRlbnZ7SURfTU9ERUx9XyRlbnZ7
SURfU0VSSUFMfSIKIEtFUk5FTD09ImhkKlswLTldIiwgRU5We0lEX1NFUklBTH09PSI/KiIsIFNZ
TUxJTksrPSJkaXNrL2J5LWlkL2F0YS0kZW52e0lEX01PREVMfV8kZW52e0lEX1NFUklBTH0tcGFy
dCVuIgogCi1LRVJORUw9PSJzZCpbITAtOV18c3IqIiwgQVRUUlN7aWVlZTEzOTRfaWR9PT0iPyoi
LCBFTlZ7SURfU0VSSUFMfT0iJGF0dHJ7aWVlZTEzOTRfaWR9IiwgRU5We0lEX0JVU309ImllZWUx
Mzk0IgogS0VSTkVMPT0ic2QqWyEwLTldfHNyKiIsIEVOVntJRF9TRVJJQUx9IT0iPyoiLCBTVUJT
WVNURU1TPT0idXNiIiwgSU1QT1JUe3Byb2dyYW19PSJ1c2JfaWQgLS1leHBvcnQgJXAiCiBLRVJO
RUw9PSJzZCpbITAtOV18c3IqIiwgRU5We0lEX1NFUklBTH0hPSI/KiIsIElNUE9SVHtwcm9ncmFt
fT0ic2NzaV9pZCAtLWV4cG9ydCAtLXdoaXRlbGlzdGVkIC1kICR0ZW1wbm9kZSIsIEVOVntJRF9C
VVN9PSJzY3NpIgogS0VSTkVMPT0iY2Npc3M/Y1swLTldZFswLTldKiIsIEVOVntJRF9TRVJJQUx9
IT0iPyoiLCBJTVBPUlR7cHJvZ3JhbX09InNjc2lfaWQgLS1leHBvcnQgLS13aGl0ZWxpc3RlZCAt
ZCAkdGVtcG5vZGUiLCBFTlZ7SURfQlVTfT0iY2Npc3MiCiBLRVJORUw9PSJzZCpbITAtOV18c3Iq
fGNjaXNzP2NbMC05XWRbMC05XSoiLCBFTlZ7SURfU0VSSUFMfT09Ij8qIiwgU1lNTElOSys9ImRp
c2svYnktaWQvJGVudntJRF9CVVN9LSRlbnZ7SURfU0VSSUFMfSIKIEtFUk5FTD09InNkKlswLTld
fGNjaXNzKnBbMC05XSoiLCBFTlZ7SURfU0VSSUFMfT09Ij8qIiwgU1lNTElOSys9ImRpc2svYnkt
aWQvJGVudntJRF9CVVN9LSRlbnZ7SURfU0VSSUFMfS1wYXJ0JW4iCiAKKyMgZmlyZXdpcmUKK0tF
Uk5FTD09InNkKlshMC05XXxzcioiLCBBVFRSU3tpZWVlMTM5NF9pZH09PSI/KiIsIFNZTUxJTksr
PSJkaXNrL2J5LWlkL2llZWUxMzk0LSRhdHRye2llZWUxMzk0X2lkfSIKK0tFUk5FTD09InNkKlsw
LTldIiwgQVRUUlN7aWVlZTEzOTRfaWR9PT0iPyoiLCBTWU1MSU5LKz0iZGlzay9ieS1pZC9pZWVl
MTM5NC0kYXR0cntpZWVlMTM5NF9pZH0tcGFydCVuIgorCiAjIGxpYmF0YSBjb21wYXQgKGF0YS0q
IGxpbmtzLCBsaWtlIG9sZCBoZCogZGV2aWNlcyBkaWQgY3JlYXRlKQogS0VSTkVMPT0ic2QqWyEw
LTldfHNyKiIsIEVOVntJRF9WRU5ET1J9PT0iQVRBIiwgUFJPR1JBTT0iYXRhX2lkICR0ZW1wbm9k
ZSIsIFJFU1VMVD09Ij8qIiwgRU5We0lEX0FUQV9DT01QQVR9PSIkcmVzdWx0IiwgU1lNTElOSys9
ImRpc2svYnktaWQvYXRhLSRlbnZ7SURfQVRBX0NPTVBBVH0iCiBLRVJORUw9PSJzZCpbMC05XSIs
IEVOVntJRF9BVEFfQ09NUEFUfT09Ij8qIiwgU1lNTElOSys9ImRpc2svYnktaWQvYXRhLSRlbnZ7
SURfQVRBX0NPTVBBVH0tcGFydCVuIgo=
------=_Part_49242_18319996.1222312329883--
