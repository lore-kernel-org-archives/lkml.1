Return-Path: <linux-kernel-owner+w=401wt.eu-S1757146AbZFVRbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbZFVRbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZFVRbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:31:35 -0400
Received: from mail-qy0-f171.google.com ([209.85.221.171]:33729 "EHLO
	mail-qy0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbZFVRbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:31:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=AG62oaf1W6sHPCnsuKhYgzwGl2dwLAdkskB/CIP8SUZw+UQC5hyUL+Xvo/93/Dvcxy
         8YBvLq5V0D872ZoiM1nmPXW4b/IGE7LAfVimtoCIoKd8B3A1nGlC+NJAsdriJMXZKej9
         +rUFKbnNVQW2TxcxZjmX/zmBh8+8Gx1imdTcw=
Message-ID: <4A3FBFF1.8050504@gmail.com>
Date: Mon, 22 Jun 2009 13:31:29 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com,
       paulmck@linux.vnet.ibm.com, davidel@xmailserver.org, mingo@elte.hu,
       rusty@rustcorp.com.au
Subject: Re: [KVM PATCH v3 3/3] KVM: Fix races in irqfd using new eventfd_kref_get
 interface
References: <20090622155504.22967.50532.stgit@dev.haskins.net> <20090622160556.22967.76273.stgit@dev.haskins.net> <20090622165708.GB15228@redhat.com>
In-Reply-To: <20090622165708.GB15228@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7519CAC0089EF438E0EB6E36"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7519CAC0089EF438E0EB6E36
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Mon, Jun 22, 2009 at 12:05:57PM -0400, Gregory Haskins wrote:
>  =20
>> This patch fixes all known races in irqfd, and paves the way to restor=
e
>> DEASSIGN support.  For details of the eventfd races, please see the pa=
tch
>> presumably commited immediately prior to this one.
>>
>> In a nutshell, we use eventfd_kref_get/put() to properly manage the
>> lifetime of the underlying eventfd.  We also use careful coordination
>> with our workqueue to ensure that all irqfd objects have terminated
>> before we allow kvm to shutdown.  The logic used for shutdown walks
>> all open irqfds and releases them.  This logic can be generalized in
>> the future to allow a subset of irqfds to be released, thus allowing
>> DEASSIGN support.
>>
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>>    =20
>
> I think this patch is a shade too tricky. Some explanation why below.
>
> But I think irqfd_pop is a good idea.
>  =20

Yeah, next we can add something like "irqfd_remove(gsi)" in a similar
way to do DEASSIGN.

> Here's an alternative design sketch: add a list of irqfds to be shutdow=
n
> in kvm, and create a single-threaded workqueue. To kill an irqfd, move
> it from list of live irqfds to list of dead irqfds, then schedule work
> on a workqueue that walks this list and kills irqfds.
>  =20

Yeah, I actually thought of that too, and I think that will work.  But
then I realized flush_schedule_work does the same thing and its much
less code.  Perhaps it is also much less clear, too ;)  At the very
least, you have made me realize I need to comment better.
>  =20
>> ---
>>
>>  virt/kvm/eventfd.c |  144 ++++++++++++++++++++++++++++++++++++++++---=
---------
>>  1 files changed, 110 insertions(+), 34 deletions(-)
>>
>> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
>> index 9656027..67985cd 100644
>> --- a/virt/kvm/eventfd.c
>> +++ b/virt/kvm/eventfd.c
>> @@ -28,6 +28,7 @@
>>  #include <linux/file.h>
>>  #include <linux/list.h>
>>  #include <linux/eventfd.h>
>> +#include <linux/kref.h>
>> =20
>>  /*
>>   * ------------------------------------------------------------------=
--
>> @@ -36,26 +37,68 @@
>>   * Credit goes to Avi Kivity for the original idea.
>>   * ------------------------------------------------------------------=
--
>>   */
>> +
>> +enum {
>> +	irqfd_flags_shutdown,
>> +};
>> +
>>  struct _irqfd {
>>  	struct kvm               *kvm;
>> +	struct kref              *eventfd;
>>    =20
>
>
> Yay, kref.
>
>  =20
>>  	int                       gsi;
>>  	struct list_head          list;
>>  	poll_table                pt;
>>  	wait_queue_head_t        *wqh;
>>  	wait_queue_t              wait;
>> -	struct work_struct        inject;
>> +	struct work_struct        work;
>> +	unsigned long             flags;
>>    =20
>
> Just make it "int shutdown"?
>  =20

Yep, that is probably fine but we will have to use an explicit wmb in
lieu of a set_bit operation.  NBD.

>  =20
>>  };
>> =20
>>  static void
>> -irqfd_inject(struct work_struct *work)
>> +irqfd_release(struct _irqfd *irqfd)
>> +{
>> +	eventfd_kref_put(irqfd->eventfd);
>> +	kfree(irqfd);
>> +}
>> +
>> +static void
>> +irqfd_work(struct work_struct *work)
>>  {
>> -	struct _irqfd *irqfd =3D container_of(work, struct _irqfd, inject);
>> +	struct _irqfd *irqfd =3D container_of(work, struct _irqfd, work);
>>  	struct kvm *kvm =3D irqfd->kvm;
>> =20
>> -	mutex_lock(&kvm->irq_lock);
>> -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
>> -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
>> -	mutex_unlock(&kvm->irq_lock);
>> +	if (!test_bit(irqfd_flags_shutdown, &irqfd->flags)) {
>>    =20
>
> Why is it safe to test this bit outside of any lock?
>  =20
Because the ordering is guaranteed to set_bit(), schedule_work().  All
we need to do is make sure that the work-queue runs at least one more
time after the flag has been set.  (Of course, I could have screwed up
too, but that was my rationale).

>  =20
>> +		/* Inject an interrupt */
>> +		mutex_lock(&kvm->irq_lock);
>> +		kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
>> +		kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
>> +		mutex_unlock(&kvm->irq_lock);
>> +	} else {
>>    =20
>
>
> Not much shared code here - create a separate showdown work struct?
> They are cheap ...
>  =20

We can't because we need to ensure that all inject-jobs complete before
release-jobs.  Reading the work-queue code, it would be a deadlock for
the release-job to do a flush_work(inject-job).  Therefore, both
workloads are encapsulated into a single job, and we ensure that the job
is launched at least one more time after the flag has been set.

Of course, now that I wrote that,  I realize it was clear-as-mud in the
code and needs some commenting ;)

>  =20
>> +		/* shutdown the irqfd */
>> +		struct _irqfd *_irqfd =3D NULL;
>> +
>> +		mutex_lock(&kvm->lock);
>> +
>> +		if (!list_empty(&irqfd->list))
>> +			_irqfd =3D irqfd;
>> +
>> +		if (_irqfd)
>> +			list_del(&_irqfd->list);
>> +
>> +		mutex_unlock(&kvm->lock);
>> +
>> +		/*
>> +		 * If the item is not currently on the irqfds list, we know
>> +		 * we are running concurrently with the KVM side trying to
>> +		 * remove this item as well.
>>    =20
>
> We do? How? As far as I can see list is only empty after it has been
> created.  Generally, it would be better to either use a flag or use
> list_empty as an indication of going down, but not both.
>  =20

I think you are mis-reading that.  list_empty(&irqfd->list) is the
individual irqfd list-item, not the kvm->irqfds list itself.  This
conditional is telling us whether the irqfd in question is on or off the
list (its effectively an irqfd-specific flag), not whether the global
list is empty.  Again, poor commenting on my part.

>  =20
>>  Since the KVM side should be
>> +		 * holding the reference now, and will block behind a
>> +		 * flush_work(), lets just let them do the release() for us
>> +		 */
>> +		if (!_irqfd)
>> +			return;
>> +
>> +		irqfd_release(_irqfd);
>> +	}
>>  }
>> =20
>>  static int
>> @@ -65,25 +108,20 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, i=
nt sync, void *key)
>>  	unsigned long flags =3D (unsigned long)key;
>> =20
>>  	/*
>> -	 * Assume we will be called with interrupts disabled
>> +	 * called with interrupts disabled
>>  	 */
>> -	if (flags & POLLIN)
>> -		/*
>> -		 * Defer the IRQ injection until later since we need to
>> -		 * acquire the kvm->lock to do so.
>> -		 */
>> -		schedule_work(&irqfd->inject);
>> -
>>  	if (flags & POLLHUP) {
>>  		/*
>> -		 * for now, just remove ourselves from the list and let
>> -		 * the rest dangle.  We will fix this up later once
>> -		 * the races in eventfd are fixed
>> +		 * ordering is important: shutdown flag must be visible
>> +		 * before we schedule
>>  		 */
>>  		__remove_wait_queue(irqfd->wqh, &irqfd->wait);
>> -		irqfd->wqh =3D NULL;
>> +		set_bit(irqfd_flags_shutdown, &irqfd->flags);
>>    =20
>
> So what happens if a previously scheduled work runs on irqfd
> and sees this flag?
My original thought was "thats ok", but now that you mention it I am not
so sure.  Ill give it some more thought because maybe you are on to
something.

>  And note that multiple works can run on irqfd
> in parallel.
>  =20

They can?  I thought work-queue items were guaranteed to only schedule
once?  If what you say is true, its broken, I agree, and Ill need to
revisit.  Let me get back to you.
>  =20
>>  	}
>> =20
>> +	if (flags & (POLLHUP | POLLIN))
>> +		schedule_work(&irqfd->work);
>> +
>>  	return 0;
>>  }
>> =20
>> @@ -102,6 +140,7 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int fl=
ags)
>>  {
>>  	struct _irqfd *irqfd;
>>  	struct file *file =3D NULL;
>> +	struct kref *kref =3D NULL;
>>  	int ret;
>>  	unsigned int events;
>> =20
>> @@ -112,7 +151,7 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int fl=
ags)
>>  	irqfd->kvm =3D kvm;
>>  	irqfd->gsi =3D gsi;
>>  	INIT_LIST_HEAD(&irqfd->list);
>> -	INIT_WORK(&irqfd->inject, irqfd_inject);
>> +	INIT_WORK(&irqfd->work, irqfd_work);
>> =20
>>  	file =3D eventfd_fget(fd);
>>  	if (IS_ERR(file)) {
>> @@ -133,11 +172,13 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int =
flags)
>>  	list_add_tail(&irqfd->list, &kvm->irqfds);
>>  	mutex_unlock(&kvm->lock);
>> =20
>> -	/*
>> -	 * Check if there was an event already queued
>> -	 */
>> -	if (events & POLLIN)
>> -		schedule_work(&irqfd->inject);
>> +	kref =3D eventfd_kref_get(file);
>> +	if (IS_ERR(file)) {
>> +		ret =3D PTR_ERR(file);
>> +		goto fail;
>> +	}
>> +
>> +	irqfd->eventfd =3D kref;
>> =20
>>  	/*
>>  	 * do not drop the file until the irqfd is fully initialized, otherw=
ise
>> @@ -145,9 +186,18 @@ kvm_irqfd(struct kvm *kvm, int fd, int gsi, int f=
lags)
>>  	 */
>>  	fput(file);
>> =20
>> +	/*
>> +	 * Check if there was an event already queued
>> +	 */
>>    =20
>
> This comment seems to confuse more that it clarifies:
> queued where? eventfd only counts... Just kill the comment?
>
>  =20
non-zero values in eventfd are "queued" as a signal.  This test just
checks if an interrupt was already injected before we registered.

