Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbZFODso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbZFODso (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 23:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZFODse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 23:48:34 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:48938 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbZFODsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 23:48:33 -0400
Message-ID: <4A35C482.2040809@novell.com>
Date: Sun, 14 Jun 2009 23:48:18 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       Davide Libenzi <davidel@xmailserver.org>, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org
Subject: Re: [KVM PATCH v2 2/2] kvm: use POLLHUP to close an irqfd instead
 of an explicit ioctl
References: <20090604124047.10544.38861.stgit@dev.haskins.net> <20090604124812.10544.5811.stgit@dev.haskins.net> <20090614114854.GA10269@redhat.com> <4A34F2B7.1030606@novell.com> <20090614132843.GC10646@redhat.com>
In-Reply-To: <20090614132843.GC10646@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0084FA0596BD566535F9EC7A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0084FA0596BD566535F9EC7A
Content-Type: multipart/mixed;
 boundary="------------020303060803080608000304"

This is a multi-part message in MIME format.
--------------020303060803080608000304
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

[ restoring poor Davide's proper email address.  Sorry for the constant
fat-fingering of your addr, Davide! ]

Michael S. Tsirkin wrote:
> On Sun, Jun 14, 2009 at 08:53:11AM -0400, Gregory Haskins wrote:
>  =20
>> Michael S. Tsirkin wrote:
>>    =20
>>> On Thu, Jun 04, 2009 at 08:48:12AM -0400, Gregory Haskins wrote:
>>>  =20
>>>      =20
>>>> +static void
>>>> +irqfd_disconnect(struct _irqfd *irqfd)
>>>> +{
>>>> +	struct kvm *kvm;
>>>> +
>>>> +	mutex_lock(&irqfd->lock);
>>>> +
>>>> +	kvm =3D rcu_dereference(irqfd->kvm);
>>>> +	rcu_assign_pointer(irqfd->kvm, NULL);
>>>> +
>>>> +	mutex_unlock(&irqfd->lock);
>>>> +
>>>> +	if (!kvm)
>>>> +		return;
>>>> =20
>>>>  	mutex_lock(&kvm->lock);
>>>> -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
>>>> -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
>>>> +	list_del(&irqfd->list);
>>>>  	mutex_unlock(&kvm->lock);
>>>> +
>>>> +	/*
>>>> +	 * It is important to not drop the kvm reference until the next gr=
ace
>>>> +	 * period because there might be lockless references in flight up
>>>> +	 * until then
>>>> +	 */
>>>> +	synchronize_srcu(&irqfd->srcu);
>>>> +	kvm_put_kvm(kvm);
>>>>  }
>>>>    =20
>>>>        =20
>>> So irqfd object will persist after kvm goes away, until eventfd is cl=
osed?
>>>  =20
>>>      =20
>> Yep, by design.  It becomes part of the eventfd and is thus associated=

>> with its lifetime.  Consider it as if we made our own anon-fd
>> implementation for irqfd and the lifetime looks similar.  The differen=
ce
>> is that we are reusing eventfd and its interface semantics.
>>    =20
>>>  =20
>>>      =20
>>>> =20
>>>>  static int
>>>>  irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key=
)
>>>>  {
>>>>  	struct _irqfd *irqfd =3D container_of(wait, struct _irqfd, wait);
>>>> +	unsigned long flags =3D (unsigned long)key;
>>>> =20
>>>> -	/*
>>>> -	 * The wake_up is called with interrupts disabled.  Therefore we n=
eed
>>>> -	 * to defer the IRQ injection until later since we need to acquire=
 the
>>>> -	 * kvm->lock to do so.
>>>> -	 */
>>>> -	schedule_work(&irqfd->work);
>>>> +	if (flags & POLLIN)
>>>> +		/*
>>>> +		 * The POLLIN wake_up is called with interrupts disabled.
>>>> +		 * Therefore we need to defer the IRQ injection until later
>>>> +		 * since we need to acquire the kvm->lock to do so.
>>>> +		 */
>>>> +		schedule_work(&irqfd->inject);
>>>> +
>>>> +	if (flags & POLLHUP) {
>>>> +		/*
>>>> +		 * The POLLHUP is called unlocked, so it theoretically should
>>>> +		 * be safe to remove ourselves from the wqh using the locked
>>>> +		 * variant of remove_wait_queue()
>>>> +		 */
>>>> +		remove_wait_queue(irqfd->wqh, &irqfd->wait);
>>>> +		flush_work(&irqfd->inject);
>>>> +		irqfd_disconnect(irqfd);
>>>> +
>>>> +		cleanup_srcu_struct(&irqfd->srcu);
>>>> +		kfree(irqfd);
>>>> +	}
>>>> =20
>>>>  	return 0;
>>>>  }
>>>>    =20
>>>>        =20
>>> And it is removed by this function when eventfd is closed.
>>> But what prevents the kvm module from going away, meanwhile?
>>>  =20
>>>      =20
>> Well, we hold a reference to struct kvm until we call
>> irqfd_disconnect().  If kvm closes first, we disconnect and disassocia=
te
>> all references to kvm leaving irqfd->kvm =3D NULL.  Likewise, if irqfd=

