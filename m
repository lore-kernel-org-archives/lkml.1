Return-Path: <linux-kernel-owner+w=401wt.eu-S1759096AbZFBSXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759096AbZFBSXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 14:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755128AbZFBSXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 14:23:35 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:44322 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbZFBSXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 14:23:34 -0400
Message-ID: <4A256E12.9060301@novell.com>
Date: Tue, 02 Jun 2009 14:23:14 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, mst@redhat.com
Subject: Re: [KVM-RFC PATCH 2/2] kvm: use POLLHUP to close an irqfd instead
 of an explicit ioctl
References: <20090602151135.29746.91320.stgit@dev.haskins.net> <20090602151538.29746.40356.stgit@dev.haskins.net> <20090602180256.GD6743@linux.vnet.ibm.com>
In-Reply-To: <20090602180256.GD6743@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4CEF18A2C563C0BCDB9F6B18"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4CEF18A2C563C0BCDB9F6B18
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Paul E. McKenney wrote:
> On Tue, Jun 02, 2009 at 11:15:38AM -0400, Gregory Haskins wrote:
>  =20
>> Assigning an irqfd object to a kvm object creates a relationship that =
we
>> currently manage by having the kvm oject acquire/hold a file* referenc=
e to
>> the underlying eventfd.  The lifetime of these objects is properly mai=
ntained
>> by decoupling the two objects whenever the irqfd is closed or kvm is c=
losed,
>> whichever comes first.
>>
>> However, the irqfd "close" method is less than ideal since it requires=
 two
>> system calls to complete (one for ioctl(kvmfd, IRQFD_DEASSIGN), the ot=
her for
>> close(eventfd)).  This dual-call approach was utilized because there w=
as no
>> notification mechanism on the eventfd side at the time irqfd was imple=
mented.
>>
>> Recently, Davide proposed a patch to send a POLLHUP wakeup whenever an=

>> eventfd is about to close.  So we eliminate the IRQFD_DEASSIGN ioctl (=
*)
>> vector in favor of sensing the desassign automatically when the fd is =
closed.
>> The resulting code is slightly more complex as a result since we need =
to
>> allow either side to sever the relationship independently.  We utilize=
 SRCU
