Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbZKHPse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbZKHPse (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 10:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbZKHPsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 10:48:33 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:46036 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbZKHPsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 10:48:32 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Paolo Giarrusso <p.giarrusso@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Daylight saving time & FAT
References: <a4d0c86c0911051222q1ec384a2u724e0c8b1432ddb6@mail.gmail.com>
Date: Mon, 09 Nov 2009 00:48:33 +0900
In-Reply-To: <a4d0c86c0911051222q1ec384a2u724e0c8b1432ddb6@mail.gmail.com>
	(Paolo Giarrusso's message of "Thu, 5 Nov 2009 21:22:45 +0100")
Message-ID: <873a4p9fvy.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Giarrusso <p.giarrusso@gmail.com> writes:

> When re-rsync'ing two hard drives (one VFAT, one NTFS mounted with
> ntfs-3g) after a Daylight Saving Time change (I was on CEST, +0200,
> now I'm on CET, +0100), I discovered a one-hour time difference over
> all files (on FAT, they are one hour in future).
> My current understanding is that FAT stores times relative to the
> current timezone, and that's crappy (see fat_time_fat2unix(), in
> fs/fat/misc.c). But with the current code, it gets even more crappy -
> the same file will have a different _UTC_ timestamp depending on my
> current timezone, since the current offset from UTC is added to the
> stored timestamp to get the UTC time (I verified the timezone change
> would perfectly explain, even in sign, the time difference I found).
> That's why I guess that the FAT timestamps are wrong.
> I frankly doubt that Windows is so bad.
>
> On DOS, they could get away without any conversion at all. But on
> current Windows systems? Either you find the right time zone at file
> saving time (too complicated IMHO) or ignore DST when saving/restoring
> time (i.e. pretend DST is not in effect, and add the shift if needed).
> I don't know right now what happens.
> I wrote this mail to discuss what would be the correct solution (the
> second?), and if it is possible to implement it.

fat_time_{fat2unix,unix2fat}() doesn't handle timezone correctly. It
just uses timeoffset from sys_tz.tz_minuteswest. But, it is not enough
for localtime. Because it doesn't handle DST or such complex stuff. (As
workaround, fat has "tz=UTC" option)

To get correct conversion, those functions have to handle timezone
database (zoneinfo or something).

I think the issues would be, who (userland or kernel) handle zoneinfo,
and how handle.

Well, so, FWIW, I was thinking make timezone subsystem. userland app
pass one of zoneinfo to kernel as data via ioctl or sysfs or something
with name, and subsystem manages the lifetime/etc. of data.  And
provide utc2local(time, zone name) to convert time correctly.

So, fs would be able to get help of utc2local() to convert to on-disk
format, and probably, zonename will be specified as mount option.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
