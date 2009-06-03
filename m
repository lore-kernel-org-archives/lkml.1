Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbZFCBx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbZFCBx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 21:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbZFCBxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 21:53:50 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:55130 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbZFCBxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 21:53:48 -0400
Message-ID: <4A25D799.10604@novell.com>
Date: Tue, 02 Jun 2009 21:53:29 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, mst@redhat.com
Subject: Re: [KVM-RFC PATCH 2/2] kvm: use POLLHUP to close an irqfd instead
 of an explicit ioctl
References: <20090602151135.29746.91320.stgit@dev.haskins.net> <20090602151538.29746.40356.stgit@dev.haskins.net> <20090602180256.GD6743@linux.vnet.ibm.com> <4A256E12.9060301@novell.com> <20090602220157.GF6743@linux.vnet.ibm.com>
In-Reply-To: <20090602220157.GF6743@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6D819D70084DFBDA4B6CE0B1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6D819D70084DFBDA4B6CE0B1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Paul E. McKenney wrote:
> On Tue, Jun 02, 2009 at 02:23:14PM -0400, Gregory Haskins wrote:
>  =20
>> Paul E. McKenney wrote:
>>    =20
>>> On Tue, Jun 02, 2009 at 11:15:38AM -0400, Gregory Haskins wrote:
>>>  =20
>>>      =20
>>>> Assigning an irqfd object to a kvm object creates a relationship tha=
t we
>>>> currently manage by having the kvm oject acquire/hold a file* refere=
nce to
>>>> the underlying eventfd.  The lifetime of these objects is properly m=
aintained
>>>> by decoupling the two objects whenever the irqfd is closed or kvm is=
 closed,
>>>> whichever comes first.
>>>>
>>>> However, the irqfd "close" method is less than ideal since it requir=
es two
>>>> system calls to complete (one for ioctl(kvmfd, IRQFD_DEASSIGN), the =
other for
>>>> close(eventfd)).  This dual-call approach was utilized because there=
 was no
>>>> notification mechanism on the eventfd side at the time irqfd was imp=
lemented.
>>>>
>>>> Recently, Davide proposed a patch to send a POLLHUP wakeup whenever =
an
>>>> eventfd is about to close.  So we eliminate the IRQFD_DEASSIGN ioctl=
 (*)
