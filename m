Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbZJ0Orv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbZJ0Orv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 10:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbZJ0Orv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 10:47:51 -0400
Received: from mail-px0-f180.google.com ([209.85.216.180]:47237 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbZJ0Ort (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 10:47:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=VgxYShRDQG8oQItjjiWWdIjbt0T7jRCfBz8uTgALkstHO5WLNrJK0fTT3KWemG/SrD
         V+GXkWfGArXTfUzYUJnIIv4R6QCFoWJODvSNttc7mD5r0CO7QrSRf9GMcrtnbbijY22/
         68KUZfQod4qxcmWTcDJhntBx690T2xq7rzGqg=
Message-ID: <4AE70815.7030307@gmail.com>
Date: Tue, 27 Oct 2009 10:47:49 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: [KVM PATCH v3 1/3] KVM: fix race in irq_routing logic
References: <20091026162148.23704.47286.stgit@dev.haskins.net> <20091026162157.23704.12420.stgit@dev.haskins.net> <20091027064529.GJ29477@redhat.com> <4AE6F7F7.1010302@gmail.com> <20091027140237.GM29477@redhat.com>
In-Reply-To: <20091027140237.GM29477@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCA8753F05D275425BA8AB4BF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCA8753F05D275425BA8AB4BF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Gleb Natapov wrote:
> On Tue, Oct 27, 2009 at 09:39:03AM -0400, Gregory Haskins wrote:
>> Gleb Natapov wrote:
>>> On Mon, Oct 26, 2009 at 12:21:57PM -0400, Gregory Haskins wrote:
>>>> The current code suffers from the following race condition:
>>>>
>>>> thread-1                                    thread-2
>>>> -----------------------------------------------------------
>>>>
>>>> kvm_set_irq() {
>>>>    rcu_read_lock()
>>>>    irq_rt =3D rcu_dereference(table);
>>>>    rcu_read_unlock();
>>>>
>>>>                                        kvm_set_irq_routing() {
>>>>                                           mutex_lock();
>>>>                                           irq_rt =3D table;
>>>>                                           rcu_assign_pointer();
>>>>                                           mutex_unlock();
>>>>                                           synchronize_rcu();
>>>>
>>>>                                           kfree(irq_rt);
>>>>
>>>>    irq_rt->entry->set(); /* bad */
>>>>
>>> This is not what happens. irq_rt is never accessed outside read-side
>>> critical section.
>> Sorry, I was generalizing to keep the comments short.  I figured it
>> would be clear what I was actually saying, but realize in retrospect
>> that I was a little ambiguous.
>>
> A little is underestimation :) There is not /* bad */ line in the code!=


Sorry, that was my own highlighting, not trying to reflect actual code.

>=20
>> Yes, irq_rt is not accessed outside the RSCS.  However, the entry
>> pointers stored in the irq_rt->map are, and this is equally problemati=
c
>> afaict.
> The pointer is in text and can't disappear without kvm_set_irq()
> disappearing too.

No, the entry* pointer is .text _AND_ .data, and is subject to standard
synchronization rules like most other objects.

Unless I am misreading the code, the entry* pointers point to heap
within the irq_rt pointer.  Therefore, the "kfree(irq_rt)" I mention
above effectively invalidates the entire set of entry* pointers that you
are caching, and is thus an issue.

>=20
>> In this particular case we seem to never delete entries at run-time on=
ce
>> they are established.  Therefore, while perhaps sloppy, its technicall=
y
>> safe to leave them unprotected from this perspective.

Note: I was wrong in this statement.  I forgot that it's not safe at
run-time either since the entry objects are part of irq_rt.

>> The issue is more
>> related to shutdown since a kvm_set_irq() caller could be within the
>> aforementioned race-region and call entry->set() after the guest is
>> gone.  Or did I miss something?
>>
> The caller of kvm_set_irq() should hold reference to kvm instance, so i=
t
> can't disappear while you are inside kvm_set_irq(). RCU protects only
> kvm->irq_routing not kvm structure itself.

Agreed, but this has nothing to do with protecting the entry* pointers.

>=20
>>> Data is copied from irq_rt onto the stack and this copy is accessed
>>> outside critical section.
>> As mentioned above, I do not believe this really protect us.  And even=

> I don't see the prove it doesn't, so I assume it does.

What would you like to see beyond what I've already provided you?  I can
show how the entry pointers are allocated as part of the irq_rt, and I
can show how the irq_rt (via entry->set) access is racy against
invalidation.

>=20
>> if it did, the copy is just a work-around to avoid sleeping within the=

> It is not a work-around. There was two solutions to the problem one is
> to call ->set() outside rcu critical section

This is broken afaict without taking additional precautions, such as a
reference count on the irq_rt structure, but I mentioned this alternate
solution in my header.

> another is to use SRCU. I
> decided to use the first one. This way the code is much simpler

"simpler" is debatable, but ok.  SRCU is an established pattern
available in the upstream kernel, so I don't think its particularly
complicated or controversial to use.

> and I remember asking Paul what are the disadvantages of using SRCU and=
 there
> was something.
>=20

The disadvantages to my knowledge are as follows:

1) rcu_read_lock is something like 4x faster than srcu_read_lock(), but
we are talking about nanoseconds on modern hardware (I think Paul quoted
me 10ns vs 45ns on his rig).  I don't think either overhead is something
to be concerned about in this case.

2) standard rcu supports deferred synchronization (call_rcu()), as well
as barriers (synchronize_rcu()), whereas SRCU only supports barriers
(synchronize_srcu()).  We only use the barrier type in this code path,
so that is not an issue.

3) SRCU requires explicit initialization/cleanup, whereas regular RCU
does not.  Trivially solved in my patch since KVM has plenty of
init/cleanup hook points.

>> standard RCU RSCS, which is what SRCU is designed for.  So rather than=

>> inventing an awkward two-phased stack based solution, it's better to
>> reuse the provided tools, IMO.
>>
>> To flip it around:  Is there any reason why an SRCU would not work her=
e,
>> and thus we were forced to use something like the stack-copy approach?=

>>
> If SRCU has no disadvantage comparing to RCU why not use it always? :)

No one is debating that SRCU has some disadvantages to RCU, but it
should also be noted that RCU has disadvantages as well (for instance,
you can't sleep within the RSCS except for preemptible-based configuratio=
ns)

The differences between them is really not the issue.  The bottom line
is that upstream KVM irq_routing code is broken afaict with the
application of RCU alone.

IMO: Its not the tool for the job:  At least, not when used alone.  You
either need RCU + reference count (which has more overhead than SRCU due
to the atomic ops), or SRCU.  There may perhaps be other variations on
this theme, as well, and I am not married to SRCU as the solution, per
se.  But it is *a* solution that I believe works, and IMO its the
best/cleanest/simplest one at our disposal.


--------------enigCA8753F05D275425BA8AB4BF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrnCBUACgkQP5K2CMvXmqHTBgCeLBY5y7vuB504kYCtfRgX7fQY
8nYAn2HmNjx1CysPtAc6w34mtvAMBpKR
=8hn3
-----END PGP SIGNATURE-----

--------------enigCA8753F05D275425BA8AB4BF--
