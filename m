Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbZJSSKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbZJSSKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 14:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbZJSSKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 14:10:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755022AbZJSSKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 14:10:05 -0400
Date: Tue, 20 Oct 2009 03:09:57 +0900 (JST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Ellerman <michael@ellerman.id.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Michael Neuling <mikey@neuling.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Characters vanishing in the tty layer? (maybe related to [Bug
 #14388] keyboard under X with 2.6.31)
In-Reply-To: <1255934287.4192.125.camel@concordia>
Message-ID: <alpine.LFD.2.00.0910200245330.13080@eeepc.linux-foundation.org>
References: <1255501294.21962.24.camel@concordia>  <alpine.LFD.2.01.0910140748420.6146@localhost.localdomain> <1255934287.4192.125.camel@concordia>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 19 Oct 2009, Michael Ellerman wrote:
> 
> As Benh said it's not really bisectable on our kernel. But I got Mikey
> to bisect it on upstream using a different simulator model, and he
> couldn't tie it down. It becomes easier to hit in more recent kernels
> (since 27), but he could hit in 25 too.

Ok, thanks to the verification.

And I think I see why it got easier to hit lately, and to some degree I 
think we can at least partially avoid it:

>       * hvc_console reads all our input and passes it to the tty code
>         via tty_insert_flip_char()
>       * flush_to_ldisc() runs calling n_tty_receive_buf(), which fills
>         4K of tty->read_buf
>       * Once read_buf is full, tty->receive_room becomes 0 and
>         flush_to_ldisc() reschedules itself to run again in 1 jiffy.
>       * Bash reads 1 character, causing receive_room to become 1.
>       * flush_to_ldisc() runs again and inserts 1 more char because
>         receive_room is now 1.

.. ok, I agree that our behavior in the "buffer full" case is likely not 
wonderful. And that's especially true in the 'icanon' case..

>       * (repeat the last two steps a few times)
>       * Bash sets tty->icanon = 1 via n_tty_set_termios(), which calls
>         n_tty_set_room(). Because icanon is enabled, n_tty_set_room()
>         lies and says we have space for 1 character even though we
>         don't.

So just to clarify - icanon wasn't set before?

>       * flush_to_ldisc() runs, sees that receive_room is 1 and calls
>         n_tty_receive_buf()
>       * n_tty_receive_buf() calls n_tty_receive_char() which drops the
>         character because there's no room (~ line 1132).
>       * We keep dropping characters until we see a newline, which
>         increments tty->canon_data, causing n_tty_set_room() to report 0
>         space left, and so flush_to_ldisc() reschedules again.

Did you have newlines in the big bulk dump?

If there really aren't any newlines, I don't think we can do a lot. icanon 
handling kind of fundamentally doesn't work if there is no newline at all, 
since it is all about line buffering, and we obviously have to limit the 
lines _somewhere_.

But I also thihk that we only update that whole 'canon_data' thing if we 
_received_ the newlines while we were in icanon mode (but I didn't really 
check very closely), so if we actually switch from -icanon to +icanon, I 
think canon_data can be confused, and we thus handle the buffer-full case 
worse than we _could_ have.

> It's a bit unfortunate that n_tty_set_room() lies about the available
> space when icanon = 1, but it makes sense in order to handle erase. It
> would be nice if n_tty_receive_buf() returned a status to
> flush_to_disc() to say "actually I could only fit X chars after all,
> please take them back" - but I don't grok how that would play with all
> the other logic in there.

Yeah, I don't think that is even worth it. The thing is, we do have to 
start dropping characters at some point, so trying to extend the non-drop 
case just moves it somewhere else. If you are in canon mode, and the line 
is longer than <some-number-that-happens-to-be-4kB>, you're basically 
screwed.

But what we _might_ do is to handle the "turn on canon mode" case better, 
in case the old buffer had newlines. IOW, instead of always setting 
'canon_data' to 0 when icanon changes (and setting canon_head to the tail 
of the data), maybe we should simply _count_ the number of newlines (and 
set canon_head to the last one in the buffer).

IOW, if you do have newlines in your bulk data before icanon got set, we 
could probably make n_tty handle that case better.

That said, as far as I know, the tty layer behavior in this area has 
basically always been the way it is. The fact that you can see it more 
easily is almost certainly just related to just how the buffers that lead 
up to flush_to_ldisc have grown, and are now allowed to fill up further. 
So it probably got much easier to trigger, but it is likely not in any way 
a really new case, and goes back not just to 2.6.25, but probably 
forever...

I wonder a bit what in your particular environment makes this problem show 
up, but I assume that your simulation environment ends up just blindly 
stuffing the tty buffers through the virtual console, so you basically 
have "simulated typing" that was (a) started long before the reader was 
interested in accepting it and (b) was a huge dump rather than what any 
real load would be.

But if you change n_tty_set_termios() to count newlines when it sets 
icanon, you might get the behaviour you want, and it would seem to me to 
be an improvement over what we have now, so I wouldn't object to it, even 
if I suspect nobody else has ever cared, and would ever care in the 
future.

			Linus