>> closes first, we disassociate with kvm with the above quoted logic.  I=
n
>> either case, we are holding a kvm reference up until that "disconnect"=

>> point.  Therefore kvm should not be able to disappear before that
>> disconnect, and after that point we do not care.
>>    =20
>
> Yes, we do care.
>
> Here's the scenario in more detail:
>
> - kvm is closed
> - irq disconnect is called
> - kvm is put
> - kvm module is removed: all irqs are disconnected
> - eventfd closes and triggers callback into removed kvm module
> - crash
>  =20

[ lightbulb turns on]

Ah, now I see the point you were making.  I thought you were talking
about the .text in kvm_set_irq() (which would be protected by my
kvm_get_kvm() reference afaict).  But you are actually talking about the
irqfd .text itself.  Indeed, you are correct that is this currently a
race.  Good catch!

>  =20
>> If that is not sufficient to prevent kvm.ko from going away in the
>> middle, then IMO kvm_get_kvm() has a bug, not irqfd. ;) However, I
>> believe everything is actually ok here.
>>
>> -Greg
>>
>>    =20
>
>
> BTW, why can't we remove irqfds in kvm_release?
>  =20

Well, this would be ideal but we run into that bi-directional reference
thing that we talked about earlier and we both agree is non-trivial to
solve.  Solving this locking problem would incidentally also pave the
way for restoring the DEASSIGN feature, so patches welcome!  In the
meantime, I think we can close the hole you found with the following
patch (build-tested only):

commit f3a8dccc9e815599438e9feb0ea53e8eb10ad2b3
Author: Gregory Haskins <ghaskins@novell.com>
Date:   Sun Jun 14 23:37:49 2009 -0400

    KVM: make irqfd take kvm.ko module reference

    Michael Tsirkin pointed out that we currently have a race between
someone
    holding an irqfd reference and an rmmod against kvm.ko.  This patch
closes
    that hole by making sure that irqfd holds a kvm.ko reference for its
lifetime.

    Found-by: Michael S. Tsirkin <mst@redhat.com>
    Signed-off-by: Gregory Haskins <ghaskins@novell.com>

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 2c8028c..67e4eca 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -29,6 +29,7 @@
 #include <linux/list.h>
 #include <linux/eventfd.h>
 #include <linux/srcu.h>
+#include <linux/module.h>

 /*
  * --------------------------------------------------------------------
@@ -123,6 +124,7 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int
sync, void
 *key)

                cleanup_srcu_struct(&irqfd->srcu);
                kfree(irqfd);
+               module_put(THIS_MODULE);
        }

        return 0;
@@ -176,6 +178,7 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags=
)
        if (ret < 0)
                goto fail;

+       __module_get(THIS_MODULE);
        kvm_get_kvm(kvm);

        mutex_lock(&kvm->lock);





--------------020303060803080608000304
Content-Type: application/pgp-signature;
 name="signature.asc"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="signature.asc"

LS0tLS1CRUdJTiBQR1AgU0lHTkFUVVJFLS0tLS0KVmVyc2lvbjogR251UEcvTWFjR1BHMiB2
Mi4wLjExIChEYXJ3aW4pCkNvbW1lbnQ6IFVzaW5nIEdudVBHIHdpdGggTW96aWxsYSAtIGh0
dHA6Ly9lbmlnbWFpbC5tb3pkZXYub3JnCgppRVlFQVJFQ0FBWUZBa28xd21rQUNna1FsT1NP
QmRnWlV4azQ5Z0NmYlhISzcybFg2MGNLNzZQZEgweU0zME40ClJUa0FuM0pMMTA3VG1iN3pV
K2Zvd2RzbElzVDBTbTRlCj1oSElmCi0tLS0tRU5EIFBHUCBTSUdOQVRVUkUtLS0tLQoK
--------------020303060803080608000304--

--------------enig0084FA0596BD566535F9EC7A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko1xIIACgkQlOSOBdgZUxnKZACdGNW7lxTB8FBEvW/vJoLozYVh
MosAn1RhrgQZkXlayjiJvE88AhPMXbUM
=4hKh
-----END PGP SIGNATURE-----

--------------enig0084FA0596BD566535F9EC7A--
