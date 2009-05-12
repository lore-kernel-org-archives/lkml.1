Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbZELGCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbZELGCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 02:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZELGCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 02:02:36 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:42308 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbZELGCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 02:02:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=J1KTIhCXoEa5t44wyR50rtiXCaTDOnihMCydx53ZgfDX4oCKd8YIwoN4YVICHOsdNE
         bYL1/kjyfpQzAI/vXv+sLSQxLWlIRI+nLcH9MK/yfeeo5gMrIjwOCbPmvE7XoffAlhFq
         nMmeWmFEdIUpE+qKZORzU/i1GpCJhbdNiWhgc=
Date: Tue, 12 May 2009 08:02:31 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] Acer Aspire One Fan Control
Message-ID: <20090512060231.GB26286@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	Peter Feuerer <peter@piie.net>, LKML <linux-kernel@vger.kernel.org>,
	lenb@kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>
References: <cone.1240858632.795110.5316.1000@onepiie> <20090428072519.GA12170@liondog.tnic> <1240913055.29860.14.camel@maxim-laptop> <cone.1240949852.549814.7466.1000@mentalhome> <1240950704.3781.12.camel@maxim-laptop> <cone.1241299309.265715.3948.1000@mentalhome> <20090503184617.GA3555@liondog.tnic> <cone.1241648222.299676.7476.1000@mentalhome> <20090509171432.GA31126@liondog.tnic> <cone.1242065107.695268.13534.1000@onepiie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cone.1242065107.695268.13534.1000@onepiie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 11, 2009 at 08:05:07PM +0200, Peter Feuerer wrote:
> Hello,
>
> Borislav Petkov writes:
>>
>> the more I'm looking at the driver, the more I get annoyed by that
>> user/kernel mode operation split. Remind me again why the driver should
>> be loaded and not started automatically but the user should be required
>> to activate it explicitly?
>
> The idea of not starting the module in kernel mode was from Matthew. And 
> he stated that it could harm the hardware when software controls the fan  
> instead of the BIOS. It may also be possible, that the warranty gets 
> invalid when you do that. Not sure about how acer would handle a defect 
> which could be caused by overheating and when they detect that software 
> was controlling the fan. That's why I think Matthew is right. 

We actually don't have any reliable source for the temperature envelope
of the surrounding hardware, right? Quick search didn't reveal anything
here. I only came across a bunch of freeware tools which do fan control
of the aspire ones but all the temperature trip points for the fan in
those were ranging from 50 - 63° which leads to think that those all are
kinda "common sense"-settings the authors came up with without any hard
data from the manufacturer.

For example, mine has a Seagate Momentum ATA-8 ST9160310AS hdd and its
spec[¹] says:

"2.10.1       Ambient temperature

Ambient temperature is defined as the temperature of the environment
immediately surrounding the drive. Actual drive case temperature should
not exceed 65°C (149°F) within the operating ambient conditions."

>From what I could measure here empirically, the fan starts in low RPM
mode at around 37°C and and gets cranked up to max when the temp
reaches ~55°C. This envelope in the BIOS code is taking surrounding
devices into consideration, I guess and am wondering whether the 67°C
setting in your driver is still within safe limits, hmmm?

[..]

>> What is more, if the userspace program would fail, there's no way
>> for the module to get activated again and jump in instead of the
>> userspace program to the rescue. Which goes more to show that you
>> don't need userspace control _at_ _all_ and the only two agents
>> controlling the fan should be the BIOS or the kernel module.
>
> After reading and thinking about all this a while, I agree with you.
> In the next patch I won't allow the user to switch on/off the fan
> anymore.

Cool.

>> So I think that the kernel module should take over fan control
>> upon load. This way you'll be able to get rid of all that needless
>> complexity around kernelmode/disable_kernelmode and have a simple
>> clean design.
>
> I would really like to do that, but what do you think about the
>hardware damage / warranty things written above?

It seems that the BIOS setting is lower/safer so, yes, you're right, we
don't want to void any warranties, so the BIOS control _should_ actually
be the default since we are not at all sure whether moving the envelope
up the temperature scale won't hurt the hardware.

/me would love to see some reliable info on that from the manufacturer...

[..]

Thanks for your work.


¹http://www.seagate.com/staticfiles/support/disc/manuals/notebook/momentus/5400.4/SATA/100468842a.pdf

-- 
Regards/Gruss,
    Boris.
