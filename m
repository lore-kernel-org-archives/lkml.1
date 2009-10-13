Return-Path: <linux-kernel-owner+w=401wt.eu-S1759002AbZJMHOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002AbZJMHOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757359AbZJMHOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:14:19 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:36619 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbZJMHOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:14:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:x-archive:mime-version:content-type;
        b=JwpB1mqcbzf6I4uoZ2EXJFn0M+SwQE3EtmLpSFRLQkqyqii2jJ6i7EniShMsSXNBeW
         NSm/9mSb3VClGBxxjI/y7l4acLDiVQton0oodNI4t9vuoQIuwUHg+F8vZY58rxMx+4BR
         RQW3kmgDCfiqghj9UsU2EUqpJFSeNMv+RvxkM=
Date: Tue, 13 Oct 2009 04:13:34 -0300 (BRST)
From: "=?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?=" 
	<fredlwm@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>, Nix <nix@esperi.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Fulghum <paulkf@microgate.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Boyan <btanastasov@yahoo.co.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
In-Reply-To: <4AD3F769.5080405@gmail.com>
Message-ID: <alpine.LNX.2.01.0910130405200.9297@dyndns.pervalidus.net>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera> <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com> <87ljjgfcbu.fsf@spindle.srvr.nix> <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain> <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
 <4AD3F769.5080405@gmail.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
X-Archive: encrypt
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009, Justin P. Mattock wrote:

