Return-Path: <linux-kernel-owner+w=401wt.eu-S1757562AbZFPOst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbZFPOst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 10:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZFPOsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 10:48:40 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:54304 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbZFPOsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 10:48:39 -0400
Message-ID: <4A37B0BB.3020005@novell.com>
Date: Tue, 16 Jun 2009 10:48:27 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, davidel@xmailserver.org,
       paulmck@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based notifier
 interface
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com> <4A37A7FC.4090403@novell.com> <20090616143816.GA18196@redhat.com>
In-Reply-To: <20090616143816.GA18196@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3941861297B42CDEE02D242A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3941861297B42CDEE02D242A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Tue, Jun 16, 2009 at 10:11:08AM -0400, Gregory Haskins wrote:
>  =20
>> Michael S. Tsirkin wrote:
>>    =20
>>> On Mon, Jun 15, 2009 at 10:29:56PM -0400, Gregory Haskins wrote:
>>>  =20
>>>      =20
>>>> irqfd and its underlying implementation, eventfd, currently utilize
>>>> the embedded wait-queue in eventfd for signal notification.  The nic=
e thing
>>>> about this design decision is that it re-uses the existing
>>>> eventfd/wait-queue code and it generally works well....with several
>>>> limitations.
>>>>
>>>> One of the limitations is that notification callbacks are always cal=
led
>>>> inside a spin_lock_irqsave critical section.  Another limitation is
>>>> that it is very difficult to build a system that can recieve release=

>>>> notification without being racy.
>>>>
>>>> Therefore, we introduce a new registration interface that is SRCU ba=
sed
>>>> instead of wait-queue based, and implement the internal wait-queue
>>>> infrastructure in terms of this new interface.  We then convert irqf=
d
>>>> to use this new interface instead of the existing wait-queue code.
>>>>
>>>> The end result is that we now have the opportunity to run the interr=
upt
>>>> injection code serially to the callback (when the signal is raised f=
rom
>>>> process-context, at least) instead of always deferring the injection=
 to a
>>>> work-queue.
>>>>
>>>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>>>> CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>>> CC: Davide Libenzi <davidel@xmailserver.org>
>>>> ---
>>>>
>>>>  fs/eventfd.c            |  115 ++++++++++++++++++++++++++++++++++++=
+++++++----
>>>>  include/linux/eventfd.h |   30 ++++++++++++
>>>>  virt/kvm/eventfd.c      |  114 +++++++++++++++++++++---------------=
-----------
>>>>  3 files changed, 188 insertions(+), 71 deletions(-)
>>>>
>>>> diff --git a/fs/eventfd.c b/fs/eventfd.c
>>>> index 72f5f8d..505d5de 100644
>>>> --- a/fs/eventfd.c
>>>> +++ b/fs/eventfd.c
>>>> @@ -30,8 +30,47 @@ struct eventfd_ctx {
>>>>  	 */
>>>>  	__u64 count;
>>>>  	unsigned int flags;
>>>> +	struct srcu_struct srcu;
>>>> +	struct list_head nh;
>>>> +	struct eventfd_notifier notifier;
>>>>  };
>>>> =20
>>>> +static void _eventfd_wqh_notify(struct eventfd_notifier *en)
>>>> +{
>>>> +	struct eventfd_ctx *ctx =3D container_of(en,
>>>> +					       struct eventfd_ctx,
>>>> +					       notifier);
>>>> +
>>>> +	if (waitqueue_active(&ctx->wqh))
>>>> +		wake_up_poll(&ctx->wqh, POLLIN);
>>>> +}
>>>> +
>>>> +static void _eventfd_notify(struct eventfd_ctx *ctx)
>>>> +{
>>>> +	struct eventfd_notifier *en;
>>>> +	int idx;
>>>> +
>>>> +	idx =3D srcu_read_lock(&ctx->srcu);
>>>> +
>>>> +	/*
>>>> +	 * The goal here is to allow the notification to be preemptible
>>>> +	 * as often as possible.  We cannot achieve this with the basic
>>>> +	 * wqh mechanism because it requires the wqh->lock.  Therefore
>>>> +	 * we have an internal srcu list mechanism of which the wqh is
>>>> +	 * a client.
>>>> +	 *
>>>> +	 * Not all paths will invoke this function in process context.
>>>> +	 * Callers should check for suitable state before assuming they
>>>> +	 * can sleep (such as with preemptible()).  Paul McKenney assures
>>>> +	 * me that srcu_read_lock is compatible with in-atomic, as long as=

>>>> +	 * the code within the critical section is also compatible.
>>>> +	 */
>>>> +	list_for_each_entry_rcu(en, &ctx->nh, list)
>>>> +		en->ops->signal(en);
>>>> +
>>>> +	srcu_read_unlock(&ctx->srcu, idx);
>>>> +}
>>>> +
>>>>  /*
>>>>   * Adds "n" to the eventfd counter "count". Returns "n" in case of
>>>>   * success, or a value lower then "n" in case of coutner overflow.
>>>>    =20
>>>>        =20
>>> This is ugly, isn't it? With CONFIG_PREEMPT=3Dno preemptible() is alw=
ays false.
>>>
>>> Further, to do useful things it might not be enough that you can slee=
p:
>>> with iofd you also want to access current task with e.g. copy from us=
er.
>>>
>>> Here's an idea: let's pass a flag to ->signal, along the lines of
>>> signal_is_task, that tells us that it is safe to use current, and add=

>>> eventfd_signal_task() which is the same as eventfd_signal but lets ev=
eryone
>>> know that it's safe to both sleep and use current->mm.
>>>
>>> Makes sense?
>>>  =20
>>>      =20
>> It does make sense, yes.  What I am not clear on is how would eventfd
>> detect this state such as to populate such flags, and why cant the
>> ->signal() CB do the same?
>>
>> Thanks Michael,
>> -Greg
>>
>>    =20
>
> eventfd can't detect this state. But the callers know in what context t=
hey are.
> So the *caller* of eventfd_signal_task makes sure of this: if you are i=
n a task,
> you can call eventfd_signal_task() if not, you must call eventfd_signal=
=2E
>
>
>  =20
Hmm, this is an interesting idea, but I think it would be problematic in
real-world applications for the long-term.  For instance, the -rt tree
and irq-threads .config option in the process of merging into mainline
changes context types for established code.  Therefore, what might be
"hardirq/softirq" logic today may execute in a kthread tomorrow.  I
think its dangerous to try to solve the problem with caller provided
info:  the caller may be ignorant of its true state.  IMO, the ideal
solution needs to be something we can detect at run-time.

Thanks Michael,
-Greg


--------------enig3941861297B42CDEE02D242A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko3sLsACgkQlOSOBdgZUxnxWgCeLPMpzbnMkb3mbGyy0nU5a3FZ
Bi0AniAIxyFYe0MOfI/ueNmhDyOz6MNz
=keZg
-----END PGP SIGNATURE-----

--------------enig3941861297B42CDEE02D242A--
