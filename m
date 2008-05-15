Return-Path: <linux-kernel-owner+w=401wt.eu-S1757610AbYEOTTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610AbYEOTTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754844AbYEOTTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:19:31 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:44963 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbYEOTT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:19:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=FuhYaZwTNd3GnZ2ZJ1ZvjzMeIxIQxTfy79c0SW5/vOqc7+gXUF/OPkm8DM0XWIKsximqk+pl5kWoYM8sjbX93FaR+6h0g9NFcxZPfNlGfOLM9BCh9DhK2iRB4M/azFm93eisnCgDEWjTCD5CHQIHmCaQeEYiPoCzM1yz9oPncjw=
Message-ID: <482C8CBE.2060101@gmail.com>
Date: Thu, 15 May 2008 21:19:26 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Michael Buesch <mb@bu3sch.de>,
       Gordon Farquharson <gordonfarquharson@gmail.com>
Subject: Re: crossbuild fails in modpost
References: <482C3E3E.9090204@gmail.com> <482C6F02.1000205@gmail.com> <20080515173539.GA23959@uranus.ravnborg.org> <20080515174015.GA24024@uranus.ravnborg.org>
In-Reply-To: <20080515174015.GA24024@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg napsal(a):
> On Thu, May 15, 2008 at 07:35:39PM +0200, Sam Ravnborg wrote:
>> On Thu, May 15, 2008 at 07:12:34PM +0200, Jiri Slaby wrote:
>>> Well, let's fix sam's email.
>>>
>>> Jiri Slaby napsal(a):
>>>> Hi,
>>>>
>>>> probably
>>>> 4ce6efed48d736e3384c39ff87bda723e1f8e041
>>>> kbuild: soften modpost checks when doing cross builds
>>>>
>>>> causes build failures on x86_64 kernel build on 32 bit machine:
>>>>
>>>> make -f /local/xslaby/hid/scripts/Makefile.modpost
>>>> YYYYYYYYYYYYYY x86_64 x86_64
>>>>  scripts/mod/modpost -m -a -o /local/xslaby/buhid/Module.symvers    -S 
>>>> -K /local/xslaby/buhid/Module.markers -M 
>>>> /local/xslaby/buhid/Module.markers   -s
>>>> XXXXXXXXXXXXXXXXXX 20: 0 (2), 4 (4), 8 (4), 12 (8)
>>>> FATAL: drivers/hid/hid-apple: sizeof(struct hid_device_id)=20 is not a 
>>>> modulo of the size of section __mod_hid_device_table=648.
>>>> Fix definition of struct hid_device_id in mod_devicetable.h
>>>> make[2]: *** [__modpost] Error 1
>>>> make[1]: *** [modules] Error 2
>>>> make: *** [sub-make] Error 2
>>>>
>>>> after sticking echo into:
>>>> __modpost: $(modules:.ko=.o) FORCE
>>>> +       @echo YYYYYYYYYYYYYY $(KBUILD_BUILDHOST) $(ARCH)
>>>>        $(call cmd,modpost) $(wildcard vmlinux) $(filter-out FORCE,$^)
>>>>
>> Your machine claims it is a x86_64 and you are building for a x86_64
>> according to the following line:
>>>> YYYYYYYYYYYYYY x86_64 x86_64
>> So it looks to me that you are building for 64 bit on a 64 bit machine.
>> So when you write:
>>  on x86_64 kernel build on 32 bit machine:
>>
>> I assume you try to say that your HOSTCC is 32 bit and your
>> kernel cc is 64 bit (or something similar).
>>
>> The commit you reference loosen up the check so we do not do the
>> check if we _know_ that the host and the target system differs.
>> The only thing I can imagine right now to solve your issue would
>> be to skip the check if we do not use the same gcc for target and host?

Well, the compiler is the same, but it's told to compile the kernel with 
-m64. It runs on x86_64 kernel and i386 userspace. It's debian i386 gcc 
package which understands x86_64 objects too. No SUBARCH option, it seems to 
default to x86_64.

> So something like this (entirely untested):
> 
> --- a/scripts/Makefile.modpost
> +++ b/scripts/Makefile.modpost
> @@ -65,7 +65,7 @@ modules   := $(patsubst %.o,%.ko, $(wildcard $(__modules:.ko=.o)))
>  # Stop after building .o files if NOFINAL is set. Makes compile tests quicker
>  _modpost: $(if $(KBUILD_MODPOST_NOFINAL), $(modules:.ko:.o),$(modules))
>  
> -ifneq ($(KBUILD_BUILDHOST),$(ARCH))
> +ifneq ($(CC),$(HOSTCC))

gcc gcc :)

>          cross_build := 1
>  endif
