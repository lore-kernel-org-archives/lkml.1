Return-Path: <linux-kernel-owner+w=401wt.eu-S1763923AbXHDIwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763923AbXHDIwl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 04:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758280AbXHDIwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 04:52:34 -0400
Received: from canadatux.org ([85.214.62.144]:36973 "EHLO
	zoidberg.canadatux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbXHDIwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 04:52:32 -0400
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Aug 2007 04:52:32 EDT
Date: Sat, 4 Aug 2007 10:44:26 +0200
From: Matthias Hensler <matthias@wspse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Processes spinning forever, apparently in lock_timer_base()?
Message-ID: <20070804084426.GA20464@kobayashi-maru.wspse.de>
Reply-To: Matthias Hensler <matthias@wspse.de>
References: <46B10BB7.60900@redhat.com> <20070803113407.0b04d44e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <20070803113407.0b04d44e.akpm@linux-foundation.org>
Organization: WSPse (http://www.wspse.de/)
X-Gummibears: Bouncing here and there and everywhere
X-Face: &Tv]9SsNpb/$w8\G-O%>W02aApFW^P>[x+Upv9xQB!2;iD9Y1-Lz'qlc{+lL2Y>J(u76 Jk,cJ@$tP2-M%y?^'jn2J]3C'ss_~"u?kA^X&{]h?O?@*VwgSGob73I9r}&S%ktup0k2 !neScg3'HO}PU#Ac>jwNL|P@f|f*sz*cP'hi)/<JQC4|Q[$D@aQ"C{$>a=6.rc-P1vXa rjVXlzClmNfcSy/$4tQz
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 03, 2007 at 11:34:07AM -0700, Andrew Morton wrote:
> (attempting to cc Matthias.  If I have the wrong one, please fix it up)

You got the correct one.

> > Looks like the same problem with spinlock unfairness we've seen
> > elsewhere: it seems to be looping here? Or is everyone stuck
> > just waiting for writeout?
> [...]
> I think.  Or perhaps lock_timer_base() really has gone and got stuck.  One
> possibility is that gcc has decided to cache timer->base in a register
> rather than rereading it around that loop, which would be bad.  Do:
>=20
> gdb vmlinux
> (gdb) x/100i lock_timer_base

This is from an affected kernel, but not the kernel matching my
stack-trace. Hope it is useful anyway. If not maybe Chuck can provide
the vmlinux file for the 2.6.22.1-27.fc7 kernel (the debuginfo seems to
be deleted from all mirrors).

