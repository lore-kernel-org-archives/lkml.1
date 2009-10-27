Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbZJ0PCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbZJ0PCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 11:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbZJ0PCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 11:02:24 -0400
Received: from mail-px0-f180.google.com ([209.85.216.180]:38180 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbZJ0PCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 11:02:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=RdQt7FstuUL+weA3vo9tmjvuj+h5sDqK9h75+NiWx2wnsDFzjJwssc5ASo684vt33B
         /EPESKWfN4K3rXKy+Snti+9icl+PXIrq561dbAW4zcGGMkr5v7jNyxYCJKQvLY8++qmn
         JQeyfMW+dmXUAAQgSwnxnyb6O9/1TOdPKCKoU=
Message-ID: <4AE70B7F.5030602@gmail.com>
Date: Tue, 27 Oct 2009 11:02:23 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Gleb Natapov <gleb@redhat.com>, Gregory Haskins <ghaskins@novell.com>,
       kvm@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [KVM PATCH v3 1/3] KVM: fix race in irq_routing logic
References: <20091026162148.23704.47286.stgit@dev.haskins.net> <20091026162157.23704.12420.stgit@dev.haskins.net> <20091027064529.GJ29477@redhat.com> <4AE6F7F7.1010302@gmail.com> <20091027140237.GM29477@redhat.com> <20091027144932.GK6645@linux.vnet.ibm.com>
In-Reply-To: <20091027144932.GK6645@linux.vnet.ibm.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6657AE1F908DB4369087A641"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6657AE1F908DB4369087A641
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Thanks for this, Paul.

Some questions and statements below.

Paul E. McKenney wrote:
> On Tue, Oct 27, 2009 at 04:02:37PM +0200, Gleb Natapov wrote:
>> On Tue, Oct 27, 2009 at 09:39:03AM -0400, Gregory Haskins wrote:
>=20
> [ . . . ]
>=20
>>> standard RCU RSCS, which is what SRCU is designed for.  So rather tha=
n
>>> inventing an awkward two-phased stack based solution, it's better to
>>> reuse the provided tools, IMO.
>>>
>>> To flip it around:  Is there any reason why an SRCU would not work he=
re,
>>> and thus we were forced to use something like the stack-copy approach=
?
>>>
>> If SRCU has no disadvantage comparing to RCU why not use it always? :)=

>=20
> The disadvantages of SRCU compared to RCU include the following:
>=20
> 1.	SRCU requires that the return value of srcu_read_lock()
> 	be fed into srcu_read_unlock().  This is usually not a problem,
> 	but can be painful if there are multiple levels of function
> 	call separating the two.

Right, and this is simple/neat w.r.t. its usage in irq_routing, so no
problem there.

>=20
> 2.	SRCU's grace periods are about 4x slower than those of RCU.
> 	And they also don't scale all that well with extremely large
> 	numbers of CPUs (but this can be fixed when/if it becomes a
> 	real problem).

The irq_routing update path is extremely infrequent, so this should not
be an issue.

>=20
> 3.	SRCU's read-side primitives are also significantly slower than
> 	those of RCU.
>=20

Are the 10ns vs 45ns numbers that I mentioned in my last reply the
proper ballpark?  How do these compare to an atomic-op, say an
uncontended spinlock on modern hardware?  The assumption is that
srcu_read_lock() should be significantly cheaper than a read-lock().  If
its not, then we might as well use something else, I suppose.  But if
its not, I guess you probably wouldn't have bothered to invent it in the
first place ;)

> 4.	SRCU does not have a call_srcu().  One could be provided, but
> 	its semantics would be a bit strange due to the need to limit
> 	the number of callbacks, given that general blocking is
> 	permitted in SRCU read-side critical sections.  (And it would
> 	take some doing to convince me to supply an SRCU!)

This is not an issue in our design.

>=20
> 5.	The current SRCU has no reasonable way to implement read-side
> 	priority boosting, as there is no record of which task
> 	is read-holding which SRCU.

Given the infrequency of the update path, I do not see this as a problem.=


Kind Regards,
-Greg


--------------enig6657AE1F908DB4369087A641
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrnC38ACgkQP5K2CMvXmqHh5ACdGLep4fTDLxH4pDxhcV6I+XZf
0osAnitVCApFiH8V8Hq+oTIGSMgBhvMo
=cxt9
-----END PGP SIGNATURE-----

--------------enig6657AE1F908DB4369087A641--
