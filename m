Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbZGFO4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbZGFO4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 10:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbZGFO4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 10:56:24 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:33338 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbZGFO4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 10:56:23 -0400
Message-ID: <4A521082.40209@novell.com>
Date: Mon, 06 Jul 2009 10:56:02 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
       davidel@xmailserver.org
Subject: Re: [KVM PATCH v9 0/5] irqfd fixes and enhancements
References: <20090702153454.20186.99191.stgit@dev.haskins.net> <4A4CD729.6050300@redhat.com> <4A50723E.6030305@redhat.com>
In-Reply-To: <4A50723E.6030305@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0E7207E462280C681F871BD9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0E7207E462280C681F871BD9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 07/02/2009 06:50 PM, Avi Kivity wrote:
>> On 07/02/2009 06:37 PM, Gregory Haskins wrote:
>>> (Applies to kvm.git/master:1f9050fd)
>>>
>>> The following is the latest attempt to fix the races in
>>> irqfd/eventfd, as
>>> well as restore DEASSIGN support.  For more details, please read the
>>> patch
>>> headers.
>>>
>>> As always, this series has been tested against the kvm-eventfd unit
>>> test
>>> and everything appears to be functioning properly. You can download
>>> this
>>> test here:
>>
>> Applied, thanks.
>>
>
> ... and unapplied.  There's a refcounting mismatch in irqfd_cleanup: a
> reference is taken for each irqfd, but dropped for each guest.  This
> causes an oops if a guest with no irqfds is created and destroyed:

I was able to reproduce this issue.  The problem turned out to be that I
inadvertently always did a flush_workqueue(), even if the work-queue was
never initialized.  =20

The following interdiff applied to the reverted patch has been confirmed
to fix the issue:

-------------------

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index fcc3469..52b0e04 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -318,6 +318,9 @@ kvm_irqfd_deassign(struct kvm *kvm, int fd, int gsi)
        struct _irqfd *irqfd, *tmp;
        struct eventfd_ctx *eventfd;
=20
+       if (!kvm->irqfds.init)
+               return -ENOENT;
+
        eventfd =3D eventfd_ctx_fdget(fd);
        if (IS_ERR(eventfd))
                return PTR_ERR(eventfd);
@@ -360,6 +363,9 @@ kvm_irqfd_release(struct kvm *kvm)
 {
        struct _irqfd *irqfd, *tmp;
=20
+       if (!kvm->irqfds.init)
+               return;
+
        spin_lock_irq(&kvm->irqfds.lock);
=20
        list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds.items, list)

---------------------

You can pick up this fix folded into the original v9:5/5 patch here:

git pull
git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/linux-2.6-hacks.gi=
t
for-avi

Sorry for the sloppy patch in v9. :(  Will strive to do better next time.=


Regards,
-Greg


--------------enig0E7207E462280C681F871BD9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpSEIYACgkQlOSOBdgZUxkyewCfU7ogOaoTPN6x5hY9khDoCYIL
ab8An0jfnsyz2DIYOv+KBpueXS+iedyq
=gO+N
-----END PGP SIGNATURE-----

--------------enig0E7207E462280C681F871BD9--