>>>> vector in favor of sensing the desassign automatically when the fd i=
s closed.
>>>> The resulting code is slightly more complex as a result since we nee=
d to
>>>> allow either side to sever the relationship independently.  We utili=
ze SRCU
>>>> to guarantee stable concurrent access to the KVM pointer without add=
ing
>>>> additional atomic operations in the fast path.
>>>>
>>>> At minimum, this design should be acked by both Davide and Paul (cc'=
d).
>>>>
>>>> (*) The irqfd patch does not exist in any released tree, so the unde=
rstanding
>>>> is that we can alter the irqfd specific ABI without taking the norma=
l
>>>> precautions, such as CAP bits.
>>>>    =20
>>>>        =20
>>> A few questions and suggestions interspersed below.
>>>
>>> 							Thanx, Paul
>>>  =20
>>>      =20
>> Thanks for the review, Paul.
>>    =20
>
> Some questions, clarifications, and mea culpas below.
>
> 							Thanx, Paul
>
>  =20
>> (FYI: This isn't quite what I was asking you about on IRC yesterday, b=
ut
>> it's related...and the SRCU portion of the conversation *did* inspire =
me
>> here.  Just note that the stuff I was asking about is still forthcomin=
g)
>>    =20
>
> ;-)
>
>  =20
>>>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>>>> CC: Davide Libenzi <davidel@xmailserver.org>
>>>> CC: Michael S. Tsirkin <mst@redhat.com>
>>>> CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>>> ---
>>>>
>>>>  include/linux/kvm.h |    2 -
>>>>  virt/kvm/eventfd.c  |  177 +++++++++++++++++++++++-----------------=
-----------
>>>>  virt/kvm/kvm_main.c |    3 +
>>>>  3 files changed, 81 insertions(+), 101 deletions(-)
>>>>
>>>> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
>>>> index 632a856..29b62cc 100644
>>>> --- a/include/linux/kvm.h
>>>> +++ b/include/linux/kvm.h
>>>> @@ -482,8 +482,6 @@ struct kvm_x86_mce {
>>>>  };
>>>>  #endif
>>>>
>>>> -#define KVM_IRQFD_FLAG_DEASSIGN (1 << 0)
>>>> -
>>>>  struct kvm_irqfd {
>>>>  	__u32 fd;
>>>>  	__u32 gsi;
>>>> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
>>>> index f3f2ea1..6ed62e2 100644
>>>> --- a/virt/kvm/eventfd.c
>>>> +++ b/virt/kvm/eventfd.c
>>>> @@ -37,26 +37,63 @@
>>>>   * ----------------------------------------------------------------=
----
>>>>   */
>>>>  struct _irqfd {
>>>> +	struct mutex              lock;
>>>> +	struct srcu_struct        srcu;
>>>>  	struct kvm               *kvm;
>>>>  	int                       gsi;
>>>> -	struct file              *file;
>>>>  	struct list_head          list;
>>>>  	poll_table                pt;
>>>>  	wait_queue_head_t        *wqh;
>>>>  	wait_queue_t              wait;
>>>> -	struct work_struct        work;
>>>> +	struct work_struct        inject;
>>>>  };
>>>>
>>>>  static void
>>>>  irqfd_inject(struct work_struct *work)
>>>>  {
>>>> -	struct _irqfd *irqfd =3D container_of(work, struct _irqfd, work);
>>>> -	struct kvm *kvm =3D irqfd->kvm;
>>>> +	struct _irqfd *irqfd =3D container_of(work, struct _irqfd, inject)=
;
>>>> +	struct kvm *kvm;
>>>> +	int idx;
>>>> +
>>>> +	idx =3D srcu_read_lock(&irqfd->srcu);
>>>> +
>>>> +	kvm =3D rcu_dereference(irqfd->kvm);
>>>>        =20

[4]

>>>> +	if (kvm) {
>>>> +		mutex_lock(&kvm->lock);
>>>> +		kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
>>>> +		kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
>>>> +		mutex_unlock(&kvm->lock);
>>>> +	}
>>>> +
>>>> +	srcu_read_unlock(&irqfd->srcu, idx);
>>>> +}
>>>>    =20
>>>>        =20
>> [1]
>>
>>    =20
>>>> +
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
>>>>    =20
>>>>        =20
>> [2]
>>
>>    =20
>>>> +
>>>> +	if (!kvm)
>>>> +		return;
>>>>
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
>>>>    =20
>>>>        =20
>>> The lockless references are all harmless even if carried out after th=
e
>>> kvm structure has been removed?
>>>      =20
>> No, but all ([1]) references to my knowledge occur within an srcu
>> read-side CS, and we only drop the object reference ([3]) outside of
>> that CS by virtue of the synchronize_srcu() barrier below.  The one
>> notable exception is [2], which I don't declare as a read-side CS sinc=
e
>> I hold the mutex during the swap.
>>
>> OTOH, this is really my _intention_, not _reality_ per se. ;)  E.g. I
>> may have completely flubbed up the design, so I'm glad you are looking=

>> at it.
>>    =20
>
> Looks good in general -- my question is about the window of time
> between when the object is removed from the list (and might still have
> readers referencing it) and when the object is freed (and, courtesy of
> synchronize_srcu(), can no longer be referenced by readers).
>
> In other words, the following sequence of events:
>
> o	CPU 0 picks up a pointer to the object.
>
> o	CPU 1 removes that same object from the list, and invokes
> 	synchronize_srcu(), which cannot return yet due to CPU 0
> 	being in an SRCU read-side critical section.
>
> o	CPU 0 acquires the lock and invokes the pair of kvm_set_irq()
> 	calls, releases the lock and exits the SRCU read-side critical
> 	section.
>
> o	CPU 1's synchronize_srcu() can now return, and does.
>
> o	CPU 1 frees the object.
>
> I honestly don't know enough about KVM to say whether or not this is a
> problem, but thought I should ask.  ;-)
>  =20

Right, ok.  What you outline is consistent with my expectations.  That
is, I need to make sure that it is not possible to have any concurrent
code call kvm_put_cpu between [4] and [1] against the same pointer.   It
is, of course, ok if some other code path enters irqfd_inject() _after_
[2] because I would have already swapped the pointer with NULL and it
will simply bail out on the conditional right after [4].
>  =20
>>>   Or does there need to be a ->deleted
>>> field that allows the lockless references to ignore a kvm structure t=
hat
>>> has already been deleted?
>>>      =20
>> I guess you could say that the "rcu_assign_pointer(NULL)" is my
>> "deleted" field.  The reader-side code in question should check for th=
at
>> condition before proceeding.
>>    =20
>
> Fair enough!  But please keep in mind that the pointer could be assigne=
d
> to NULL just after we dereference it, especially if we are interrupted
> or preempted or something.

