Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbZBEPjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbZBEPjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 10:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757960AbZBEPiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 10:38:46 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:44118 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757939AbZBEPio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 10:38:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dWiMPczHMZTxgcMdcGeQOX8zOyRWd22510KYdMurmEDUbt7Pw8N0PaiQnghhZjxM3P
         mmMt/XlwuMSeahiCTV6MVs3YOGTfhbBagFXdZ6OP4O0eaAc44ZKVbHHUCx7oqz5lUOfZ
         yarEyUoOFxffLPLNLCV5aB/tX6K5w+USf1V44=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0902050908400.7489@cnc.isely.net>
References: <56e1b5710902050641l5ece10e5hedd11fb3f4292886@mail.gmail.com>
	 <Pine.LNX.4.64.0902050908400.7489@cnc.isely.net>
Date: Thu, 5 Feb 2009 16:38:41 +0100
Message-ID: <56e1b5710902050738n33616bdfuf9ca0b157d8d260f@mail.gmail.com>
Subject: Re: [PATCH]: Cleanup: Remove gcc format string warnings when 
	compiling with -Wformat-security (was: Re: [PATCH] Kbuild: Disable the 
	-Wformat-security gcc flag)
From: Floris Kraak <randakar@gmail.com>
To: Mike Isely <isely@pobox.com>
Cc: Roland Dreier <rdreier@cisco.com>, Robert Hancock <hancockrwd@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andreas Schwab <schwab@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 4:22 PM, Mike Isely <isely@isely.net> wrote:
>> ---
>> Cleanup: Remove gcc format string warnings when compiling with -Wformat-security
>>
>> When compiling the kernel with an allyesconfig and the gcc flags
>> -Wformat and -Wformat-security the build process emits 135 warnings
>> along these lines:
>>
>> init/main.c:557: warning: format not a string literal and no format arguments
>> init/initramfs.c:582: warning: format not a string literal and no
>> format arguments
>> arch/x86/kernel/dumpstack.c:115: warning: format not a string literal
>> and no format arguments
>> ...
>>
>> While many of these warnings are harmless - the format string is
>> statically set within the kernel itself and is known to not contain
>> any format qualifiers - a number of them are potentially less so.
>> This patch fixes all known call sites emitting this warning.
>>
>
>   [...]
>
>> diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
>> b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
>> index fa304e5..42ccab0 100644
>> --- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
>> +++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
>> @@ -1967,7 +1967,7 @@ static void pvr2_hdw_setup_low(struct pvr2_hdw *hdw)
>>       if (!pvr2_hdw_dev_ok(hdw)) return;
>>
>>       for (idx = 0; idx < hdw->hdw_desc->client_modules.cnt; idx++) {
>> -             request_module(hdw->hdw_desc->client_modules.lst[idx]);
>> +             request_module("%s", hdw->hdw_desc->client_modules.lst[idx]);
>>       }
>
> The incoming string in this case comes from a static initialization in
> the same source file (it's a compiled-in list of support module names to
> select based on the specific hardware type that the driver has
> detected).

I'm not surprised ;-)

>
> In both of these cases, the proposed change doesn't do any harm, but it
> does introduce some otherwise pointless inefficiency.
>

I'd *love* to be able to just tell the compiler "hey gcc! we know all
callers are using compiled in static strings here so ignore this one
ok?"
Or even better, for GCC to just detect it itself somehow. Heck, isn't
this the kind of thing that sparse exists for?

One way to solve this without (hopefully) introducing pointless
inefficiency might be to just have printk_noformat() and variants and
make all places that emit this warning call the *_noformat()
alternatives.
But I'm not sure that wouldn't just be introducing pointless
inefficiency to get rid of pointless inefficiency ;-)

> But hey, if this is all with the goal of silencing another script
> casting a big net, I won't stand in the way.

Ubuntu has the gcc flags that cause the build to emit these warnings
enabled by default. Probably some other (security conscious) distro's
enable this as well.
I've posted a patch that enables those flags kernel wide (not sure if
it arrived, nobody replied ;-) ) so that new patches are more likely
to not contain this type of thing.

>
> Acked-By: Mike Isely <isely@pobox.com>
>

Thanks for the ack ;-)

Regards,
Floris
---
"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."
  -- Ben Franklin

"The course of history shows that as a government grows, liberty
decreases."
  -- Thomas Jefferson
