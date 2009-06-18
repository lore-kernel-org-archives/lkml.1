Return-Path: <linux-kernel-owner+w=401wt.eu-S1760852AbZFRMpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760852AbZFRMpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 08:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbZFRMpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 08:45:41 -0400
Received: from mail-fx0-f212.google.com ([209.85.220.212]:57897 "EHLO
	mail-fx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbZFRMpk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 08:45:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UK4tcN7O+J5eIpe9ygFC5zIDUZ6E+X+a0C8Xcn9aWfwCeacNiHAYSu6LnOw3L2ATfV
         ML8MfZQGZvxFESBt/tk5MD2wsIJYlb2SeAvKBw76B6XllWmyOGqXAjI9O0IiFOiTgijQ
         2G5lX1MVq6gXiXIB79+rHOqnR0pe3i4aHVtEg=
MIME-Version: 1.0
In-Reply-To: <cone.1245325770.489357.31537.1000@arca>
References: <20090604211103.4214303f.peter@piie.net>
	 <200906160747.04094.edt@aei.ca>
	 <20090616205747.GA6356@rhlx01.hs-esslingen.de>
	 <20090617001435.e2d86780.peter@piie.net>
	 <20090617122022.GA13141@rhlx01.hs-esslingen.de>
	 <cone.1245309039.632882.31537.1000@arca>
	 <9ea470500906180329w7c8975b0ra60fa219221d53f6@mail.gmail.com>
	 <cone.1245322548.289821.31537.1000@arca>
	 <9ea470500906180442r7beb49a8odcb3bf602df78b47@mail.gmail.com>
	 <cone.1245325770.489357.31537.1000@arca>
Date: Thu, 18 Jun 2009 14:45:41 +0200
Message-ID: <9ea470500906180545j5e1a78f7qcb887ad843b489f3@mail.gmail.com>
Subject: Re: [PATCH] Request driver inclusion - acer aspire one fan control
From: Borislav Petkov <petkovbb@googlemail.com>
To: Peter Feuerer <peter@piie.net>
Cc: Andreas Mohr <andi@lisas.de>, Ed Tomlinson <edt@aei.ca>,
       akpm@linux-foundation.org, Len Brown <len.brown@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 18, 2009 at 1:49 PM, Peter Feuerer<peter@piie.net> wrote:
>>>>> Actually I think pre_suspend_kernelmode is needed, so it won't be
>>>>> dropped.
>>>>
>>>> and it is needed, because...?
>>>
>>> It's needed because we do now a clean revert to bios mode before we
>>> suspend.
>>> And after resume we have to switch to kernelmode again, if the driver was
>>> in
>>> kernelmode before suspend. So we need to keep track of in what state the
>>> driver was before suspending. That's what's this variable is for.
>>
>> You've got that state in the 'kernelmode' variable. See full comment:
>> http://marc.info/?l=linux-kernel&m=124482114200865
>
> We are talking about patch 0.5.9 and not 0.5.8, are we?
> http://patchwork.kernel.org/patch/30733/mbox/
>
> have a look at at line 543:
> +       /* remember previous setting */
> +       pre_suspend_kernelmode = kernelmode;
> +
> +       if (kernelmode) {
> +               acerhdf_revert_to_bios_mode();
> +               if (acerhdf_thz_dev)
> +                       thermal_zone_device_update(acerhdf_thz_dev);
> +       }

ok, this starts to look quite a bit overengineered for no reason. First,
acerhdf_revert_to_bios_mode() sets the fan to auto. Then, you've added
a thermal_zone_device_update() call in there which does set the fan to
auto indirectly _again_. And we end up with _three_ variables which
represent only _one_ state. Here's what it should do:

suspend:
 - set fan to auto

resume:
 - the thermal layer figures out what to do based on the 'kernelmode' and
 current temperature.

That's it, everything else is too much.

I'll have a deeper look during the weekend.

-- 
Regards/Gruss,
Boris
