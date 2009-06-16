Return-Path: <linux-kernel-owner+w=401wt.eu-S1757853AbZFPSJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853AbZFPSJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZFPSJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:09:47 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:43589 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbZFPSJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:09:46 -0400
Message-ID: <4A37DFE2.2020506@novell.com>
Date: Tue, 16 Jun 2009 14:09:38 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, paulmck@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based	notifier
 interface
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com> <4A37A7FC.4090403@novell.com> <20090616143816.GA18196@redhat.com> <4A37B0BB.3020005@novell.com> <20090616145502.GA1102@redhat.com> <4A37B832.6040206@novell.com> <20090616154150.GA17494@redhat.com> <4A37C592.2030407@novell.com> <20090616175300.GA24514@redhat.com>
In-Reply-To: <20090616175300.GA24514@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1BBB43D6002560D84A34E3ED"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1BBB43D6002560D84A34E3ED
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Tue, Jun 16, 2009 at 12:17:22PM -0400, Gregory Haskins wrote:
>  =20
>>> Maybe I misunderstand what iosignalfd is - isn't it true that you get=
 eventfd
>>> and kvm will signal that when guest performs io write to a specific
>>> address, and then drivers can get eventfd and poll it to detect
>>> these writes?
>>>  =20
>>>      =20
>> Correct.
>>
>>    =20
>>> If yes, you have no way to know that the other end of eventfd
>>> is connected to kvm, so you don't know you can access current->mm.
>>>  =20
>>>      =20
>> Well, my intended use for them *does* know its connected to KVM.=20
>>    =20
>
> How does it know? You get a file descriptor and you even figure out it'=
s an
> eventfd. Now what? Any process can write there.
>  =20

Well, I suppose that is true.  Unlike my current hypercall coupling
deployed in vbus v3, anyone can signal the event for the iosignalfd.=20
However, it wouldn't matter other than looking like an errant signal as
I do not use "current" for anything. (e.g. all the virtio pointers are
stored independently to the iosignalfd)
>  =20
>> Perhaps there will be others that do not in the future, but like I sai=
d
>> it could be addressed as those actually arise.
>>
>>
>>    =20
>>>  =20
>>>      =20
>>>> So since I cannot use it accurately for the hardirq/threaded-irq typ=
e
>>>> case, and I don't actually need it for the iosignalfd case, I am not=

>>>> sure its the right direction (at least for now).  I do think it migh=
t
>>>> have merit for syscal/vmexit uses outside of iosignalfd, but I do no=
t
>>>> see a current use-case for it so perhaps it can wait until one arise=
s.
>>>>
>>>> -Greg
>>>>    =20
>>>>        =20
>>> But, it addresses the CONFIG_PREEMPT off case, which your design does=
n't
>>> seem to.
>>>  =20
>>>      =20
>> Well, the problem is that it only addresses it partially in a limited
>> set of circumstances, and doesn't address the broader problem.  I'll
>> give you an example:
>>
>> (First off, lets assume that we are not going to have
>> eventfd_signal_task(), but rather eventfd_signal() with two option
>> flags: EVENTFD_SIGNAL_CANSLEEP, and EVENTFD_SIGNAL_CURRENTVALID
>>
>> Today vbus-enet has a rx-thread and a tx-thread at least partially
>> because I need process-context to do the copy_to_user(other->mm) type
>> stuff (and we will need similar for our virtio-net backend as well).  =
I
>> also utilize irqfd to do interrupt injection.  Now, since I know that =
I
>> have kthread_context, I could modify vbus-enet to inject interrupts wi=
th
>> EVENTFD_SIGNAL_CANSLEEP set, and this is fine.  I know that is safe.
>>
>> However, the problem is above that!  I would like to optimize out the
>> tx-thread to begin with with a similar "can_sleep()" pattern whenever
>> possible.
>>
>> For instance, if the netif stack calls me to do a transmit and it
>> happens to be in a sleepable context, it would be nice to just skip
>> waking up the tx-thread.  I would therefore just do the
>> copy_to_user(other->mm) + irqfd directly in the netif callback, thereb=
y
>> skipping the context switch.
>>    =20
>
> What do you mean by copy_to_user(other->mm) here?  If you are going to =
switch
> to another mm, then I think current->mm must be valid (I think it's not=
 enough
> that you can sleep). So preemptible() might not be enough.
>  =20

I dont currently use switch_mm, if that is what you mean.  I save the
task_struct into the appropriate context so current->mm doesn't matter
to me.  I never use it.  All I need (afaik) is to acquire the proper
mutex first.  I am not an MM expert, so perhaps I have this wrong but it
does appear to work properly even from kthread context.

-Greg



--------------enig1BBB43D6002560D84A34E3ED
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko33+IACgkQlOSOBdgZUxlsIQCeLz7rI0xdh62iMzpcFLZSlCO5
zZQAnRLrojjvvubMcy11OfbRq/X+21EB
=Y0mr
-----END PGP SIGNATURE-----

--------------enig1BBB43D6002560D84A34E3ED--
