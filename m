Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbZEKIsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbZEKIsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 04:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755632AbZEKIsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 04:48:41 -0400
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:34911 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755221AbZEKIsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 04:48:40 -0400
MIME-version: 1.0
X-IronPort-AV: E=Sophos;i="4.40,327,1238968800";
 d="p7s'?scan'208";a="11402323"
Message-id: <4A07E646.7090100@rz.rwth-aachen.de>
Date: Mon, 11 May 2009 10:48:06 +0200
From: Dieter an Mey <anmey@rz.rwth-aachen.de>
Reply-to: anmey@rz.rwth-aachen.de
Organization: RWTH Aachen - Rechen- und Kommunikationszentrum
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
To: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4]: affinity-on-next-touch
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de>
In-reply-to: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de>
Content-type: multipart/signed; protocol="application/x-pkcs7-signature";
 micalg=sha1; boundary=------------ms090904080907000706020707
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms090904080907000706020707
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

Hello,

I am supporting Stefan's activity from the parallel programmer's=20
perspective and I would be happy to provide further input, if needed.

best regards
Dieter

Stefan Lankes schrieb:
> Hello,
>=20
> I wrote a patch to support the adaptive data distribution strategy
> "affinity-on-next-touch" for NUMA architectures. The patch is in an ear=
ly
> state and I am interested in your comments.
>=20
> The basic idea of "affinity-on-next-touch" is this: Via some runtime
> mechanism, a user-level process activates "affinity-on-next-touch" for =
a
> certain region of its virtual memory space. Afterwards, each page in th=
is
> region will be migrated to that node which next tries to access it.
> Noordergraaf and van der Pas [1] have proposed to extend the OpenMP sta=
ndard
> to support this strategy. Since version 9, the =93affinity-on-next-touc=
h=94
> mechanism is available in Solaris and can be triggered via the madvise
> system call. L=F6f and Homgren [2] and Terboven et al. [3] have describ=
ed
> their encouraging experiences with this implementation.
>=20
> Linux does not yet support "affinity-on-next-touch". Terboven et al. [3=
]
> have presented a user-level implementation of this strategy for Linux. =
To
> realize "affinity-on-next-touch" in user space, they protect a specific=

> memory area from read and write accesses and install a signal handler t=
o
> catch access violations. If a thread accesses a page in the protected m=
emory
> area, the signal handler migrates the page to the node which handled th=
e
> access violation. Afterwards, the signal handler clears the page protec=
tion
> and the interrupted thread is resumed.=20
>=20
> Unfortunately, the overhead of this solution is very high. For instance=
, to
> distribute 512 MByte via "affinity-on-next-touch" the user-level soluti=
on
> needs 2518ms on our dual-socket, quad-core Opteron 2376 system with the=

> current kernel (2.6.30-rc4). I evaluated this overhead with the followi=
ng
> OpenMP code:
>=20
>    madvise(array, sizeof(int) * SIZE, MADV_ACCESS_LWP);
>    start =3D omp_get_wtime();
>    #pragma omp parallel for
>    for (j =3D 0; j < SIZE; j +=3D pagesize/sizeof(int))
>       array[j]++;
>    end =3D omp_get_wtime();
>    printf("time: %lf ms\n", (end - start) * 1000.0);
>=20
> The benchmark uses 8 threads and each thread is bound to one core.
>=20
> I divide my patch into the following 4 parts:
>=20
> [Patch 1/4]: Extend the system call madvise with a new parameter
> MADV_ACCESS_LWP (the same as used in Solaris). The specified memory are=
a
> then uses "affinity-on-next-touch".  In this case, madvise_access_lwp
> protects the memory area from read and write access. To avoid unnecessa=
ry
> list operations, the patch changes the permissions only in the page tab=
le
> entries and does not update the list of VMAs. Beside this, the system c=
all
> madvise set also the new =93untouched bit=94 of the "page" record.
>=20
> [Patch 2/4]: The pte fault handler detects, via a new "untouched bit" i=
nside
> of the "page" record, that the page which the thread tried to access us=
es
> =93affinity-on-next-touch=94. Afterwards, the kernel reads the original=

