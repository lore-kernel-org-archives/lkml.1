Return-Path: <linux-kernel-owner+w=401wt.eu-S1751890AbYI3GfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbYI3GfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 02:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYI3Gex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 02:34:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:16054 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbYI3Gew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 02:34:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=cfjUcP18qT3Itz2CyjMhfzbjtI9p6N/bCQc9Dskeg0kJYfCDf0edieIkURaEDh0krN
         MRFuG3Kfi6GSOjBakYhu9mRMWuyyTUtQQ+fkwd0jfXdpd7VM+pnpCxE+mFcv+zwxf/aG
         al9s6LnT/QI2FFKbAnc8ODAlTtc+yDFp9Nlns=
Message-ID: <86802c440809292334o557d2158ob2c52aebd3caf0b3@mail.gmail.com>
Date: Mon, 29 Sep 2008 23:34:51 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] x86: do not allow to optimize flag_is_changeable_p()
Cc: "Krzysztof Helt" <krzysztof.h1@poczta.fm>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <48E1C3BD.5020705@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080929200603.dcdc5b71.krzysztof.h1@poczta.fm>
	 <48E1C3BD.5020705@goop.org>
X-Google-Sender-Auth: 16af2fe14e29c363
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 11:14 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Krzysztof Helt wrote:
>> From: Krzysztof Helt <krzysztof.h1@wp.pl>
>>
>> The flag_is_changeable_p() is used by
>> has_cpuid_p() which can return different results
>> in the code sequence below:
>>
>>  if (!have_cpuid_p())
>>       identify_cpu_without_cpuid(c);
>>
>>   /* cyrix could have cpuid enabled via c_identify()*/
>>   if (!have_cpuid_p())
>>       return;
>>
>> Otherwise, the gcc 3.4.6 optimizes these two calls
>> into one which make the code not working correctly.
>> Cyrix cpus have the CPUID instruction enabled but
>> it is not detected due to the gcc optimization.
>> Thus the ARR registers (mtrr like) are not detected
>> on such a cpu.
>>
>
> If "asm volatile" changes the code and fixes the bug, it seems like
> you're making use of an undocumented - or at least non-portable - behaviour.
>
> Does adding a "memory" clobber also fix the problem?  That would have
> better defined characteristics.
>

how about

        if (!have_cpuid_p()) {
                identify_cpu_without_cpuid(c);

                /* cyrix could have cpuid enabled via c_identify()*/
                if (!have_cpuid_p())
                        return;
        }


YH
