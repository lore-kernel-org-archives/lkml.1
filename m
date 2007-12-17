Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbXLQNKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbXLQNKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754279AbXLQNKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:10:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52210 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466AbXLQNKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:10:01 -0500
Date: Mon, 17 Dec 2007 14:09:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Paul Rolland <rol@as2917.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20071217130933.GB27992@elte.hu>
References: <20071215080831.404cdb32@tux.DEF.witbe.net> <47638C8C.2090604@gmail.com> <476438B4.2020600@zytor.com> <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com> <476524DB.7020806@gmail.com> <20071216152250.GA21245@elte.hu> <4765D43E.1010800@gmail.com> <20071217105744.GA14315@elte.hu> <4766684D.40202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4766684D.40202@gmail.com>
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

> On 17-12-07 11:57, Ingo Molnar wrote:
>
>> thanks Rene! I've added your patch to x86.git. I changed a few things 
>> ontop of it, see the additional changelog and delta patch below.
>
> "appropriated it", more. [...]

huh?

> [...] Definitely not going to forgive you for deleting that comment.

Do you mean:

+/*
+ * High on a hill was a lonely goatherd
+ */

?

>>  void native_io_delay(void)
>>  {
>> -	io_delay();
>> +	switch (io_delay_type) {
>
> That's the clumsy bit. native_io_delay() used to be an inline outb, 
> now it's a switch. Yes, sure, versus an indirect call it's not 
> actually worse, except as an uglification.

the switch enableds the sysctl. I dont see the callback as in any way 
cleaner. (in fact it made things more inflexible.)

>> -#ifndef CONFIG_UDELAY_IO_DELAY
>> -static int __init dmi_alternate_io_delay_port(const struct dmi_system_id *id)
>> +static int __init dmi_io_delay_0xed_port(const struct dmi_system_id *id)
>>  {
>> -	printk(KERN_NOTICE "%s: using alternate I/O delay port\n", id->ident);
>> -	io_delay = alternate_io_delay;
>> +	printk(KERN_NOTICE "%s: using 0xed I/O delay port\n", id->ident);
>> +	io_delay_type = CONFIG_IO_DELAY_TYPE_0XED;
>> +
>>  	return 0;
>>  }
>
> This isn't correct. DMI shouldn't override the CONFIG choice or 
> someone with matching DMI will have a defective CONFIG option. That's 
> why I put all of it inside #ifndef.

no, the DMI quirk is just that: a quirk that makes boxes work. The DMI 
quirk takes precedence over just about any .config default, except an 
explicit boot-commandline override.

	Ingo
