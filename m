Return-Path: <linux-kernel-owner+w=401wt.eu-S1752457AbZJTFbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbZJTFbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 01:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbZJTFbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 01:31:24 -0400
Received: from ozlabs.org ([203.10.76.45]:41051 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbZJTFbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 01:31:23 -0400
Subject: Re: Characters vanishing in the tty layer? (maybe related to [Bug
 #14388] keyboard under X with 2.6.31)
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Michael Neuling <mikey@neuling.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <alpine.LFD.2.00.0910200245330.13080@eeepc.linux-foundation.org>
References: <1255501294.21962.24.camel@concordia>
	 <alpine.LFD.2.01.0910140748420.6146@localhost.localdomain>
	 <1255934287.4192.125.camel@concordia>
	 <alpine.LFD.2.00.0910200245330.13080@eeepc.linux-foundation.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Dj7eXjEUnyvfUHfkaE1e"
Date: Tue, 20 Oct 2009 16:31:23 +1100
Message-Id: <1256016683.5992.20.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Dj7eXjEUnyvfUHfkaE1e
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-10-20 at 03:09 +0900, Linus Torvalds wrote:
>=20
> On Mon, 19 Oct 2009, Michael Ellerman wrote:
> >=20
> > As Benh said it's not really bisectable on our kernel. But I got Mikey
> > to bisect it on upstream using a different simulator model, and he
> > couldn't tie it down. It becomes easier to hit in more recent kernels
> > (since 27), but he could hit in 25 too.
>=20
> Ok, thanks to the verification.
>=20
> And I think I see why it got easier to hit lately, and to some degree I=20
> think we can at least partially avoid it:
>=20
> >       * hvc_console reads all our input and passes it to the tty code
> >         via tty_insert_flip_char()
> >       * flush_to_ldisc() runs calling n_tty_receive_buf(), which fills
> >         4K of tty->read_buf
> >       * Once read_buf is full, tty->receive_room becomes 0 and
> >         flush_to_ldisc() reschedules itself to run again in 1 jiffy.
> >       * Bash reads 1 character, causing receive_room to become 1.
> >       * flush_to_ldisc() runs again and inserts 1 more char because
> >         receive_room is now 1.
>=20
> .. ok, I agree that our behavior in the "buffer full" case is likely not=20
> wonderful. And that's especially true in the 'icanon' case..
>=20
> >       * (repeat the last two steps a few times)
> >       * Bash sets tty->icanon =3D 1 via n_tty_set_termios(), which call=
s
> >         n_tty_set_room(). Because icanon is enabled, n_tty_set_room()
> >         lies and says we have space for 1 character even though we
> >         don't.
>=20
> So just to clarify - icanon wasn't set before?

It wasn't set before.

> >       * flush_to_ldisc() runs, sees that receive_room is 1 and calls
> >         n_tty_receive_buf()
> >       * n_tty_receive_buf() calls n_tty_receive_char() which drops the
> >         character because there's no room (~ line 1132).
> >       * We keep dropping characters until we see a newline, which
> >         increments tty->canon_data, causing n_tty_set_room() to report =
0
> >         space left, and so flush_to_ldisc() reschedules again.
>=20
> Did you have newlines in the big bulk dump?

Yes. It's not really a bulk dump, it's just a bit over 4K of shell
script that we're writing into the console to run a test. So lots of
newlines.

> If there really aren't any newlines, I don't think we can do a lot. icano=
n=20
> handling kind of fundamentally doesn't work if there is no newline at all=
,=20
> since it is all about line buffering, and we obviously have to limit the=20
> lines _somewhere_.

Right that makes sense. But shouldn't be the case here.

> But I also thihk that we only update that whole 'canon_data' thing if we=20
> _received_ the newlines while we were in icanon mode (but I didn't really=
=20
> check very closely), so if we actually switch from -icanon to +icanon, I=20
> think canon_data can be confused, and we thus handle the buffer-full case=
=20
> worse than we _could_ have.

Yeah I think that's right. n_tty_set_termios() always sets canon_data to
0 when there is a canon change, in either direction. And I don't see
anything else will fix it.

> > It's a bit unfortunate that n_tty_set_room() lies about the available
> > space when icanon =3D 1, but it makes sense in order to handle erase. I=
t
> > would be nice if n_tty_receive_buf() returned a status to
> > flush_to_disc() to say "actually I could only fit X chars after all,
> > please take them back" - but I don't grok how that would play with all
> > the other logic in there.
>=20
> Yeah, I don't think that is even worth it. The thing is, we do have to=20
> start dropping characters at some point, so trying to extend the non-drop=
=20
> case just moves it somewhere else. If you are in canon mode, and the line=
=20
> is longer than <some-number-that-happens-to-be-4kB>, you're basically=20
> screwed.

Agreed.

> But what we _might_ do is to handle the "turn on canon mode" case better,=
=20
> in case the old buffer had newlines. IOW, instead of always setting=20
> 'canon_data' to 0 when icanon changes (and setting canon_head to the tail=
=20
> of the data), maybe we should simply _count_ the number of newlines (and=20
> set canon_head to the last one in the buffer).
>=20
> IOW, if you do have newlines in your bulk data before icanon got set, we=20
> could probably make n_tty handle that case better.

Yeah I think that is the root cause of my bug. There are plenty of lines
in my buffer, so n_tty_set_room() should not be accepting more data.

> That said, as far as I know, the tty layer behavior in this area has=20
> basically always been the way it is. The fact that you can see it more=20
> easily is almost certainly just related to just how the buffers that lead=
=20
> up to flush_to_ldisc have grown, and are now allowed to fill up further.=20
> So it probably got much easier to trigger, but it is likely not in any wa=
y=20
> a really new case, and goes back not just to 2.6.25, but probably=20
> forever...

Yeah, we only stopped at 25 because our toolchain was too new :}

> I wonder a bit what in your particular environment makes this problem sho=
w=20
> up, but I assume that your simulation environment ends up just blindly=20
> stuffing the tty buffers through the virtual console, so you basically=20
> have "simulated typing" that was (a) started long before the reader was=20
> interested in accepting it and (b) was a huge dump rather than what any=20
> real load would be.

Yes and no. (a) doesn't seem to apply, no amount of delay before
starting the input makes a difference. And (b) only sort of. I don't
think a bit more than 4K is a ridiculous amount to stuff down a console.
Though I guess we're "typing" at a ridiculous speed.

> But if you change n_tty_set_termios() to count newlines when it sets=20
> icanon, you might get the behaviour you want, and it would seem to me to=20
> be an improvement over what we have now, so I wouldn't object to it, even=
=20
> if I suspect nobody else has ever cared, and would ever care in the=20
> future.

Clearly no one has ever cared before :)  I'll have a look if I can come
up with a neat fix.

cheers

--=-Dj7eXjEUnyvfUHfkaE1e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrdSysACgkQdSjSd0sB4dKKQQCglnukbr8KVAqz8aCXaumBSY7I
WhIAn1RZiTOpLEJ8SBcTPEiePUEIX9qH
=zt7p
-----END PGP SIGNATURE-----

--=-Dj7eXjEUnyvfUHfkaE1e--