Right, and that should be ok IIUC as long as I can be guaranteed to
never call kvm_put_kvm() before the dereferencer calls
srcu_read_unlock().  I currently believe this guarantee is provided by
the synchronize_srcu() at [3], but please straighten me out if that is a
naive assumption.

>   Or is the idea to re-check the pointer under some lock?
>
>  =20
I do not currently believe I need to worry about that case, but as
always, straighten me out if that is wrong. ;)

>>> On the other hand, if it really is somehow OK for kvm_set_irq() to be=

>>> called on an already-deleted kvm structure, then this code would be O=
K
>>> as is.
>>>      =20
>> Definitely not, so if you think that can happen please raise the flag.=

>>    =20
>
> Apologies, I was being a bit sloppy.  Instead of "already-deleted",
> I should have said something like "already removed from the list but
> not yet freed".
>  =20

Ah, ok.  The answer in that case would be "yes".  It's ok to call
kvm_set_irq() while the irqfd->kvm pointer is NULL, but it is not ok to
call it after or during kvm_put_kvm() has been invoked.  Technically the
first safe point is right after the last mutex_unlock(&kvm->lock)
completes (right before [1]), and is officially annotated with the
subsequent srcu_read_unlock().
>  =20
>>>> +	synchronize_srcu(&irqfd->srcu);
>>>> +	kvm_put_kvm(kvm);
>>>>    =20
>>>>        =20
>> [3]
>>
>>    =20
>>>>  }
>>>>
>>>>  static int
>>>> @@ -64,12 +101,28 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode,=
 int sync, void *key)
