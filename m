Return-Path: <linux-kernel-owner+w=401wt.eu-S1759772AbZGIHMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759772AbZGIHMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 03:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759444AbZGIHM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 03:12:27 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:55325 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398AbZGIHMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 03:12:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=JMsy6BtlnvvJDDbOdUKx9UalBXtumtLH+Jufo3erdtsZm/JY+JHW0qQMqL9EwvRtPN
         UeuvUp/YCjjcI0VIBCBKXi9xcLY90fRrEWcC3COVvZbnQXnzehPpmovQLWZKDkOAW4S7
         MRBO7+V/bZbyp5320g3db4xeBi6WViZGbEfTQ=
Message-ID: <4A559851.5030302@gmail.com>
Date: Thu, 09 Jul 2009 09:12:17 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Matthias Pfaller <leo@marco.de>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: DMI year "00" + ACPI [was: DMI: fix dmi_get_year year parsing]
References: <1246998990-9594-1-git-send-email-jirislaby@gmail.com> <4A5440BA.6070409@marco.de> <4A5442AD.1080402@gmail.com> <4A5444BD.1090905@marco.de>
In-Reply-To: <4A5444BD.1090905@marco.de>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2009 09:03 AM, Matthias Pfaller wrote:
> Jiri Slaby wrote:
>> On 07/08/2009 08:46 AM, Matthias Pfaller wrote:
>>> Jiri Slaby wrote:
>>>> Don't guess a year number base. Use 10 instead, since year may
>>>> be 2-digit starting with 0, so that we would end up in base equal
>>>> to 8.
>>>>
>>>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>>>> Reported-by: Matthias Pfaller <leo@marco.de>
>>>> ---
>>>>  drivers/firmware/dmi_scan.c |    2 +-
>>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
>>>> index 6071078..8fe0f6e 100644
>>>> --- a/drivers/firmware/dmi_scan.c
>>>> +++ b/drivers/firmware/dmi_scan.c
>>>> @@ -611,7 +611,7 @@ int dmi_get_year(int field)
>>>>          return 0;
>>>>  
>>>>      s += 1;
>>>> -    year = simple_strtoul(s, NULL, 0);
>>>> +    year = simple_strtoul(s, NULL, 10);
>>>>      if (year && year < 100) {    /* 2-digit year */
>>>>          year += 1900;
>>>>          if (year < 1996)    /* no dates < spec 1.0 */
>>> I just noticed, that this is not enough, because this will still fail
>>> for xxx/xx/00. I suggest the following patch:
>>
>> Actually the patch below is not correct. Standard says consider xx/xx/yy
>> as 19yy, not 20yy.
>>
>> BTW. the patch above is not useful, reporting 1908 and 1909 as a year is
>> almost the same as 1900.
> 
> Sorry, I don't understand.

Nevermind, you're right. Both patches are OK, however we might hit a
regression with 00/00/00 entries so that acpi gets unintentionally armed
now for them (ACPI checks year == 0). I don't know if it's worth it. Any
ideas?

>>> --- drivers/firmware/dmi_scan.c.bak     Wed Jul  8 02:42:04 2009
>>> +++ drivers/firmware/dmi_scan.c Wed Jul  8 02:42:17 2009
>>> @@ -360,12 +360,15 @@
>>>                 return 0;
>>>
>>>         s += 1;
>>> -       year = simple_strtoul(s, NULL, 0);
>>> -       if (year && year < 100) {       /* 2-digit year */
>>> -               year += 1900;
>>> -               if (year < 1996)        /* no dates < spec 1.0 */
>>> -                       year += 100;
>>> +       if (s[0] == '0' && s[1] == '0' && s[2] == '\0') {
>>> +               year = 2000;
>>> +       } else {
>>> +               year = simple_strtoul(s, NULL, 10);
>>> +               if (year && year < 100) {       /* 2-digit year */
>>> +                       year += 1900;
>>> +                       if (year < 1996)        /* no dates < spec
>>> 1.0 */
>>> +                               year += 100;
>>> +               }
>>>         }
>>> -
>>>         return year;
>>>  }

