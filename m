Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbZD0Kg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbZD0Kg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 06:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbZD0KgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 06:36:09 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:34244 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbZD0KgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 06:36:07 -0400
Message-ID: <49F58A8C.7090808@novell.com>
Date: Mon, 27 Apr 2009 06:35:56 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v2 2/2] kvm: add support for irqfd via	eventfd-notification
 interface
References: <20090424042142.1796.60756.stgit@dev.haskins.net> <20090424042518.1796.65593.stgit@dev.haskins.net> <49F572EF.4010909@redhat.com>
In-Reply-To: <49F572EF.4010909@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF6D1FAA06BF62E702DDF93A6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF6D1FAA06BF62E702DDF93A6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>> This allows an eventfd to be registered as an irq source with a
>> guest.  Any
>> signaling operation on the eventfd (via userspace or kernel) will inje=
ct
>> the registered GSI at the next available window.
>>
>> =20
>> +struct kvm_irqfd {
>> +    __u32 fd;
>> +    __u32 gsi;
>> +};
>> +
>>  =20
>
> I think it's better to have ioctl create and return the fd.  This way
> we aren't tied to eventfd (though it makes a lot of sense to use it).

I dont mind either way, but I am not sure it buys us much as the one
driving the fd would need to understand if the interface is
eventfd-esque or something else anyway.  Let me know if you still want
to see this changed.

>
> Also, please add a flags field and some padding so we can extend it
> later.
>

Good idea.  Will do.

>> +
>> +#include <linux/kvm_host.h>
>> +#include <linux/eventfd.h>
>> +#include <linux/workqueue.h>
>> +#include <linux/wait.h>
>> +#include <linux/poll.h>
>> +#include <linux/file.h>
>> +#include <linux/list.h>
>> +
>> +struct _irqfd {
>> +    struct kvm               *kvm;
>> +    int                       gsi;
>> +    struct file              *file;
>> +    struct list_head          list;
>> +    poll_table                pt;
>> +    wait_queue_head_t        *wqh;
>> +    wait_queue_t              wait;
>> +    struct work_struct        work;
>> +};
>> +
>> +static void
>> +irqfd_inject(struct work_struct *work)
>> +{
>> +    struct _irqfd *irqfd =3D container_of(work, struct _irqfd, work);=

>> +    struct kvm *kvm =3D irqfd->kvm;
>> +
>> +    mutex_lock(&kvm->lock);
>> +    kvm_set_irq(kvm, kvm->irqfd.src, irqfd->gsi, 1);
>>  =20
>
> Need to lower the irq too (though irqfd only supports edge triggered
> interrupts).
>
Should I just do back-to-back 1+0 inside the same lock?

>> +    mutex_unlock(&kvm->lock);
>> +}
>> +
>> +static int
>> +irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
>> +{
>> +    struct _irqfd *irqfd =3D container_of(wait, struct _irqfd, wait);=

>> +
>> +    /*
>> +     * The eventfd calls its wake_up with interrupts disabled,
>> +     * so we need to defer the IRQ injection until later since we nee=
d
>> +     * to acquire the kvm->lock to do so.
>> +     */
>> +    schedule_work(&irqfd->work);
>> +
>> +    return 0;
>> +}
>>  =20
>
> One day we'll have lockless injection and we'll want to drop this.  I
> guess if we create the fd ourselves we can make it work, but I don't
> see how we can do this with eventfd.
>

Hmm...this is a good point.  There probably is no way to use eventfd
"off the shelf" in a way that doesn't cause this callback to be in a
critical section.  Should we just worry about switching away from
eventfd when this occurs, or should I implement a custom anon-fd now?


>> +int
>> +kvm_irqfd_assign(struct kvm *kvm, int fd, int gsi)
>> +{
>> +    struct _irqfd *irqfd;
>> +    struct file *file;
>> +    int ret;
>> +
>> +    irqfd =3D kzalloc(sizeof(*irqfd), GFP_KERNEL);
>> +    if (!irqfd)
>> +        return -ENOMEM;
>> +
>> +    irqfd->kvm =3D kvm;
>> +    irqfd->gsi =3D gsi;
>> +    INIT_LIST_HEAD(&irqfd->list);
>> +    init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
>> +    init_poll_funcptr(&irqfd->pt, irqfd_ptable_queue_proc);
>> +    INIT_WORK(&irqfd->work, irqfd_inject);
>> +
>> +    file =3D eventfd_fget(fd);
>> +    if (IS_ERR(file)) {
>> +        ret =3D PTR_ERR(file);
>> +        goto fail;
>> +    }
>> +
>> +    ret =3D file->f_op->poll(file, &irqfd->pt);
>> +    /* do we need to look for errors in ret? */
>>  =20
>
> Do we?

Probably.  Will fix in v3.

>
>> +
>> +    irqfd->file =3D file;
>> +
>> +    mutex_lock(&kvm->lock);
>> +    if (kvm->irqfd.src =3D=3D -1) {
>> +        ret =3D kvm_request_irq_source_id(kvm);
>> +        BUG_ON(ret < 0);
>>  =20
>
> I think you can reuse the userspace irq source (since it's just
> another way for userspace to inject an interrupt).  It isn't really
> needed since the irq source stuff is only needed to support level
> triggered interrupts.
>
Ack, will do.

Thanks Avi,
-Greg




--------------enigF6D1FAA06BF62E702DDF93A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkn1iowACgkQlOSOBdgZUxluogCfSLs4Px4Ic+IpEtzzBI+YRWqv
Y8IAniFnDA3/zgGtT/AqwT7BBHzCMe28
=QqdD
-----END PGP SIGNATURE-----

--------------enigF6D1FAA06BF62E702DDF93A6--
