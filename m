Return-Path: <linux-kernel-owner+w=401wt.eu-S1759186AbYDAQti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186AbYDAQti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 12:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755819AbYDAQtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 12:49:12 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:21216 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbYDAQtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 12:49:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:references:user-agent:mime-version:content-type;
        b=WKoNOK86sK5YpzvnjJNc83J2kWx6pid3YPUY8OaZa+x1AJO7aLc1ydTD1We7Ru3nLKHNa1rG9jJUWcnUBFKk2QOFYIHTORT1Nb8cWMtnP2in3pb+ldiJ2iVSpNWP2GFBDBiat6zwuvpdbdIHJNxYb/j8UcYDpLfVwcN0hRGpnmM=
Date: Tue, 1 Apr 2008 20:48:46 +0400 (MSD)
From: Sergey Dolgov <solkaa@gmail.com>
X-X-Sender: solka@slke.laptop
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: usb-storage, error reading the last 8 sectors, regression in
 2.6.25-rc7
In-Reply-To: <20080401155323.GB31604@one-eyed-alien.net>
Message-ID: <alpine.DEB.1.10.0804012040300.3959@slke.laptop>
References: <20080401143420.GB20920@one-eyed-alien.net> <Pine.LNX.4.44L0.0804011040260.4253-100000@iolanthe.rowland.org> <20080401155323.GB31604@one-eyed-alien.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1426689057-1207068544=:3959"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1426689057-1207068544=:3959
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 1 Apr 2008, Matthew Dharm wrote:

> On Tue, Apr 01, 2008 at 10:42:51AM -0400, Alan Stern wrote:
>> On Tue, 1 Apr 2008, Matthew Dharm wrote:
>>
>>> On Tue, Apr 01, 2008 at 10:28:52AM -0400, Alan Stern wrote:
>>>> On Tue, 1 Apr 2008, Oliver Neukum wrote:
>>>>
>>>>> Am Dienstag, 1. April 2008 03:58:31 schrieb Alan Stern:
>>>>>> Nevertheless, it's clear that the problem has nothing to do with the
>>>>>> USB stack.  The real source of the problem lies in the device itself,
>>>>>> for reporting a bogus error when in fact nothing went wrong.  That may
>>>>>> also explain why you don't always see the problem -- sometimes the
>>>>>> device works the way it ought to.
>>>>>
>>>>> Reminds me of the devices that can read the last sector but only if it is read
>>>>> by itself. Do you reckon this device may have the "opposite" quirk?
>>>>
>>>> Could be something like that.
>>>
>>> Didn't I see some SCSI patches go by to implement exactly this change?
>>> That is, only read the last sector by itself?
>>
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

First of all, thank you guys for your help!

I have reverted commit 23c3e290fb9ce38cabc2822b47583fc8702411bf ([SCSI] 
usbstorage: use last_sector_bug flag universally) and my card reader seems 
to be working properly.

I'll need to give it some more testing to be 100 % shure though (so far 
I've just booted once).

As for what should be done to handle both kinds of hardware peculiarities, 
I'm not the one to advise, but looks like sometheng needs to be done.

--
Sergey
--8323329-1426689057-1207068544=:3959--
