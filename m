Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbZJMDoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbZJMDoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 23:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758800AbZJMDoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 23:44:10 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:41201 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbZJMDoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 23:44:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uW4QVrasj9tCEJyPenAGUKzVPhkPQcsyxbj+nWJ/B4srVO3cuAcbnv1F93uDaXVg54
         Ju3qtUwYZdfTtCQnbxYDbXWfoFbCShdStduIz9vx0HvlAuL2h86aS/BgRi7wYelKOCh2
         KZ7OcBb+Gie2S4xXZm4COAcHSm3zPwYF0mmEU=
Message-ID: <4AD3F769.5080405@gmail.com>
Date: Mon, 12 Oct 2009 20:43:37 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Nix <nix@esperi.org.uk>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Fulghum <paulkf@microgate.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Boyan <btanastasov@yahoo.co.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       =?ISO-8859-1?Q?=22Fr=E9d=E9ric_L=2E_W=2E_Meunier=22?= 
	<fredlwm@gmail.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera> <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com> <87ljjgfcbu.fsf@spindle.srvr.nix> <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain> <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> [ Alan, Paulkf - the tty buffering and locking is originally your code,
>    although from about three years ago, when it used to be in tty_io.c..
>    Any comment? ]
>
> On Mon, 12 Oct 2009, Linus Torvalds wrote:
>    
>> Alan, Ogawa-san, do either of you see some problem in tty_buffer.c,
>> perhaps?
>>      
>
> Hmm. I see one, at least.
>
> The "tty_insert_flip_string()" locking seems totally bogus.
>
> It does that "tty_buffer_request_room()" call and subsequent copying with
> no locking at all - sure, the tty_buffer_request_room() function itself
> locks the buffers, but then unlocks it when returning, so when we actually
> do the memcpy() etc, we can race with anybody.
>
> I don't really see who would care, but it does look totally broken.
>
> I dunno, this patch seems to make sense to me. Am I missing something?
>
> [ NOTE! The patch is totally untested. It compiled for me on x86-64, and
>    apart from that I'm just going to say that it looks obvious, and the old
>    code looks obviously buggy. Also, any remaining users of
>
> 	tty_prepare_flip_string
> 	tty_prepare_flip_string_flags
>
>    are still fundamentally broken and buggy, while users of
>
> 	tty_buffer_request_room
>
>    are pretty damn odd and suspect (but a lot of them seem to be just
>    pointless: they then call tty_insert_flip_string(), which means that the
>    tty_buffer_request_room() call was totally redundant ]
>
> Comments? Does this work? Does it make any difference? It seems fairly
> unlikely, but it's the only obvious problem I've seen in the tty buffering
> code so far.
>
> And that code is literally 3 years old, and it seems unlikely that a
> regular _keyboard_ buffer would be able to hit the (rather small) race
> condition. But other serialization may have hidden it, and timing
> differences could certainly have caused it to trigger much more easily.
>
> 			Linus
>
> ---
>   drivers/char/tty_buffer.c |   33 +++++++++++++++++++++++++--------
>   1 files changed, 25 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
> index 3108991..25ab538 100644
> --- a/drivers/char/tty_buffer.c
> +++ b/drivers/char/tty_buffer.c
> @@ -196,13 +196,10 @@ static struct tty_buffer *tty_buffer_find(struct tty_struct *tty, size_t size)
>    *
>    *	Locking: Takes tty->buf.lock
>    */
> -int tty_buffer_request_room(struct tty_struct *tty, size_t size)
> +static int locked_tty_buffer_request_room(struct tty_struct *tty, size_t size)
>   {
>   	struct tty_buffer *b, *n;
>   	int left;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&tty->buf.lock, flags);
>
>   	/* OPTIMISATION: We could keep a per tty "zero" sized buffer to
>   	   remove this conditional if its worth it. This would be invisible
> @@ -225,9 +222,20 @@ int tty_buffer_request_room(struct tty_struct *tty, size_t size)
>   			size = left;
>   	}
>
> -	spin_unlock_irqrestore(&tty->buf.lock, flags);
>   	return size;
>   }
> +
> +int tty_buffer_request_room(struct tty_struct *tty, size_t size)
> +{
> +	int retval;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&tty->buf.lock, flags);
> +	retval = locked_tty_buffer_request_room(tty, size);
> +	spin_unlock_irqrestore(&tty->buf.lock, flags);
> +	return retval;
> +}
> +
>   EXPORT_SYMBOL_GPL(tty_buffer_request_room);
>
>   /**
> @@ -239,16 +247,20 @@ EXPORT_SYMBOL_GPL(tty_buffer_request_room);
>    *	Queue a series of bytes to the tty buffering. All the characters
>    *	passed are marked as without error. Returns the number added.
>    *
> - *	Locking: Called functions may take tty->buf.lock
> + *	Locking: We take tty->buf.lock
>    */
>
>   int tty_insert_flip_string(struct tty_struct *tty, const unsigned char *chars,
>   				size_t size)
>   {
>   	int copied = 0;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&tty->buf.lock, flags);
>   	do {
> -		int space = tty_buffer_request_room(tty, size - copied);
> +		int space = locked_tty_buffer_request_room(tty, size - copied);
>   		struct tty_buffer *tb = tty->buf.tail;
> +
>   		/* If there is no space then tb may be NULL */
>   		if (unlikely(space == 0))
>   			break;
> @@ -260,6 +272,7 @@ int tty_insert_flip_string(struct tty_struct *tty, const unsigned char *chars,
>   		/* There is a small chance that we need to split the data over
>   		   several buffers. If this is the case we must loop */
>   	} while (unlikely(size>  copied));
> +	spin_unlock_irqrestore(&tty->buf.lock, flags);
>   	return copied;
>   }
>   EXPORT_SYMBOL(tty_insert_flip_string);
> @@ -282,8 +295,11 @@ int tty_insert_flip_string_flags(struct tty_struct *tty,
>   		const unsigned char *chars, const char *flags, size_t size)
>   {
>   	int copied = 0;
> +	unsigned long irqflags;
> +
> +	spin_lock_irqsave(&tty->buf.lock, irqflags);
>   	do {
> -		int space = tty_buffer_request_room(tty, size - copied);
> +		int space = locked_tty_buffer_request_room(tty, size - copied);
>   		struct tty_buffer *tb = tty->buf.tail;
>   		/* If there is no space then tb may be NULL */
>   		if (unlikely(space == 0))
> @@ -297,6 +313,7 @@ int tty_insert_flip_string_flags(struct tty_struct *tty,
>   		/* There is a small chance that we need to split the data over
>   		   several buffers. If this is the case we must loop */
>   	} while (unlikely(size>  copied));
> +	spin_unlock_irqrestore(&tty->buf.lock, irqflags);
>   	return copied;
>   }
>   EXPORT_SYMBOL(tty_insert_flip_string_flags);
>
>    
I can throw your patch in over here for the heck of it.
If there's somebody who's really hitting this bug
then the results would be better  if this is the area that causing
this bug.(from here the only issue I'm seeing is spinning
history commands in the terminal  from time to time,
nothing of any unusable keys like others are reporting).

Justin P. Mattock
