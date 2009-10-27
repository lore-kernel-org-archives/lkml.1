Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbZJ0NjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbZJ0NjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 09:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbZJ0NjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 09:39:08 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:30831 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbZJ0NjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 09:39:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=bHqnt0zV5kRjX9+Hf+5xh44P6so8HayqcV3JmGNWOGUfX49dQiOZgczz7+KwHrgo4q
         H3vnWs0iyl5ZSOyM/hk1EXoZoF6syvoj5TlJmFymlXSKh7hjS3tWhSlDnC383tzxxdSJ
         mcaez1VSwE2sQ7HDBAtEBxCo9VydMYgdl2N94=
Message-ID: <4AE6F7F7.1010302@gmail.com>
Date: Tue, 27 Oct 2009 09:39:03 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: [KVM PATCH v3 1/3] KVM: fix race in irq_routing logic
References: <20091026162148.23704.47286.stgit@dev.haskins.net> <20091026162157.23704.12420.stgit@dev.haskins.net> <20091027064529.GJ29477@redhat.com>
In-Reply-To: <20091027064529.GJ29477@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE72CA70663330B3397696C62"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE72CA70663330B3397696C62
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Gleb Natapov wrote:
> On Mon, Oct 26, 2009 at 12:21:57PM -0400, Gregory Haskins wrote:
>> The current code suffers from the following race condition:
>>
>> thread-1                                    thread-2
>> -----------------------------------------------------------
>>
>> kvm_set_irq() {
>>    rcu_read_lock()
>>    irq_rt =3D rcu_dereference(table);
>>    rcu_read_unlock();
>>
>>                                        kvm_set_irq_routing() {
>>                                           mutex_lock();
>>                                           irq_rt =3D table;
>>                                           rcu_assign_pointer();
>>                                           mutex_unlock();
>>                                           synchronize_rcu();
>>
>>                                           kfree(irq_rt);
>>
>>    irq_rt->entry->set(); /* bad */
>>
> This is not what happens. irq_rt is never accessed outside read-side
> critical section.

Sorry, I was generalizing to keep the comments short.  I figured it
would be clear what I was actually saying, but realize in retrospect
that I was a little ambiguous.

Yes, irq_rt is not accessed outside the RSCS.  However, the entry
pointers stored in the irq_rt->map are, and this is equally problematic
afaict.

In this particular case we seem to never delete entries at run-time once
they are established.  Therefore, while perhaps sloppy, its technically
safe to leave them unprotected from this perspective.  The issue is more
related to shutdown since a kvm_set_irq() caller could be within the
aforementioned race-region and call entry->set() after the guest is
gone.  Or did I miss something?

> Data is copied from irq_rt onto the stack and this copy is accessed
> outside critical section.

As mentioned above, I do not believe this really protect us.  And even
if it did, the copy is just a work-around to avoid sleeping within the
standard RCU RSCS, which is what SRCU is designed for.  So rather than
inventing an awkward two-phased stack based solution, it's better to
reuse the provided tools, IMO.

To flip it around:  Is there any reason why an SRCU would not work here,
and thus we were forced to use something like the stack-copy approach?

Kind Regards,
-Greg


--------------enigE72CA70663330B3397696C62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrm9/cACgkQP5K2CMvXmqGOiwCghnCZqSOvphfog7Ka/mn+X5V0
jtIAn2FcKx03Ah7KtV8baIs9FV7ICUgN
=1dWw
-----END PGP SIGNATURE-----

--------------enigE72CA70663330B3397696C62--
