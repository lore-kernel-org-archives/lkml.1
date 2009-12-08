Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbZLHOvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbZLHOvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 09:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbZLHOvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 09:51:15 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:56162 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364AbZLHOvO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 09:51:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LUUbO5BTnpR5Fc0wwJjDqwlRlyNe2oMlLVaAyWZLiJmGA+5VdE3Ls7ySIEKne9gplS
         ejl/spvJPUYPuKKXFBQ7i/uKzxf1Rfp1fsuDEOWtFm32c7wuE3uJlyrxkwfBs7DHN+Mv
         uwNh467zPsI1duzum0QJw5tIUOp+ruEbKTSoQ=
MIME-Version: 1.0
In-Reply-To: <4B1E5DA3.7000206@redhat.com>
References: <20091204220708.GD25669@core.coreip.homeip.net>
	 <20091206065512.GA14651@core.coreip.homeip.net>
	 <4B1B99A5.2080903@redhat.com> <m3638k6lju.fsf@intrepid.localdomain>
	 <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
	 <m3skbn6dv1.fsf@intrepid.localdomain>
	 <9e4733910912061323x22c618ccyf6edcee5b021cbe3@mail.gmail.com>
	 <4B1D934E.7030103@redhat.com> <m3hbs1vain.fsf@intrepid.localdomain>
	 <4B1E5DA3.7000206@redhat.com>
Date: Tue, 8 Dec 2009 09:51:20 -0500
Message-ID: <9e4733910912080651s30d600aay4c37f59e60e9c697@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR 
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, kraxel@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 8, 2009 at 9:07 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Krzysztof Halasa wrote:
>> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
>>
>>>> What is the interface for attaching an in-kernel decoder?
>>> IMO, it should use the kfifo for it. However, if we allow both raw data and
>>> in-kernel decoders to read data there, we'll need a spinlock to protect the
>>> kfifo.
>>
>> This may be an option, but I think we should be able to attach protocol
>> decoders in parallel, directly to the IRQ handler. At least with RC-5
>> (that's what I personally use) it means reliable decoding, no need for
>> any timeouts, the code is clean, fast (can be a part of hard IRQ
>> handler) and simple.
>>
>> The decoder needs something like
>>       rc5_signal_change(ptr, space_or_mark, microseconds).
>>
>> At least mark->space or space->mark events must be reported. For better
>> reliability, both of them.
>
> If you use a kfifo to store the event (space_or_mark, timestamp),
> the IRQ handler can return immediately, and a separate kernel thread
> can do the decode without needing to touch at the IRQ. It also helps to
> have a decoder independent of the kernel driver.

The first version of my code ran the decoders from the IRQ. That
wasn't a good model for sharing decoders between drivers. So I
switched to using a kernel thread. There is also the problem of
handing decoded events off up the chain. You can't do that from IRQ
context.

If I remember correctly the kernel thread would run approximately two
times per IR message received. But sometimes it would only run once.
It's a random function of the load on the system. The kernel thread
empties the FIFO and sends the pulses in parallel to the decoders.

Code for doing this is in the patches I posted. I wasn't aware of
kfifo when I wrote them so I coded my own fifo.

-- 
Jon Smirl
jonsmirl@gmail.com
