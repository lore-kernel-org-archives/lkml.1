Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbZICSN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbZICSN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 14:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756052AbZICSN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 14:13:28 -0400
Received: from mail-iw0-f175.google.com ([209.85.223.175]:45697 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbZICSN1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 14:13:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=YR5H4H3fT0b+QWOACwRiVuIBXznzErZTRIJ+V5qp9BO8itN4ZxCwDJxxSOsaXSLPxb
         QWVLkHbK241ApDGnRroY7cSuvQOMA5906TxuWr9ju6m/IT66rOwgv01rAtMPH5RusC86
         qNh7zrHBUCQ32gih7qoON77kt/Mc6+yn4T1/A=
MIME-Version: 1.0
In-Reply-To: <1251962791.3336.3.camel@johannes.local>
References: <1251958266-10692-1-git-send-email-lrodriguez@atheros.com> 
	<1251962791.3336.3.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 3 Sep 2009 11:13:09 -0700
X-Google-Sender-Auth: f61f1ea9b9db1d1e
Message-ID: <43e72e890909031113r6010519br3b81d15cc331ba85@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: clear cfg80211_inform_bss() from kmemleak 
	reports
To: Johannes Berg <johannes@sipsolutions.net>,
       Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 3, 2009 at 12:26 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Thu, 2009-09-03 at 02:11 -0400, Luis R. Rodriguez wrote:
>> This was giving false positives. We use eventually free this
>> through kref_put(), things are not so obvious through
>> cfg80211_bss_update().
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  net/wireless/scan.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
>> index 19c5a9a..79f7a5d 100644
>> --- a/net/wireless/scan.c
>> +++ b/net/wireless/scan.c
>> @@ -495,6 +495,9 @@ cfg80211_inform_bss(struct wiphy *wiphy,
>>
>>       kref_init(&res->ref);
>>
>> +     /* cfg80211_bss_update() eats up res - we ensure we free it there */
>> +     kmemleak_ignore(res);
>> +
>>       res = cfg80211_bss_update(wiphy_to_dev(wiphy), res, 0);
>>       if (!res)
>>               return NULL;
>
> That's not making sense. cfg80211_bss_update() doesn't actually take a
> reference, it adds a new one for itself and then we return one to the
> caller.

What I meant is it gobbles it up and spits another thing out. When it
gobbles it up the routine then uses kref_put().

> Why can it not track this?

It probably can, just not sure if it follows kref_put(), I was under
the impression here it doesn't and because of it we were getting false
positives. Catalin, can you confirm?

> Actually it looks like we do leak one in net/mac80211/ibss.c.


  Luis
