Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbZHGRN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbZHGRN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 13:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbZHGRN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 13:13:26 -0400
Received: from mail-yw0-f177.google.com ([209.85.211.177]:44722 "EHLO
	mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205AbZHGRNZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 13:13:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=efWQ1ZV3QoOC7Iix0AceOGVbkmYyhtPadWB2D7ZXZ2AN/j/46dcTZYTSvIk2dp0422
         KFibmEcN+Snzd9CdP9Q8rwCFcCXkk+Mz0YY2kKQyoHxym61kGUT37lqdDTbvpGEUk55h
         wT1vmghR60ieSQkTVUZgLy8fvO7CcZJ1VBmxk=
MIME-Version: 1.0
In-Reply-To: <20090807151304.GE7545@tuxdriver.com>
References: <c6b1100b0908070350t3101030bs4b3d2e7485ad9aee@mail.gmail.com> 
	<200908071324.45269.elendil@planet.nl> <c6b1100b0908070556sb3f4f80sc757d8b100cbcb3c@mail.gmail.com> 
	<20090807134803.GA7545@tuxdriver.com> <c6b1100b0908070757t7b973180s17959e0f46347d5d@mail.gmail.com> 
	<20090807151304.GE7545@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 7 Aug 2009 10:13:05 -0700
Message-ID: <43e72e890908071013w28644e70h5323e19d19da33a2@mail.gmail.com>
Subject: Re: ath5k - strange regulatory domain change
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Chris Clayton <chris2553@googlemail.com>, Frans Pop <elendil@planet.nl>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 7, 2009 at 8:16 AM, John W. Linville<linville@tuxdriver.com> wrote:
> On Fri, Aug 07, 2009 at 03:57:30PM +0100, Chris Clayton wrote:
>> 2009/8/7 John W. Linville <linville@tuxdriver.com>:
>> > On Fri, Aug 07, 2009 at 01:56:43PM +0100, Chris Clayton wrote:
>
>> >> To sum this up then (as I understand things):
>> >>
>> >> 1. I am the system administrator (root);
>> >> 2. I am using a valid (albeit deprecated from 2.6.31) method to tell
>> >> the wireless infrastructure that I want the regulatory domain set to
>> >> GB;
>> >> 3. GB is a valid code; and
>> >> 4. the wireless infrastructure sets the regulatory domain to CN.
>> >> 5. in 2.6.30, the wireless infrastructure does what I (the root user)
>> >> tell it to do.
>> >>
>> >> That's a regression in my book. Oh well! I do have the iw and crda
>> >> applications installed, so I've taken that route of setting the
>> >> regulatory domain to GB.
>> >
>> > Are you actually getting the wrong regulatory rules enforced?  Or are
>> > you merely bothered that it is reporting "CN" instead of "GB"?
>> >
>>
>> I'm not sure whether it's wrong or not. To these dmesg snippets from
>> my original post look wrong because one of the frequency ranges listed
>> for CN is outside those listed for GB and one of the CN max_eirp
>> entries is not preent in the GB list. Whether that is OK or not I
>> don't know and can't find (lay user) documentation to tell me.
>>
>> cfg80211: Regulatory domain changed to country: GB
>>         (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>>         (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>>         (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>>         (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>>         (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
>>
>> cfg80211: Regulatory domain changed to country: CN
>>         (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>>         (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>>         (5735000 KHz - 5835000 KHz @ 40000 KHz), (N/A, 3000 mBm)
>
> It looks like a mismatch to me.  Luis, can you sort this out?

There is no regression at all, ath5k *got* regulatory domain as of
2.6.31, before that the EEPROM was never read for regulatory domain
treatment. So what you see happening on 2.6.31 is interpretation of
the EEPROM as the vendor designed it and using the regulatory
infrastructure to help compliance. The "CN" is the first alpha2 that
the atheros card's programmed EEPROM regulatory domain code matches
to, so all there is here is a lack of clarity to the user of what was
done and that can be fixed.

Let me elaborate: Atheros EEPROM can be programmed by 3 types of
regulatory domains, I've documented this on the wiki for the shared
ath.ko module [1]. When you get a "regpair" there is no direct 1-1
country mapping. The way the EEPROM was programmed for this type of
regulatory domain was to give you a group number under which other
countries fall under. If you ended up getting a direct alpha2
programmed in the EEPROM instead you would still end up matching the
alpha2 to a group number. The group number leads you to a regulatory
domain that all those countries in that group number adhere to. So it
was a way to group up regulatory domain rules between countries. The
"CN" you see just so happens to be the alpha2 for the first country in
the same group regulatory domain group.

What we can do is to elaborate on that on the dmesg and also maybe
pick the most common country on the group so it will tend to match the
country users are on.

I am seeing if we can deprecate the group stuff on Atheros EEPROM but
that will take some time.

[1] http://wireless.kernel.org/en/users/Drivers/ath

  Luis
