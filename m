Return-Path: <linux-kernel-owner+w=401wt.eu-S1758421AbZGHHDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421AbZGHHDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 03:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbZGHHDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 03:03:45 -0400
Received: from k.marco.de ([217.6.149.82]:48294 "HELO mail.marco.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753010AbZGHHDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 03:03:44 -0400
Message-ID: <4A5444BD.1090905@marco.de>
Date: Wed, 08 Jul 2009 09:03:25 +0200
From: Matthias Pfaller <leo@marco.de>
Organization: marco Systemanalyse und Entwicklung GmbH
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/1] DMI: fix dmi_get_year year parsing
References: <1246998990-9594-1-git-send-email-jirislaby@gmail.com> <4A5440BA.6070409@marco.de> <4A5442AD.1080402@gmail.com>
In-Reply-To: <4A5442AD.1080402@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 07/08/2009 08:46 AM, Matthias Pfaller wrote:
>> Jiri Slaby wrote:
>>> Don't guess a year number base. Use 10 instead, since year may
>>> be 2-digit starting with 0, so that we would end up in base equal
>>> to 8.
>>>
>>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>>> Reported-by: Matthias Pfaller <leo@marco.de>
>>> ---
>>>  drivers/firmware/dmi_scan.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
>>> index 6071078..8fe0f6e 100644
>>> --- a/drivers/firmware/dmi_scan.c
>>> +++ b/drivers/firmware/dmi_scan.c
>>> @@ -611,7 +611,7 @@ int dmi_get_year(int field)
>>>          return 0;
>>>  
>>>      s += 1;
>>> -    year = simple_strtoul(s, NULL, 0);
>>> +    year = simple_strtoul(s, NULL, 10);
>>>      if (year && year < 100) {    /* 2-digit year */
>>>          year += 1900;
>>>          if (year < 1996)    /* no dates < spec 1.0 */
>> I just noticed, that this is not enough, because this will still fail
>> for xxx/xx/00. I suggest the following patch:
> 
> Actually the patch below is not correct. Standard says consider xx/xx/yy
> as 19yy, not 20yy.
> 
> BTW. the patch above is not useful, reporting 1908 and 1909 as a year is
> almost the same as 1900.

Sorry, I don't understand. simple_strtoul will return 8 for my bios. So
1900 will get added resulting in 1908 (as you said). But because 1908 is 
still less than 1996 now 100 will get added which results in 2008 which 
is what I need.

> Do you have such a broken BIOS?

Yes. Its on an etx-cd, an embedded board from kontron. dmidecode output:

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
         Vendor: Phoenix Technologies LTD
         Version: MCALR116
         Release Date: 08/13/08
         Address: 0xE3F90
         Runtime Size: 114800 bytes
         ROM Size: 1024 kB
         Characteristics:
                 ISA is supported
                 PCI is supported
                 PC Card (PCMCIA) is supported
                 PNP is supported
                 BIOS is upgradeable
                 BIOS shadowing is allowed
                 ESCD support is available
                 Boot from CD is supported
                 ACPI is supported
                 USB legacy is supported
                 BIOS boot specification is supported

Our systems started to fail after we got boards with a newer bios from 
our supplier...

> 
>> --- drivers/firmware/dmi_scan.c.bak     Wed Jul  8 02:42:04 2009
>> +++ drivers/firmware/dmi_scan.c Wed Jul  8 02:42:17 2009
>> @@ -360,12 +360,15 @@
>>                 return 0;
>>
>>         s += 1;
>> -       year = simple_strtoul(s, NULL, 0);
>> -       if (year && year < 100) {       /* 2-digit year */
>> -               year += 1900;
>> -               if (year < 1996)        /* no dates < spec 1.0 */
>> -                       year += 100;
>> +       if (s[0] == '0' && s[1] == '0' && s[2] == '\0') {
>> +               year = 2000;
>> +       } else {
>> +               year = simple_strtoul(s, NULL, 10);
>> +               if (year && year < 100) {       /* 2-digit year */
>> +                       year += 1900;
>> +                       if (year < 1996)        /* no dates < spec 1.0 */
>> +                               year += 100;
>> +               }
>>         }
>> -
>>         return year;
>>  }
>>
> 


-- 
Matthias Pfaller                          Software Entwicklung
marco Systemanalyse und Entwicklung GmbH  Tel   +49 8131 5161 41
Hans-Böckler-Str. 2, D 85221 Dachau       Fax   +49 8131 5161 66
http://www.marco.de/                      Email leo@marco.de
Geschäftsführer Martin Reuter             HRB 171775 Amtsgericht München
