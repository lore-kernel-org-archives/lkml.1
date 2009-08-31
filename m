Return-Path: <linux-kernel-owner+w=401wt.eu-S1751776AbZHaVIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbZHaVIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 17:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbZHaVIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 17:08:31 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:49279 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbZHaVIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 17:08:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=djuZdHR0/qO6RlYyOFnpeouWz8wjJAXqSc6caKZ0OVZqCaOwG33Y5KYRfifQS18mNc
         u2m5EY+1P/fIoTLsoNXVJX48Av8wH3Wjw4OhCVSohmdTWLONM9Pi78z8vMc5kUWX8tcj
         ocuQc7b4N1yiougsjI6L45ZcO7l3F72m/L7x0=
Date: Tue, 1 Sep 2009 00:12:24 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "Brown, Len" <len.brown@intel.com>,
       "Moore, Robert" <robert.moore@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: acpi_ex_system_memory_space_handler oops
Message-ID: <20090831211224.GA3028@localdomain.by>
References: <20090812201034.GA2983@localdomain.by>
 <1250498613.28336.68.camel@minggr.sh.intel.com>
 <20090817113059.GA3245@localdomain.by>
 <d3f22a0908170622x7dd9ce73m5c3ea86406cc9935@mail.gmail.com>
 <20090818071359.GA3713@localdomain.by>
 <1250579915.13743.8.camel@minggr.sh.intel.com>
 <20090827075253.GB3536@localdomain.by>
 <1251359994.3282.11.camel@minggr.sh.intel.com>
 <20090827082927.GD3536@localdomain.by>
 <1251362657.3282.19.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <1251362657.3282.19.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/27/09 16:44), Lin Ming wrote:
> On Thu, 2009-08-27 at 16:29 +0800, Sergey Senozhatsky wrote:
> > On (08/27/09 15:59), Lin Ming wrote:
> > > > rc7-git5 (patched)
> > > >=20
> > > > [    0.178628] ACPI: EC: Look up EC in DSDT
> > > > [    0.196480] ACPI: Interpreter enabled
> > > > [    0.196575] ACPI: (supports S0 S1 S3 S4 S5)
> > > > [    0.197184] ACPI: Using IOAPIC for interrupt routing
> > > > [    0.197352] PCI: MCFG configuration 0: base e0000000 segment 0 b=
uses 0 - 255
> > > > [    0.203511] ACPI Error (dswload-0790): [PCFG] Namespace lookup f=
ailure, AE_ALREADY_EXISTS
> > > > [    0.203738] ACPI Exception: AE_ALREADY_EXISTS, During name looku=
p/catalog 20090521 psloop-227
> > > > [    0.203964] ACPI Error (psparse-0537): Method parse/execution fa=
iled [\_SB_.RBPE] (Node f7017678), AE_ALREADY_EXISTS
> > > > [    0.204256] ACPI: Marking method RBPE as Serialized because of A=
E_ALREADY_EXISTS error
> > > > [    0.204510] ACPI Error (psparse-0537): Method parse/execution fa=
iled [\_GPE._L01] (Node f701d198), AE_ALREADY_EXISTS
> > > > [    0.204803] ACPI: Marking method _L01 as Serialized because of A=
E_ALREADY_EXISTS error
> > > > [    0.205063] ACPI Exception: AE_ALREADY_EXISTS, while evaluating =
GPE method [_L01] 20090521 evgpe-568
> > >=20
>=20
> So the patch only fixes the oops,=20
> we also need to fix the AE_ALREADY_EXISTS error.
>=20
> AE_ALREADY_EXISTS fix not confirmed.
I'm afraid there was my mistake. No luck in reproducing this with patched k=
ernel.

I've updated BIOS (305 -> 307, ASUS F3Jc) - unpatched kernel (rc8, rc7) oop=
ses.

Made some changes to acpi_ex_system_memory_space_handler:

	static int prev_ebx =3D 0;
	struct pt_regs *regs =3D task_pt_regs(current);
	[..]
	if (prev_ebx !=3D regs->bx) {
		printk("EAX: %08lx EBX: %08lx ECX: %08lx EDX: %08lx\n",
			   regs->ax, regs->bx, regs->cx, regs->dx);
		prev_ebx =3D regs->bx;
	}

