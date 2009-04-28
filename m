Return-Path: <linux-kernel-owner+w=401wt.eu-S1760776AbZD1LjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760776AbZD1LjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 07:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757399AbZD1LjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 07:39:04 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:52565 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605AbZD1LjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 07:39:03 -0400
Message-ID: <49F6EACA.3050808@novell.com>
Date: Tue, 28 Apr 2009 07:38:50 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v2 2/2] kvm: add support for irqfd via	eventfd-notification
 interface
References: <20090424042142.1796.60756.stgit@dev.haskins.net> <20090424042518.1796.65593.stgit@dev.haskins.net> <49F572EF.4010909@redhat.com> <49F58A8C.7090808@novell.com> <49F58D75.7040304@redhat.com> <49F5B2DA.5060207@novell.com> <49F6CDFC.6000400@redhat.com> <49F6DB9D.3080501@novell.com> <49F6E1CA.1010106@redhat.com> <49F6E2BB.9070604@novell.com> <49F6E313.7020502@redhat.com> <49F6E3B2.5010306@redhat.com>
In-Reply-To: <49F6E3B2.5010306@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig09B4623EDC6004627F789419"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig09B4623EDC6004627F789419
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Avi Kivity wrote:
>>>
>>> So what is your proposal for such interface?
>>>
>>>  =20
>>
>> ->write().
>>
>
> Alternatively, a new fileop ->signal_event(), which would map to
> eventfd_signal() or irqfd_signal().  This would be defined to work in
> irq contexts.  It may also be useful for uio interrupts.
>
Hmm...I'm not crazy about either of those.  write() has obvious
limitations both from a interrupt execution context, as well as the
awkwardness of dealing with creating+passing a viable "userspace"
pointer from kernel code.  On the other hand, a new fileop doesn't quite
seem appropriate either since it doesn't apply to the overall fileop
abstraction very well.

We could potentially have a separate vtable interface just for
event-type fds, and make eventfd and irqfd the first implementations.=20
But I am not sure it is worth it.  What I suggest is that we work within
the existing eventfd interface.  It was designed specifically to signal
events, after all.

If at some point in the future we need to ensure that the callbacks are
not invoked from a preempt-off/irq-off critical section, we can revist
the eventfd internals at that time.  Note that since we would like to
support signaling from interrupt context anyway, trying to get rid of
the wqh critical section that we have today may be a fools errand (*).=20
Instead, we should probably focus on making the injection path support
non-preemptible contexts, as this will have the biggest benefits and
gains in the long run.

Thoughts?
-Greg

(*) The biggest benefit is that you can do tricks like
                                  "if (preemptible()) do_it_now(); else
do_it_later();"



--------------enig09B4623EDC6004627F789419
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkn26soACgkQlOSOBdgZUxkfHACdF3xSUogxZJVfQN6APSBwmHug
0kQAoINhdb7XKp/jlUekwLr2Zx5JCCkl
=XZYu
-----END PGP SIGNATURE-----

--------------enig09B4623EDC6004627F789419--
