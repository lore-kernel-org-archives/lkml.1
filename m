Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbZKHSXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbZKHSXF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 13:23:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbZKHSXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 13:23:04 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:45897 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbZKHSXD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 13:23:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=RIHAnCv7h99ndTAoFwP7EQLEYw2fhJMFP+n2A+6YnHNKDV7pQjqZYgKQmJQdesX8Xl
         mV56S6cdujfrbjlJqEPWu2aaDnjeTOkCVkRXx5Pi8h9d68meUb28ePkVKOiqZp98cSXV
         15Fit0fNLH20EjDSHmM55x82YYvj3cf0cLzlA=
MIME-Version: 1.0
In-Reply-To: <20091108110512.3cfad100@mycelium.queued.net>
References: <20091106154911.29400@gmx.net> <20091106155937.11d95279@lxorguk.ukuu.org.uk> 
	<20091106165731.26800@gmx.net> <20091106182218.43940287@lxorguk.ukuu.org.uk> 
	<20091106200620.179910@gmx.net> <m3r5sbcl07.fsf@intrepid.localdomain> 
	<20091107000559.166710@gmx.net> <40101cc30911070311u56035911l5eb50ac4abb73acc@mail.gmail.com> 
	<20091108110512.3cfad100@mycelium.queued.net>
From: Matteo Croce <technoboy85@gmail.com>
Date: Sun, 8 Nov 2009 19:22:47 +0100
Message-ID: <40101cc30911081022h33ac20d7od591a9bcdb739f04@mail.gmail.com>
Subject: Re: i686 quirk for AMD Geode
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 8, 2009 at 5:05 PM, Andres Salomon <dilinger@collabora.co.uk> wrote:
> See comment below.  BTW, how does this affect performance on LXs?
> Do you have any hard numbers for common tasks?
>
> On Sat, 7 Nov 2009 12:11:55 +0100
> Matteo Croce <technoboy85@gmail.com> wrote:
> [...]
>>
>> --- a/arch/x86/kernel/Makefile        2009-11-06 15:06:52.246223989
>> +0100 +++ b/arch/x86/kernel/Makefile  2009-11-06
>> 15:07:04.294054613 +0100 @@ -89,7 +89,7 @@
>>  obj-$(CONFIG_HPET_TIMER)     += hpet.o
>>
>>  obj-$(CONFIG_K8_NB)          += k8.o
>> -obj-$(CONFIG_MGEODE_LX)              += geode_32.o mfgpt_32.o
>> +obj-$(CONFIG_MGEODE_LX)              += geode_32.o mfgpt_32.o
>> nopl_emu.o obj-$(CONFIG_DEBUG_RODATA_TEST)    += test_rodata.o
>>  obj-$(CONFIG_DEBUG_NX_TEST)  += test_nx.o
>>
>> --- a/arch/x86/kernel/cpu/amd.c       2009-11-06 15:06:52.254223805
>> +0100 +++ b/arch/x86/kernel/cpu/amd.c 2009-11-06
>> 15:07:04.294054613 +0100 @@ -138,8 +138,10 @@
>>       }
>>
>>       if (c->x86_model == 10) {
>> -             /* AMD Geode LX is model 10 */
>> -             /* placeholder for any needed mods */
>> +             /* Geode only lacks the NOPL instruction to be i686,
>> +                but we can emulate it in the exception handler
>> +                and promote it to a class 6 cpu */
>> +             boot_cpu_data.x86 = 6;
>>               return;
>>       }
>
> If you're going to update this, you also need to make sure that you're
> not breaking things that check it.  For example,
> arch/x86/include/asm/geode.h has an is_geode_lx check that expects
> boot_cpu_data.x86 to be 5.  Please be sure to update all these places
> when creating a patch like this.
>

Right, but what if is_geode_lx() is called befor the x86.id change takes effect?
Maybe something like this?

--- a/arch/x86/include/asm/geode.h 2009-11-08 19:13:43.531117343 +0100
+++ b/arch/x86/include/asm/geode.h      2009-11-08 19:19:42.130618023 +0100
@@ -177,7 +177,7 @@
 static inline int is_geode_lx(void)
 {
        return ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) &&
-               (boot_cpu_data.x86 == 5) &&
+               (boot_cpu_data.x86 == 5 || boot_cpu_data.x86 == 6) &&
                (boot_cpu_data.x86_model == 10));
 }
