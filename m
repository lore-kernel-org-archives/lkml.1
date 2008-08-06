Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbYHFVqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbYHFVqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbYHFVqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:46:39 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:58873 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbYHFVqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:46:38 -0400
Date: Wed, 6 Aug 2008 14:46:35 -0700
From: Ira Snyder <iws@ovro.caltech.edu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Simple UART driver help and TTY questions
Message-ID: <20080806214635.GM6257@ovro.caltech.edu>
References: <20080805163307.GJ6257@ovro.caltech.edu> <489A1364.4020809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489A1364.4020809@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (ovro.ovro.caltech.edu [192.100.16.2]); Wed, 06 Aug 2008 14:46:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 11:11:00PM +0200, Jiri Slaby wrote:
> conOn 08/05/2008 06:33 PM, Ira Snyder wrote:
>> static void tiny_config_port(struct uart_port *port, int flags)
>> {
>> 	FUNC_ENTER();
>
>         if (flags & UART_CONFIG_TYPE)
>                 port->type = PORT_16550A;
>
>> }
>
> According to the straces, you get -EIO from ioctl and read which most 
> likely means TTY_IO_ERROR bit set due to tiny_port->type = PORT_UNKNOWN 
> (i.e. 0). Try the above.

Not quite, but it got me on the right track. I needed to set port->type
before calling uart_add_one_port().

Now it gets into my code. Previously, it had never even called any of my
code. None of it. Unfortunately, I ran it and it segfaulted. Turns out
that Greg's tinyserial driver didn't implement ops->set_termios() and
that was the cause. Implementing that got everything working.

Now I get in my dmesg:
[   73.813893] ttytiny: Tiny serial driver
[   83.714486] Enter: tiny_startup
[   83.717676] Enter: tiny_set_termios
[   83.721193] Enter: tiny_set_mctrl
[   85.463793] Enter: tiny_stop_rx
[   85.466987] Enter: tiny_set_mctrl
[   85.470328] Enter: tiny_shutdown

And that looks very reasonable. (It was produced by cat /dev/ttytiny0,
for your information).

Thanks a lot for your help! That problem had me completely stumped for a
couple of days now :)

Ira
