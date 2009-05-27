Return-Path: <linux-kernel-owner+w=401wt.eu-S1760414AbZE0L1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760414AbZE0L1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756699AbZE0L1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:27:12 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:35177 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbZE0L1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:27:10 -0400
Message-ID: <4A1D2380.2020600@novell.com>
Date: Wed, 27 May 2009 07:26:56 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>, mtosatti@redhat.com
Subject: Re: [KVM PATCH v4 2/3] kvm: make io_bus interface more robust
References: <20090526191010.20860.75372.stgit@dev.haskins.net> <20090526191534.20860.38511.stgit@dev.haskins.net> <4A1CFFC5.9070100@redhat.com>
In-Reply-To: <4A1CFFC5.9070100@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig11A04A9E7E48984571310BA8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig11A04A9E7E48984571310BA8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

[Restoring Davide's proper email.  I had a typo in the original v4
announcement.  Sorry Davide]

Avi Kivity wrote:
> Gregory Haskins wrote:
>> Today kvm_io_bus_regsiter_dev() returns void and will internally
>> BUG_ON if it
>> fails.  We want to create dynamic MMIO/PIO entries driven from
>> userspace later
>> in the series, so we need to enhance the code to be more robust with t=
he
>> following changes:
>>
>>    1) Add a return value to the registration function
>>    2) Fix up all the callsites to check the return code, handle any
>>       failures, and percolate the error up to the caller.
>>    3) Refactor io_bus to allow "holes" in the array so device hotplug
>>       can add/remove devices arbitrarily.
>>    4) Add an unregister function
>>
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>> ---
>>
>>  arch/x86/kvm/i8254.c      |   34 ++++++++++++++++++++++---------
>>  arch/x86/kvm/i8259.c      |    9 +++++++-
>>  include/linux/kvm_host.h  |    8 +++++--
>>  virt/kvm/coalesced_mmio.c |    8 ++++++-
>>  virt/kvm/ioapic.c         |    9 ++++++--
>>  virt/kvm/kvm_main.c       |   49
>> +++++++++++++++++++++++++++++++++++++++------
>>  6 files changed, 92 insertions(+), 25 deletions(-)
>>
>> diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
>> index 584e3d3..6cf84d4 100644
>> --- a/arch/x86/kvm/i8254.c
>> +++ b/arch/x86/kvm/i8254.c
>> @@ -564,36 +564,40 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm,
>> u32 flags)
>>  {
>>      struct kvm_pit *pit;
>>      struct kvm_kpit_state *pit_state;
>> +    int ret;
>> =20
>>      pit =3D kzalloc(sizeof(struct kvm_pit), GFP_KERNEL);
>>      if (!pit)
>>          return NULL;
>> =20
>>      pit->irq_source_id =3D kvm_request_irq_source_id(kvm);
>> -    if (pit->irq_source_id < 0) {
>> -        kfree(pit);
>> -        return NULL;
>> -    }
>> -
>> -    mutex_init(&pit->pit_state.lock);
>> -    mutex_lock(&pit->pit_state.lock);
>> -    spin_lock_init(&pit->pit_state.inject_lock);
>> +    if (pit->irq_source_id < 0)
>> +        goto fail;
>> =20
>>      /* Initialize PIO device */
>>      pit->dev.read =3D pit_ioport_read;
>>      pit->dev.write =3D pit_ioport_write;
>>      pit->dev.in_range =3D pit_in_range;
>>      pit->dev.private =3D pit;
>> -    kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
>> +    ret =3D kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
>> +    if (ret < 0)
>> +        goto fail;
>> =20
>>      if (flags & KVM_PIT_SPEAKER_DUMMY) {
>>          pit->speaker_dev.read =3D speaker_ioport_read;
>>          pit->speaker_dev.write =3D speaker_ioport_write;
>>          pit->speaker_dev.in_range =3D speaker_in_range;
>>          pit->speaker_dev.private =3D pit;
>> -        kvm_io_bus_register_dev(&kvm->pio_bus, &pit->speaker_dev);
>> +        ret =3D kvm_io_bus_register_dev(&kvm->pio_bus,
>> +                          &pit->speaker_dev);
>> +        if (ret < 0)
>> +            goto fail;
>>      }
>> =20
>> +    mutex_init(&pit->pit_state.lock);
>> +    mutex_lock(&pit->pit_state.lock);
>> +    spin_lock_init(&pit->pit_state.inject_lock);
>> +
>>  =20
>
> You are registering the PIT before it is initialized.  That exposes a
> race.  The original code also did that, but at least the pit lock was
> held while this was done.
Doh!  Will fix.

>
>>      kvm->arch.vpit =3D pit;
>>      pit->kvm =3D kvm;
>> =20
>> @@ -613,6 +617,16 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm,
>> u32 flags)
>>      kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
>> =20
>>      return pit;
>> +
>> +fail:
>> +    kvm_io_bus_unregister_dev(&kvm->pio_bus, &pit->speaker_dev);
>>  =20
>
> There's an option now to avoid speaker_dev, so this needs to be
> conditional.

