Return-Path: <linux-kernel-owner+w=401wt.eu-S933231AbXEEQFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231AbXEEQFJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933232AbXEEQFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:05:08 -0400
Received: from neon.samage.net ([85.17.153.66]:34868 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933231AbXEEQFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:05:05 -0400
Message-ID: <2470.81.207.0.53.1178366553.squirrel@secure.samage.net>
In-Reply-To: <20070505091643.GA25704@elf.ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
    <200704272107.28565.oliver@neukum.org>
    <84144f020704280222s42ff99ddg3eea3cb353c8882e@mail.gmail.com>
    <200704281537.53479.oliver@neukum.org> <20070503120637.GA3866@ucw.cz>
    <3052.81.207.0.53.1178315528.squirrel@secure.samage.net>
    <20070505091643.GA25704@elf.ucw.cz>
Date: Sat, 5 May 2007 14:02:33 +0200 (CEST)
Subject: Re: Back to the future.
From: "Indan Zupancic" <indan@nul.nu>
To: "Pavel Machek" <pavel@ucw.cz>
Cc: "Oliver Neukum" <oliver@neukum.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Nigel Cunningham" <nigel@nigel.suspend2.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: cf96151651da5a5ace2e908a4273e1b9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, May 5, 2007 11:16, Pavel Machek wrote:
>> But the same functionality can be achieved by doing:
>>
>> 1) Define a user password (e.g. /etc/shadow thing). (Once)
>>
>> 2) When a user logs in: get random data and encrypt it with the password,
>> this becomes the AES key. Store both the data and key in a secure way in
>> memory, e.g. using the existing kernel key infrastructure.
>
>
>
>> Advantage of this scheme is that it only need AES and can be done (mostly)
>> in kernel space. It's also faster and simpler than the current RSA scheme.
>> Disadvantage is that it wastes at least 32 bytes of memory when the system
>> is running, to store the data and key.
>
> Another disadvantage is that you need to hack into PAM infrastructure,
> that your suspend password needs to be same as someone's login
> password, and that it will really only work with single-user machine.

The first two are only true if you want to integrate it with user login, so
that a user only needs to sign in once, which seems like a convenient thing.
But if you don't want to integrate with the existing login infrastructure,
then just don't. And those disadvantages are true for any system that wants
users to login once.

Then the disadvantage is reduced to a user needing to provide the password
at suspend if the system wasn't booted from a snapshot. But no need for
users to generate any files, just to choose a resume password.

If the resume key is stored per user instead of a single global instance, it
will work with a multi-user system too. A more interesting question is what
should happen when one user did the suspend and the other wants to resume.
Throw away the snapshot? Refuse booting? Or boot and switch "active user"?

If you don't want people to resume each other's suspends then a key per user
works. If you want them to, then it becomes a bit tricky, especially if you
don't integrate with the login system. You don't want that a user can resume
someone else's snapshot and have access to everything that other user left
open. Nor do you want users to give a password twice.

If you want users to be able to resume each other's snapshots, you probably
also want the system to switch users after the resume. No matter what scheme
is used, this becomes hairy and hard to get watertight. (Perhaps "impossible"
is more realistic: how to be able to read the suspend image and copying it
to RAM again, without having access to all data within?)

But if it's an "us" against "them" case, and you want users to resume each
other's snapshots, you're right that the scheme I proposed will fall apart.
In which case it needs to be adjusted a bit to handle this case:

Have one global suspend/resume key, and for each user store it on disk,
encrypted with that user's password. Also store the key in memory as
before. Now when the system is suspended any user needs to have provided
his password once for everyone to be able to suspend without giving a
password. Also everyone can resume, if they have access to the file with
the list of encrypted keys and provide the right password. (Notice that
this looks more like the current scheme, where the private part of the
RSA key is encrypted with a passphrase and all stored in a file.)

Though it seems that using suspend to disk on a real multi-user system is
always asking for problems, because the suspend image may contain valuable
data which shouldn't be thrown away, but easily can by other users. Nor do
you want users to claim the machine, so it's a lose/lose situation. Also
with resume every user effectively gets root access, because of all the
memory access. So inter-user security is down the drain anyway.

Only sane usage I can see is when the users trust each other, in which case
they can as well agree on one resume password. ;-)

Greetings,

Indan


