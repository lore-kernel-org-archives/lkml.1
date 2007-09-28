Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbXI1Iwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbXI1Iwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbXI1IwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:52:25 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47066 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630AbXI1IwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:52:24 -0400
Message-ID: <46FCC0B8.7090403@bull.net>
Date: Fri, 28 Sep 2007 10:52:08 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: WARNING: at arch/x86_64/kernel/smp.c:397 smp_call_function_mask()
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org> <390947257.08622@ustc.edu.cn>
In-Reply-To: <390947257.08622@ustc.edu.cn>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 28/09/2007 10:58:25,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 28/09/2007 10:58:26,
	Serialize complete at 28/09/2007 10:58:26
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3C2A7634F9C6D4F7B4320924"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3C2A7634F9C6D4F7B4320924
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Fengguang Wu wrote:
> On Thu, Sep 27, 2007 at 02:22:20AM -0700, Andrew Morton wrote:
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-r=
c8/2.6.23-rc8-mm2/
> =20
> Laurent,
>=20
> It triggered a WARNING on first run in qemu:

Thank you to report it.

>=20
> [    0.310000] WARNING: at arch/x86_64/kernel/smp.c:397 smp_call_functi=
on_mask()
> [    0.310000]
> [    0.310000] Call Trace:
> [    0.310000]  [<ffffffff8100dbde>] dump_trace+0x3ee/0x4a0
> [    0.310000]  [<ffffffff8100dcd3>] show_trace+0x43/0x70
> [    0.310000]  [<ffffffff8100dd15>] dump_stack+0x15/0x20
> [    0.310000]  [<ffffffff8101cd44>] smp_call_function_mask+0x94/0xa0
> [    0.310000]  [<ffffffff8101cd69>] smp_call_function+0x19/0x20
> [    0.310000]  [<ffffffff8104277f>] on_each_cpu+0x1f/0x50
> [    0.310000]  [<ffffffff81026eac>] global_flush_tlb+0x8c/0x110
> [    0.310000]  [<ffffffff81025c85>] free_init_pages+0xe5/0xf0
> [    0.310000]  [<ffffffff81549b5e>] alternative_instructions+0x7e/0x15=
0
> [    0.310000]  [<ffffffff8154a2ea>] check_bugs+0x1a/0x20
> [    0.310000]  [<ffffffff81540c4a>] start_kernel+0x2da/0x380
> [    0.310000]  [<ffffffff81540132>] _sinittext+0x132/0x140


the reason is the WARN_ON():

390 int smp_call_function_mask(cpumask_t mask,
391                            void (*func)(void *), void *info,
392                            int wait)
393 {
394         int ret;
395
396         /* Can deadlock when called with interrupts disabled */
397         WARN_ON(irqs_disabled());
398
399         spin_lock(&call_lock);
400         ret =3D __smp_call_function_mask(mask, func, info, wait);
401         spin_unlock(&call_lock);
402         return ret;
403 }

The patch I sent to Andi didn't include this WARN_ON() and it's why I did=
n't
find this issue. (see http://lkml.org/lkml/2007/8/24/101)

smp_call_function_mask() is called by smp_call_function() which calls a f=
unction
on all CPU except current.
The comment of smp_call_function() specifies:
=2E..
 * You must not call this function with disabled interrupts or from a
 * hardware interrupt handler or from a bottom half handler.
 * Actually there are a few legal cases, like panic.
 */

So this WARN_ON() is correct, and the caller (global_flush_tlb()) doesn't=
 follow
this rule.

I guess this WARN_ON() is only needed when we have current CPU in provide=
d mask.
So I think we should change:

int smp_call_function (void (*func) (void *info), void *info, int nonatom=
ic,
                        int wait)
{
        return smp_call_function_mask(cpu_online_map, func, info, wait);
}
("cpu_online_map" is a bad choice, comment also specifies: "run a functio=
n on
all other CPU")

to

int smp_call_function (void (*func) (void *info), void *info, int nonatom=
ic,
                        int wait)
{
        int ret;
	cpumask_t allbutself;

	allbutself =3D cpu_online_map;
	cpu_clear(smp_processor_id(), allbutself);

        spin_lock(&call_lock);
        ret =3D __smp_call_function_mask(allbutself, func, info, wait);
        spin_unlock(&call_lock);
        return ret;
}
(which is smp_call_function_mask() without the WARN_ON() and without curr=
ent cpu
in the mask)

Andi, is this correct ?
Andrew, should I send a patch implementing this change ?

Regards,
Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth


--------------enig3C2A7634F9C6D4F7B4320924
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFG/MC89Kffa9pFVzwRAkyQAKDYp3+RExaTVTeIqhhkYvlEYbXahwCgl8pT
SU7fYTM+nC5VMhMIHBEaJu4=
=Qg6F
-----END PGP SIGNATURE-----

--------------enig3C2A7634F9C6D4F7B4320924--
