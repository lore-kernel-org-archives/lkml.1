Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbZGIHqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbZGIHqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 03:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZGIHqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 03:46:42 -0400
Received: from mail.marco.de ([217.6.149.82]:54959 "HELO mail.marco.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751429AbZGIHqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 03:46:42 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jul 2009 03:46:41 EDT
Message-ID: <4A559EAB.10706@marco.de>
Date: Thu, 09 Jul 2009 09:39:23 +0200
From: Matthias Pfaller <leo@marco.de>
Organization: marco Systemanalyse und Entwicklung GmbH
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: DMI year "00" + ACPI [was: DMI: fix dmi_get_year year parsing]
References: <1246998990-9594-1-git-send-email-jirislaby@gmail.com> <4A5440BA.6070409@marco.de> <4A5442AD.1080402@gmail.com> <4A5444BD.1090905@marco.de> <4A559851.5030302@gmail.com>
In-Reply-To: <4A559851.5030302@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 07/08/2009 09:03 AM, Matthias Pfaller wrote:
>> Jiri Slaby wrote:
>>> On 07/08/2009 08:46 AM, Matthias Pfaller wrote:
>>>> Jiri Slaby wrote:
>>>>> Don't guess a year number base. Use 10 instead, since year may
>>>>> be 2-digit starting with 0, so that we would end up in base equal
>>>>> to 8.
>>>>>
>>>>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>>>>> Reported-by: Matthias Pfaller <leo@marco.de>
>>>>> ---
>>>>>  drivers/firmware/dmi_scan.c |    2 +-
>>>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>>>
>>>>> diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
>>>>> index 6071078..8fe0f6e 100644
>>>>> --- a/drivers/firmware/dmi_scan.c
>>>>> +++ b/drivers/firmware/dmi_scan.c
>>>>> @@ -611,7 +611,7 @@ int dmi_get_year(int field)
>>>>>          return 0;
>>>>>  
>>>>>      s += 1;
>>>>> -    year = simple_strtoul(s, NULL, 0);
>>>>> +    year = simple_strtoul(s, NULL, 10);
>>>>>      if (year && year < 100) {    /* 2-digit year */
>>>>>          year += 1900;
>>>>>          if (year < 1996)    /* no dates < spec 1.0 */
>>>> I just noticed, that this is not enough, because this will still fail
>>>> for xxx/xx/00. I suggest the following patch:
>>> Actually the patch below is not correct. Standard says consider xx/xx/yy
>>> as 19yy, not 20yy.
>>>
>>> BTW. the patch above is not useful, reporting 1908 and 1909 as a year is
>>> almost the same as 1900.
>> Sorry, I don't understand.
> 
> Nevermind, you're right. Both patches are OK, however we might hit a
> regression with 00/00/00 entries so that acpi gets unintentionally armed
> now for them (ACPI checks year == 0). I don't know if it's worth it. Any
> ideas?

There are bioses with 00/00/00? How about that:

--- dmi_scan.c.orig     Thu Jul  9 03:34:48 2009
+++ dmi_scan.c  Thu Jul  9 03:38:19 2009
@@ -352,17 +352,36 @@
                 return -1;
         if (*s == '\0')
                 return 0;
+
+       /* Month must not be zero */
+       if (simple_strtoul(s, NULL, 10) == 0)
+               return 0;
+
+       /* Look for day of month */
+       s = strchr(s, '/');
+       if (!s)
+               return 0;
+
+       /* Day of month must not be zero */
+       s += 1;
+       if (simple_strtoul(s, NULL, 10) == 0)
+               return 0;
+
+       /* Look for year */
         s = strrchr(s, '/');
         if (!s)
                 return 0;
          s += 1;
-       year = simple_strtoul(s, NULL, 0);
-       if (year && year < 100) {       /* 2-digit year */
-               year += 1900;
-               if (year < 1996)        /* no dates < spec 1.0 */
-                       year += 100;
+       if (s[0] == '0' && s[1] == '0' && s[2] == '\0') {
+               year = 2000;
+       } else {
+               year = simple_strtoul(s, NULL, 10);
+               if (year && year < 100) {       /* 2-digit year */
+                       year += 1900;
+                       if (year < 1996)        /* no dates < spec 1.0 */
+                               year += 100;
+               }
         }
-
         return year;
  }
-- 
Matthias Pfaller                          Software Entwicklung
marco Systemanalyse und Entwicklung GmbH  Tel   +49 8131 5161 41
Hans-Böckler-Str. 2, D 85221 Dachau       Fax   +49 8131 5161 66
http://www.marco.de/                      Email leo@marco.de
Geschäftsführer Martin Reuter             HRB 171775 Amtsgericht München
