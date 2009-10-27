Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbZJ0Our@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbZJ0Our (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 10:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbZJ0Ouq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 10:50:46 -0400
Received: from mail-px0-f180.google.com ([209.85.216.180]:38875 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbZJ0Oup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 10:50:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=H9H1ldmLixk3Mq1p7Z0UAHRjeWxfHikW40z+IHRgh9nWy/e/5U6Nh6oCL6rSDLnNQI
         c1I/irMoFDHPDgZLC3/q5ITPWHT/LDc4B3aZn72EIMNzmWuGlVbJ0jYWWPYTVhK4WfZL
         og8o4grKjGVXNpczTyA6UpA3n1cABYXTCxxHk=
Message-ID: <4AE708C5.7090508@gmail.com>
Date: Tue, 27 Oct 2009 10:50:45 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: [KVM PATCH v3 1/3] KVM: fix race in irq_routing logic
References: <20091026162148.23704.47286.stgit@dev.haskins.net> <20091026162157.23704.12420.stgit@dev.haskins.net> <20091027064529.GJ29477@redhat.com> <4AE6F7F7.1010302@gmail.com> <4AE6FCEF.8030607@gmail.com> <20091027140507.GN29477@redhat.com>
In-Reply-To: <20091027140507.GN29477@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE496B7F4316669F863BAD3E6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE496B7F4316669F863BAD3E6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Gleb Natapov wrote:
> On Tue, Oct 27, 2009 at 10:00:15AM -0400, Gregory Haskins wrote:
>> Gregory Haskins wrote:
>>> Gleb Natapov wrote:
>>>> On Mon, Oct 26, 2009 at 12:21:57PM -0400, Gregory Haskins wrote:
>>>>> The current code suffers from the following race condition:
>>>>>
>>>>> thread-1                                    thread-2
>>>>> -----------------------------------------------------------
>>>>>
>>>>> kvm_set_irq() {
>>>>>    rcu_read_lock()
>>>>>    irq_rt =3D rcu_dereference(table);
>>>>>    rcu_read_unlock();
>>>>>
>>>>>                                        kvm_set_irq_routing() {
>>>>>                                           mutex_lock();
>>>>>                                           irq_rt =3D table;
>>>>>                                           rcu_assign_pointer();
>>>>>                                           mutex_unlock();
>>>>>                                           synchronize_rcu();
>>>>>
>>>>>                                           kfree(irq_rt);
>>>>>
>>>>>    irq_rt->entry->set(); /* bad */
>>>>>
>>>> This is not what happens. irq_rt is never accessed outside read-side=

>>>> critical section.
>>> Sorry, I was generalizing to keep the comments short.  I figured it
>>> would be clear what I was actually saying, but realize in retrospect
>>> that I was a little ambiguous.
>> Here is a revised problem statement
>>
>>     thread-1                                    thread-2
>>     -----------------------------------------------------------
>>
>>     kvm_set_irq() {
>>        rcu_read_lock()
>>        irq_rt =3D rcu_dereference(table);
>>        entry_cache =3D get_entries(irq_rt);
>>        rcu_read_unlock();
>>
>>                                             invalidate_entries(irq_rt)=
;
>>
>>        for_each_entry(entry_cache)
>> 	  entry->set(); /* bad */
>>
>>     -------------------------------------------------------------
>>
>>
>> "invalidate_entries()" may be any operation that deletes an entry at
>> run-time (doesn't exist today), or as the guest is shutting down.  As
>> far as I can tell, the current code does not protect us from either
>> condition, and my proposed patch protects us from both.  Did I miss
>> anything?
>>
> Yes. What happened to irq_rt is completely irrelevant at the point you
> marked /* bad */.

kfree() happened to irq_rt, and thus to the objects behind the pointers
in entry_cache at the point I marked /* bad */.

That certainly isn't /* good */ ;)

-Greg


--------------enigE496B7F4316669F863BAD3E6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrnCMUACgkQP5K2CMvXmqHiAQCfcmt6oLDnoU97iH59L2huEKLx
wd8AmgNXr6nViXLz0S9uJePBJxLmiMGO
=Y8kv
-----END PGP SIGNATURE-----

--------------enigE496B7F4316669F863BAD3E6--