(gdb) x/100i lock_timer_base
0xc102ffda <lock_timer_base>:   push   %ebp
0xc102ffdb <lock_timer_base+1>: mov    %edx,%ebp
0xc102ffdd <lock_timer_base+3>: push   %edi
0xc102ffde <lock_timer_base+4>: mov    %eax,%edi
0xc102ffe0 <lock_timer_base+6>: push   %esi
0xc102ffe1 <lock_timer_base+7>: push   %ebx
0xc102ffe2 <lock_timer_base+8>: mov    0x14(%edi),%ebx
0xc102ffe5 <lock_timer_base+11>:        mov    %ebx,%esi
0xc102ffe7 <lock_timer_base+13>:        and    $0xfffffffe,%esi
0xc102ffea <lock_timer_base+16>:        je     0xc1030004 <lock_timer_base+=
42>
0xc102ffec <lock_timer_base+18>:        mov    %esi,%eax
0xc102ffee <lock_timer_base+20>:        call   0xc122ff35 <_spin_lock_irqsa=
ve>
0xc102fff3 <lock_timer_base+25>:        mov    %eax,0x0(%ebp)
0xc102fff6 <lock_timer_base+28>:        cmp    0x14(%edi),%ebx
0xc102fff9 <lock_timer_base+31>:        je     0xc1030008 <lock_timer_base+=
46>
0xc102fffb <lock_timer_base+33>:        mov    %eax,%edx
0xc102fffd <lock_timer_base+35>:        mov    %esi,%eax
0xc102ffff <lock_timer_base+37>:        call   0xc122ff95 <_spin_unlock_irq=
restore>
0xc1030004 <lock_timer_base+42>:        pause =20
0xc1030006 <lock_timer_base+44>:        jmp    0xc102ffe2 <lock_timer_base+=
8>
0xc1030008 <lock_timer_base+46>:        mov    %esi,%eax
0xc103000a <lock_timer_base+48>:        pop    %ebx
0xc103000b <lock_timer_base+49>:        pop    %esi
0xc103000c <lock_timer_base+50>:        pop    %edi
0xc103000d <lock_timer_base+51>:        pop    %ebp
0xc103000e <lock_timer_base+52>:        ret   =20
0xc103000f <try_to_del_timer_sync>:     push   %esi
0xc1030010 <try_to_del_timer_sync+1>:   or     $0xffffffff,%esi
0xc1030013 <try_to_del_timer_sync+4>:   push   %ebx
0xc1030014 <try_to_del_timer_sync+5>:   mov    %eax,%ebx
0xc1030016 <try_to_del_timer_sync+7>:   sub    $0x4,%esp
0xc1030019 <try_to_del_timer_sync+10>:  mov    %esp,%edx
0xc103001b <try_to_del_timer_sync+12>:  call   0xc102ffda <lock_timer_base>
0xc1030020 <try_to_del_timer_sync+17>:  cmp    %ebx,0x4(%eax)
0xc1030023 <try_to_del_timer_sync+20>:  mov    %eax,%ecx
0xc1030025 <try_to_del_timer_sync+22>:  je     0xc1030049 <try_to_del_timer=
_sync+58>
0xc1030027 <try_to_del_timer_sync+24>:  xor    %esi,%esi
0xc1030029 <try_to_del_timer_sync+26>:  cmpl   $0x0,(%ebx)
0xc103002c <try_to_del_timer_sync+29>:  je     0xc1030049 <try_to_del_timer=
_sync+58>
0xc103002e <try_to_del_timer_sync+31>:  mov    (%ebx),%edx
0xc1030030 <try_to_del_timer_sync+33>:  mov    $0x1,%si
0xc1030034 <try_to_del_timer_sync+37>:  mov    0x4(%ebx),%eax
0xc1030037 <try_to_del_timer_sync+40>:  mov    %eax,0x4(%edx)
0xc103003a <try_to_del_timer_sync+43>:  mov    %edx,(%eax)
0xc103003c <try_to_del_timer_sync+45>:  movl   $0x200200,0x4(%ebx)
0xc1030043 <try_to_del_timer_sync+52>:  movl   $0x0,(%ebx)
0xc1030049 <try_to_del_timer_sync+58>:  mov    (%esp),%edx
0xc103004c <try_to_del_timer_sync+61>:  mov    %ecx,%eax
0xc103004e <try_to_del_timer_sync+63>:  call   0xc122ff95 <_spin_unlock_irq=
restore>
0xc1030053 <try_to_del_timer_sync+68>:  mov    %esi,%eax
0xc1030055 <try_to_del_timer_sync+70>:  pop    %ebx
---Type <return> to continue, or q <return> to quit---
0xc1030056 <try_to_del_timer_sync+71>:  pop    %ebx
0xc1030057 <try_to_del_timer_sync+72>:  pop    %esi
0xc1030058 <try_to_del_timer_sync+73>:  ret   =20
0xc1030059 <del_timer_sync>:    push   %ebx
0xc103005a <del_timer_sync+1>:  mov    %eax,%ebx
0xc103005c <del_timer_sync+3>:  mov    %ebx,%eax
0xc103005e <del_timer_sync+5>:  call   0xc103000f <try_to_del_timer_sync>
0xc1030063 <del_timer_sync+10>: test   %eax,%eax
0xc1030065 <del_timer_sync+12>: jns    0xc103006b <del_timer_sync+18>
0xc1030067 <del_timer_sync+14>: pause =20
0xc1030069 <del_timer_sync+16>: jmp    0xc103005c <del_timer_sync+3>
0xc103006b <del_timer_sync+18>: pop    %ebx
0xc103006c <del_timer_sync+19>: ret   =20
0xc103006d <__mod_timer>:       push   %ebp
0xc103006e <__mod_timer+1>:     mov    %edx,%ebp
0xc1030070 <__mod_timer+3>:     push   %edi
0xc1030071 <__mod_timer+4>:     push   %esi
0xc1030072 <__mod_timer+5>:     mov    %eax,%esi
0xc1030074 <__mod_timer+7>:     push   %ebx
0xc1030075 <__mod_timer+8>:     sub    $0x8,%esp
0xc1030078 <__mod_timer+11>:    mov    0x18(%esp),%edx
0xc103007c <__mod_timer+15>:    call   0xc102f693 <__timer_stats_timer_set_=
start_info>
0xc1030081 <__mod_timer+20>:    cmpl   $0x0,0xc(%esi)
0xc1030085 <__mod_timer+24>:    jne    0xc103008b <__mod_timer+30>
0xc1030087 <__mod_timer+26>:    ud2a  =20
0xc1030089 <__mod_timer+28>:    jmp    0xc1030089 <__mod_timer+28>
0xc103008b <__mod_timer+30>:    lea    0x4(%esp),%edx
0xc103008f <__mod_timer+34>:    mov    %esi,%eax
0xc1030091 <__mod_timer+36>:    call   0xc102ffda <lock_timer_base>
0xc1030096 <__mod_timer+41>:    movl   $0x0,(%esp)
0xc103009d <__mod_timer+48>:    mov    %eax,%ebx
0xc103009f <__mod_timer+50>:    cmpl   $0x0,(%esi)
0xc10300a2 <__mod_timer+53>:    je     0xc10300bc <__mod_timer+79>
0xc10300a4 <__mod_timer+55>:    mov    0x4(%esi),%eax
0xc10300a7 <__mod_timer+58>:    mov    (%esi),%edx
0xc10300a9 <__mod_timer+60>:    mov    %eax,0x4(%edx)
0xc10300ac <__mod_timer+63>:    mov    %edx,(%eax)
0xc10300ae <__mod_timer+65>:    movl   $0x200200,0x4(%esi)
0xc10300b5 <__mod_timer+72>:    movl   $0x1,(%esp)
0xc10300bc <__mod_timer+79>:    mov    %fs:0xc13a6104,%edx
0xc10300c3 <__mod_timer+86>:    mov    $0xc13a75dc,%eax
0xc10300c8 <__mod_timer+91>:    mov    (%edx,%eax,1),%edi
0xc10300cb <__mod_timer+94>:    cmp    %edi,%ebx
0xc10300cd <__mod_timer+96>:    je     0xc10300f0 <__mod_timer+131>
0xc10300cf <__mod_timer+98>:    cmp    %esi,0x4(%ebx)
0xc10300d2 <__mod_timer+101>:   je     0xc10300f0 <__mod_timer+131>
0xc10300d4 <__mod_timer+103>:   andl   $0x1,0x14(%esi)
0xc10300d8 <__mod_timer+107>:   mov    $0x1,%al
0xc10300da <__mod_timer+109>:   xchg   %al,(%ebx)
(gdb)=20