Kernel oopses at acpi_ex_system_memory_space_handler+0x75, which is
mov    0x8(%ebx),%edx  /* 0x8(%ebx) =3D=3D mem_info->mapped_physical_addres=
s */

2 normal boots:
[    0.179720] EAX: 00000002 EBX: c1603684 ECX: c15adae0 EDX: 00000002
[    0.203556] EAX: f7231fc8 EBX: f7231fe0 ECX: c1062064 EDX: 00000000
[    0.204522] EAX: 00000002 EBX: c1603684 ECX: c15adae0 EDX: 00000002
[    0.204727] EAX: f7231fc8 EBX: f7231fe0 ECX: c1062064 EDX: 00000000
[    0.205402] EAX: 00000002 EBX: c1603684 ECX: c15adae0 EDX: 00000002
[    0.207394] EAX: f7231fc8 EBX: f7231fe0 ECX: c1062064 EDX: 00000000
[    0.207742] EAX: 00000002 EBX: c1603684 ECX: c15adae0 EDX: 00000002
[    0.223926] EAX: 00000002 EBX: c160368c ECX: c15adae0 EDX: 00000002
[    0.313569] EAX: 00000002 EBX: c1603720 ECX: c15adae0 EDX: 00000002
[    0.538362] EAX: 00000002 EBX: c160395c ECX: c15adae0 EDX: 00000002
[    0.539345] EAX: 00000002 EBX: c1603960 ECX: c15adae0 EDX: 00000002
[    0.551478] EAX: 00000002 EBX: c1603968 ECX: c15adae0 EDX: 00000002
[    0.553474] EAX: 00000002 EBX: c160396c ECX: c15adae0 EDX: 00000002
[    0.559407] EAX: 00000002 EBX: c1603970 ECX: c15adae0 EDX: 00000002
[    0.562432] EAX: 00000002 EBX: c1603974 ECX: c15adae0 EDX: 00000002
[    0.567686] EAX: f68fffc8 EBX: f68fffe0 ECX: c1062064 EDX: 00000000
[    0.929685] EAX: 00000002 EBX: c160399c ECX: c15adae0 EDX: 00000002
[    0.943102] EAX: f68fffc8 EBX: f68fffe0 ECX: c1062064 EDX: 00000000
[    1.119718] EAX: f707bfc8 EBX: f707bfe0 ECX: c1062064 EDX: 00000000
[    4.247438] EAX: 00000004 EBX: 00000003 ECX: 08061916 EDX: 00000003
[    4.624659] EAX: 00000080 EBX: b7fe3000 ECX: 00007111 EDX: 08d26e88
[    9.422412] EAX: 00000003 EBX: 00000003 ECX: b7f4e000 EDX: 00001000
[   15.780002] EAX: 00000003 EBX: 00000007 ECX: b803a000 EDX: 00001000
[   30.282635] EAX: 00000003 EBX: 00000004 ECX: b7313000 EDX: 00001000
[   31.760373] EAX: 00000003 EBX: 00000005 ECX: b8081000 EDX: 00001000
[   46.478595] EAX: 00000003 EBX: 00000011 ECX: b8085000 EDX: 00001000
[   60.287018] EAX: 00000003 EBX: 00000004 ECX: b7313000 EDX: 00001000
[   76.503652] EAX: 00000003 EBX: 00000011 ECX: b8085000 EDX: 00001000
[   95.286847] EAX: 00000003 EBX: 00000004 ECX: b7313000 EDX: 00001000
[  103.537367] EAX: 00000003 EBX: 00000005 ECX: b8081000 EDX: 00001000
[  106.503656] EAX: 00000003 EBX: 00000011 ECX: b8085000 EDX: 00001000

