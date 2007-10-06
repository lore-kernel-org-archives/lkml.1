Return-Path: <linux-kernel-owner+w=401wt.eu-S1765523AbXJFWO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765523AbXJFWO2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 18:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbXJFWOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 18:14:20 -0400
Received: from barikada.upol.cz ([158.194.242.200]:46079 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbXJFWOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 18:14:19 -0400
Date: Sun, 7 Oct 2007 00:28:25 +0200
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: On text size and run time if config is "n", [PATCH 2/2] Colored kernel output (run3)
Message-ID: <20071006222825.GK22435@flower.upol.cz>
References: <Pine.LNX.4.64.0710062147370.20637@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0710062209530.20637@fbirervta.pbzchgretzou.qr> <20071006212538.GH22435@flower.upol.cz> <Pine.LNX.4.64.0710062322240.30354@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710062322240.30354@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2007 at 11:27:54PM +0200, Jan Engelhardt wrote:
[]
> _call_console_drivers() skips the <N> substring and passes on the rest of the
> message:
> 
>                 if (msg_level < 0 && ((end - cur_index) > 2) &&
>                                 LOG_BUF(cur_index + 0) == '<' &&
>                                 LOG_BUF(cur_index + 1) >= '0' &&
>                                 LOG_BUF(cur_index + 1) <= '7' &&
>                                 LOG_BUF(cur_index + 2) == '>') {
>                         msg_level = LOG_BUF(cur_index + 1) - '0';
>                         cur_index += 3;
>                         start_print = cur_index;
>                 }
> 
> >I mean, *write() have nothing to do with loglevels. If they do
> >(suddenly), then why not to use a char in the *str to make it possible? I
> >might be wrong, but there are already macros before format strings in
> >printk().
> >
> >And this is not `loglevel' thing any more. It's attributes, which can be
> >used by many other drivers/file systems/schedulers/ what ever, if
> >developers, like Ingo, will extend printk() output to be more nice in
> >subsystems they develop.
> 
> If I interpret you correctly, you want me to remove cur_index+=3
> and instead reparse <N> in drivers/char/vt.c. But that's not good,
> because if you use serial, we won't go to vt.c, and in the end,
> 8250.c would also need to parse <N>, which I think is just walking
> around the hill.

I thought, i was talking about *write() functions, that got one
additional unrelated, non config removable API change in face of
`unsigned int loglevel'.

Idea. Extend those macro defines before format string with one
additional macro, that will be empty, if config is NO and having
colour byte otherwise.

In the *write() functions, have

 color = str[0];
 ++str;

in case if config is YES. And nothing otherwise.


Sorry, i don't know much about stuff, you've presented:

> kernel/printk.c -> 8250.c -> grab_loglevel_from_string -> ignore it and print
> message
> kernel/printk.c -> vt.c -> grab_loglevel_from_string -> print color according
> to loglevel

so maybe i just am an ignorant. Anyway this:

> VS
> 
> kernel/printk.c -> pass loglevel directly to 8250.c -> ignore loglevel and
> print message
> kernel/printk.c -> pass loglevel directly to vt.c -> print color according to
> loglevel

have no compile or run time optimization possible.
____