>>>>  {
>>>>  	struct _irqfd *irqfd =3D container_of(wait, struct _irqfd, wait);
>>>>
>>>> -	/*
>>>> -	 * The wake_up is called with interrupts disabled.  Therefore we n=
eed
>>>> -	 * to defer the IRQ injection until later since we need to acquire=
 the
>>>> -	 * kvm->lock to do so.
>>>> -	 */
>>>> -	schedule_work(&irqfd->work);
>>>> +	switch ((unsigned long)key) {
>>>> +	case POLLIN:
>>>> +		/*
>>>> +		 * The POLLIN wake_up is called with interrupts disabled.
>>>> +		 * Therefore we need to defer the IRQ injection until later
>>>> +		 * since we need to acquire the kvm->lock to do so.
>>>> +		 */
>>>> +		schedule_work(&irqfd->inject);
>>>> +		break;
>>>> +	case POLLHUP:
>>>> +		/*
>>>> +		 * The POLLHUP is called unlocked, so it theoretically should
>>>> +		 * be safe to remove ourselves from the wqh
>>>> +		 */
>>>> +		remove_wait_queue(irqfd->wqh, &irqfd->wait);
>>>> +		flush_work(&irqfd->inject);
>>>> +		irqfd_disconnect(irqfd);
>>>>    =20
>>>>        =20
>>> Good.  The fact that irqfd_disconnect() does a synchronize_srcu()
>>> prevents any readers from trying to do an SRCU operation on an alread=
y
>>> cleaned-up srcu_struct, so this does look safe to me.
>>>      =20
>> As an additional data point, we can guarantee that we will never be
>> called again since we synchronously unhook from the wqh and kvm->irqfd=
s
>> list, and the POLLHUP is called from f_ops->release().
>>    =20
>
> So the window is short, but still exists, correct?
>  =20

Can you elaborate?


>  =20
>>>> +		cleanup_srcu_struct(&irqfd->srcu);
>>>> +		kfree(irqfd);
>>>> +		break;
>>>> +	}
>>>>
>>>>  	return 0;
>>>>  }
>>>> @@ -84,8 +137,8 @@ irqfd_ptable_queue_proc(struct file *file, wait_q=
ueue_head_t *wqh,
>>>>  	add_wait_queue(wqh, &irqfd->wait);
>>>>  }
>>>>
>>>> -static int
>>>> -kvm_assign_irqfd(struct kvm *kvm, int fd, int gsi)
>>>> +int
>>>> +kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
>>>>  {
>>>>  	struct _irqfd *irqfd;
>>>>  	struct file *file =3D NULL;
>>>> @@ -95,10 +148,12 @@ kvm_assign_irqfd(struct kvm *kvm, int fd, int g=
si)
>>>>  	if (!irqfd)
>>>>  		return -ENOMEM;
>>>>
>>>> +	mutex_init(&irqfd->lock);
>>>> +	init_srcu_struct(&irqfd->srcu);
>>>>  	irqfd->kvm =3D kvm;
>>>>  	irqfd->gsi =3D gsi;
>>>>  	INIT_LIST_HEAD(&irqfd->list);
>>>> -	INIT_WORK(&irqfd->work, irqfd_inject);
>>>> +	INIT_WORK(&irqfd->inject, irqfd_inject);
>>>>
>>>>  	/*
>>>>  	 * Embed the file* lifetime in the irqfd.
>>>> @@ -120,12 +175,18 @@ kvm_assign_irqfd(struct kvm *kvm, int fd, int =
gsi)
>>>>  	if (ret < 0)
>>>>  		goto fail;
>>>>
>>>> -	irqfd->file =3D file;
>>>> +	kvm_get_kvm(kvm);
>>>>
>>>>  	mutex_lock(&kvm->lock);
>>>>  	list_add_tail(&irqfd->list, &kvm->irqfds);
>>>>    =20
>>>>        =20
>>> Doesn't the above need to be list_add_tail_rcu()?  Unless I am confus=
ed,
>>> this is the point at which the new SRCU-protected structure is first
>>> made public.  If so, you really do need list_add_tail_rcu() to make s=
ure
>>> that concurrent readers don't see pre-initialized values in the struc=
ture.
>>>      =20
>> I *think* this is ok as a traditional list, because the only paths tha=
t
>> touch this list are guarded by the kvm->lock mutex.  Let me know if yo=
u
>> see otherwise or if that is not enough.
>>    =20
>
> My mistake, you are using rcu_assign_pointer() and rcu_dereference()
> instead of the list primitives.  Never mind!!!
>  =20

Yeah, and note that we actually have two types of objects and their
references floating around:

*) We have "struct irqfd" which can be thought of as an extension of
eventfd.  It holds exactly one (or zero) references to kvm via the
irqfd->kvm pointer, and as you note above I use rcu_XX() macros and srcu
to manage it.

*) Conversely, we have "struct kvm" which may have a 1:N relationship
with many irqfds, which I manage with a standard list at kvm->irqfds
protected by kvm->lock.

So the code that uses the rcu_dereference/rcu_assign_pointer is actually
different than the code mentioned above that is manipulating the
kvm->irqfds list with list_add_tail().  The latter isn't directly RCU
related and is why you see the non-rcu variants of the list functions in
use.

That said, if you still see a hole in that approach, do not be shy in
pointing it out ;)

Thanks again for taking to time to go over all this, Paul.  I know you
are very busy, and its very much appreciated!

-Greg

>  =20
>>>>  	mutex_unlock(&kvm->lock);
>>>>
>>>> +	/*
>>>> +	 * do not drop the file until the irqfd is fully initialized, othe=
rwise
>>>> +	 * we might race against the POLLHUP
>>>> +	 */
>>>> +	fput(file);
>>>> +
>>>>  	return 0;
>>>>
>>>>  fail:
>>>> @@ -139,97 +200,17 @@ fail:
>>>>  	return ret;
>>>>  }
>>>>
>>>> -static void
>>>> -irqfd_release(struct _irqfd *irqfd)
>>>> -{
>>>> -	/*
>>>> -	 * The ordering is important.  We must remove ourselves from the w=
qh
>>>> -	 * first to ensure no more event callbacks are issued, and then fl=
ush
>>>> -	 * any previously scheduled work prior to freeing the memory
>>>> -	 */
>>>> -	remove_wait_queue(irqfd->wqh, &irqfd->wait);
>>>> -
>>>> -	flush_work(&irqfd->work);
>>>> -
>>>> -	fput(irqfd->file);
>>>> -	kfree(irqfd);
>>>> -}
>>>> -
>>>> -static struct _irqfd *
>>>> -irqfd_remove(struct kvm *kvm, struct file *file, int gsi)
>>>> -{
>>>> -	struct _irqfd *irqfd;
>>>> -
>>>> -	mutex_lock(&kvm->lock);
>>>> -
>>>> -	/*
>>>> -	 * linear search isn't brilliant, but this should be an infrequent=

>>>> -	 * slow-path operation, and the list should not grow very large
>>>> -	 */
>>>> -	list_for_each_entry(irqfd, &kvm->irqfds, list) {
>>>> -		if (irqfd->file !=3D file || irqfd->gsi !=3D gsi)
>>>> -			continue;
>>>> -
>>>> -		list_del(&irqfd->list);
>>>> -		mutex_unlock(&kvm->lock);
>>>> -
>>>> -		return irqfd;
>>>> -	}
>>>> -
>>>> -	mutex_unlock(&kvm->lock);
>>>> -
>>>> -	return NULL;
>>>> -}
>>>> -
>>>> -static int
>>>> -kvm_deassign_irqfd(struct kvm *kvm, int fd, int gsi)
>>>> -{
>>>> -	struct _irqfd *irqfd;
>>>> -	struct file *file;
>>>> -	int count =3D 0;
>>>> -
>>>> -	file =3D fget(fd);
>>>> -	if (IS_ERR(file))
>>>> -		return PTR_ERR(file);
>>>> -
>>>> -	while ((irqfd =3D irqfd_remove(kvm, file, gsi))) {
>>>> -		/*
>>>> -		 * We remove the item from the list under the lock, but we
>>>> -		 * free it outside the lock to avoid deadlocking with the
>>>> -		 * flush_work and the work_item taking the lock
>>>> -		 */
>>>> -		irqfd_release(irqfd);
>>>> -		count++;
>>>> -	}
>>>> -
>>>> -	fput(file);
>>>> -
>>>> -	return count ? count : -ENOENT;
>>>> -}
>>>> -
>>>>  void
>>>>  kvm_irqfd_init(struct kvm *kvm)
>>>>  {
>>>>  	INIT_LIST_HEAD(&kvm->irqfds);
>>>>  }
>>>>
>>>> -int
>>>> -kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
>>>> -{
>>>> -	if (flags & KVM_IRQFD_FLAG_DEASSIGN)
>>>> -		return kvm_deassign_irqfd(kvm, fd, gsi);
>>>> -
>>>> -	return kvm_assign_irqfd(kvm, fd, gsi);
>>>> -}
>>>> -
>>>>  void
>>>>  kvm_irqfd_release(struct kvm *kvm)
>>>>  {
>>>>  	struct _irqfd *irqfd, *tmp;
>>>>
>>>> -	/* don't bother with the lock..we are shutting down */
>>>> -	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list) {
>>>> -		list_del(&irqfd->list);
>>>> -		irqfd_release(irqfd);
>>>> -	}
>>>> +	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list)
>>>> +		irqfd_disconnect(irqfd);
>>>>  }
>>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>>> index 902fed9..a9f62bb 100644
>>>> --- a/virt/kvm/kvm_main.c
>>>> +++ b/virt/kvm/kvm_main.c
>>>> @@ -1029,7 +1029,6 @@ static void kvm_destroy_vm(struct kvm *kvm)
>>>>  	spin_lock(&kvm_lock);
>>>>  	list_del(&kvm->vm_list);
>>>>  	spin_unlock(&kvm_lock);
>>>> -	kvm_irqfd_release(kvm);
>>>>  	kvm_free_irq_routing(kvm);
>>>>  	kvm_io_bus_destroy(&kvm->pio_bus);
>>>>  	kvm_io_bus_destroy(&kvm->mmio_bus);
>>>> @@ -1064,6 +1063,8 @@ static int kvm_vm_release(struct inode *inode,=
 struct file *filp)
>>>>  {
>>>>  	struct kvm *kvm =3D filp->private_data;
>>>>
>>>> +	kvm_irqfd_release(kvm);
>>>> +
>>>>  	kvm_put_kvm(kvm);
>>>>  	return 0;
>>>>  }
>>>>
>>>>    =20
>>>>        =20
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>  =20
>>>      =20
>>    =20
>
>
>  =20




--------------enig6D819D70084DFBDA4B6CE0B1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkol150ACgkQlOSOBdgZUxnTcACfV6jCBB2h+/Ivz2cIz+B7MnuF
868Anj1fMF+hQwfJKSD9L2qN/riBj1Ft
=nz/K
-----END PGP SIGNATURE-----

--------------enig6D819D70084DFBDA4B6CE0B1--
