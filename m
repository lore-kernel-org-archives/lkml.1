Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbZFRNjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbZFRNjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 09:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZFRNjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 09:39:24 -0400
Received: from smtprelay04.ispgateway.de ([80.67.18.16]:38116 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063AbZFRNjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 09:39:24 -0400
References: <20090604211103.4214303f.peter@piie.net> <200906160747.04094.edt@aei.ca> <20090616205747.GA6356@rhlx01.hs-esslingen.de> <20090617001435.e2d86780.peter@piie.net> <20090617122022.GA13141@rhlx01.hs-esslingen.de> <cone.1245309039.632882.31537.1000@arca> <9ea470500906180329w7c8975b0ra60fa219221d53f6@mail.gmail.com> <cone.1245322548.289821.31537.1000@arca> <9ea470500906180442r7beb49a8odcb3bf602df78b47@mail.gmail.com> <cone.1245325770.489357.31537.1000@arca> <9ea470500906180545j5e1a78f7qcb887ad843b489f3@mail.gmail.com>
Message-ID: <cone.1245331895.30957.31537.1000@arca>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <pfe@piie.net>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: Andreas Mohr <andi@lisas.de>, Ed Tomlinson <edt@aei.ca>,
       akpm@linux-foundation.org, Len Brown <len.brown@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Request driver inclusion - acer aspire one fan control
Date: Thu, 18 Jun 2009 15:31:35 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Borislav Petkov writes:

> Hi,
> 
> On Thu, Jun 18, 2009 at 1:49 PM, Peter Feuerer<peter@piie.net> wrote:
>>>>>> Actually I think pre_suspend_kernelmode is needed, so it won't be
>>>>>> dropped.
>>>>>
>>>>> and it is needed, because...?
>>>>
>>>> It's needed because we do now a clean revert to bios mode before we
>>>> suspend.
>>>> And after resume we have to switch to kernelmode again, if the driver was
>>>> in
>>>> kernelmode before suspend. So we need to keep track of in what state the
>>>> driver was before suspending. That's what's this variable is for.
>>>
>>> You've got that state in the 'kernelmode' variable. See full comment:
>>> http://marc.info/?l=linux-kernel&m=124482114200865
>>
>> We are talking about patch 0.5.9 and not 0.5.8, are we?
>> http://patchwork.kernel.org/patch/30733/mbox/
>>
>> have a look at at line 543:
>> +       /* remember previous setting */
>> +       pre_suspend_kernelmode = kernelmode;
>> +
>> +       if (kernelmode) {
>> +               acerhdf_revert_to_bios_mode();
>> +               if (acerhdf_thz_dev)
>> +                       thermal_zone_device_update(acerhdf_thz_dev);
>> +       }
> 
> ok, this starts to look quite a bit overengineered for no reason. First,
> acerhdf_revert_to_bios_mode() sets the fan to auto. Then, you've added
> a thermal_zone_device_update() call in there which does set the fan to
> auto indirectly _again_. And we end up with _three_ variables which
> represent only _one_ state. Here's what it should do:

You are partly right, setting the fan to auto in 
"acerhdf_revert_to_bios_mode" can be removed, as this is done by the thermal 
layer when calling "acerhdf_set_cur_state" with disable_kernelmode=1.
But besides that I think it is a clean way. 
This way we _completely_ disable the thermal polling before going suspend 
and ensure the thermal layer doesn't handle the fan anymore. When we resume 
we let the thermal layer take over the fan again. In my opinion this is much 
cleaner than just switching the fan to auto without keeping the polling of 
the thermal layer in mind.
The big problem with the polling is, that you don't know when the next 
thermal polling shot arrives. Is it after acerhdf_suspend was called, or 
after system-resume but before acerhdf_resume was called, or after 
acerhdf_resume was called… You can't know! That's why in my opinion 
completely disabling our kernelmode is the only clean solution.

--peter

P.S. I built the official 2.6.30 release (because current git is freezing 
all the time), patched it with acerhdf 0.5.9 and was testing suspend/resume 
about 40 times now. Was always hitting the suspend button while working ;). 
I wasn't able to reproduce the "unexpected fanstate" issue, <=0.5.8 had.
