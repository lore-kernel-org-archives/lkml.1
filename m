Return-Path: <linux-kernel-owner+w=401wt.eu-S1760276AbZFOMId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760276AbZFOMId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755206AbZFOMIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:08:24 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:48741 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbZFOMIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:08:23 -0400
Message-ID: <4A3639B2.7080006@novell.com>
Date: Mon, 15 Jun 2009 08:08:18 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org
Subject: Re: [KVM PATCH v2 2/2] kvm: use POLLHUP to close an irqfd instead
 of an explicit ioctl
References: <20090604124047.10544.38861.stgit@dev.haskins.net> <20090604124812.10544.5811.stgit@dev.haskins.net> <20090614114854.GA10269@redhat.com> <4A34F2B7.1030606@novell.com> <20090614132843.GC10646@redhat.com> <4A35C269.7050209@novell.com> <20090615094650.GA4949@redhat.com>
In-Reply-To: <20090615094650.GA4949@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9B5AAEFCA782688D342682BF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9B5AAEFCA782688D342682BF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Sun, Jun 14, 2009 at 11:39:21PM -0400, Gregory Haskins wrote:
>  =20
>> Michael S. Tsirkin wrote:
>>    =20
>>> On Sun, Jun 14, 2009 at 08:53:11AM -0400, Gregory Haskins wrote:
>>>  =20
>>>      =20
>>>> Michael S. Tsirkin wrote:
>>>>    =20
>>>>        =20
>>>>> On Thu, Jun 04, 2009 at 08:48:12AM -0400, Gregory Haskins wrote:
>>>>>  =20
>>>>>      =20
>>>>>          =20
>>>>>> +static void
>>>>>> +irqfd_disconnect(struct _irqfd *irqfd)
>>>>>> +{
>>>>>> +	struct kvm *kvm;
>>>>>> +
>>>>>> +	mutex_lock(&irqfd->lock);
>>>>>> +
>>>>>> +	kvm =3D rcu_dereference(irqfd->kvm);
>>>>>> +	rcu_assign_pointer(irqfd->kvm, NULL);
>>>>>> +
>>>>>> +	mutex_unlock(&irqfd->lock);
>>>>>> +
>>>>>> +	if (!kvm)
>>>>>> +		return;
>>>>>> =20
>>>>>>  	mutex_lock(&kvm->lock);
>>>>>> -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
>>>>>> -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
>>>>>> +	list_del(&irqfd->list);
>>>>>>  	mutex_unlock(&kvm->lock);
>>>>>> +
>>>>>> +	/*
>>>>>> +	 * It is important to not drop the kvm reference until the next =
grace
>>>>>> +	 * period because there might be lockless references in flight u=
p
>>>>>> +	 * until then
>>>>>> +	 */
>>>>>> +	synchronize_srcu(&irqfd->srcu);
>>>>>> +	kvm_put_kvm(kvm);
>>>>>>  }
>>>>>>    =20
>>>>>>        =20
>>>>>>            =20
>>>>> So irqfd object will persist after kvm goes away, until eventfd is =
closed?
>>>>>  =20
>>>>>      =20
>>>>>          =20
>>>> Yep, by design.  It becomes part of the eventfd and is thus associat=
ed
>>>> with its lifetime.  Consider it as if we made our own anon-fd
>>>> implementation for irqfd and the lifetime looks similar.  The differ=
ence
>>>> is that we are reusing eventfd and its interface semantics.
>>>>    =20
>>>>        =20
>>>>>  =20
>>>>>      =20
>>>>>          =20
>>>>>> =20
>>>>>>  static int
>>>>>>  irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *k=
ey)
>>>>>>  {
>>>>>>  	struct _irqfd *irqfd =3D container_of(wait, struct _irqfd, wait)=
;
>>>>>> +	unsigned long flags =3D (unsigned long)key;
>>>>>> =20
>>>>>> -	/*
>>>>>> -	 * The wake_up is called with interrupts disabled.  Therefore we=
 need
>>>>>> -	 * to defer the IRQ injection until later since we need to acqui=
re the
>>>>>> -	 * kvm->lock to do so.
>>>>>> -	 */
>>>>>> -	schedule_work(&irqfd->work);
>>>>>> +	if (flags & POLLIN)
>>>>>> +		/*
>>>>>> +		 * The POLLIN wake_up is called with interrupts disabled.
>>>>>> +		 * Therefore we need to defer the IRQ injection until later
>>>>>> +		 * since we need to acquire the kvm->lock to do so.
>>>>>> +		 */
>>>>>> +		schedule_work(&irqfd->inject);
>>>>>> +
>>>>>> +	if (flags & POLLHUP) {
>>>>>> +		/*
>>>>>> +		 * The POLLHUP is called unlocked, so it theoretically should
>>>>>> +		 * be safe to remove ourselves from the wqh using the locked
>>>>>> +		 * variant of remove_wait_queue()
>>>>>> +		 */
>>>>>> +		remove_wait_queue(irqfd->wqh, &irqfd->wait);
>>>>>> +		flush_work(&irqfd->inject);
>>>>>> +		irqfd_disconnect(irqfd);
>>>>>> +
>>>>>> +		cleanup_srcu_struct(&irqfd->srcu);
>>>>>> +		kfree(irqfd);
>>>>>> +	}
>>>>>> =20
>>>>>>  	return 0;
>>>>>>  }
>>>>>>    =20
>>>>>>        =20
>>>>>>            =20
>>>>> And it is removed by this function when eventfd is closed.
>>>>> But what prevents the kvm module from going away, meanwhile?
>>>>>  =20
>>>>>      =20
>>>>>          =20
>>>> Well, we hold a reference to struct kvm until we call
>>>> irqfd_disconnect().  If kvm closes first, we disconnect and disassoc=
iate
>>>> all references to kvm leaving irqfd->kvm =3D NULL.  Likewise, if irq=
fd
>>>> closes first, we disassociate with kvm with the above quoted logic. =
 In