> Is the machine really completely dead?

No.

> Or are some tasks running?

Still open SSH sessions are fine. I am able to perform certain tasks,
including killing processes which will eventually resolv the issue.

> If the latter, it might be dirty-memory windup - perhaps some device
> driver has died and we're not getting writes out to disk.

I have two affected systems with similar setup but different hardware.

> Are all the CPUs running flat-out?

Both systems are single core.

> If so, yup, maybe it's lock_timer_base().  Hit sysrq-P ten times, see
> where things are stuck.

I can do that, no problem.

> Please leave `vmstat 1' running in an ssh seesion next time, let's see the
> output just prior to the hang.

Will do.

> And do this:
>=20
> while true
> do
> 	echo
> 	cat /proc/meminfo
> 	sleep 1
> done
>=20
> in another ssh session so we can see what the memory looked like when
> it died too.

OK.

I am also willing to try the patch posted by Richard.

In fact both systems have two harddrives mirroring their data with rsync
all 4 hours and most of the time the system gets stuck in such a rsync
run. Always when mirroring /var/spool/imap which contains around 500.000
files.

As written if the filesystem is mounted without noatime the problem is
gone.

Regards,
Matthias

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUBRrQ8YoagCBsispUdAQI2EgP9F5qqG/fFMRMaO9mZYHLSWSJoq0R7cCWw
2AW9qPIaIq8e7/zq5zwxHuo/mOJdT5RqunZxM8naGAX7TrhphhVbx4Tvx2jXSjKD
gezbfl4OJV2H6VtdytKtmhCjQVIjPIMnth2jxTpv0+T/C3CtkqQH6FfiPDiWYspi
TRt4lewk9Zo=
=K/of
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
