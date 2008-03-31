Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbYCaEdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbYCaEdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 00:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbYCaEdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 00:33:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:3441 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbYCaEdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 00:33:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=kBbpAUr0kyC02QtPoLZG48Kn4vtLA4yY/QCmW+zH67/pozDsBeo9AWJiyngvfQ1D0IGfA6ieyjbExdDYF3UVJdOOHXojKU3hpZhGHN40zhrf918ynCjAtq9Eu+Xv41K37Z847uGwAq6hX23mJWokYXcHGOT+fGaoXo765TIjEdQ=
Message-ID: <47F06987.2060208@gmail.com>
Date: Mon, 31 Mar 2008 13:33:11 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Roger Heflin <rogerheflin@gmail.com>
CC: Hans-Peter Jansen <hpj@urpla.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.24.3: regular sata drive resets - worrisome?
References: <200803201518.32109.hpj@urpla.net> <200803300114.40096.hpj@urpla.net> <47EEE4BF.5080609@gmail.com> <200803301400.10766.hpj@urpla.net> <47EF8A65.1010005@gmail.com>
In-Reply-To: <47EF8A65.1010005@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roger Heflin wrote:
>> The only non-failing drive was sdf as it was running in standby mode 
>> in this md raid 5 ensemble:
>>
>> 20080323-011337-sdc.log:195 Hardware_ECC_Recovered  0x001a   100   
>> 100   000    Old_age   Always       -       162956700
>> 20080323-011338-sde.log:195 Hardware_ECC_Recovered  0x001a   100   
>> 100   000    Old_age   Always       -       148429049

Hmmm... looks similar.

>>> Hmmm... If the drive is failing FLUSHs, I would expect to see elevated
>>> reallocation counters and maybe some pending counts.  Aieee.. weird.
>>
>> But there are no reallocations nor any pending sectors on any of them.

Yeah, indded.

>>>>>>> It's been 4 samsung drives at all hanging on a sata sil 3124:
>>>>> FLUSH_EXT timing out usually indicates that the drive is having
>>>>> problem writing out what it has in its cache to the media.  There was
>>>>> one case where FLUSH_EXT timeout was caused by the driver failing to
>>>>> switch controller back from NCQ mode before issuing FLUSH_EXT but that
>>>>> was on sata_nv.  There hasn't been any similar problem on sata_sil24.
>>>> Hmm, I didn't noticed any data distortions, and if there where, they
>>>> live on as copies in their new home..
>>> It should have appeared as read errors.  Maybe the drive successfully
>>                              ^^^^
>>                              write (I guess)

I actually meant read.  For the corrupted data to get transferred to 
other disks, it should have been read as wrong values but such things 
should never happen as ECC checks would fail.

>>> wrote those sectors after 30+ secs timeout.
>>
>> That would point to some driver issue, wouldn't it? Roger Heflin also
>> experienced similar behavior with that controller, which wasn't 
>> reproducible with another.

Roger's problem is different one.  I'll talk about it below.

>> I can offer to you rebuilding that md in a test environment, and 
>> giving you access to it, if you're interested.

Can you hook up those failed drives to a different controller?  Say, 
ahci or ata_piix and put them under write load (ext3 w/ barrier=1 and 
copying lots of files into it should work) and see whether the problem 
reproduces?

> Here are the errors I get, though look at it closer, I am don't appear 
> to be getting the reset, just this error from time to time:
> 
> sd 9:0:0:0: [sde] 976773168 512-byte hardware sectors (500108 MB)
> sd 9:0:0:0: [sde] Write Protect is off
> sd 9:0:0:0: [sde] Mode Sense: 00 3a 00 00
> sd 9:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x280000 action 0x0
> ata8.00: BMDMA2 stat 0x687d8009
> ata8.00: cmd 25/00:80:a7:00:1d/00:01:1d:00:00/e0 tag 0 cdb 0x0 data 
> 196608 in
>          res 51/04:8f:98:01:1d/00:00:1d:00:00/f0 Emask 0x1 (device error)
> ata8.00: configured for UDMA/100

That's device abort error on read.  The drive just can't read sector one 
of the requested sectors and it's not sata_sil24.  It's a bmdma one.

> I have 4 identical disks, with all 4 connected to the SIL controller all 
> give some errors, moving 2 of the disks to a promise controller makes 
> the errors go away on the 2 connected to the promise controller.   All 
> drives are part of a software raid5 array.

Ah.. okay, sata_sil.  Roger, the moving and errors are not very likely 
to have anything to do with each other.  The only possibility is 
transmission problems but the drive didn't report transport error (ICRC) 
and it's more likely that the drive was experiencing temporary failures. 
  It's also possible that the drive set ABRT although there was some 
problem with the transport tho.

If you move the drive back to the sata_sil, do those problems appear 
again?  Anyways, this doesn't really have anything to do with what Hans 
is seeing.

Thanks.

-- 
tejun
