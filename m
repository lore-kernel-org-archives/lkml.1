Return-Path: <linux-kernel-owner+w=401wt.eu-S1753125AbYHLCIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbYHLCIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 22:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYHLCIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 22:08:44 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:44435 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbYHLCIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 22:08:44 -0400
Message-ID: <48A0F024.30609@novell.com>
Date: Mon, 11 Aug 2008 22:06:28 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: David Miller <davem@davemloft.net>, a.p.zijlstra@chello.nl,
       jkacur@gmail.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] BUG: using smp_processor_id() in preemptible [00000000]
 code: caller is __qdisc_run
References: <520f0cf10808110611y62f6a4e2v94a0d0cde1d5d79d@mail.gmail.com> <20080811.140014.94581847.davem@davemloft.net> <1218488979.15798.39.camel@lappy.programming.kicks-ass.net> <20080811.142359.145735170.davem@davemloft.net> <alpine.DEB.1.10.0808112121370.32393@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0808112121370.32393@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.6
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig004DA4DEBFB276E5BC2CD29B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig004DA4DEBFB276E5BC2CD29B
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Steven Rostedt wrote:
> On Mon, 11 Aug 2008, David Miller wrote:
>
>  =20
>> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Date: Mon, 11 Aug 2008 23:09:38 +0200
>>
>>    =20
>>> On Mon, 2008-08-11 at 14:00 -0700, David Miller wrote:
>>>      =20
>>>> From: "John Kacur" <jkacur@gmail.com>
>>>> Date: Mon, 11 Aug 2008 15:11:46 +0200
>>>>
>>>>        =20
>>>>> __qdisc_run() calls qdisc_restart() which calls
>>>>> handle_dev_cpu_collision(skb, dev, q); and then the problem shows u=
p
>>>>> here:
>>>>> __get_cpu_var(netdev_rx_stat).cpu_collision++;
>>>>>
>>>>> The solution is to disable interrupts around the above increment. H=
ere
>>>>> is an attached patch to do so. (Thank's to Peter Zijlstra for help =
in
>>>>> the analysis and dropping the answer in my lap, so if I got it righ=
t
>>>>> it is due to his help, but if I messed it up, then I did that part =
all
>>>>> by myself.)
>>>>>          =20
>>>> __qdisc_run() always runs in software interrupt context,
>>>> so I guess this is some problem with the -rt stuff running
>>>> software interrupts in threads?
>>>>        =20
>>> Hmm, good point - and those threads should be cpu affine on -rt if I'=
m
>>> not mistaken. Steven, do you happen to remember details?
>>>      =20
>> The key issue is whether those threads run software interrupts
>> in a compatible environment.  And such a proper environment allows
>> plain smp_processor_id() without any special preparations.
>>
>>    =20
>
> Yes, we have a softirq thread per CPU. We should have a test in the=20
> smp_processor_id for rt to not bug if it is called by known "per_cpu"=20
> threads.
>  =20
something like

#ifdef CONFIG_PREEMPT_RT
    WARN_ON(!in_atomic() && current->rt.nr_cpus_allowed > 1);
#else
    WARN_ON(!in_atomic());
#endif

would probably work and be fairly efficient.  Of course nr_cpus_allowed=20
technically could be adjusted at any time, so perhaps not.  Its probably =

good enough for a warning check, however.

> -- Steve
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-user=
s" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  =20



--------------enig004DA4DEBFB276E5BC2CD29B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkig8CQACgkQlOSOBdgZUxmw6ACeJ6jWS0JXIjER77d+Hy8W/sYh
lfkAnAzlmoUUvjyXKSyE1wNQS0UYaF/1
=Fibs
-----END PGP SIGNATURE-----

--------------enig004DA4DEBFB276E5BC2CD29B--
