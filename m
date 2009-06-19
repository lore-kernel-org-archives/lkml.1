Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbZFSVuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbZFSVuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 17:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZFSVt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 17:49:56 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:55836 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbZFSVtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 17:49:55 -0400
Message-ID: <4A3C07FF.3000406@novell.com>
Date: Fri, 19 Jun 2009 17:49:51 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: mst@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix notifier
 race conditions
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <20090619185138.31118.14916.stgit@dev.haskins.net> <alpine.DEB.1.10.0906191156580.14884@makko.or.mcafeemobile.com> <4A3C004B.8010706@novell.com> <alpine.DEB.1.10.0906191421581.14884@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906191421581.14884@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig787894C6B79601864AB16DD9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig787894C6B79601864AB16DD9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Fri, 19 Jun 2009, Gregory Haskins wrote:
>
>  =20
>> Davide Libenzi wrote:
>>    =20
>>> On Fri, 19 Jun 2009, Gregory Haskins wrote:
>>>
>>>  =20
>>>      =20
>>>> eventfd currently emits a POLLHUP wakeup on f_ops->release() to gene=
rate a
>>>> notifier->release() callback.  This lets notification clients know i=
f
>>>> the eventfd is about to go away and is very useful particularly for
>>>> in-kernel clients.  However, as it stands today it is not possible t=
o
>>>> use the notification API in a race-free way.  This patch adds some
>>>> additional logic to the notification subsystem to rectify this probl=
em.
>>>>
>>>> Background:
>>>> -----------------------
>>>> Eventfd currently only has one reference count mechanism: fget/fput.=
  This
>>>> in of itself is normally fine.  However, if a client expects to be
>>>> notified if the eventfd is closed, it cannot hold a fget() reference=

>>>> itself or the underlying f_ops->release() callback will never be inv=
oked
>>>> by VFS.  Therefore we have this somewhat unusual situation where we =
may
>>>> hold a pointer to an eventfd object (by virtue of having a waiter re=
gistered
>>>> in its wait-queue), but no reference.  This makes it nearly impossib=
le to
>>>> design a mutual decoupling algorithm: you cannot unhook one side fro=
m the
>>>> other (or vice versa) without racing.
>>>>    =20
>>>>        =20
>>> And why is that?
>>>
>>> struct xxx {
>>> 	struct mutex mtx;
>>> 	struct file *file;
>>> 	...
>>> };
>>>
>>> struct file *xxx_get_file(struct xxx *x) {
>>> 	struct file *file;
>>>
>>> 	mutex_lock(&x->mtx);
>>> 	file =3D x->file;
>>> 	if (!file)
>>> 		mutex_unlock(&x->mtx);
>>> 	return file;
>>> }
>>>
>>> void xxx_release_file(struct xxx *x) {
>>> 	mutex_unlock(&x->mtx);
>>> }
>>>
>>> void handle_POLLHUP(struct xxx *x) {
>>> 	struct file *file;
>>>
>>> 	file =3D xxx_get_file(x);
>>> 	if (file) {
>>> 		unhook_waitqueue(file, ...);
>>> 		x->file =3D NULL;
>>> 		xxx_release_file(x);
>>> 	}
>>> }
>>>
>>>
>>> Every time you need to "use" file, you call xxx_get_file(), and if yo=
u get=20
>>> NULL, it means it's gone and you handle it accordigly to your IRQ fd =

>>> policies. As soon as you done with the file, you call xxx_release_fil=
e().
>>> Replace "mtx" with the lock that fits your needs.
>>>  =20
>>>      =20
>> Consider what would happen if the f_ops->release() was preempted insid=
e
>> the wake_up_locked_polled() after it dereferenced the xxx from the lis=
t,
>> but before it calls the callback(POLLHUP).  The xxx object, and/or the=

>> .text for the xxx object may be long gone by the time it comes back
>> around.  Afaict, there is no way to guard against that scenario unless=

>> you do something like 2/3+3/3.  Or am I missing something?
>>    =20
>
> Right. Don't you see an easier answer to that, instead of adding 300 li=
nes=20
> of code to eventfd?
>  =20

I tried, but this problem made my head hurt and this was what I came up
with that I felt closes the holes all the way.  Also keep in mind that
while I added X lines to eventfd, I took Y lines *out* of irqfd in the
process, too.  I just excluded the KVM portions in this thread per your
request, so its not apparent.  But technically, any other clients that
may come along can reuse that notification code instead of coding it
again.  One way or the other, *someone* has to do that ptable_proc stuff
;)  FYI: Its more like 133 lines, fwiw.

fs/eventfd.c            |  104
++++++++++++++++++++++++++++++++++++++++++++----
 include/linux/eventfd.h |   36 ++++++++++++++++
 2 files changed, 133 insertions(+), 7 deletions(-)

In case you care, heres what the complete solution when I include KVM
currently looks like:

 fs/eventfd.c            |  104 +++++++++++++++++++++++++--
 include/linux/eventfd.h |   36 +++++++++
 virt/kvm/eventfd.c      |  181
+++++++++++++++++++++++++-----------------------
 3 files changed, 228 insertions(+), 93 deletions(-)

> For example, turning wake_up_locked() into a nornal wake_up().
>  =20

I am fairly confident it is not that simple after having thought about
this issue over the last few days.  But I've been wrong in the past.=20
Propose a patch and I will review it for races/correctness, if you
like.  Perhaps a combination of that plus your asymmetrical locking
scheme would work.  One of the challenges you will hit is avoiding ABBA
between your "get" lock and the wqh, but good luck!

-Greg



--------------enig787894C6B79601864AB16DD9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko8B/8ACgkQlOSOBdgZUxnLowCggnVa61D1QEV9vwpVh3GINT9s
L+4AnjfzUo45GHZQlUeUiJv3WIdTEb14
=INYq
-----END PGP SIGNATURE-----

--------------enig787894C6B79601864AB16DD9--
