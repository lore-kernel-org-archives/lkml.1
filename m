Return-Path: <linux-kernel-owner+w=401wt.eu-S934872AbZDHRIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934872AbZDHRIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934728AbZDHRG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:06:58 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64866 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934404AbZDHRGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:06:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=TAnUCMcgqvsE0lzzekEDbrFVBkMT8+nNJmoZpKjaYdhxLmqBWoiYEiKd8qY2VaN6v2
         YOzNXMUmH02MAGeOC7Q8XukRvQfkYgnUCX8PbWDjkMHbNkJ8TtmRpLnBr1isx0zN7I1O
         pGLM505vN5AogiAtlevIs7lfrvp4QysEJkAXc=
MIME-Version: 1.0
Reply-To: alan-jenkins@tuffmail.co.uk
In-Reply-To: <49DCB976.4020200@lwfinger.net>
References: <49DC2DF5.3010603@lwfinger.net> <49DC31EA.8050208@linux.intel.com>
	 <200904081631.09150.rusty@rustcorp.com.au>
	 <49DCB976.4020200@lwfinger.net>
Date: Wed, 8 Apr 2009 18:06:18 +0100
Message-ID: <9b2b86520904081006m6e6b5276v834c3565b0f6f4c7@mail.gmail.com>
Subject: Re: Regression in 2.6.30-rc1 since commit acae0515 - wireless broken
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/8/09, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Rusty Russell wrote:
>> On Wednesday 08 April 2009 14:41:06 Arjan van de Ven wrote:
>>> Larry Finger wrote:
>>>> The most recent pulls of the Linux-2.6 git tree has broken wireless. The
>>>> problem
>>>> was bisected with commit acae05156551fd7528fbb616271e672789388e3c,
>>>> entitled
>>>> "module: create a request_module_nowait()", indicated as the faulty
>>>> change. This
>>>> is seen with driver b43 on my system, and 2 reports for driver iwlagn:
>>>> http://marc.info/?l=linux-wireless&m=123916157630571&w=2 and
>>>> http://marc.info/?l=linux-wireless&m=123913015021457&w=2.
>>>>
>>>> For b43, the logged error messages are:
>>> rusty... I still suspect your "int to bool" conversion stuff ;-)
>>
>> One way to find out.  Here's the reversion:
>>
>> diff --git a/include/linux/kmod.h b/include/linux/kmod.h
>> --- a/include/linux/kmod.h
>> +++ b/include/linux/kmod.h
>> @@ -29,12 +29,10 @@
>>  #ifdef CONFIG_MODULES
>>  /* modprobe exit status on success, -ve on error.  Return value
>>   * usually useless though. */
>> -extern int __request_module(bool wait, const char *name, ...) \
>
> The patch did not fix the problem. The symptoms are the same.
>
> Larry

Hi, I can confirm this bug on ath5k.

Something is very wrong with request_module(), this is just the most
obvious symptom.  It also seems to affect libusual (loading
usb-storage) and FAT (loading NLS modules).

If I hotplug my wireless device, it then loads correctly.  So I'm
guessing wireless modules e.g. encryption modules get loaded too
asynchronously.   I.e. on boot, the  sub-modules are loaded too late.
But when I hotplug the device, the modules are already loaded.

Same with FAT - it fails on first attempt to mount because of missing
NLS module, then works on second mount,

I agree that commit looks like it should be a no-op though :-).
I will try to confirm the OP's bisection by reverting the commit, acae0515.

Alan