> permissions from vm_area_struct, restores them in the page tables and
> migrates the page to the current node. To accelerate page migration, th=
e
> patch avoids unnecessary calls to migrate_prep().
>=20
> [Patch 3/4]: If the "untouched" bit is set, mprotect isn=92t permitted =
to
> change the permission in the page table entry. By using of
> "affinity-on-next-touch", the access permission will be set by the pte =
fault
> handler.
>=20
> [Patch 4/4]: This part of the patch adds some counters to detect migrat=
ion
> errors and publishes these counters via /proc/vmstat. Besides this, the=

> Kconfig file is extend with the parameter CONFIG_AFFINITY_ON_NEXT_TOUCH=
=2E
>=20
> With this patch, the kernel reduces the overhead of page distribution v=
ia
> "affinity-on-next-touch" from 2518ms to 366ms compared to the user-leve=
l
> approach. Currently, I'm evaluating the performance of the patch with s=
ome
> other benchmarks and test applications (stream benchmark, Jacobi solver=
, PDE
> solver,...).
>=20
> I am very interested in your comments!
>=20
> Stefan
>=20
> [1] Noordergraaf, L., van der Pas, R.: Performance Experiences on Suns
> WildFire Prototype. In: Proceedings of the 1999 ACM/IEEE conference on
> Supercomputing,Portland, Oregon, USA (November 1999)
>=20
> [2] L=F6f, H., Holmgren, S.: affinity-on-next-touch: Increasing the
> Performance of an Industrial PDE Solver on a cc-NUMA System. In: Procee=
dings
> of the 19th Annual International Conference on Supercomputing, Cambridg=
e,
> Massachusetts, USA (June 2005) 387=96392
>=20
> [3]. Terboven, C., an Mey, D., Schmidl, D., Jin, H., Reichstein, T.: Da=
ta
> and Thread Affinity in OpenMP Programs. In: Proceedings of the 2008 Wor=
kshop
> on Memory Access on future Processors: A solved problem?, ACM Internati=
onal
> Conference on Computing Frontiers, Ischia, Italy (May 2008) 377=96384
>=20
>=20
>=20

--=20
Dipl.-Math. Dieter an Mey, HPC Team Lead
RWTH Aachen University, Center for Computing and Communication
Rechen- und Kommunikationszentrum der RWTH Aachen
Seffenter Weg 23, D 52074 Aachen (Germany)
Phone: + 49 241 80 24377 - Fax/UMS: + 49 241 80 624377
mailto:anmey@rz.rwth-aachen.de http://www.rz.rwth-aachen.de


