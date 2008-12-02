Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbYLBK3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbYLBK3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 05:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYLBK32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 05:29:28 -0500
Received: from eazy.amigager.de ([213.239.192.238]:35328 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbYLBK31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 05:29:27 -0500
Date: Tue, 2 Dec 2008 11:29:25 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: Mark Lord <lkml@rtr.ca>
Cc: Len Brown <lenb@kernel.org>, Alessandro Zummo <a.zummo@towertech.it>,
       David Brownell <david-b@pacbell.net>,
       lkml <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com,
       linux-acpi@vger.kernel.org
Subject: Re: PATCH: /proc/acpi/alarm: handle day-of-month wraparound on
	readback
Message-ID: <20081202102925.GA3194@dose.home.local>
Mail-Followup-To: Mark Lord <lkml@rtr.ca>, Len Brown <lenb@kernel.org>,
	Alessandro Zummo <a.zummo@towertech.it>,
	David Brownell <david-b@pacbell.net>,
	lkml <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com,
	linux-acpi@vger.kernel.org
References: <200806222042.13929.david-b@pacbell.net> <4934176F.6080900@rtr.ca> <4934188E.6080701@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4934188E.6080701@rtr.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 12:02:06 -0500, Mark Lord wrote:
> Mark Lord wrote:
>> Fix month wrap issue with readback from /proc/acpi/alarm
>> This bug has been around *forever*.
>>
>> $ echo '2008-12-01 10:36:20' > /proc/acpi/alarm
>> $ cat /proc/acpi/alarm
>> 2008-11-01 10:36:20
>>
>> Note how the readback above shows the month incorrectly.
>> But with this patch applied, it shows the correct month (12).
> ..
>
> I should add, that the above test requires that the alarm
> be set for any day of the *next* month from the current month.
> My MythTV box does a readback test any time it programs a wakeup,
> and noticed the bug over this past weekend (2008-11-30).

Why not just use the new RTC drivers and /sys/class/rtc/rtc0/wakealarm?
MythTV already provides seconds since epoch for the wakeup time, so you
can use this value without converting it:

$ cat /usr/local/bin/myth-setwaketime
#!/bin/sh

SYSFS_WAKE_FILE="/sys/class/rtc/rtc0/wakealarm"

echo -n "Wakeup time is "
date -d @$1

if ! test -w "$SYSFS_WAKE_FILE" ; then
	exit 1
fi

echo 0 > "$SYSFS_WAKE_FILE"
echo "$1" > "$SYSFS_WAKE_FILE"