> Linus Torvalds wrote:
>> [ Alan, Paulkf - the tty buffering and locking is originally your code,
>>    although from about three years ago, when it used to be in tty_io.c..
>>    Any comment? ]
>> 
>> On Mon, 12 Oct 2009, Linus Torvalds wrote:
>> 
>>> Alan, Ogawa-san, do either of you see some problem in tty_buffer.c,
>>> perhaps?
>>> 
>> 
>> Hmm. I see one, at least.
>> 
>> The "tty_insert_flip_string()" locking seems totally bogus.
>> 
>> It does that "tty_buffer_request_room()" call and subsequent copying with
>> no locking at all - sure, the tty_buffer_request_room() function itself
>> locks the buffers, but then unlocks it when returning, so when we actually
>> do the memcpy() etc, we can race with anybody.
>> 
>> I don't really see who would care, but it does look totally broken.
>> 
>> I dunno, this patch seems to make sense to me. Am I missing something?
>> 
>> [ NOTE! The patch is totally untested. It compiled for me on x86-64, and
>>    apart from that I'm just going to say that it looks obvious, and the old
>>    code looks obviously buggy. Also, any remaining users of
>>
>> 	tty_prepare_flip_string
>> 	tty_prepare_flip_string_flags
>>
>>    are still fundamentally broken and buggy, while users of
>>
>> 	tty_buffer_request_room
>>
>>    are pretty damn odd and suspect (but a lot of them seem to be just
>>    pointless: they then call tty_insert_flip_string(), which means that the
>>    tty_buffer_request_room() call was totally redundant ]
>> 
>> Comments? Does this work? Does it make any difference? It seems fairly
>> unlikely, but it's the only obvious problem I've seen in the tty buffering
>> code so far.
>> 
>> And that code is literally 3 years old, and it seems unlikely that a
>> regular _keyboard_ buffer would be able to hit the (rather small) race
>> condition. But other serialization may have hidden it, and timing
>> differences could certainly have caused it to trigger much more easily.
>>
>> 			Linus
>> 
>> ---
>>   drivers/char/tty_buffer.c |   33 +++++++++++++++++++++++++--------
>>   1 files changed, 25 insertions(+), 8 deletions(-)
>> 
>> diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
>> index 3108991..25ab538 100644
>> --- a/drivers/char/tty_buffer.c
>> +++ b/drivers/char/tty_buffer.c
>> @@ -196,13 +196,10 @@ static struct tty_buffer *tty_buffer_find(struct 
>> tty_struct *tty, size_t size)
>>    *
>>    *	Locking: Takes tty->buf.lock
>>    */
>> -int tty_buffer_request_room(struct tty_struct *tty, size_t size)
>> +static int locked_tty_buffer_request_room(struct tty_struct *tty, size_t 
>> size)
>>   {
>>   	struct tty_buffer *b, *n;
>>   	int left;
>> -	unsigned long flags;
>> -
>> -	spin_lock_irqsave(&tty->buf.lock, flags);
>>
>>   	/* OPTIMISATION: We could keep a per tty "zero" sized buffer to
>>   	   remove this conditional if its worth it. This would be invisible
>> @@ -225,9 +222,20 @@ int tty_buffer_request_room(struct tty_struct *tty, 
>> size_t size)
>>   			size = left;
>>   	}
>> 
>> -	spin_unlock_irqrestore(&tty->buf.lock, flags);
>>   	return size;
>>   }
>> +
>> +int tty_buffer_request_room(struct tty_struct *tty, size_t size)
>> +{
>> +	int retval;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&tty->buf.lock, flags);
>> +	retval = locked_tty_buffer_request_room(tty, size);
>> +	spin_unlock_irqrestore(&tty->buf.lock, flags);
>> +	return retval;
>> +}
>> +
>>   EXPORT_SYMBOL_GPL(tty_buffer_request_room);
>>
>>   /**
>> @@ -239,16 +247,20 @@ EXPORT_SYMBOL_GPL(tty_buffer_request_room);
>>    *	Queue a series of bytes to the tty buffering. All the characters
>>    *	passed are marked as without error. Returns the number added.
>>    *
>> - *	Locking: Called functions may take tty->buf.lock
>> + *	Locking: We take tty->buf.lock
>>    */
>>
>>   int tty_insert_flip_string(struct tty_struct *tty, const unsigned char 
>> *chars,
>>   				size_t size)
>>   {
>>   	int copied = 0;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&tty->buf.lock, flags);
>>   	do {
>> -		int space = tty_buffer_request_room(tty, size - copied);
>> +		int space = locked_tty_buffer_request_room(tty, size - 
>> copied);
>>   		struct tty_buffer *tb = tty->buf.tail;
>> +
>>   		/* If there is no space then tb may be NULL */
>>   		if (unlikely(space == 0))
>>   			break;
>> @@ -260,6 +272,7 @@ int tty_insert_flip_string(struct tty_struct *tty, 
>> const unsigned char *chars,
>>   		/* There is a small chance that we need to split the data 
>> over
>>   		   several buffers. If this is the case we must loop */
>>   	} while (unlikely(size>  copied));
>> +	spin_unlock_irqrestore(&tty->buf.lock, flags);
>>   	return copied;
>>   }
>>   EXPORT_SYMBOL(tty_insert_flip_string);
>> @@ -282,8 +295,11 @@ int tty_insert_flip_string_flags(struct tty_struct 
>> *tty,
>>   		const unsigned char *chars, const char *flags, size_t size)
>>   {
>>   	int copied = 0;
>> +	unsigned long irqflags;
>> +
>> +	spin_lock_irqsave(&tty->buf.lock, irqflags);
>>   	do {
>> -		int space = tty_buffer_request_room(tty, size - copied);
>> +		int space = locked_tty_buffer_request_room(tty, size - 
>> copied);
>>   		struct tty_buffer *tb = tty->buf.tail;
>>   		/* If there is no space then tb may be NULL */
>>   		if (unlikely(space == 0))
>> @@ -297,6 +313,7 @@ int tty_insert_flip_string_flags(struct tty_struct 
>> *tty,
>>   		/* There is a small chance that we need to split the data 
>> over
>>   		   several buffers. If this is the case we must loop */
>>   	} while (unlikely(size>  copied));
>> +	spin_unlock_irqrestore(&tty->buf.lock, irqflags);
>>   	return copied;
>>   }
>>   EXPORT_SYMBOL(tty_insert_flip_string_flags);
>>
>> 
> I can throw your patch in over here for the heck of it.
> If there's somebody who's really hitting this bug
> then the results would be better  if this is the area that causing
> this bug.(from here the only issue I'm seeing is spinning
> history commands in the terminal  from time to time,
> nothing of any unusable keys like others are reporting).

I tested it on top of 2.6.31.4 (after putting back 
e043e42bdb66885b3ac10d27a01ccb9972e2b0a3), and the keyboard is 
fine after almost 3h. Before that, the problems would appear in 
less than 1h. Maybe I spoke too soon, but...

Boyan, does it work for you ?