--------------ms090904080907000706020707
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIITHTCC
BCEwggMJoAMCAQICAgDHMA0GCSqGSIb3DQEBBQUAMHExCzAJBgNVBAYTAkRFMRwwGgYDVQQK
ExNEZXV0c2NoZSBUZWxla29tIEFHMR8wHQYDVQQLExZULVRlbGVTZWMgVHJ1c3QgQ2VudGVy
MSMwIQYDVQQDExpEZXV0c2NoZSBUZWxla29tIFJvb3QgQ0EgMjAeFw0wNjEyMTkxMDI5MDBa
Fw0xOTA2MzAyMzU5MDBaMFoxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpERk4tVmVyZWluMRAw
DgYDVQQLEwdERk4tUEtJMSQwIgYDVQQDExtERk4tVmVyZWluIFBDQSBHbG9iYWwgLSBHMDEw
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDpm8NnhfkNrvWNVMOWUDU9YuluTO2U
1wBblSJ01CDrNI/W7MAxBAuZgeKmFNJSoCgjhIt0iQReW+DieMF4yxbLKDU5ey2QRdDtoAB6
fL9KDhsAw4bpXCsxEXsM84IkQ4wcOItqaACa7txPeKvSxhObdq3u3ibo7wGvdA/BCaL2a869
080UME/15eOkyGKbghoDJzANAmVgTe3RCSMqljVYJ9N2xnG2kB3E7f81hn1vM7PbD8URwoqD
oZRdQWvY0hD1TP3KUazZve+Sg7va64sWVlZDz+HVEz2mHycwzUlU28kTNJpxdcVs6qcLmPkh
nSevPqM5OUhqjK3JmfvDEvK9AgMBAAGjgdkwgdYwcAYDVR0fBGkwZzBloGOgYYZfaHR0cDov
L3BraS50ZWxlc2VjLmRlL2NnaS1iaW4vc2VydmljZS9hZl9Eb3dubG9hZEFSTC5jcmw/LWNy
bF9mb3JtYXQ9WF81MDkmLWlzc3Vlcj1EVF9ST09UX0NBXzIwHQYDVR0OBBYEFEm3xs/oPR9/
6kR7Eyn38QpwPt5kMB8GA1UdIwQYMBaAFDHDeRu69VPXF+CJei0XbAqzK50zMA4GA1UdDwEB
/wQEAwIBBjASBgNVHRMBAf8ECDAGAQH/AgECMA0GCSqGSIb3DQEBBQUAA4IBAQA74Vp3wEgX
3KkY7IGvWonwvSiSpspZGBJw7Cjy565/lizn8l0ZMfYTK3S9vYCyufdnyTmieTvhERHua3iR
M347XyYndVNljjNj7s9zw7CSI0khUHUjoR8Y4pSFPT8z6XcgjaK95qGFKUD2P3MyWA0Ja6ba
hWzAP7uNZmRWJE6uDT8yNQFb6YyC2XJZT7GGhfF0hVblw/hc843uR7NTBXDn5U2KaYMo4RMJ
hp5eyOpYHgwf+aTUWgRo/Sg+iwK2WLX2oSw3VwBnqyNojWOl75lrXP1LVvarQIc01BGSbOyH
xQoLBzNytG8MHVQs2FHHzL8w00Ny8TK/jM5JY6gA9/IcMIIE6DCCA9CgAwIBAgIECfJ04DAN
BgkqhkiG9w0BAQUFADBaMQswCQYDVQQGEwJERTETMBEGA1UEChMKREZOLVZlcmVpbjEQMA4G
A1UECxMHREZOLVBLSTEkMCIGA1UEAxMbREZOLVZlcmVpbiBQQ0EgR2xvYmFsIC0gRzAxMB4X
DTA3MDIxNDExNDkzOFoXDTE5MDIxMzAwMDAwMFowXjELMAkGA1UEBhMCREUxFDASBgNVBAoT
C1JXVEggQWFjaGVuMRcwFQYDVQQDEw5SV1RIIEFhY2hlbiBDQTEgMB4GCSqGSIb3DQEJARYR
Y2FAcnd0aC1hYWNoZW4uZGUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC4MAhk
48jcelLfNUI5kvMv+CF54xJnL4x/cJQnN2NId6CJ3fqs0siO2exIACfzdjxOUpQ6ZFOn5pdT
vTi7stnk8WAaP/d9LFd8k9Gbxjh7xh3L+0a3ac+/tHJcX564ntUxGtVGMuShEoUaZUT5fw97
TL36UJ8OqXLrqpdAKcFKaJ+pgRp2gTLj4MNUMPjA4GlstpjoLnT++qFm7t/ZS92/E3OqNJUw
HH6C35vSroVscmg+a7XxT6U4JO99MYxNcTIMzhPS9Ytp+302w7i51daBjr0hFGPK0nLSV6gv
77zBSFJ7AVGJJxBSUzDn0xkDLYvZwqaeYkj8kDB2oSeRyfGjAgMBAAGjggGwMIIBrDAPBgNV
HRMBAf8EBTADAQH/MAsGA1UdDwQEAwIBBjAdBgNVHQ4EFgQUbtU+wBwvcck8v0lO72pVSOzR
8jgwHwYDVR0jBBgwFoAUSbfGz+g9H3/qRHsTKffxCnA+3mQwHAYDVR0RBBUwE4ERY2FAcnd0
aC1hYWNoZW4uZGUwgYgGA1UdHwSBgDB+MD2gO6A5hjdodHRwOi8vY2RwMS5wY2EuZGZuLmRl
L2dsb2JhbC1yb290LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMD2gO6A5hjdodHRwOi8vY2RwMi5w
Y2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMIGiBggrBgEFBQcB
AQSBlTCBkjBHBggrBgEFBQcwAoY7aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9v
dC1jYS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwRwYIKwYBBQUHMAKGO2h0dHA6Ly9jZHAyLnBj
YS5kZm4uZGUvZ2xvYmFsLXJvb3QtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MA0GCSqGSIb3
DQEBBQUAA4IBAQAXh37GLAscIHrVqQYrG5P/dYULxAseU6xuXKnSpVTnMWVFf1TtN/p2D+8X
TKtl/A4WlYa9np+ONblWcS1nJsuYf7N9wrO4zCEcVBNLIAHCY3ZXG+IoNHwgXqSYqXHzrAQZ
jkSJr1RfbFE4njUy0nNhtC51HX0ongWfqODc6z7aF9we20615Mh8Kk8uox4XgjLLV/UjPVlw
RAnuYIeF0wycvQ6jz/PJMuOrXShpqejpaiRXqKx8oPXAlCcnoqRLlQc1L0iwQHBn0Em6tDmM
Hcahbf9SBOWiZ8+O0av4ly8CQ95okz9hto9UErXUIzNea2AQXBtlIyLLKgVuYPf4i3IyMIIF
AjCCA+qgAwIBAgIECmkqUzANBgkqhkiG9w0BAQUFADBeMQswCQYDVQQGEwJERTEUMBIGA1UE
ChMLUldUSCBBYWNoZW4xFzAVBgNVBAMTDlJXVEggQWFjaGVuIENBMSAwHgYJKoZIhvcNAQkB
FhFjYUByd3RoLWFhY2hlbi5kZTAeFw0wNzA1MTUxMjUxMTdaFw0xMDA1MTQxMjUxMTdaMGcx
CzAJBgNVBAYTAkRFMRQwEgYDVQQKEwtSV1RIIEFhY2hlbjEqMCgGA1UECxMhUmVjaGVuLSB1
bmQgS29tbXVuaWthdGlvbnN6ZW50cnVtMRYwFAYDVQQDEw1EaWV0ZXIgYW4gTWV5MIIBIjAN
BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA4fMB1JjYkn0GRmN7RKDkoOKX8eOXLzPv7f7E
ocshsLfaN/0wKI8UBNuaPukyqkNEnBFGw853WlV1tcur+6QbN57gObCTgAP90WXVjfQ6UkCQ
3+STaKse04L69FVq2+BF5LdIVP9E68TlBFY3jkHoa0I8+UMxioi1f2C10N4BByfmUWwS3kHd
L64NVKVeEjIR3IxJn9UqPaE47WEg2+kKo2AyCLX4ugVlWW8mR4nkQH/+Yfy9/CzHPNrZNGXn
N4ez4hi7q5QjDxxoC9CVRY9ogLYooNIM332CRCo7ytdD6SyDcdTaCX49zCV3V/6CJHQZiVXr
WaKp2PYFpt3Kh1VIWQIDAQABo4IBvTCCAbkwCQYDVR0TBAIwADALBgNVHQ8EBAMCBeAwKQYD
VR0lBCIwIAYIKwYBBQUHAwIGCCsGAQUFBwMEBgorBgEEAYI3FAICMB0GA1UdDgQWBBRawVdE
2zGOJRmuGsBtY97jDpwu+TAfBgNVHSMEGDAWgBRu1T7AHC9xyTy/SU7valVI7NHyODAiBgNV
HREEGzAZgRdhbm1leUByei5yd3RoLWFhY2hlbi5kZTB5BgNVHR8EcjBwMDagNKAyhjBodHRw
Oi8vY2RwMS5wY2EuZGZuLmRlL3J3dGgtY2EvcHViL2NybC9jYWNybC5jcmwwNqA0oDKGMGh0
dHA6Ly9jZHAyLnBjYS5kZm4uZGUvcnd0aC1jYS9wdWIvY3JsL2NhY3JsLmNybDCBlAYIKwYB
BQUHAQEEgYcwgYQwQAYIKwYBBQUHMAKGNGh0dHA6Ly9jZHAxLnBjYS5kZm4uZGUvcnd0aC1j
YS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwQAYIKwYBBQUHMAKGNGh0dHA6Ly9jZHAyLnBjYS5k
Zm4uZGUvcnd0aC1jYS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwDQYJKoZIhvcNAQEFBQADggEB
AAmJk+3uQcrCIR2RSafYW2l+vmbXXynFIcOgxRW3dkmFGCbaibmA62lR1rFSho62AkMGtNFn
Pj7nZNjxkP0QWoYsueTHSBok1qaD60BNtlydI7jofupmHgAeuO3Xn/qXny3DB/HcMs/AfbRh
y/1xVIvddaeLu+m0w8RNC9SmLHFUo29yygn9S+rbbr/9Lak6PfemFNXhFG8eseCCIvJVVj7H
wzE45Lpch/57pJSB8Zx9IyKiXEaqnYr7qIm2z2gdI4tSz5SEbjw0LT+7kx6LJ+bSBlQ6qzw4
w7TI+YT5yr6dQM5gq4UmYXXFV5gVRSTRdO2VAwzcPFxhS5N2MyBRC0MwggUCMIID6qADAgEC
AgQKaSpTMA0GCSqGSIb3DQEBBQUAMF4xCzAJBgNVBAYTAkRFMRQwEgYDVQQKEwtSV1RIIEFh
Y2hlbjEXMBUGA1UEAxMOUldUSCBBYWNoZW4gQ0ExIDAeBgkqhkiG9w0BCQEWEWNhQHJ3dGgt
YWFjaGVuLmRlMB4XDTA3MDUxNTEyNTExN1oXDTEwMDUxNDEyNTExN1owZzELMAkGA1UEBhMC
REUxFDASBgNVBAoTC1JXVEggQWFjaGVuMSowKAYDVQQLEyFSZWNoZW4tIHVuZCBLb21tdW5p
a2F0aW9uc3plbnRydW0xFjAUBgNVBAMTDURpZXRlciBhbiBNZXkwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQDh8wHUmNiSfQZGY3tEoOSg4pfx45cvM+/t/sShyyGwt9o3/TAo
jxQE25o+6TKqQ0ScEUbDzndaVXW1y6v7pBs3nuA5sJOAA/3RZdWN9DpSQJDf5JNoqx7Tgvr0
VWrb4EXkt0hU/0TrxOUEVjeOQehrQjz5QzGKiLV/YLXQ3gEHJ+ZRbBLeQd0vrg1UpV4SMhHc
jEmf1So9oTjtYSDb6QqjYDIItfi6BWVZbyZHieRAf/5h/L38LMc82tk0Zec3h7PiGLurlCMP
HGgL0JVFj2iAtiig0gzffYJEKjvK10PpLINx1NoJfj3MJXdX/oIkdBmJVetZoqnY9gWm3cqH
VUhZAgMBAAGjggG9MIIBuTAJBgNVHRMEAjAAMAsGA1UdDwQEAwIF4DApBgNVHSUEIjAgBggr
BgEFBQcDAgYIKwYBBQUHAwQGCisGAQQBgjcUAgIwHQYDVR0OBBYEFFrBV0TbMY4lGa4awG1j
3uMOnC75MB8GA1UdIwQYMBaAFG7VPsAcL3HJPL9JTu9qVUjs0fI4MCIGA1UdEQQbMBmBF2Fu
bWV5QHJ6LnJ3dGgtYWFjaGVuLmRlMHkGA1UdHwRyMHAwNqA0oDKGMGh0dHA6Ly9jZHAxLnBj
YS5kZm4uZGUvcnd0aC1jYS9wdWIvY3JsL2NhY3JsLmNybDA2oDSgMoYwaHR0cDovL2NkcDIu
cGNhLmRmbi5kZS9yd3RoLWNhL3B1Yi9jcmwvY2FjcmwuY3JsMIGUBggrBgEFBQcBAQSBhzCB
hDBABggrBgEFBQcwAoY0aHR0cDovL2NkcDEucGNhLmRmbi5kZS9yd3RoLWNhL3B1Yi9jYWNl
cnQvY2FjZXJ0LmNydDBABggrBgEFBQcwAoY0aHR0cDovL2NkcDIucGNhLmRmbi5kZS9yd3Ro
LWNhL3B1Yi9jYWNlcnQvY2FjZXJ0LmNydDANBgkqhkiG9w0BAQUFAAOCAQEACYmT7e5BysIh
HZFJp9hbaX6+ZtdfKcUhw6DFFbd2SYUYJtqJuYDraVHWsVKGjrYCQwa00Wc+Pudk2PGQ/RBa
hiy55MdIGiTWpoPrQE22XJ0juOh+6mYeAB647def+pefLcMH8dwyz8B9tGHL/XFUi911p4u7
6bTDxE0L1KYscVSjb3LKCf1L6ttuv/0tqTo996YU1eEUbx6x4IIi8lVWPsfDMTjkulyH/nuk
lIHxnH0jIqJcRqqdivuoibbPaB0ji1LPlIRuPDQtP7uTHosn5tIGVDqrPDjDtMj5hPnKvp1A
zmCrhSZhdcVXmBVFJNF07ZUDDNw8XGFLk3YzIFELQzGCAzIwggMuAgEBMGYwXjELMAkGA1UE
BhMCREUxFDASBgNVBAoTC1JXVEggQWFjaGVuMRcwFQYDVQQDEw5SV1RIIEFhY2hlbiBDQTEg
MB4GCSqGSIb3DQEJARYRY2FAcnd0aC1hYWNoZW4uZGUCBAppKlMwCQYFKw4DAhoFAKCCAaEw
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMDkwNTExMDg0ODA2
WjAjBgkqhkiG9w0BCQQxFgQUdAoky7erYe7L0eYA4w/oj6d7vPswUgYJKoZIhvcNAQkPMUUw
QzAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcw
DQYIKoZIhvcNAwICASgwdQYJKwYBBAGCNxAEMWgwZjBeMQswCQYDVQQGEwJERTEUMBIGA1UE
ChMLUldUSCBBYWNoZW4xFzAVBgNVBAMTDlJXVEggQWFjaGVuIENBMSAwHgYJKoZIhvcNAQkB
FhFjYUByd3RoLWFhY2hlbi5kZQIECmkqUzB3BgsqhkiG9w0BCRACCzFooGYwXjELMAkGA1UE
BhMCREUxFDASBgNVBAoTC1JXVEggQWFjaGVuMRcwFQYDVQQDEw5SV1RIIEFhY2hlbiBDQTEg
MB4GCSqGSIb3DQEJARYRY2FAcnd0aC1hYWNoZW4uZGUCBAppKlMwDQYJKoZIhvcNAQEBBQAE
ggEA2HsMTD1OAqQhEIDHsiKmA5swxnSd8wDPDdYZBEvru7AxLF+ug9gTEyRZLs1JT10PBUfe
v2hP6i7z9AHdtD+I5wqMiYx7BLnOMu2eUtNkSRSNUjpQwTid0hTwizAsrrwnJA5DOs9JVGeY
I7q9I1jWQg2kPojybOgW/cJ0z6Za/GwB5o8r/qmgFdjar6mCyQ16i62r+Jr04QlpuI7kwatt
HZDOMsgfzVf+M80JfwtZnXX9aJLQu4GVkeFQW56a9ka0RVfttejTweZnKQWFNBn4y1zihzv2
JycpFZlgCYu0DsPczulyoPxaoa9OXomX2DbHVzUi6GkGcnNO7ld8RH+62gAAAAAAAA==
--------------ms090904080907000706020707--
