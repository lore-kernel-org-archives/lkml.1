Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbZFPOWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbZFPOWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 10:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757770AbZFPOW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 10:22:28 -0400
Received: from mail-qy0-f201.google.com ([209.85.221.201]:49708 "EHLO
	mail-qy0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbZFPOW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 10:22:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=wgbfaLmoB210xOcWf1JCB+8iCQoEyeseDqBEwShTYXjm9RVxQLS52P5pTiOG1gru3E
         LDEcB3pnxR7Duxg4PwSvoO6H9+4y1VuBKt7zlk6GRLy77DGq+tBFJyN2J1RSZn2o/d/c
         ZBRYFNgy0+C80z7kGGKSSyMAeMZkmqVsyZ8VQ=
Message-ID: <4A37AAA1.6040808@gmail.com>
Date: Tue, 16 Jun 2009 10:22:25 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, davidel@xmailserver.org,
       paulmck@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based	notifier
 interface
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com> <4A37A984.5000705@novell.com>
In-Reply-To: <4A37A984.5000705@novell.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDB9DC1BBAE79A7A759144A7E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDB9DC1BBAE79A7A759144A7E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

[Adding Ingo]

Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
>  =20
>> On Mon, Jun 15, 2009 at 10:29:56PM -0400, Gregory Haskins wrote:
>>  =20
>>    =20
>>> irqfd and its underlying implementation, eventfd, currently utilize
>>> the embedded wait-queue in eventfd for signal notification.  The nice=
 thing
>>> about this design decision is that it re-uses the existing
>>> eventfd/wait-queue code and it generally works well....with several
>>> limitations.
>>>
>>> One of the limitations is that notification callbacks are always call=
ed
>>> inside a spin_lock_irqsave critical section.  Another limitation is
>>> that it is very difficult to build a system that can recieve release
>>> notification without being racy.
>>>
>>> Therefore, we introduce a new registration interface that is SRCU bas=
ed
>>> instead of wait-queue based, and implement the internal wait-queue
>>> infrastructure in terms of this new interface.  We then convert irqfd=

>>> to use this new interface instead of the existing wait-queue code.
>>>
>>> The end result is that we now have the opportunity to run the interru=
pt
>>> injection code serially to the callback (when the signal is raised fr=
om
>>> process-context, at least) instead of always deferring the injection =
to a
>>> work-queue.
>>>
>>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>>> CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>> CC: Davide Libenzi <davidel@xmailserver.org>
>>> ---
>>>
>>>  fs/eventfd.c            |  115 +++++++++++++++++++++++++++++++++++++=
++++++----
>>>  include/linux/eventfd.h |   30 ++++++++++++
>>>  virt/kvm/eventfd.c      |  114 +++++++++++++++++++++----------------=
----------
>>>  3 files changed, 188 insertions(+), 71 deletions(-)
>>>
>>> diff --git a/fs/eventfd.c b/fs/eventfd.c
>>> index 72f5f8d..505d5de 100644
>>> --- a/fs/eventfd.c
>>> +++ b/fs/eventfd.c
>>> @@ -30,8 +30,47 @@ struct eventfd_ctx {
>>>  	 */
>>>  	__u64 count;
>>>  	unsigned int flags;
>>> +	struct srcu_struct srcu;
>>> +	struct list_head nh;
>>> +	struct eventfd_notifier notifier;
>>>  };
>>> =20
>>> +static void _eventfd_wqh_notify(struct eventfd_notifier *en)
>>> +{
>>> +	struct eventfd_ctx *ctx =3D container_of(en,
>>> +					       struct eventfd_ctx,
>>> +					       notifier);
>>> +
>>> +	if (waitqueue_active(&ctx->wqh))
>>> +		wake_up_poll(&ctx->wqh, POLLIN);
>>> +}
>>> +
>>> +static void _eventfd_notify(struct eventfd_ctx *ctx)
>>> +{
>>> +	struct eventfd_notifier *en;
>>> +	int idx;
>>> +
>>> +	idx =3D srcu_read_lock(&ctx->srcu);
>>> +
>>> +	/*
>>> +	 * The goal here is to allow the notification to be preemptible
>>> +	 * as often as possible.  We cannot achieve this with the basic
>>> +	 * wqh mechanism because it requires the wqh->lock.  Therefore
>>> +	 * we have an internal srcu list mechanism of which the wqh is
>>> +	 * a client.
>>> +	 *
>>> +	 * Not all paths will invoke this function in process context.
>>> +	 * Callers should check for suitable state before assuming they
>>> +	 * can sleep (such as with preemptible()).  Paul McKenney assures
>>> +	 * me that srcu_read_lock is compatible with in-atomic, as long as
>>> +	 * the code within the critical section is also compatible.
>>> +	 */
>>> +	list_for_each_entry_rcu(en, &ctx->nh, list)
>>> +		en->ops->signal(en);
>>> +
>>> +	srcu_read_unlock(&ctx->srcu, idx);
>>> +}
>>> +
>>>  /*
>>>   * Adds "n" to the eventfd counter "count". Returns "n" in case of
>>>   * success, or a value lower then "n" in case of coutner overflow.
>>>    =20
>>>      =20
>> This is ugly, isn't it? With CONFIG_PREEMPT=3Dno preemptible() is alwa=
ys false.
>>  =20
>>    =20
>
> As an aside, this is something I would like to address.  I keep running=

> into this pattern where I could do something in-line if I had a
> "can_sleep()" context.  Otherwise, I have to punt to something like a
> workqueue which adds latency.  The closest thing I have to "can_sleep()=
"
> is preemptible(), which, as you correctly pointed out is limited to onl=
y
> working with CONFIG_PREEMPT=3Dy.
>
> Its been a while since I looked into it, but one of the barriers that
> would need to be overcome is the fact that the preempt_count stuff gets=

> compiled away with CONFIG_PREEMPT=3Dn.  It is conceivable that we could=

> make the preempt_count logic an independent config variable from
> CONFIG_PREEMPT to provide a can_sleep() macro without requiring
> full-blow preemption to be enabled.  So my questions would be as follow=
s:
>
> a) Is the community conducive to such an idea?
> b) Are there other things to consider/fix besides the lack of
> preempt_count in order to implement such a beast?
>
> -Greg
>
>
>  =20
Hi Ingo,

Any thoughts here?

-Greg


--------------enigDB9DC1BBAE79A7A759144A7E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko3qqEACgkQP5K2CMvXmqFSkACeKxHfDxEUmovg3OGHYMjUkQin
fmEAn1wZEODTKnsnXNUmEKtmEnxx5NuM
=ylWe
-----END PGP SIGNATURE-----

--------------enigDB9DC1BBAE79A7A759144A7E--
