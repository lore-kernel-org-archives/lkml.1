Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbZBDOwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbZBDOwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 09:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZBDOwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 09:52:34 -0500
Received: from [84.77.67.98] ([84.77.67.98]:1970 "EHLO ventoso.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbZBDOwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 09:52:34 -0500
Message-ID: <4989ABA8.8010807@ventoso.org>
Date: Wed, 04 Feb 2009 15:52:24 +0100
From: Luca Olivetti <luca@ventoso.org>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
       Janne Grunau <janne-dvb@grunau.be>
Subject: Re: [crash] af9005_usb_module_init(): BUG: unable to handle kernel
 paging request at ff100000
References: <20090203172836.GA6964@elte.hu>	 <1233685361.5903.131.camel@desktop> <20090203193029.GA13726@elte.hu>	 <4988ABEE.6020703@ventoso.org> <1233710080.15119.37.camel@desktop>
In-Reply-To: <1233710080.15119.37.camel@desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

En/na Daniel Walker ha escrit:
> On Tue, 2009-02-03 at 21:41 +0100, Luca Olivetti wrote:
> 
>> No, I don't have 2.6.28, but I guess that maybe once usb_register is
>> called the dvb-usb subsystem asynchronously (is that an smp system?)
>> starts polling the remote before the rc_decode function pointer has been
>> initialized.
>> Could you try to initialize it to NULL before calling usb_register?
> 
> What happens to the decode function when you have,
> 
> CONFIG_DVB_USB_AF9005=y
> CONFIG_DVB_USB_AF9005_REMOTE=n
> 
> It seems that the decode function is defined inside,
> drivers/media/dvb/dvb-usb/af9005-remote.c
> 
> but that doesn't get compiled in the case above. It looks like you end
> up with af9005_rc_decode being a function local weak symbol
> (uninitialized) which then gets assigned to rc_decode .. I think the
> crash actually happens on rc_keys_size which get assigned another
> uninitialized local, and it gets de-referenced .

Doesn't symbol_request return a NULL in such a case?
At the time I didn't try the above configuration 
(CONFIG_DVB_USB_AF9005_REMOTE=n), but removed the compiled 
dvb-usb-af9005-remote.ko, and all was well (i.e. the symbol_request 
returned NULL and the remote handling was disabled).

> Here's a patch I compile tested, and I think it would fix the issue.

But it'd break the alternative rc decoding module (not integrated in the 
kernel because it uses lirc):

http://ventoso.org/luca/af9005/README.lirc

Not really an issue for me, since I'm using a lirc-serial homebrew 
device, (besides, my af9005 device is broken, though the remote part is 
still working, so in a pinch I could use it as an usb remote receiver).

@Ingo, silly question, but do you have an af9005 based device where this 
is crashing?

Bye
-- 
Luca


