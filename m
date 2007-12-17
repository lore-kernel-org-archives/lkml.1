Return-Path: <linux-kernel-owner+w=401wt.eu-S1760347AbXLQOjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760347AbXLQOjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 09:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbXLQOjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 09:39:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48193 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbXLQOjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 09:39:31 -0500
Date: Mon, 17 Dec 2007 15:39:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "David P. Reed" <dpreed@reed.com>
Cc: Rene Herman <rene.herman@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Paul Rolland <rol@as2917.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20071217143900.GA16604@elte.hu>
References: <476462BE.3030701@gmail.com> <4764687D.6080609@zytor.com> <476524DB.7020806@gmail.com> <20071216152250.GA21245@elte.hu> <4765D43E.1010800@gmail.com> <20071217105744.GA14315@elte.hu> <4766684D.40202@gmail.com> <20071217130933.GB27992@elte.hu> <47667812.8050708@gmail.com> <47667A85.3080100@reed.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47667A85.3080100@reed.com>
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


* David P. Reed <dpreed@reed.com> wrote:

> Rene Herman wrote:
>> No, most definitely not. Having the user select udelay or none through the 
>> kernel config and then the kernel deciding "ah, you know what, I'll know 
>> better and use port access anyway" is _utterly_ broken behaviour. Software 
>> needs to listen to its master.
>
> When acting as an ordinary user, the .config is beyond my control 
> (except on Gentoo).  It is in control of the distro (Fedora, Ubuntu, 
> ... but perhaps not Gentoo).  I think the distro guys want a default 
> behavior that is set in .config, with quirk overrides being done when 
> needed.  And of course the user in his/her boot params gets the final 
> say.

yeah, that's exactly the thinking. Distros basically set general policy, 
but a quirk is (almost) always specific and correct enough to override 
that. We could perhaps refine this by directing the quirk to only be 
applied if the current type is 0x80 - because in that case we know that 
it's definitely not going to work. I.e. something like the small patch 
below?

	Ingo

---
 arch/x86/kernel/io_delay.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-x86.q/arch/x86/kernel/io_delay.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/io_delay.c
+++ linux-x86.q/arch/x86/kernel/io_delay.c
@@ -47,8 +47,11 @@ EXPORT_SYMBOL(native_io_delay);
 
 static int __init dmi_io_delay_0xed_port(const struct dmi_system_id *id)
 {
-	printk(KERN_NOTICE "%s: using 0xed I/O delay port\n", id->ident);
-	io_delay_type = CONFIG_IO_DELAY_TYPE_0XED;
+	if (io_delay_type == CONFIG_IO_DELAY_TYPE_0X80) {
+		printk(KERN_NOTICE "%s: using 0xed I/O delay port\n",
+			id->ident);
+		io_delay_type = CONFIG_IO_DELAY_TYPE_0XED;
+	}
 
 	return 0;
 }
