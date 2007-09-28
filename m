Return-Path: <linux-kernel-owner+w=401wt.eu-S1760802AbXI1JTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802AbXI1JTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756853AbXI1JTC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:19:02 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:55084 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135AbXI1JTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:19:00 -0400
Message-ID: <46FCC6F5.2030109@bull.net>
Date: Fri, 28 Sep 2007 11:18:45 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: WARNING: at arch/x86_64/kernel/smp.c:397 smp_call_function_mask()
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org>	<390947257.08622@ustc.edu.cn>	<46FCC0B8.7090403@bull.net> <20070928020950.bdcad2c2.akpm@linux-foundation.org>
In-Reply-To: <20070928020950.bdcad2c2.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 28/09/2007 11:25:01,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 28/09/2007 11:25:03,
	Serialize complete at 28/09/2007 11:25:03
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC67004127B7512C637AC6E57"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC67004127B7512C637AC6E57
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Andrew Morton wrote:
> On Fri, 28 Sep 2007 10:52:08 +0200 Laurent Vivier <Laurent.Vivier@bull.=
net> wrote:
>=20
>> Fengguang Wu wrote:
>>> On Thu, Sep 27, 2007 at 02:22:20AM -0700, Andrew Morton wrote:
>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23=
-rc8/2.6.23-rc8-mm2/
>>> =20
>>> Laurent,
>>>
>>> It triggered a WARNING on first run in qemu:
>> Thank you to report it.
>>
>>> [    0.310000] WARNING: at arch/x86_64/kernel/smp.c:397 smp_call_func=
tion_mask()
>>> [    0.310000]
>>> [    0.310000] Call Trace:
>>> [    0.310000]  [<ffffffff8100dbde>] dump_trace+0x3ee/0x4a0
>>> [    0.310000]  [<ffffffff8100dcd3>] show_trace+0x43/0x70
>>> [    0.310000]  [<ffffffff8100dd15>] dump_stack+0x15/0x20
>>> [    0.310000]  [<ffffffff8101cd44>] smp_call_function_mask+0x94/0xa0=

>>> [    0.310000]  [<ffffffff8101cd69>] smp_call_function+0x19/0x20
>>> [    0.310000]  [<ffffffff8104277f>] on_each_cpu+0x1f/0x50
>>> [    0.310000]  [<ffffffff81026eac>] global_flush_tlb+0x8c/0x110
>>> [    0.310000]  [<ffffffff81025c85>] free_init_pages+0xe5/0xf0
>>> [    0.310000]  [<ffffffff81549b5e>] alternative_instructions+0x7e/0x=
150
>>> [    0.310000]  [<ffffffff8154a2ea>] check_bugs+0x1a/0x20
>>> [    0.310000]  [<ffffffff81540c4a>] start_kernel+0x2da/0x380
>>> [    0.310000]  [<ffffffff81540132>] _sinittext+0x132/0x140
>>
>> the reason is the WARN_ON():
>>
>> 390 int smp_call_function_mask(cpumask_t mask,
>> 391                            void (*func)(void *), void *info,
>> 392                            int wait)
>> 393 {
>> 394         int ret;
>> 395
>> 396         /* Can deadlock when called with interrupts disabled */
>> 397         WARN_ON(irqs_disabled());
>> 398
>> 399         spin_lock(&call_lock);
>> 400         ret =3D __smp_call_function_mask(mask, func, info, wait);
>> 401         spin_unlock(&call_lock);
>> 402         return ret;
>> 403 }
>>
>> The patch I sent to Andi didn't include this WARN_ON() and it's why I =
didn't
>> find this issue. (see http://lkml.org/lkml/2007/8/24/101)
>>
>> smp_call_function_mask() is called by smp_call_function() which calls =
a function
>> on all CPU except current.
>> The comment of smp_call_function() specifies:
>> ...
>>  * You must not call this function with disabled interrupts or from a
>>  * hardware interrupt handler or from a bottom half handler.
>>  * Actually there are a few legal cases, like panic.
>>  */
>>
>> So this WARN_ON() is correct, and the caller (global_flush_tlb()) does=
n't follow
>> this rule.
>>
>> I guess this WARN_ON() is only needed when we have current CPU in prov=
ided mask.
>> So I think we should change:
>>
>> int smp_call_function (void (*func) (void *info), void *info, int nona=
tomic,
>>                         int wait)
>> {
>>         return smp_call_function_mask(cpu_online_map, func, info, wait=
);
>> }
>> ("cpu_online_map" is a bad choice, comment also specifies: "run a func=
tion on
>> all other CPU")
>>
>> to
>>
>> int smp_call_function (void (*func) (void *info), void *info, int nona=
tomic,
>>                         int wait)
>> {
>>         int ret;
>> 	cpumask_t allbutself;
>>
>> 	allbutself =3D cpu_online_map;
>> 	cpu_clear(smp_processor_id(), allbutself);
>>
>>         spin_lock(&call_lock);
>>         ret =3D __smp_call_function_mask(allbutself, func, info, wait)=
;
>>         spin_unlock(&call_lock);
>>         return ret;
>> }
>> (which is smp_call_function_mask() without the WARN_ON() and without c=
urrent cpu
>> in the mask)
>>
>> Andi, is this correct ?
>> Andrew, should I send a patch implementing this change ?
>=20
> umm, I think all the smp_call_function fucntions are deadlocky if calle=
d
> with local interrupts disabled, regardless of whether the calling CPU i=
s in
> the mask.
>=20
> If CPU A is sending a cross-cpu call to CPU B and CPU B is sending a
> cross-cpu call to CPU A, and they both have local interrupts disabled..=
=2E

OK, so there are two errors:

1- one I introduce myself (without any help from anyone) where
smp_call_function() calls all online CPUs instead of calling all CPUs exc=
ept itself.

2- one in global_flush_tlb() which calls smp_call_function() with irqs di=
sabled.

I think I should at least correct #1 ?

Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth


--------------enigC67004127B7512C637AC6E57
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFG/Mb49Kffa9pFVzwRAl3gAJ4tLIR8z9RhQAwqNrs8va303O7wHACeIJv1
XU6aaCsnLqje6r4RD1hFVKY=
=oa4y
-----END PGP SIGNATURE-----

--------------enigC67004127B7512C637AC6E57--
