Return-Path: <linux-kernel-owner+w=401wt.eu-S1765486AbXJFV2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765486AbXJFV2I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 17:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbXJFV14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 17:27:56 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:33635 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbXJFV1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 17:27:55 -0400
Date: Sat, 6 Oct 2007 23:27:54 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Oleg Verych <olecom@flower.upol.cz>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] Colored kernel output (run3)
In-Reply-To: <20071006212538.GH22435@flower.upol.cz>
Message-ID: <Pine.LNX.4.64.0710062322240.30354@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710062147370.20637@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0710062209530.20637@fbirervta.pbzchgretzou.qr>
 <20071006212538.GH22435@flower.upol.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 6 2007 23:25, Oleg Verych wrote:
>> ---
>>  arch/x86_64/kernel/early_printk.c |   11 +++++++----
>>  drivers/char/Kconfig              |    4 +++-
>>  drivers/char/vt.c                 |   32 ++++++++++++++++++++++++--------
>>  drivers/net/netconsole.c          |    3 ++-
>>  drivers/serial/8250.c             |    3 ++-
>>  drivers/serial/8250_early.c       |    3 ++-
>>  include/linux/console.h           |    2 +-
>>  kernel/printk.c                   |   12 +++++++-----
>>  8 files changed, 48 insertions(+), 22 deletions(-)
>
>Making this amount changes and not thinking about more intelligent
>coding of the functionality?

Well humm.. in an unmodified kernel, the last function that has
knowledge of the loglevel is _call_console_drivers() in kernel/printk.c.
>From there, the call chain is directly -> __call_console_drivers() ->
drivers/char/vt.c:vt_console_print().

_call_console_drivers() skips the <N> substring and passes on the rest of the
message:

                if (msg_level < 0 && ((end - cur_index) > 2) &&
                                LOG_BUF(cur_index + 0) == '<' &&
                                LOG_BUF(cur_index + 1) >= '0' &&
                                LOG_BUF(cur_index + 1) <= '7' &&
                                LOG_BUF(cur_index + 2) == '>') {
                        msg_level = LOG_BUF(cur_index + 1) - '0';
                        cur_index += 3;
                        start_print = cur_index;
                }

>I mean, *write() have nothing to do with loglevels. If they do
>(suddenly), then why not to use a char in the *str to make it possible? I
>might be wrong, but there are already macros before format strings in
>printk().
>
>And this is not `loglevel' thing any more. It's attributes, which can be
>used by many other drivers/file systems/schedulers/ what ever, if
>developers, like Ingo, will extend printk() output to be more nice in
>subsystems they develop.

If I interpret you correctly, you want me to remove cur_index+=3
and instead reparse <N> in drivers/char/vt.c. But that's not good,
because if you use serial, we won't go to vt.c, and in the end,
8250.c would also need to parse <N>, which I think is just walking
around the hill.


kernel/printk.c -> 8250.c -> grab_loglevel_from_string -> ignore it and print
message
kernel/printk.c -> vt.c -> grab_loglevel_from_string -> print color according
to loglevel

VS

kernel/printk.c -> pass loglevel directly to 8250.c -> ignore loglevel and
print message
kernel/printk.c -> pass loglevel directly to vt.c -> print color according to
loglevel
