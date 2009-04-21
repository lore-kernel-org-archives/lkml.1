Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbZDUMU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbZDUMU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 08:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbZDUMUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 08:20:11 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:60701 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbZDUMUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 08:20:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SWV7TchdqXimU9KLKxftpCup5yOfZi8A110SYqUxl3eu8UdtU4rqfxcHPjMGErJvlP
         DPEkf3296U4DDM0hN1SK5+Vc3E4ZeT6iSQwG6/n47uY6iYSwUCOAZZ1ZgGEBLVhJt509
         hQ84vb+1OxOovtbUlXG5FHmGdCMfXAAFQZURk=
Message-ID: <49EDB9F8.6000807@gmail.com>
Date: Tue, 21 Apr 2009 14:20:08 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.2 Thunderbird/3.0b2
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Zijlstra <peterz@infradead.org>,
       Christophe Lermytte <christophe.lermytte@thomson.net>,
       linux-kernel@vger.kernel.org
Subject: Re: mutex_lock_slowpath warning using mxser tty driver (input/output
 error)
References: <1238689565.14822.99.camel@thom> <1238696349.5133.25.camel@laptop> <20090402194401.154bbc36@lxorguk.ukuu.org.uk> <49D51EDD.4060902@gmail.com> <20090402235508.31c7f2b6@lxorguk.ukuu.org.uk> <20090403003302.GB9052@cmpxchg.org>
In-Reply-To: <20090403003302.GB9052@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2009 02:33 AM, Johannes Weiner wrote:
> On Thu, Apr 02, 2009 at 11:55:08PM +0100, Alan Cox wrote:
>> On Thu, 02 Apr 2009 22:23:57 +0200
>> Jiri Slaby <jirislaby@gmail.com> wrote:
>>
>>> On 04/02/2009 08:44 PM, Alan Cox wrote:
>>>>> It appears to want to lock a mutex in interrupt context, something
>>>>> that's a definite no-no.
>>>>>
>>>>> CCed the folks who might know a thing or two about the driver.
>>>> Moxa is not a USB driver so the USB trace at the end makes no sense at
>>>> all.
>>> Yes, unreliable stack entries, but echo_set_canon_col is called from irq
>>> context and locks mutex.
>> Which means that either the driver is calling the ldisc receive handlers
>> from an IRQ directly (not allowed) or calling the tty_flip_buffer_push
>> paths and set tty->low_latency
>>
>> 2.6.29 is the first kernel that catches this bug with warnings.
> 
> It sets tty->low_latency = 1 on ->open(), unconditionally, and does
> tty_flip_buffer_push() from the interrupt handler.
> 
> Both things seem to have been there for a very long time (git-blame
> says longer than git).

I have no idea why it was added in fact and so whether it is sufficient
and correct just to remove the tty->low_latency setting hence I can't
fix it on my own.

It was added when Alan merged moxa's updated driver in (from
full-linux-history git):

commit c8caa4c1a9cda2fa01fa89c29020e31f5a923e0b
Author: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date:   Wed Dec 22 01:14:43 2004 -0800

[PATCH] Bring Moxa serial back into being

Moxa have released several driver updates now including support up to
2.6.8 but don't themselves feel its worth the effort of doing a cleaned
up merge for the base kernel.  So I pulled their latest driver release
(1.8) and removed all the macro gunge that makes it build on
2.2.0->2.6.8.  I then fixed it to run on 2.6.9/10 and fixed a bug in the
break handling.

It still doesn't do PCI hotplug but I don't have any PCI moxa cards to
really tackle that particular case.

I've also merged Adriank Bunk's two 'could be static' changes into this
diff set.
