Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbZFSQHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbZFSQHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 12:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbZFSQHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 12:07:24 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:48387 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbZFSQHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 12:07:23 -0400
Message-ID: <4A3BB7B8.1050509@novell.com>
Date: Fri, 19 Jun 2009 12:07:20 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, davidel@xmailserver.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org
Subject: Re: [KVM PATCH v2 2/2] kvm: use POLLHUP to close an irqfd instead
 of an explicit ioctl
References: <20090604124047.10544.38861.stgit@dev.haskins.net> <4A3639B2.7080006@novell.com> <20090615125439.GI6351@redhat.com> <200906181446.31373.rusty@rustcorp.com.au> <20090618064908.GB11155@redhat.com> <4A3A2C67.4030406@novell.com> <20090618122219.GE16838@redhat.com> <4A3A4938.60604@novell.com> <20090618143547.GA19408@redhat.com> <4A3A6B6B.3020705@novell.com> <20090619153703.GA3022@redhat.com>
In-Reply-To: <20090619153703.GA3022@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8F9A4F968B9E701F0A43B465"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8F9A4F968B9E701F0A43B465
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Thu, Jun 18, 2009 at 12:29:31PM -0400, Gregory Haskins wrote:
>  =20
>> Michael S. Tsirkin wrote:
>>    =20
>>> On Thu, Jun 18, 2009 at 10:03:36AM -0400, Gregory Haskins wrote:
>>>  =20
>>>      =20
>>>> Michael S. Tsirkin wrote:
>>>>    =20
>>>>        =20
>>>>> On Thu, Jun 18, 2009 at 08:00:39AM -0400, Gregory Haskins wrote:
>>>>>  =20
>>>>>      =20
>>>>>          =20
>>>>>> Michael S. Tsirkin wrote:
>>>>>>    =20
>>>>>>
>>>>>>        =20
>>>>>>            =20
>>>>>>> BTW, Gregory, this can be used to fix the race in the design: cre=
ate a
>>>>>>> thread and let it drop the module reference with module_put_and_e=
xit.
>>>>>>>  =20
>>>>>>>      =20
>>>>>>>          =20
>>>>>>>              =20
>>>>>> I had thought of doing something like this initially too, but I th=
ink
>>>>>> its racy as well.  Ultimately, you need to make sure the eventfd
>>>>>> callback is completely out before its safe to run, and deferring t=
o a
>>>>>> thread would not change this race.  The only sane way I can see to=
 do
>>>>>> that is to have the caller infrastructure annotate the event someh=
ow
>>>>>> (either directly with a module_put(), or indirectly with some kind=
 of
>>>>>> state transition that can be tracked with something like
>>>>>> synchronize_sched().
>>>>>>    =20
>>>>>>        =20
>>>>>>            =20
>>>>> Here's what one could do: create a thread for each irqfd, and incre=
ment
>>>>> module ref count, put that thread to sleep.  When done with
>>>>> irqfd, don't delete it and don't decrement module refcount, wake th=
read
>>>>> instead.  thread kills irqfd and calls module_put_and_exit.
>>>>>
>>>>> I don't think it's racy
>>>>>      =20
>>>>>          =20
>>>> I believe it is. How would you prevent the thread from doing the
>>>> module_put_and_exit() before the eventfd callback thread is known to=

>>>> have exited the relevant .text section?
>>>>    =20
>>>>        =20
>>> Right.
>>>
>>>  =20
>>>      =20
>>>> All this talk does give me an idea, tho.  Ill make a patch.
>>>>    =20
>>>>        =20
>>> OK, but ask yourself whether this bag of tricks is worth it, and whet=
her
>>> we'll find another hole later. Let's reserve the trickiness for
>>> fast-path, where it's needed, and keep at least the assign/deassign s=
imple.
>>>  =20
>>>      =20
>> Understood.  OTOH, going back to the model where two steps are needed
>> for close() is ugly too, so I don't want to just give up and revert th=
at
>> fix too easily.  At some point we will call it one way or the other, b=
ut
>> I am not there quite yet.
>>    =20
>>>  =20
>>>      =20
>>>>>  =20
>>>>>      =20
>>>>>          =20
>>>>>>> Which will work, but I guess at this point we should ask ourselve=
s
>>>>>>> whether all the hearburn with srcu, threads and module references=
 is
>>>>>>> better than just asking the user to call and ioctl.
>>>>>>>  =20
>>>>>>>      =20
>>>>>>>          =20
>>>>>>>              =20
>>>>>> I am starting to agree with you, here. :)
>>>>>>
>>>>>> Note one thing: the SRCU stuff is mostly orthogonal from the rest =
of the
>>>>>> conversation re: the module_put() races.  I only tied it into the
>>>>>> current thread because the eventfd_notifier_register() thread gave=
 me a
>>>>>> convenient way to hook some other context to do the module_put(). =
 In
>>>>>> the long term, the srcu changes are for the can_sleep() stuff.  So=
 on
>>>>>> that note, lets see if I can convince Davide that the srcu stuff i=
s not
>>>>>> so evil before we revert the POLLHUP patches, since the module_put=
() fix
>>>>>> is trivial once that is in place.
>>>>>>    =20
>>>>>>        =20
>>>>>>            =20
>>>>> Can this help with DEASSIGN as well? We need it for migration.
>>>>>  =20
>>>>>      =20
>>>>>          =20
>>>> No, but afaict you do not need this for migration anyway.  Migrate t=
he
>>>> GSI and re-call kvm_irqfd() on the other side.  Would the fd even be=

>>>> relevant across a migration anyway?  I would think not, but admitted=
ly I
>>>> know little about how qemu/kvm migration actually works.
>>>>    =20
>>>>        =20
>>> Yes but that's not live migration. For live migration, the trick is t=
hat
>>> you are running locally but send changes to remote guest.  For that, =
we
>>> need to put qemu in the middle between the device and the guest, so i=
t
>>> can detect activity and update the remote side.
>>>
>>> And the best way to do that is to take poll eventfd that device assig=
ns
>>> and push eventfd that kvm polls. To switch between this setup
>>> and the one where kvm polls the ventfd from device directly,
>>> you need deassign.
>>>  =20
>>>      =20
>> So its still not clear why the distinction between
>> deassign-the-gsi-but-leave-the-fd-valid is needed over a simple
>> close().  Can you elaborate?
>>    =20
>
>
> The fd needs to be left assigned to the device, so that we can poll
> the fd and get events, then forward them to kvm.
>  =20

Ah, ok.  Now I get what you are trying to do.

Well, per the PM I sent you this morning, I figured out the magic to
resolve the locking issues.  So we should be able to add DEASSIGN logic
soon, I hope.

-Greg



--------------enig8F9A4F968B9E701F0A43B465
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko7t7gACgkQlOSOBdgZUxlmqwCZAXmZ7XO32jkQ/LVd6aR3DZA9
vskAn1S6MImr82ER+MIOAaYke4T2A4JL
=dgIF
-----END PGP SIGNATURE-----

--------------enig8F9A4F968B9E701F0A43B465--