>> +	if (events & POLLIN)
>> +		schedule_work(&irqfd->work);
>> +
>>  	return 0;
>> =20
>>  fail:
>> +	if (kref && !IS_ERR(kref))
>> +		eventfd_kref_put(kref);
>> +
>>  	if (file && !IS_ERR(file))
>>  		fput(file);
>>    =20
>
> let's add a couple more labels and avoid the kref/file check
> and the initialization above?
>  =20

I think that just makes it more confusing, personally.  But I will give
it some thought.

>  =20
>> =20
>> @@ -161,21 +211,47 @@ kvm_irqfd_init(struct kvm *kvm)
>>  	INIT_LIST_HEAD(&kvm->irqfds);
>>  }
>> =20
>> +static struct _irqfd *
>> +irqfd_pop(struct kvm *kvm)
>> +{
>> +	struct _irqfd *irqfd =3D NULL;
>> +
>> +	mutex_lock(&kvm->lock);
>> +
>> +	if (!list_empty(&kvm->irqfds)) {
>> +		irqfd =3D list_first_entry(&kvm->irqfds, struct _irqfd, list);
>> +		list_del(&irqfd->list);
>> +	}
>> +
>> +	mutex_unlock(&kvm->lock);
>> +
>> +	return irqfd;
>> +}
>> +
>>  void
>>  kvm_irqfd_release(struct kvm *kvm)
>>  {
>> -	struct _irqfd *irqfd, *tmp;
>> +	struct _irqfd *irqfd;
>> =20
>> -	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list) {
>> -		if (irqfd->wqh)
>> -			remove_wait_queue(irqfd->wqh, &irqfd->wait);
>> +	while ((irqfd =3D irqfd_pop(kvm))) {
>> =20
>> -		flush_work(&irqfd->inject);
>> +		remove_wait_queue(irqfd->wqh, &irqfd->wait);
>> =20
>> -		mutex_lock(&kvm->lock);
>> -		list_del(&irqfd->list);
>> -		mutex_unlock(&kvm->lock);
>> +		/*
>> +		 * We guarantee there will be no more notifications after
>> +		 * the remove_wait_queue returns.  Now lets make sure we
>> +		 * synchronize behind any outstanding work items before
>> +		 * releasing the resources
>> +		 */
>> +		flush_work(&irqfd->work);
>> =20
>> -		kfree(irqfd);
>> +		irqfd_release(irqfd);
>>  	}
>> +
>> +	/*
>> +	 * We need to wait in case there are any outstanding work-items
>> +	 * in flight that had already removed themselves from the list
>> +	 * prior to entry to this function
>> +	 */
>>    =20
>
> Looks scary. Why doesn't the flush above cover all cases?
>  =20

The path inside the while() is for when KVM wins the race and finds the
item in the list.  It atomically removes it, and is responsible for
freeing it in a coordinated way.  In this case, we must block with the
flush_work() before we can irqfd_release() so that we do not yank the
memory out from under a running work-item.

The flush_scheduled_work() is for when eventfd wins the race and has
already removed itself from the list in the "shutdown" path in the
work-item.  We want to make sure that kvm_irqfd_release() cannot return
until all work-items have exited to prevent something like the kvm.ko
module unloading while the work-item is still in flight.

Thanks Michael,
-Greg
>  =20
>> +	flush_scheduled_work();
>>  }
>>    =20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>  =20



--------------enig7519CAC0089EF438E0EB6E36
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAko/v/EACgkQP5K2CMvXmqGOLACcCGbwSxuaKy9u4ts1TSfVWK4Z
Lm8An1CmSxnOBJGYaWrxI1rqDflYCUXf
=JeP/
-----END PGP SIGNATURE-----

--------------enig7519CAC0089EF438E0EB6E36--
