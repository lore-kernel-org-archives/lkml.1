Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbYKQUcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbYKQUcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 15:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYKQUc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 15:32:28 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:48237 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbYKQUc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 15:32:27 -0500
Date: Mon, 17 Nov 2008 12:30:32 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Julia Lawall <julia@diku.dk>
Cc: lm-sensors <lm-sensors@lm-sensors.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: adt7470/adt7473: Check input values from sysfs
Message-ID: <20081117203031.GK8668@plum>
Reply-To: djwong@us.ibm.com
References: <Pine.LNX.4.64.0811151612160.4660@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811151612160.4660@pc-004.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding lkml,lm-sensors to cc]

On Sat, Nov 15, 2008 at 04:33:03PM +0100, Julia Lawall wrote:
> Hello,
> 
> I saw your recent patch that converts calls to simple_strtol to 
> strict_strtol and wondered if the same transformation would be useful 
> elsewhere.

I think so.

> diff -u -p a/drivers/hwmon/ad7414.c b/drivers/hwmon/ad7414.c
> diff -u -p a/drivers/hwmon/ad7418.c b/drivers/hwmon/ad7418.c
> diff -u -p a/drivers/hwmon/adm1029.c b/drivers/hwmon/adm1029.c
> diff -u -p a/drivers/hwmon/f71805f.c b/drivers/hwmon/f71805f.c
> diff -u -p a/drivers/hwmon/gl520sm.c b/drivers/hwmon/gl520sm.c
> diff -u -p a/drivers/hwmon/lm63.c b/drivers/hwmon/lm63.c
> diff -u -p a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
> diff -u -p a/drivers/hwmon/lm83.c b/drivers/hwmon/lm83.c
> diff -u -p a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
> diff -u -p a/drivers/hwmon/lm93.c b/drivers/hwmon/lm93.c

Seems like a generally good idea.

> There are a few other cases where the call to simple_strtol is part of a 
> more complicated expression or where the result is stored in a variable of 
> type int, rather than long.  I didn't check for cases where the buffer 
> parameter is not declared as const.

Since it's a sysfs write attribute, I think it's always const.

int/long confusion might be a problem if sizeof(int) != sizeof(long).  I
think those are called LP64 machines, but I don't know if Linux runs in
those environments (it probably does).

> I was wondering whether you think the transformation is of more general 
> interest than the cases you have considered, and whether it is worthwhile 

Yes!

> to pursue this (and whether you have done it all already in some patch I 
> didn't notice).

I have only patched those two drivers (adt7470/73) that I wrote myself.
I don't really have time to clean up the other drivers, so thank you for
coming along with a cool-looking cleanup tool. :)

> A concern is whether it is always reasonable to return -EINVAL.  I assume 

As far as the hwmon drivers go, I think that it's fairly safe to return
-EINVAL if the input is something totally unintelligible.

> it is, because these functions are all stored in the same kind of 
> structure, but there is perhaps something I am overlooking.  In 
> particular, I didn't manage to find out where these functions are actually 
> called.

Something like:

echo notanumber > /sys/class/hwmon/hwmon0/device/temp1_max

--D
