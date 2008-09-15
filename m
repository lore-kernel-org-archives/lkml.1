Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbYIOP3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbYIOP3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 11:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbYIOP3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 11:29:09 -0400
Received: from host254-130-static.190-82-b.business.telecomitalia.it ([82.190.130.254]:53982
	"EHLO nausicaa2.coritel.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754085AbYIOP3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 11:29:08 -0400
Message-ID: <48CE7FA8.2020409@coritel.it>
Date: Mon, 15 Sep 2008 17:30:48 +0200
From: Marco Stornelli <marco.stornelli@coritel.it>
Organization: CoRiTeL
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Linux AVR32 <kernel@avr32linux.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] avr32: added mem kernel command line option support
References: <48CE33D7.1040203@coritel.it>	<20080915074042.f5059467.randy.dunlap@oracle.com>	<48CE77C6.90307@coritel.it> <20080915080517.5d75721e.randy.dunlap@oracle.com>
In-Reply-To: <20080915080517.5d75721e.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Fixed the type of size and start, now they are resource_size_t.
Fixed the double pointer parameter, now it's only a single pointer.
Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
--- linux-2.6.26.5/arch/avr32/kernel/setup.c.orig    2008-09-15 11:30:00.000000000 +0200

+++ linux-2.6.26.5/arch/avr32/kernel/setup.c 2008-09-15
11:30:17.000000000 +0200
@@ -283,6 +283,25 @@ static int __init early_parse_fbmem(char
}
early_param("fbmem", early_parse_fbmem);

+/*
+ * Pick out the memory size. We look for mem=size@start,
+ * where start and size are "size[KkMmGg]"
+ */
+static int __init early_mem(char *p)
+{
+ resource_size_t size, start;
+
+ start = system_ram->start;
+ size = memparse(p, &p);
+ if (**p == '@')
+ start = memparse(p + 1, &p);
+
+ system_ram->start = start;
+ system_ram->end = system_ram->start + size - 1;
+ return 0;
+}
+early_param("mem", early_mem);
+
static int __init parse_tag_core(struct tag *tag)
{
if (tag->hdr.size > 2) {

Randy Dunlap ha scritto:
> On Mon, 15 Sep 2008 16:57:10 +0200 Marco Stornelli wrote:
>
>   
>> If you see the above function early_parse_fbmem:
>>
>> static int __init early_parse_fbmem(char *p)
>> {
>> int ret;
>> unsigned long align;
>>
>> fbmem_size = memparse(p, &p);
>> .........
>>
>> where fbmem_size is a resource_size_t (u32 because avr32 is a 32-bit
>> architecture), so I used the same philosophy. Maybe I can remove
>> unsigned long and replace it with resource_size_t to be more uniform.
>>     
>
> Yes, I think that would be better.
>
> Thanks.
>
>   
>> Randy Dunlap ha scritto:
>>     
>>> On Mon, 15 Sep 2008 12:07:19 +0200 Marco Stornelli wrote:
>>>
>>>   
>>>       
>>>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>>>
>>>> Added support for the mem kernel command line option
>>>> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
>>>> ---
>>>> --- setup.c.orig    2008-09-15 11:30:00.000000000 +0200
>>>> +++ setup.c    2008-09-15 11:30:17.000000000 +0200
>>>> @@ -283,6 +283,25 @@ static int __init early_parse_fbmem(char
>>>>  }
>>>>  early_param("fbmem", early_parse_fbmem);
>>>>  
>>>> +/*
>>>> + * Pick out the memory size.  We look for mem=size@start,
>>>> + * where start and size are "size[KkMm]"
>>>>     
>>>>         
>>>                                     [KkMmGg]
>>>
>>>   
>>>       
>>>> + */
>>>> +static int __init early_mem(char **p)
>>>> +{
>>>> +    unsigned long size, start;
>>>> +
>>>> +    start = system_ram->start;
>>>> +    size  = memparse(*p, p);
>>>>     
>>>>         
>>> memparse() returns an unsigned long long.  Is the truncation OK for avr32?
>>>
>>>   
>>>       
>>>> +    if (**p == '@')
>>>> +        start = memparse(*p + 1, p);
>>>> +
>>>> +    system_ram->start = start;
>>>> +    system_ram->end = system_ram->start + size - 1;
>>>> +    return 0;
>>>> +}
>>>> +early_param("mem", early_mem);
>>>> +
>>>>  static int __init parse_tag_core(struct tag *tag)
>>>>  {
>>>>      if (tag->hdr.size > 2) {
>>>> --
>>>>         
>
>
> ---
> ~Randy
> Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
> http://linuxplumbersconf.org/
>
>   

-- 
Marco Stornelli
Embedded Software Engineer
CoRiTeL - Consorzio di Ricerca sulle Telecomunicazioni
http://www.coritel.it

marco.stornelli@coritel.it
+39 06 72582838