I was intentionally simple here based on the fact that the unregister
can silently/harmlessly fail.  (Another scenario is that we never tried
to register the speaker_dev before we hit the fail: path.

>
>> +    kvm_io_bus_unregister_dev(&kvm->pio_bus, &pit->dev);
>> +
>> +    if (pit->irq_source_id >=3D 0)
>> +        kvm_free_irq_source_id(kvm, pit->irq_source_id);
>> +
>> +    kfree(pit);
>> +    return NULL;
>>  }
>> =20
>> @@ -52,7 +52,7 @@ extern struct kmem_cache *kvm_vcpu_cache;
>>   * in one place.
>>   */
>>  struct kvm_io_bus {
>> -    int                   dev_count;
>> +    spinlock_t lock;
>>  #define NR_IOBUS_DEVS 6
>>      struct kvm_io_device *devs[NR_IOBUS_DEVS];
>>  };
>> @@ -61,8 +61,10 @@ void kvm_io_bus_init(struct kvm_io_bus *bus);
>>  void kvm_io_bus_destroy(struct kvm_io_bus *bus);
>>  struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
>>                        gpa_t addr, int len, int is_write);
>> -void kvm_io_bus_register_dev(struct kvm_io_bus *bus,
>> -                 struct kvm_io_device *dev);
>> +int kvm_io_bus_register_dev(struct kvm_io_bus *bus,
>> +                struct kvm_io_device *dev);
>> +int kvm_io_bus_unregister_dev(struct kvm_io_bus *bus,
>> +                struct kvm_io_device *dev);
>> =20
>>  =20
>
> unregister() should return void.  There's really nothing you can do to
> recover from a failure.

Yeah, good point.

>
>> =20
>> @@ -2453,21 +2455,54 @@ struct kvm_io_device
>> *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
>>  {
>>      int i;
>> =20
>> -    for (i =3D 0; i < bus->dev_count; i++) {
>> +    for (i =3D 0; i < NR_IOBUS_DEVS; i++) {
>>          struct kvm_io_device *pos =3D bus->devs[i];
>> =20
>> -        if (pos->in_range(pos, addr, len, is_write))
>> +        if (pos && pos->in_range(pos, addr, len, is_write))
>>              return pos;
>>      }
>>  =20
>
> Let's keep dev_count, and just move things around on unregister.

Ok

-Greg


--------------enig11A04A9E7E48984571310BA8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkodI4UACgkQlOSOBdgZUxnWwgCgitr4tw4yxwOEqpISRFExZpMy
8XsAn30WozwcRImoBjn8upw8SQRTPgRd
=+5he
-----END PGP SIGNATURE-----

--------------enig11A04A9E7E48984571310BA8--
