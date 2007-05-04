Return-Path: <linux-kernel-owner+w=401wt.eu-S1161590AbXEDVwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161590AbXEDVwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 17:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161934AbXEDVwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 17:52:41 -0400
Received: from neon.samage.net ([85.17.153.66]:35941 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161590AbXEDVwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 17:52:39 -0400
Message-ID: <3052.81.207.0.53.1178315528.squirrel@secure.samage.net>
In-Reply-To: <20070503120637.GA3866@ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
    <200704272107.28565.oliver@neukum.org>
    <84144f020704280222s42ff99ddg3eea3cb353c8882e@mail.gmail.com>
    <200704281537.53479.oliver@neukum.org> <20070503120637.GA3866@ucw.cz>
Date: Fri, 4 May 2007 23:52:08 +0200 (CEST)
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
X-Scan-Signature: bc82d6a2e188773012c482ed32290af0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2007 14:06, Pavel Machek wrote:
>> > > The kernel can already do compression and encryption.
>> >
>> > Yes, if we all could agree on _which_ compression and encryption
>>
>> Any of those available in the kernel. Where's the problem?
>
> gzip is too slow for this. lzf works okay. Oh and swsusp wants rsa
> crypto.

Then port lzf to the kernel, or help with the lzo port.

Swsusp might want RSA crypto, but it doesn't really need it. Currently
it only uses it to be able to suspend without asking for a passphrase.

So the current sequence is:

1) Generate RSA keys + ask for a passphrase. (Once)

...

2) Suspend. (Encrypt snapshot with public RSA key).

...

3) Ask for the passphrase.

4) Resume.

RSA is used so that the passphrase can be thrown away between 1 and 2.


But the same functionality can be achieved by doing:

1) Define a user password (e.g. /etc/shadow thing). (Once)

2) When a user logs in: get random data and encrypt it with the password,
this becomes the AES key. Store both the data and key in a secure way in
memory, e.g. using the existing kernel key infrastructure.

...

3) Suspend.
   (Encrypt snapshot with the AES key and store the random data.)

...

3) Ask for the passphrase.
   (To get the AES key, encrypt the stored random data.)

4) Resume.

Variants are possible of course, but this is the main idea.


This is secure because the key infrastructure is secure, and even if
it isn't the system must be compromised to get the suspend key before
the suspend is done. But at that point the attacker already has all
information that can be found in the suspend image, and could have done
all kind of things to inflict damage (like installing a key logger).

Advantage of this scheme is that it only need AES and can be done (mostly)
in kernel space. It's also faster and simpler than the current RSA scheme.
Disadvantage is that it wastes at least 32 bytes of memory when the system
is running, to store the data and key.

Only thing that needs to be done in userspace is setting the random data
and AES key, but there exist a suitable interface for that (the key system).
As user login is already done in user space, this can be integrated with
that in a nice way.

Greetings,

Indan


