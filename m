Return-Path: <linux-kernel-owner+w=401wt.eu-S1758554AbYDAQcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbYDAQcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 12:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbYDAQcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 12:32:15 -0400
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:44996 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbYDAQcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 12:32:14 -0400
Message-ID: <47F26372.30508@panasas.com>
Date: Tue, 01 Apr 2008 19:31:46 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
       Sergey Dolgov <solkaa@gmail.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: usb-storage, error reading the last 8 sectors, regression in
 2.6.25-rc7
References: <20080401143420.GB20920@one-eyed-alien.net> <Pine.LNX.4.44L0.0804011040260.4253-100000@iolanthe.rowland.org> <20080401155323.GB31604@one-eyed-alien.net>
In-Reply-To: <20080401155323.GB31604@one-eyed-alien.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01 2008 at 18:53 +0300, Matthew Dharm <mdharm-kernel@one-eyed-alien.net> wrote:
> On Tue, Apr 01, 2008 at 10:42:51AM -0400, Alan Stern wrote:
>> On Tue, 1 Apr 2008, Matthew Dharm wrote:
>>
>>> On Tue, Apr 01, 2008 at 10:28:52AM -0400, Alan Stern wrote:
>>>> On Tue, 1 Apr 2008, Oliver Neukum wrote:
>>>>
>>>>> Am Dienstag, 1. April 2008 03:58:31 schrieb Alan Stern:
>>>>>> Nevertheless, it's clear that the problem has nothing to do with the 
>>>>>> USB stack.  The real source of the problem lies in the device itself, 
>>>>>> for reporting a bogus error when in fact nothing went wrong.  That may 
>>>>>> also explain why you don't always see the problem -- sometimes the 
>>>>>> device works the way it ought to.
>>>>> Reminds me of the devices that can read the last sector but only if it is read
>>>>> by itself. Do you reckon this device may have the "opposite" quirk?
>>>> Could be something like that.
>>> Didn't I see some SCSI patches go by to implement exactly this change?
>>> That is, only read the last sector by itself?
>> You are getting the two problems mixed up.  The older problem, which
>> the SCSI patche addressed, was that the device would fail when
>> accessing the last sector unless the transfer was 1 sector long.
>>
>> This problem is different.  When performing an 8-sector read that 
>> includes the last sector, the device succeeds.  When performing a 
>> 7-sector read starting from the same place (so not including the last 
>> sector), the device fails.
> 
> I thought the patch I saw unconditionally re-wrote any access that included
> the last sector into two accesses -- everything but the last sector, and
> the last sector.
> 
> In other words, the patch attempted to avoid problems on devices that
> couldn't access the last sector unless the transfer was 1 sector long by
> ONLY accessing the last sector in a single transfer.
> 
> If I'm remembering correctly, that would explain the behavior change which
> lead to the exposure of the bad behavior of this new device.  This new
> device worked with the old code, but not with the new code.
> 
> Basically, by avoiding a common error condition in device firmware, we've
> found a device that has exactly the opposite bug.
> 
> Presuming someone can find the patch in the archive, reverting it would
> produce a good test case; it should restore this device to a working state.
> Maybe we need some auto-detect logic here; try the new way, if it fails,
> revert to the old behavior.  That's probably the safe order, as a lot of
> the devices with the more 'classic' bug just die completely, whereas this
> one appears to be recoverable.
> 
> Matt
> 

The old way was not necessarily correct for this type of device bug. Only
that it had a very high chance of not appearing.

When discussing the last bug, it was said to enable it by default for USB
instead of using blacklists. It looks like this bug, or the other, needs a
blacklist.

But to me it looks like this is a 4k thing. I think Windows will always
use 4k for FAT, though never triggering either of the bugs.

The one submitting the last sector patch was, I think, Hans de Goede (CCed)
Hans ?
  If I read last 8 sectors (4k) on a device that exhibits the "last sector bug"
  Does it work? (Is 8 a magic number here)

Boaz
