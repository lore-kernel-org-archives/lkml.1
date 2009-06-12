Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbZFLLgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbZFLLgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755638AbZFLLgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:36:05 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:39423 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbZFLLgE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:36:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=H/93RXmwWQbwe3TBuhTdb5/sTK23OFeZjNzP/yegBTr0Oc2ejTJBvWq25OVsOhSylz
         X7bouMXKJ7Kf03DN41v3dUYx4std8tfNXgF1ZK8zbENmNShLwHriE1Cx0t+BRhOzDNqW
         GEHdbAzAnuWkq0hBs7ZtJFXpRzwzMaU9TalvE=
MIME-Version: 1.0
In-Reply-To: <200906121329.33473.arnd@arndb.de>
References: <200906121247.50745.arnd@arndb.de> <1244804202-17030-1-git-send-email-vapier@gentoo.org> 
	<200906121329.33473.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 12 Jun 2009 07:35:46 -0400
Message-ID: <8bd0f97a0906120435w16a1f46ewd9ad94ee35c04e6e@mail.gmail.com>
Subject: Re: [PATCH] Blackfin: sync termios header changes with x86
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 07:29, Arnd Bergmann wrote:
> On Friday 12 June 2009, Mike Frysinger wrote:
>>  #define TIOCMIWAIT   0x545C  /* wait for a change on serial input line(s) */
>>  #define TIOCGICOUNT  0x545D  /* read serial port inline interrupt counts */
>> -
>> -#define FIOQSIZE     0x545E
>> +#define TIOCGHAYESESP   0x545E  /* Get Hayes ESP configuration */
>> +#define TIOCSHAYESESP   0x545F  /* Set Hayes ESP configuration */
>> +#define FIOQSIZE     0x5460
>
> This breaks existing applications using FIOQSIZE. You really shouldn't do that.

meh, no one uses that anyways ;)

>> diff --git a/arch/blackfin/include/asm/termbits.h b/arch/blackfin/include/asm/termbits.h
>> index f37feb7..faa569f 100644
>> --- a/arch/blackfin/include/asm/termbits.h
>> +++ b/arch/blackfin/include/asm/termbits.h
>
> This one only changes whitespace, what is the point?

makes diffing easier

>> --- a/arch/blackfin/include/asm/termios.h
>> +++ b/arch/blackfin/include/asm/termios.h
>
> This change fixes one bug but not another:

better than none at all !

>> @@ -58,37 +60,55 @@ struct termio {
>>       *(unsigned short *) &(termios)->x = __tmp; \
>>  }
>>
>> -#define user_termio_to_kernel_termios(termios, termio) \
>> -({ \
>> -     SET_LOW_TERMIOS_BITS(termios, termio, c_iflag); \
>> -     SET_LOW_TERMIOS_BITS(termios, termio, c_oflag); \
>> -     SET_LOW_TERMIOS_BITS(termios, termio, c_cflag); \
>> -     SET_LOW_TERMIOS_BITS(termios, termio, c_lflag); \
>> -     copy_from_user((termios)->c_cc, (termio)->c_cc, NCC); \
>> -})
>> +static inline int user_termio_to_kernel_termios(struct ktermios *termios,
>> +                                             struct termio __user *termio)
>> +{
>> +     SET_LOW_TERMIOS_BITS(termios, termio, c_iflag);
>> +     SET_LOW_TERMIOS_BITS(termios, termio, c_oflag);
>> +     SET_LOW_TERMIOS_BITS(termios, termio, c_cflag);
>> +     SET_LOW_TERMIOS_BITS(termios, termio, c_lflag);
>> +     get_user(termios->c_line, &termio->c_line);
>> +     return copy_from_user(termios->c_cc, termio->c_cc, NCC);
>> +}
>
> You correctly read termios->c_line now, which was missing previously,
> but you still don't check the return value of the get_user and
> copy_from_user functions. The code also has a very ugly property
> of working only on little-endian architectures (which includes
> blackfin AFAICT) but should not serve as an example.

Blackfin is LE which means the assumption is fine by me

> If you want a working version of this file, best copy it from avr32
> or frv. Or just wait for the asm-generic version.

is asm-generic going to be in 2.6.31 ?  otherwise i'd prefer to have
Blackfin fixed now rather than 2.6.32+
-mike
