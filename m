Return-Path: <linux-kernel-owner+w=401wt.eu-S1761102AbZJNA4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761102AbZJNA4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 20:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760777AbZJNA4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 20:56:31 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:49366 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759101AbZJNA4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 20:56:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:x-archive:mime-version:content-type;
        b=Z6SUN1mB8lhvnzwSoymVV2teviwsZvU8v1AETgVOaE5rlOX5g7aSB53VQUgYzDSAVs
         GHX2G5GT1hACqUjDTn5sIVM2Ob3+NKWSwzAu2bKWcpjvPsGA7bDdhXiM0zC+ssIaVbER
         4nI0x6gOxO4NAgVKmNjQjsE4nIxRjRF9z/hl4=
Date: Tue, 13 Oct 2009 21:55:25 -0300 (BRST)
From: "=?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?=" 
	<fredlwm@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Boyan <btanastasov@yahoo.co.uk>,
       "Justin P. Mattock" <justinmattock@gmail.com>, Nix <nix@esperi.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Fulghum <paulkf@microgate.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
In-Reply-To: <alpine.LFD.2.01.0910131413240.3596@localhost.localdomain>
Message-ID: <alpine.LNX.2.01.0910132153221.5212@dyndns.pervalidus.net>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera> <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com> <87ljjgfcbu.fsf@spindle.srvr.nix> <alpine.LFD.2.01.0910121703390.3438@localhost.localdomain> <alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
 <4AD3F769.5080405@gmail.com> <alpine.LNX.2.01.0910130405200.9297@dyndns.pervalidus.net> <4AD437F9.9020708@yahoo.co.uk> <alpine.LFD.2.01.0910130745550.3438@localhost.localdomain> <4AD4DE4C.4010402@yahoo.co.uk> <alpine.LFD.2.01.0910131317360.26777@localhost.localdomain>
 <alpine.LFD.2.01.0910131413240.3596@localhost.localdomain>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
X-Archive: encrypt
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Linus Torvalds wrote:

>
> Another bug:
>
> On Tue, 13 Oct 2009, Linus Torvalds wrote:
>>  			if (!count) {
>> -				if (head->next == NULL)
>> -					break;
>
> Those two lines should _not_ be deleted. I cleaned up a bit too much.
>
> The rule is that we must not free the last buffer, because it's also going
> to be 'tail'.
>
> So here's a new version with that fixed (and the previous bug I already
> mentioned).
>
> Whether it _works_ is still not clear. It might eat your pet goldfish, or
> make farting noises in your general direction. Or it might fix the bug.
> Who knows?
>
> 		Linus
>
> ---
> drivers/char/tty_buffer.c |   29 +++++++++++++----------------
> 1 files changed, 13 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
> index 3108991..0296612 100644
> --- a/drivers/char/tty_buffer.c
> +++ b/drivers/char/tty_buffer.c
> @@ -402,28 +402,26 @@ static void flush_to_ldisc(struct work_struct *work)
> 		container_of(work, struct tty_struct, buf.work.work);
> 	unsigned long 	flags;
> 	struct tty_ldisc *disc;
> -	struct tty_buffer *tbuf, *head;
> -	char *char_buf;
> -	unsigned char *flag_buf;
>
> 	disc = tty_ldisc_ref(tty);
> 	if (disc == NULL)	/*  !TTY_LDISC */
> 		return;
>
> 	spin_lock_irqsave(&tty->buf.lock, flags);
> -	/* So we know a flush is running */
> -	set_bit(TTY_FLUSHING, &tty->flags);
> -	head = tty->buf.head;
> -	if (head != NULL) {
> -		tty->buf.head = NULL;
> -		for (;;) {
> -			int count = head->commit - head->read;
> +
> +	if (!test_and_set_bit(TTY_FLUSHING, &tty->flags)) {
> +		struct tty_buffer *head;
> +		while ((head = tty->buf.head) != NULL) {
> +			int count;
> +			char *char_buf;
> +			unsigned char *flag_buf;
> +
> +			count = head->commit - head->read;
> 			if (!count) {
> 				if (head->next == NULL)
> 					break;
> -				tbuf = head;
> -				head = head->next;
> -				tty_buffer_free(tty, tbuf);
> +				tty->buf.head = head->next;
> +				tty_buffer_free(tty, head);
> 				continue;
> 			}
> 			/* Ldisc or user is trying to flush the buffers
> @@ -445,9 +443,9 @@ static void flush_to_ldisc(struct work_struct *work)
> 							flag_buf, count);
> 			spin_lock_irqsave(&tty->buf.lock, flags);
> 		}
> -		/* Restore the queue head */
> -		tty->buf.head = head;
> +		clear_bit(TTY_FLUSHING, &tty->flags);
> 	}
> +
> 	/* We may have a deferred request to flush the input buffer,
> 	   if so pull the chain under the lock and empty the queue */
> 	if (test_bit(TTY_FLUSHPENDING, &tty->flags)) {
> @@ -455,7 +453,6 @@ static void flush_to_ldisc(struct work_struct *work)
> 		clear_bit(TTY_FLUSHPENDING, &tty->flags);
> 		wake_up(&tty->read_wait);
> 	}
> -	clear_bit(TTY_FLUSHING, &tty->flags);
> 	spin_unlock_irqrestore(&tty->buf.lock, flags);
>
> 	tty_ldisc_deref(disc);

For now (more than 3h), it isn't doing any harm. And no keyboard 
lockups.

BTW, the old version of the patch was funny. It booted, but at 
the login prompt I could only enter the first letter.