>> to guarantee stable concurrent access to the KVM pointer without addin=
g
>> additional atomic operations in the fast path.
>>
>> At minimum, this design should be acked by both Davide and Paul (cc'd)=
=2E
>>
>> (*) The irqfd patch does not exist in any released tree, so the unders=
tanding
>> is that we can alter the irqfd specific ABI without taking the normal
>> precautions, such as CAP bits.
>>    =20
>
> A few questions and suggestions interspersed below.
>
> 							Thanx, Paul
>  =20

Thanks for the review, Paul.

(FYI: This isn't quite what I was asking you about on IRC yesterday, but
it's related...and the SRCU portion of the conversation *did* inspire me
here.  Just note that the stuff I was asking about is still forthcoming)

>  =20
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>> CC: Davide Libenzi <davidel@xmailserver.org>
>> CC: Michael S. Tsirkin <mst@redhat.com>
>> CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> ---
>>
>>  include/linux/kvm.h |    2 -
>>  virt/kvm/eventfd.c  |  177 +++++++++++++++++++++++-------------------=
---------
>>  virt/kvm/kvm_main.c |    3 +
>>  3 files changed, 81 insertions(+), 101 deletions(-)
>>
>> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
>> index 632a856..29b62cc 100644
>> --- a/include/linux/kvm.h
>> +++ b/include/linux/kvm.h
>> @@ -482,8 +482,6 @@ struct kvm_x86_mce {
>>  };
>>  #endif
>>
>> -#define KVM_IRQFD_FLAG_DEASSIGN (1 << 0)
>> -
>>  struct kvm_irqfd {
>>  	__u32 fd;
>>  	__u32 gsi;
>> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
>> index f3f2ea1..6ed62e2 100644
>> --- a/virt/kvm/eventfd.c
>> +++ b/virt/kvm/eventfd.c
>> @@ -37,26 +37,63 @@
>>   * ------------------------------------------------------------------=
--
>>   */
>>  struct _irqfd {
>> +	struct mutex              lock;
>> +	struct srcu_struct        srcu;
>>  	struct kvm               *kvm;
>>  	int                       gsi;
>> -	struct file              *file;
>>  	struct list_head          list;
>>  	poll_table                pt;
>>  	wait_queue_head_t        *wqh;
>>  	wait_queue_t              wait;
>> -	struct work_struct        work;
>> +	struct work_struct        inject;
>>  };
>>
>>  static void
>>  irqfd_inject(struct work_struct *work)
>>  {
>> -	struct _irqfd *irqfd =3D container_of(work, struct _irqfd, work);
>> -	struct kvm *kvm =3D irqfd->kvm;
>> +	struct _irqfd *irqfd =3D container_of(work, struct _irqfd, inject);
>> +	struct kvm *kvm;
>> +	int idx;
>> +
>> +	idx =3D srcu_read_lock(&irqfd->srcu);
>> +
>> +	kvm =3D rcu_dereference(irqfd->kvm);
>> +	if (kvm) {
>> +		mutex_lock(&kvm->lock);
>> +		kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
>> +		kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
>> +		mutex_unlock(&kvm->lock);
>> +	}
>> +
>> +	srcu_read_unlock(&irqfd->srcu, idx);
>> +}
>>    =20

[1]

>> +
>> +static void
>> +irqfd_disconnect(struct _irqfd *irqfd)
>> +{
>> +	struct kvm *kvm;
>> +
>> +	mutex_lock(&irqfd->lock);
>> +
>> +	kvm =3D rcu_dereference(irqfd->kvm);
>> +	rcu_assign_pointer(irqfd->kvm, NULL);
>> +
>> +	mutex_unlock(&irqfd->lock);
>>    =20

[2]

>> +
>> +	if (!kvm)
>> +		return;
>>
>>  	mutex_lock(&kvm->lock);
>> -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 1);
>> -	kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID, irqfd->gsi, 0);
>> +	list_del(&irqfd->list);
>>  	mutex_unlock(&kvm->lock);
>> +
>> +	/*
>> +	 * It is important to not drop the kvm reference until the next grac=
e
>> +	 * period because there might be lockless references in flight up
>> +	 * until then
>> +	 */
>>    =20
>
> The lockless references are all harmless even if carried out after the
> kvm structure has been removed?

No, but all ([1]) references to my knowledge occur within an srcu
read-side CS, and we only drop the object reference ([3]) outside of
that CS by virtue of the synchronize_srcu() barrier below.  The one
notable exception is [2], which I don't declare as a read-side CS since
I hold the mutex during the swap.

OTOH, this is really my _intention_, not _reality_ per se. ;)  E.g. I
may have completely flubbed up the design, so I'm glad you are looking
at it.

>   Or does there need to be a ->deleted
> field that allows the lockless references to ignore a kvm structure tha=
t
> has already been deleted?
>  =20

I guess you could say that the "rcu_assign_pointer(NULL)" is my
"deleted" field.  The reader-side code in question should check for that
condition before proceeding.

> On the other hand, if it really is somehow OK for kvm_set_irq() to be
> called on an already-deleted kvm structure, then this code would be OK
> as is.
>  =20

Definitely not, so if you think that can happen please raise the flag.
>  =20
>> +	synchronize_srcu(&irqfd->srcu);
>> +	kvm_put_kvm(kvm);
>>    =20

[3]

