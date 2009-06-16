Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbZFPOlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbZFPOlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 10:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbZFPOlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 10:41:12 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:42424 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbZFPOlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 10:41:11 -0400
Message-ID: <4A37AEF7.7070203@novell.com>
Date: Tue, 16 Jun 2009 10:40:55 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, davidel@xmailserver.org,
       paulmck@linux.vnet.ibm.com
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based notifier
 interface
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com>
In-Reply-To: <20090616140240.GA9401@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig86AF6CDAD570166C519777E7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig86AF6CDAD570166C519777E7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Mon, Jun 15, 2009 at 10:29:56PM -0400, Gregory Haskins wrote:
>  =20
>> irqfd and its underlying implementation, eventfd, currently utilize
>> the embedded wait-queue in eventfd for signal notification.  The nice =
thing
>> about this design decision is that it re-uses the existing
>> eventfd/wait-queue code and it generally works well....with several
>> limitations.
>>
>> One of the limitations is that notification callbacks are always calle=
d
>> inside a spin_lock_irqsave critical section.  Another limitation is
>> that it is very difficult to build a system that can recieve release
>> notification without being racy.
>>
>> Therefore, we introduce a new registration interface that is SRCU base=
d
>> instead of wait-queue based, and implement the internal wait-queue
>> infrastructure in terms of this new interface.  We then convert irqfd
>> to use this new interface instead of the existing wait-queue code.
>>
>> The end result is that we now have the opportunity to run the interrup=
t
>> injection code serially to the callback (when the signal is raised fro=
m
>> process-context, at least) instead of always deferring the injection t=
o a
>> work-queue.
>>
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>> CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> CC: Davide Libenzi <davidel@xmailserver.org>
>> ---
>>
>>  fs/eventfd.c            |  115 ++++++++++++++++++++++++++++++++++++++=
+++++----
>>  include/linux/eventfd.h |   30 ++++++++++++
>>  virt/kvm/eventfd.c      |  114 +++++++++++++++++++++-----------------=
---------
>>  3 files changed, 188 insertions(+), 71 deletions(-)
>>
>> diff --git a/fs/eventfd.c b/fs/eventfd.c
>> index 72f5f8d..505d5de 100644
>> --- a/fs/eventfd.c
>> +++ b/fs/eventfd.c
>> @@ -30,8 +30,47 @@ struct eventfd_ctx {
>>  	 */
>>  	__u64 count;
>>  	unsigned int flags;
>> +	struct srcu_struct srcu;
>> +	struct list_head nh;
>> +	struct eventfd_notifier notifier;
>>  };
>> =20
>> +static void _eventfd_wqh_notify(struct eventfd_notifier *en)
>> +{
>> +	struct eventfd_ctx *ctx =3D container_of(en,
>> +					       struct eventfd_ctx,
>> +					       notifier);
>> +
>> +	if (waitqueue_active(&ctx->wqh))
>> +		wake_up_poll(&ctx->wqh, POLLIN);
>> +}
>> +
>> +static void _eventfd_notify(struct eventfd_ctx *ctx)
>> +{
>> +	struct eventfd_notifier *en;
>> +	int idx;
>> +
>> +	idx =3D srcu_read_lock(&ctx->srcu);
>> +
>> +	/*
>> +	 * The goal here is to allow the notification to be preemptible
>> +	 * as often as possible.  We cannot achieve this with the basic
>> +	 * wqh mechanism because it requires the wqh->lock.  Therefore
>> +	 * we have an internal srcu list mechanism of which the wqh is
>> +	 * a client.
>> +	 *
>> +	 * Not all paths will invoke this function in process context.
>> +	 * Callers should check for suitable state before assuming they
>> +	 * can sleep (such as with preemptible()).  Paul McKenney assures
>> +	 * me that srcu_read_lock is compatible with in-atomic, as long as
>> +	 * the code within the critical section is also compatible.
>> +	 */
>> +	list_for_each_entry_rcu(en, &ctx->nh, list)
>> +		en->ops->signal(en);
>> +
>> +	srcu_read_unlock(&ctx->srcu, idx);
>> +}
>> +
>>  /*
>>   * Adds "n" to the eventfd counter "count". Returns "n" in case of
>>   * success, or a value lower then "n" in case of coutner overflow.
>>    =20
>
> This is ugly, isn't it? With CONFIG_PREEMPT=3Dno preemptible() is alway=
s false.
>
> Further, to do useful things it might not be enough that you can sleep:=

> with iofd you also want to access current task with e.g. copy from user=
=2E
>  =20

Something else to consider:  For iosignalfd, we can assume we will
always be called from vcpu process context so we might not really need
official affirmation from the system.  For irqfd, we cannot predict who
may be injecting the interrupt (for instance, it might be a
PCI-passthrough hard-irq context).  I am not sure if this knowledge
actually helps to simplify the problem space, but I thought I should
mention it.

-Greg



--------------enig86AF6CDAD570166C519777E7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko3rvcACgkQlOSOBdgZUxmhAACfUF2Vuwp6K/jervgoYZdPam9A
e+IAnA2NOZDZGmzbjQolNqUU+j8AeXuo
=g4x6
-----END PGP SIGNATURE-----

--------------enig86AF6CDAD570166C519777E7--