***
[    0.177114] EAX: 00000002 EBX: c1603684 ECX: c15adae0 EDX: 00000002
[    0.200169] EAX: f7213fc8 EBX: f7213fe0 ECX: c1062064 EDX: 00000000
[    0.200854] EAX: 00000002 EBX: c1603684 ECX: c15adae0 EDX: 00000002
[    0.200998] EAX: f7213fc8 EBX: f7213fe0 ECX: c1062064 EDX: 00000000
[    0.201331] EAX: 00000002 EBX: c1603684 ECX: c15adae0 EDX: 00000002
[    0.202367] EAX: f7213fc8 EBX: f7213fe0 ECX: c1062064 EDX: 00000000
[    0.202569] EAX: 00000002 EBX: c1603684 ECX: c15adae0 EDX: 00000002
[    0.204209] EAX: f7213fc8 EBX: f7213fe0 ECX: c1062064 EDX: 00000000
[    0.204452] EAX: 00000002 EBX: c1603684 ECX: c15adae0 EDX: 00000002
[    0.206921] EAX: f7213fc8 EBX: f7213fe0 ECX: c1062064 EDX: 00000000
[    0.207834] EAX: 00000002 EBX: c1603684 ECX: c15adae0 EDX: 00000002
[    0.220475] EAX: 00000002 EBX: c160368c ECX: c15adae0 EDX: 00000002
[    0.319953] EAX: 00000002 EBX: c1603720 ECX: c15adae0 EDX: 00000002
[    0.540786] EAX: 00000002 EBX: c160395c ECX: c15adae0 EDX: 00000002
[    0.541769] EAX: 00000002 EBX: c1603960 ECX: c15adae0 EDX: 00000002
[    0.550439] EAX: 00000002 EBX: c1603968 ECX: c15adae0 EDX: 00000002
[    0.552394] EAX: 00000002 EBX: c160396c ECX: c15adae0 EDX: 00000002
[    0.560133] EAX: 00000002 EBX: c1603970 ECX: c15adae0 EDX: 00000002
[    0.563108] EAX: 00000002 EBX: c1603974 ECX: c15adae0 EDX: 00000002
[    0.568408] EAX: f697bfc8 EBX: f697bfe0 ECX: c1062064 EDX: 00000000
[    0.926336] EAX: f707ffc8 EBX: f707ffe0 ECX: c1062064 EDX: 00000000
[    0.932752] EAX: 00000002 EBX: c160399c ECX: c15adae0 EDX: 00000002
[    0.932974] EAX: f697bfc8 EBX: f697bfe0 ECX: c1062064 EDX: 00000000
[    4.094675] EAX: 00000004 EBX: 00000003 ECX: 08061916 EDX: 00000003
[    4.604710] EAX: 00000080 EBX: b80c2000 ECX: 00007111 EDX: 08cdae88
[    9.325215] EAX: 00000003 EBX: 00000003 ECX: b7f30000 EDX: 00001000
[   15.744843] EAX: 00000003 EBX: 00000007 ECX: b8003000 EDX: 00001000
[   30.818662] EAX: 00000003 EBX: 00000004 ECX: b7490000 EDX: 00001000
[   38.545531] EAX: 00000003 EBX: 00000005 ECX: b7edb000 EDX: 00001000


I also have changed show_registers(struct pt_regs *regs) to __show_regs(reg=
s, 0); after the stack trace.
Here are 2 oopses (they are similar):
Kacpid not tainted
EIP: 0060: [<c12a30ce>] 	EFLAGS: 00010246 	CPU: 0
EIP is at acpi_ex_system_memory_space_handler+0x75/0x22f
EAX: 00000001	EBX: 00000020	ECX: 00000008	EDX: 00000000
ESI: f7213dec	EDI: 0000008	EBP: f7213d10	ESP: f7213cdc
DS: 007b	ES: 007b	FS: 00d8	GS: 00e0	SS: 0068

***
EAX: 00000001   EBX: 00000020   ECX: 00000008   EDX: 00000000
ESI: f7213dec   EDI: 0000008    EBP: f7213d10   ESP: f7213cdc
DS: 007b        ES: 007b        FS: 00d8        GS: 00e0        SS: 0068


Note EBX: 00000020 in both cases.
(happend around 0.21 min when 'usually' EBX: c1603684/f7213fe0).


	Sergey
--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqcPLgACgkQfKHnntdSXjT8xwP8DUvjebMDEHD9dvjoIBZk/ApA
6D8Bt2hlJbigOEv8od2kLAJUYr/ZbK0JTWN6PUTi9IeNbzPuG9I5U0/xS7bcaeuc
3oojxrrqJ57CV3ZgrrhkMtG3+swFeNVmSFxQIu7SeTpK1PDeAPuPS6ImldBCr7/D
WphrMla9lNMZ87/uBt4=
=a6lr
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
