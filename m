Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbZJUPew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbZJUPew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 11:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbZJUPew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 11:34:52 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:58827 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbZJUPev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 11:34:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=utBA2wIisEiW470BxyiO4vqfjkrLdE6M4g1u+yo5GfFMW4jMm+JUpRSk1UMBbdKwxE
         evXfIodG+MqcDUKNIxFc7+Ta4vDRE3+PYfMedwkpDsn1AoTDs/aMsVa78Ke4tEYTts4P
         IxugHrbIPizthW/xlq6VKSPMGDhjXTS4F0XqI=
Message-ID: <4ADF2A1B.3010205@gmail.com>
Date: Wed, 21 Oct 2009 11:34:51 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net
Subject: Re: [KVM PATCH 1/2] KVM: Directly inject interrupts via irqfd
References: <20091021143042.14955.22470.stgit@dev.haskins.net> <20091021143453.14955.80578.stgit@dev.haskins.net> <20091021152621.GR29477@redhat.com>
In-Reply-To: <20091021152621.GR29477@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD5804BB237E99C1659FED4D2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD5804BB237E99C1659FED4D2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Gleb Natapov wrote:
> On Wed, Oct 21, 2009 at 10:34:53AM -0400, Gregory Haskins wrote:
>> IRQFD currently uses a deferred workqueue item to execute the injectio=
n
>> operation.  It was originally designed this way because kvm_set_irq()
>> required the caller to hold the irq_lock mutex, and the eventfd callba=
ck
>> is invoked from within a non-preemptible critical section.
>>
>> With the advent of lockless injection support in kvm_set_irq, the defe=
rment
>> mechanism is no longer technically needed. Since context switching to =
the
>> workqueue is a source of interrupt latency, lets switch to a direct
>> method.
>>
> kvm_set_irq is fully lockless only in MSI case. IOAPIC/PIC has mutexes.=


Right, but irqfd by design only works with MSI (or MSI like edge
triggers) anyway.  Legacy-type injections follow a different path.

In any case, I didn't change the locking (you did ;).  You recently
patched the irqfd code to remove the irq_lock, but we still had the
deferment mechanism in place to avoid the mutex_lock from within the
POLLIN callback.  Since the mutex_lock is now no longer acquired in this
path, the deferment technique is not needed either.  Its only adding
overhead for no purpose.  So I am simply cleaning that up to improve
interrupt performance.

HTH,
-Greg



--------------enigD5804BB237E99C1659FED4D2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrfKhsACgkQP5K2CMvXmqGKRQCgildNaYlwBR4PIMgZtBCjqNXV
SGIAn2BKycMGUaf5xNUIwSSraGC8BAss
=cJPw
-----END PGP SIGNATURE-----

--------------enigD5804BB237E99C1659FED4D2--
