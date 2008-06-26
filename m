Return-Path: <linux-kernel-owner+w=401wt.eu-S1760798AbYFZNYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760798AbYFZNYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbYFZNXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:23:51 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:53439 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYFZNXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:23:50 -0400
Message-ID: <48639863.808@skyrush.com>
Date: Thu, 26 Jun 2008 07:23:47 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080620)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UTC timestamp option for FAT filesystems
References: <4861D685.4070308@skyrush.com> <87od5pqh4o.fsf@basil.nowhere.org>	<4862DB28.3050001@skyrush.com> <48630286.2050006@skyrush.com> <87wskck5wi.fsf@devron.myhome.or.jp>
In-Reply-To: <87wskck5wi.fsf@devron.myhome.or.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
>> So FAT filesystem timestamps make sense in one of two modes for a given
>> volume: local time or UTC.  The former handles volumes used under
>> Windows well, and the latter would be extremely useful for other devices
>> which use FAT filesystems but need to have a more sensible "real" time
>> format (like, as I pointed out, digital cameras).
> 
> Um, so how does the camera show the timestamp of file? UTC seems to be
> hack for changing FAT for Linux. Arbitrary value is more useful and
> correct option, I think.

Since the camera does not have a concept of time zone, the camera's
clock, itself, would show UTC.  You are correct that one could, instead,
choose an arbitrary time offset when setting the camera's clock, and if
an option existed in Linux to always use this fixed offset on mount, the
Linux timestamp could be correct in this case as well.

However, there are some issues I see with choosing to do this:

1) It is more confusing than using UTC (the user, in essence, is
defining a new absolute reference time similar to UTC but not UTC (and
that matches his local time, at least for 1/2 the year).

2) If the user moves, either the camera and mount offset could be left
at the "wrong" setting that would now be less meaningful than UTC, or
the user could change both.

3) When the daylight saving time switch happens, the camera's time will
now be wrong, even though the Linux time will still be OK - they will
differ by 1 hour unless corrected.  If the camera could (and did) adjust
for DST automatically, then this would give a bad Linux time and
potentially go unnoticed until the fixed offset were corrected (note
that my camera does not ever auto-adjust; I'm not sure if any can).

So in cases 2 and 3, the user would end up needing to change the offset,
perhaps twice a year.  This is one thing I am trying to avoid by just
using UTC.  Using UTC as the "fixed offset" is the only one that makes
sense in that if one is to choose some arbitrary "universal time", it
might as well be UTC (and there are no DST issues with UTC).

> It will be specified the timezone of FAT on one disk. So, the timestamp
> is right for specified timezone on Windows always, on Linux should be
> always right...
> 
> No?

Not really.  Here's an example:

1) Create a folder on FAT in Windows in winter at local 12:00
2) Create a folder on FAT in Windows in summer at local 12:00
3) Notice that in Windows, they both will read "12:00"
4) Mount the volume under Linux with the default "local time" behavior,
   and you will notice the times are off by one hour (because Linux
   adjusts both by the same offset in the kernel, but userland
   correctly adjusts them differently due to different DST status)

This is one case in which Linux's method of FAT local time correction
breaks down, and the real root of the problem is that FAT is not using
UTC.  If, in Linux, the same FAT partition were looked at 6 months
later, the two times would still differ by one hour, but they would both
also be shifted by one hour due to the kernel's different DST correction
(i.e. the "other one" would now read "12:00".

As I mentioned, local time is not a realistic way to handle time anyway,
but the paradigm has existed in DOS/Windows FAT throughout its history
(note that NTFS, on the other hand, behaves more like a real fs).

So, if one were to, instead of UTC, use an arbitrary "fixed" offset when
mounting a FAT partition, the same issue would occur (Linux and Windows
would not agree always).

						-Joe