>>  }
>>
>>  static int
>> @@ -64,12 +101,28 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, i=
nt sync, void *key)
>>  {
>>  	struct _irqfd *irqfd =3D container_of(wait, struct _irqfd, wait);
>>
>> -	/*
>> -	 * The wake_up is called with interrupts disabled.  Therefore we nee=
d
>> -	 * to defer the IRQ injection until later since we need to acquire t=
he
>> -	 * kvm->lock to do so.
>> -	 */
>> -	schedule_work(&irqfd->work);
>> +	switch ((unsigned long)key) {
>> +	case POLLIN:
>> +		/*
>> +		 * The POLLIN wake_up is called with interrupts disabled.
>> +		 * Therefore we need to defer the IRQ injection until later
>> +		 * since we need to acquire the kvm->lock to do so.
>> +		 */
>> +		schedule_work(&irqfd->inject);
>> +		break;
>> +	case POLLHUP:
>> +		/*
>> +		 * The POLLHUP is called unlocked, so it theoretically should
>> +		 * be safe to remove ourselves from the wqh
>> +		 */
>> +		remove_wait_queue(irqfd->wqh, &irqfd->wait);
>> +		flush_work(&irqfd->inject);
>> +		irqfd_disconnect(irqfd);
>>    =20
>
> Good.  The fact that irqfd_disconnect() does a synchronize_srcu()
> prevents any readers from trying to do an SRCU operation on an already
> cleaned-up srcu_struct, so this does look safe to me.
>  =20

As an additional data point, we can guarantee that we will never be
called again since we synchronously unhook from the wqh and kvm->irqfds
list, and the POLLHUP is called from f_ops->release().

>  =20
>> +		cleanup_srcu_struct(&irqfd->srcu);
>> +		kfree(irqfd);
>> +		break;
>> +	}
>>
>>  	return 0;
>>  }
>> @@ -84,8 +137,8 @@ irqfd_ptable_queue_proc(struct file *file, wait_que=
ue_head_t *wqh,
>>  	add_wait_queue(wqh, &irqfd->wait);
>>  }
>>
>> -static int
>> -kvm_assign_irqfd(struct kvm *kvm, int fd, int gsi)
>> +int
>> +kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
>>  {
>>  	struct _irqfd *irqfd;
>>  	struct file *file =3D NULL;
>> @@ -95,10 +148,12 @@ kvm_assign_irqfd(struct kvm *kvm, int fd, int gsi=
)
>>  	if (!irqfd)
>>  		return -ENOMEM;
>>
>> +	mutex_init(&irqfd->lock);
>> +	init_srcu_struct(&irqfd->srcu);
>>  	irqfd->kvm =3D kvm;
>>  	irqfd->gsi =3D gsi;
>>  	INIT_LIST_HEAD(&irqfd->list);
>> -	INIT_WORK(&irqfd->work, irqfd_inject);
>> +	INIT_WORK(&irqfd->inject, irqfd_inject);
>>
>>  	/*
>>  	 * Embed the file* lifetime in the irqfd.
>> @@ -120,12 +175,18 @@ kvm_assign_irqfd(struct kvm *kvm, int fd, int gs=
i)
>>  	if (ret < 0)
>>  		goto fail;
>>
>> -	irqfd->file =3D file;
>> +	kvm_get_kvm(kvm);
>>
>>  	mutex_lock(&kvm->lock);
>>  	list_add_tail(&irqfd->list, &kvm->irqfds);
>>    =20
>
> Doesn't the above need to be list_add_tail_rcu()?  Unless I am confused=
,
> this is the point at which the new SRCU-protected structure is first
> made public.  If so, you really do need list_add_tail_rcu() to make sur=
e
> that concurrent readers don't see pre-initialized values in the structu=
re.
>  =20

I *think* this is ok as a traditional list, because the only paths that
touch this list are guarded by the kvm->lock mutex.  Let me know if you
see otherwise or if that is not enough.
>  =20
>>  	mutex_unlock(&kvm->lock);
>>
>> +	/*
>> +	 * do not drop the file until the irqfd is fully initialized, otherw=
ise
>> +	 * we might race against the POLLHUP
>> +	 */
>> +	fput(file);
>> +
>>  	return 0;
>>
>>  fail:
>> @@ -139,97 +200,17 @@ fail:
>>  	return ret;
>>  }
>>
>> -static void
>> -irqfd_release(struct _irqfd *irqfd)
>> -{
>> -	/*
>> -	 * The ordering is important.  We must remove ourselves from the wqh=

>> -	 * first to ensure no more event callbacks are issued, and then flus=
h
>> -	 * any previously scheduled work prior to freeing the memory
>> -	 */
>> -	remove_wait_queue(irqfd->wqh, &irqfd->wait);
>> -
>> -	flush_work(&irqfd->work);
>> -
>> -	fput(irqfd->file);
>> -	kfree(irqfd);
>> -}
>> -
>> -static struct _irqfd *
>> -irqfd_remove(struct kvm *kvm, struct file *file, int gsi)
>> -{
>> -	struct _irqfd *irqfd;
>> -
>> -	mutex_lock(&kvm->lock);
>> -
>> -	/*
>> -	 * linear search isn't brilliant, but this should be an infrequent
>> -	 * slow-path operation, and the list should not grow very large
>> -	 */
>> -	list_for_each_entry(irqfd, &kvm->irqfds, list) {
>> -		if (irqfd->file !=3D file || irqfd->gsi !=3D gsi)
>> -			continue;
>> -
>> -		list_del(&irqfd->list);
>> -		mutex_unlock(&kvm->lock);
>> -
>> -		return irqfd;
>> -	}
>> -
>> -	mutex_unlock(&kvm->lock);
>> -
>> -	return NULL;
>> -}
>> -
>> -static int
>> -kvm_deassign_irqfd(struct kvm *kvm, int fd, int gsi)
>> -{
>> -	struct _irqfd *irqfd;
>> -	struct file *file;
>> -	int count =3D 0;
>> -
>> -	file =3D fget(fd);
>> -	if (IS_ERR(file))
>> -		return PTR_ERR(file);
>> -
>> -	while ((irqfd =3D irqfd_remove(kvm, file, gsi))) {
>> -		/*
>> -		 * We remove the item from the list under the lock, but we
>> -		 * free it outside the lock to avoid deadlocking with the
>> -		 * flush_work and the work_item taking the lock
>> -		 */
>> -		irqfd_release(irqfd);
>> -		count++;
>> -	}
>> -
>> -	fput(file);
>> -
>> -	return count ? count : -ENOENT;
>> -}
>> -
>>  void
>>  kvm_irqfd_init(struct kvm *kvm)
>>  {
>>  	INIT_LIST_HEAD(&kvm->irqfds);
>>  }
>>
>> -int
>> -kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
>> -{
>> -	if (flags & KVM_IRQFD_FLAG_DEASSIGN)
>> -		return kvm_deassign_irqfd(kvm, fd, gsi);
>> -
>> -	return kvm_assign_irqfd(kvm, fd, gsi);
>> -}
>> -
>>  void
>>  kvm_irqfd_release(struct kvm *kvm)
>>  {
>>  	struct _irqfd *irqfd, *tmp;
>>
>> -	/* don't bother with the lock..we are shutting down */
>> -	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list) {
>> -		list_del(&irqfd->list);
>> -		irqfd_release(irqfd);
>> -	}
>> +	list_for_each_entry_safe(irqfd, tmp, &kvm->irqfds, list)
>> +		irqfd_disconnect(irqfd);
>>  }
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 902fed9..a9f62bb 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -1029,7 +1029,6 @@ static void kvm_destroy_vm(struct kvm *kvm)
>>  	spin_lock(&kvm_lock);
>>  	list_del(&kvm->vm_list);
>>  	spin_unlock(&kvm_lock);
>> -	kvm_irqfd_release(kvm);
>>  	kvm_free_irq_routing(kvm);
>>  	kvm_io_bus_destroy(&kvm->pio_bus);
>>  	kvm_io_bus_destroy(&kvm->mmio_bus);
>> @@ -1064,6 +1063,8 @@ static int kvm_vm_release(struct inode *inode, s=
truct file *filp)
>>  {
>>  	struct kvm *kvm =3D filp->private_data;
>>
>> +	kvm_irqfd_release(kvm);
>> +
>>  	kvm_put_kvm(kvm);
>>  	return 0;
>>  }
>>
>>    =20
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  =20



--------------enig4CEF18A2C563C0BCDB9F6B18
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkolbhYACgkQlOSOBdgZUxkxyACfT93Otx5G5bvBOcMhibpcR7dZ
HqQAn1v7LjV4rSqa6KrAVKrPJiQPRKIp
=L2t8
-----END PGP SIGNATURE-----

--------------enig4CEF18A2C563C0BCDB9F6B18--
