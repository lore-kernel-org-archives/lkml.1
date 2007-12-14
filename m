Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbXLNOq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbXLNOq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 09:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbXLNOqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 09:46:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52124 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295AbXLNOqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 09:46:49 -0500
Date: Fri, 14 Dec 2007 15:46:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@gmail.com>
Cc: "David P. Reed" <dpreed@reed.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
	on some AMD64x2 laptops, etc.
Message-ID: <20071214144628.GA16074@elte.hu>
References: <1184216528.12353.203.camel@chaos> <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com> <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <476250D5.8000409@gmail.com> <20071214142355.GA10130@elte.hu> <476294D3.4060609@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476294D3.4060609@keyaccess.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rene Herman <rene.herman@gmail.com> wrote:

>>>  /*
>>> - * This should be approx 2 Bo*oMips to start (note initial shift), and will
>>> - * still work even if initially too large, it will just take slightly longer
>>> + * Initial value roughly corresponds to a 1 GHz CPU
>>>   */
>>> -unsigned long loops_per_jiffy = (1<<12);
>>> +unsigned long loops_per_jiffy = 1000000000 / HZ;
>>>
>>>  EXPORT_SYMBOL(loops_per_jiffy);
>>
>> this is a factor of ~2400 increase - this will take an eternity to boot on 
>> any older CPU.
>
> Only any outb_p's used before loops_per_jiffy is calibrated are 
> affected.

yes - but there are a couple of early udelays, which would thus be 
affected.

> This pre-calibation thing is what's historically held this change back 
> (it's been discussed dozens of times before). At 4096, not any machine 
> is going to have an appreciable delay before calibration when 
> switching from the outb to 0x80.

i dont think this should matter: old systems that truly _need_ the ISA 
delay will be slow enough to not trip up. (nor are they really affected 
by these early delays - the delays were more for crappy ISA devices that 
get initialized later down, when the delay loop is already calibrated)

modern systems learned to depend on the PCI write posting side-effects 
of port 0x80 activities - those wont be helped by this initialization 
change either. That is a far more serious concern.

	Ingo
