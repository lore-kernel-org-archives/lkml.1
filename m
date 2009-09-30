Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbZI3Wj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbZI3Wj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 18:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbZI3Wj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 18:39:58 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:57049 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbZI3Wj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 18:39:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=dER8kQiZ99QitPsMggT3ZiCvpS4lDT+RGIwnl9zJZjswnNST0HKQ5UUKwZ2Upt8dVv
         hzmmJmcAi37zV8OPRbongyVHkVOoY7OXXJ7v+Bgro1HriypBDbCZUKiukkKzHoWE/6lm
         QrzK8CignATpC1lKLqO8LLS504NHLpHGxOyro=
Date: Thu, 1 Oct 2009 00:39:56 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
       torvalds@osdl.org
Subject: Re: x86: mce: Please revert
 22223c9b417be5fd0ab2cf9ad17eb7bd1e19f7b9
Message-ID: <20090930223956.GE17712@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	Borislav Petkov <borislav.petkov@amd.com>, torvalds@osdl.org
References: <20090930140904.GA6150@one.firstfloor.org>
 <20090930194049.GA17712@liondog.tnic>
 <20090930204643.GA24862@elte.hu>
 <20090930214859.GA28638@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090930214859.GA28638@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 11:48:59PM +0200, Ingo Molnar wrote:
> I.e. something like the patch below. Completely untested.

[..]

> Note, while looking at the interaction of decode_mce() with the other 
> MCE code i also noticed a few other things and made the following 
> cleanups/fixes:
> 
>  - Fixed the mce_decode() weak alias - a weak alias is really not good
>    here, it should be a proper callback. A weak alias will be overriden
>    if a piece of code is built into the kernel - not good, obviously.

The original idea was for the edac_mce_amd.o module to override the weak
symbol but the problem with that is that when CONFIG_CPU_SUP_AMD is set,
MCE decoding is built in by default thus overriding the weak symbol even
on non-AMD systems running distro kernels with multiple x86 CPU types
support. Your patch solves that.

However, currently we can't get rid of the decoding code when booted on
non-AMD boxes - it amounts to ~ 15K of object code on non-debug builds.
Is it worth the trouble to add it to initmem on such boxes and remove it
during boot?

>  - The patch initializes the callback on AMD family 10h and 11h - a
>    quick glance suggests that decoding of earlier models isnt supported?

Actually, the K8 error types and messages should be decoded just fine
too. I'll doublecheck and adjust the family check accordingly.

[..]

> Note that the callback allows us to have a default fallback - without 
> having to check the CPU versions during the printout itself. When an 
> EDAC module registers itself, it can install the decode-print function.

Cool. It is much cleaner that way.

Thanks, will give it a run tomorrow.

-- 
Regards/Gruss,
    Boris.
