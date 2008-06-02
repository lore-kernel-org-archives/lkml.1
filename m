Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbYFBKRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbYFBKRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYFBKQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:16:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:47090 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbYFBKQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:16:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=cdMsL85MZyCMo96CF+VcXL4weXhIt99Bl5UJ3BznSZI31eGKSYAZnVCeYsBDBtFx6A/fKy6I/yrhj6FrjFJ4MM8RTH4a4a//Byzs+HmM8mNdBOlqLNwCEpCCsmQyYP9eKYMFOT9Nu9bXJnsqEM/o2lCtLac1uBhsDvPLhs1JNmE=
Message-ID: <19f34abd0806020316v4135935dxff04bcf663ebd4bf@mail.gmail.com>
Date: Mon, 2 Jun 2008 12:16:56 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.25.3: su gets stuck for root
Cc: "David Newall" <davidn@davidnewall.com>, "Willy Tarreau" <w@1wt.eu>,
       "Harald Dunkel" <harald.dunkel@t-online.de>,
       "Joe Peterson" <joe@skyrush.com>, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@redhat.com>
In-Reply-To: <20080602102033.63e4cd18@core>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_8732_4497671.1212401816131"
References: <48434D57.6030801@skyrush.com> <48438126.3080308@t-online.de>
	 <20080602053256.GF5609@1wt.eu> <20080602091016.571dda7c@core>
	 <4843B6EE.8080104@davidnewall.com> <20080602102033.63e4cd18@core>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_8732_4497671.1212401816131
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, Jun 2, 2008 at 11:20 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Mon, 02 Jun 2008 18:31:34 +0930
> David Newall <davidn@davidnewall.com> wrote:
>
>> Alan Cox wrote:
>> > Not really. The task would get suspended if it attempted to change the
>> > tty settings while not being session leader. This is part of the POSIX
>> > and BSD job control.
>>
>> I haven't heard about this new restriction, but it begs the observation
>> that stty, when forked from a shell (the usual case), is never a session
>> leader.
>
> Sorry I mean part of the current session. I was thinking about the
> specific case of bash or the ssh->bash setup where the question would be
> whether the shell was session leader.
>
> Someone who can dup this needs to instrument it in tty_ioctl really.

Hi,

I have written a short test program that seems to reproduce it for me
(see attachment), even though the original su/stty stuff wouldn't.

Basically, the strace shows this:
ioctl(0, SNDCTL_TMR_START or TCSETS, {B38400 opost isig icanon echo
...}) = ? ERESTARTSYS (To be restarted)
--- SIGTTOU (Stopped (tty output)) @ 0 (0) ---
--- SIGTTOU (Stopped (tty output)) @ 0 (0) ---
ioctl(0, SNDCTL_TMR_START or TCSETS, {B38400 opost isig icanon echo
...}) = ? ERESTARTSYS (To be restarted)
--- SIGTTOU (Stopped (tty output)) @ 0 (0) ---
--- SIGTTOU (Stopped (tty output)) @ 0 (0) ---
... (repeating)

The exact code path triggering this seems to be:

tcsetattr() -> ioctl(TCSETS) -> set_termios() -> tty_check_change()

This is on a 2.6.24.5-85.fc8 kernel.

I don't know what's wrong, but I hope this helps.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

------=_Part_8732_4497671.1212401816131
Content-Type: text/x-csrc; name=reproduce.c
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fgywmk5e0
Content-Disposition: attachment; filename=reproduce.c

I2luY2x1ZGUgPHN5cy90eXBlcy5oPgojaW5jbHVkZSA8c3lzL3dhaXQuaD4KCiNpbmNsdWRlIDxl
cnJuby5oPgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8
c3RyaW5nLmg+CiNpbmNsdWRlIDx0ZXJtaW9zLmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KCmludApt
YWluKGludCBhcmdjLCBjaGFyICphcmd2W10pCnsKCXBpZF90IGNoaWxkOwoKCXByaW50ZigicGdp
ZCA9ICVkXG4iLCBnZXRwZ3JwKCkpOwoKCWNoaWxkID0gZm9yaygpOwoJaWYgKGNoaWxkID09IDAp
IHsKCQlzdHJ1Y3QgdGVybWlvcyB0ZXJtaW9zX3A7CgoJCXByaW50ZigiZm9ya2VkLCBwZ2lkID0g
JWRcbiIsIGdldHBncnAoKSk7CgoJCWlmIChzZXRwZ3JwKCkgPT0gLTEpIHsKCQkJcHJpbnRmKCJl
cnJvcjogc2V0cGdpZDogJXNcbiIsIHN0cmVycm9yKGVycm5vKSk7CgkJCWV4aXQoRVhJVF9GQUlM
VVJFKTsKCQl9CgoJCXByaW50ZigibmV3IHBnaWQgPSAlZFxuIiwgZ2V0cGdycCgpKTsKCgkJaWYg
KHRjZ2V0YXR0cihTVERJTl9GSUxFTk8sICZ0ZXJtaW9zX3ApID09IC0xKSB7CgkJCXByaW50Zigi
ZXJyb3I6IHRjZ2V0YXR0cjogJXNcbiIsIHN0cmVycm9yKGVycm5vKSk7CgkJCWV4aXQoRVhJVF9G
QUlMVVJFKTsKCQl9CgoJCWlmICh0Y3NldGF0dHIoU1RESU5fRklMRU5PLCAwLCAmdGVybWlvc19w
KSA9PSAtMSkgewoJCQlwcmludGYoImVycm9yOiB0Y3NldGF0dHI6ICVzXG4iLCBzdHJlcnJvcihl
cnJubykpOwoJCQlleGl0KEVYSVRfRkFJTFVSRSk7CgkJfQoKCQlleGl0KEVYSVRfU1VDQ0VTUyk7
Cgl9CgoJcHJpbnRmKCJmb3JrZWQsIGNoaWxkID0gJWRcbiIsIGNoaWxkKTsKCgl3aGlsZSAoMSkg
ewoJCXBpZF90IHBpZDsKCQlpbnQgc3RhdHVzOwoKCQlwaWQgPSB3YWl0KCZzdGF0dXMpOwoJCWlm
IChwaWQgPT0gLTEpIHsKCQkJcHJpbnRmKCJlcnJvcjogd2FpdDogJXNcbiIsIHN0cmVycm9yKGVy
cm5vKSk7CgkJCWV4aXQoRVhJVF9GQUlMVVJFKTsKCQl9CgoJCXByaW50ZigicGlkICVkIHN0YXR1
cyAlZFxuIiwgcGlkLCBzdGF0dXMpOwoJfQoKCXJldHVybiBFWElUX1NVQ0NFU1M7Cn0K
------=_Part_8732_4497671.1212401816131--