>>>> either case, we are holding a kvm reference up until that "disconnec=
t"
>>>> point.  Therefore kvm should not be able to disappear before that
>>>> disconnect, and after that point we do not care.
>>>>    =20
>>>>        =20
>>> Yes, we do care.
>>>
>>> Here's the scenario in more detail:
>>>
>>> - kvm is closed
>>> - irq disconnect is called
>>> - kvm is put
>>> - kvm module is removed: all irqs are disconnected
>>> - eventfd closes and triggers callback into removed kvm module
>>> - crash
>>>  =20
>>>      =20
>> [ lightbulb turns on]
>>
>> Ah, now I see the point you were making.  I thought you were talking
>> about the .text in kvm_set_irq() (which would be protected by my
>> kvm_get_kvm() reference afaict).  But you are actually talking about t=
he
>> irqfd .text itself.  Indeed, you are correct that is this currently a
>> race.  Good catch!
>>
>>    =20
>>>  =20
>>>      =20
>>>> If that is not sufficient to prevent kvm.ko from going away in the
>>>> middle, then IMO kvm_get_kvm() has a bug, not irqfd. ;) However, I
>>>> believe everything is actually ok here.
>>>>
>>>> -Greg
>>>>
>>>>    =20
>>>>        =20
>>> BTW, why can't we remove irqfds in kvm_release?
>>>  =20
>>>      =20
>> Well, this would be ideal but we run into that bi-directional referenc=
e
>> thing that we talked about earlier and we both agree is non-trivial to=

>> solve.  Solving this locking problem would incidentally also pave the
>> way for restoring the DEASSIGN feature, so patches welcome!
>>    =20
>
> So far the only workable approach that I see is reverting the POLLHUP
> patch. I agree it looks pretty, but DEASSIGN and closing the races is
> more important IMO. And locking will definitely become much simpler.
>
>  =20
>> In the meantime, I think we can close the hole you found with the
>> following patch (build-tested only):
>>
>> commit f3a8dccc9e815599438e9feb0ea53e8eb10ad2b3
>> Author: Gregory Haskins <ghaskins@novell.com>
>> Date:   Sun Jun 14 23:37:49 2009 -0400
>>
>>     KVM: make irqfd take kvm.ko module reference
>>   =20
>>     Michael Tsirkin pointed out that we currently have a race between =
someone
>>     holding an irqfd reference and an rmmod against kvm.ko.  This patc=
h closes
>>     that hole by making sure that irqfd holds a kvm.ko reference for i=
ts lifetime.
>>   =20
>>     Found-by: Michael S. Tsirkin <mst@redhat.com>
>>     Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>>
>> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
>> index 2c8028c..67e4eca 100644
>> --- a/virt/kvm/eventfd.c
>> +++ b/virt/kvm/eventfd.c
>> @@ -29,6 +29,7 @@
>>  #include <linux/list.h>
>>  #include <linux/eventfd.h>
>>  #include <linux/srcu.h>
>> +#include <linux/module.h>
>> =20
>>  /*
>>   * ------------------------------------------------------------------=
--
>> @@ -123,6 +124,7 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, in=
t
>> sync, void
>>  *key)
>> =20
>>                 cleanup_srcu_struct(&irqfd->srcu);
>>                 kfree(irqfd);
>> +               module_put(THIS_MODULE);
>>         }
>> =20
>>         return 0;
>>    =20
>
> module_put(THIS_MODULE) is always a bug unless you know that someone ha=
s
> a reference to the current module: the module could go away between thi=
s
> call and returning from function.
>  =20

Hmm.  I understand what you are saying conceptually (i.e. the .text
could get yanked before we hit the next line of code, in this case the
"return 0").  However, holding a reference when you _know_ someone else
holds a reference to me says that one of the references is redundant.=20
In addition, there is certainly plenty of precedence for
module_put(THIS_MODULE) all throughout the kernel (including
module_put_and_exit()).  Are those broken as well?

In any case, one of the patches I have in queue to push to Davide for
eventfd may provide a good solution to this problem as well, so I will
get that polished up today.

Thanks Michael,
-Greg

>  =20
>> @@ -176,6 +178,7 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int fl=
ags)
>>         if (ret < 0)
>>                 goto fail;
>> =20
>> +       __module_get(THIS_MODULE);
>>         kvm_get_kvm(kvm);
>> =20
>>         mutex_lock(&kvm->lock);
>>
>>
>>
>>    =20
>
>
>  =20



--------------enig9B5AAEFCA782688D342682BF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko2ObMACgkQlOSOBdgZUxmFhACeMzAadLJ4a2eoO8+pn40V0Bb1
7HEAnRkxm/ORljgday5h+zKghbRTgFds
=Xsa7
-----END PGP SIGNATURE-----

--------------enig9B5AAEFCA782688D342682BF--
