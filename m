Return-Path: <linux-kernel-owner+w=401wt.eu-S933823AbXC1XSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933823AbXC1XSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 19:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933827AbXC1XSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 19:18:41 -0400
Received: from smtp.ono.com ([62.42.230.12]:45216 "EHLO resmaa03.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933823AbXC1XSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 19:18:40 -0400
Date: Thu, 29 Mar 2007 01:18:38 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Inlining can be _very_bad...
Message-ID: <20070329011838.6e832615@werewolf-wl>
X-Mailer: Claws Mail 2.8.1cvs57 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_nK/p.b/qJ=F6l.=Di1suDPB"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_nK/p.b/qJ=F6l.=Di1suDPB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all...

I post this here as it can be of direct interest for kernel development
(as I recall many discussions about inlining yes or no...).

Testing other problems, I finally got this this issue: the same short
and stupid loop lasted from 3 to 5 times more if it was in main() than
if it was in an out-of-line function. The same (bad thing) happens if
the function is inlined.

The basic code is like this:

float	data[];

[inline] double one()
{
    double sum;
    sum = 0;
    for (i=0; i<SIZE; i++) sum += data[i];
    return sum;
}

int main()
{
    gettimeofday(&tv0,0);
    for (i=0; i<SIZE; i++)
        s0 += data[i];
    gettimeofday(&tv1,0);
    printf("T0: %6.2f ms\n",elap(tv0,tv1));
    gettimeofday(&tv0,0);
        s1 = one();
    gettimeofday(&tv1,0);
    printf("T1: %6.2f ms\n",elap(tv0,tv1));
}

The times if one() is not inlined (emt64, 2.33GHz):

apolo:~/e4> tst
T0: 1145.12 ms
S0: 268435456.00
T1: 457.19 ms
S1: 268435456.00

With one() inlined:

apolo:~/e4> tst
T0: 1200.52 ms
S0: 268435456.00
T1: 1200.14 ms
S1: 268435456.00

Looking at the assembler, the non-inlined version does:

.L2:
    cvtss2sd    (%rdx,%rax,4), %xmm0
    incq    %rax
    cmpq    $268435456, %rax
    addsd   %xmm0, %xmm1
    jne .L2

and the inlined

.L13:
    cvtss2sd    (%rdx,%rax,4), %xmm0
    incq    %rax
    cmpq    $268435456, %rax
    addsd   8(%rsp), %xmm0
    movsd   %xmm0, 8(%rsp)
    jne .L13

It looks like is updating the stack on each iteration...This is -march=opteron
code, the -march=pentium4 is similar. Same behaviour with gcc3 and gcc4.

tst.c and Makefile attached.

Nice, isn't it ? Please, probe where is my fault...

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.20-jam06 (gcc 4.1.2 20070302 (prerelease) (4.1.2-1mdv2007.1)) #1 SMP PREEMPT

--MP_nK/p.b/qJ=F6l.=Di1suDPB
Content-Type: application/octet-stream; name=Makefile
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=Makefile

UFJPRz10c3QKU1JDUz10c3QuYwpDQz1nY2M0IC1tNjQgLW1hcmNoPW9wdGVyb24gLU8yCiNDQz1n
Y2M0IC1tMzIgLW1hcmNoPXBlbnRpdW00IC1PMgojQ0MrPS1ESU5MSU5FCkxJQlM9CgpPQkpTPSQo
U1JDUzouYz0ubykKQVNNUz0kKFNSQ1M6LmM9LnMpCgphbGw6ICQoUFJPRykgJChBU01TKQoKJChQ
Uk9HKTogJChPQkpTKQoJJChDQykgLW8gJEAgJChPQkpTKSAkKExJQlMpCgouYy5vOgoJJChDQykg
LWMgJDwKCi5jLnM6CgkkKENDKSAtYyAtUyAkPAoKY2xlYW46CglAcm0gLWYgJChQUk9HKSAkKE9C
SlMpICQoQVNNUykgY29yZSB0YWdzCg==

--MP_nK/p.b/qJ=F6l.=Di1suDPB
Content-Type: text/x-csrc; name=tst.c
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=tst.c

#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#define SIZE 256*1024*1024

#define elap(t0,t1) \
	((1000*t1.tv_sec+0.001*t1.tv_usec) - (1000*t0.tv_sec+0.001*t0.tv_usec))

double  one();

float	*data;

#ifdef INLINE
inline
#endif
double one()
{
	int i;
	double sum;

	sum =3D 0;
	asm("#FBGN");
	for (i=3D0; i<SIZE; i++)
		sum +=3D data[i];
	asm("#FEND");

	return sum;
}

int main(int argc,char** argv)
{
	struct timeval	tv0,tv1;
	double			s0,s1;
	int				i;

	data =3D malloc(SIZE*sizeof(float));
	for (i=3D0; i<SIZE; i++)
		data[i] =3D 1;

	gettimeofday(&tv0,0);
	s0 =3D 0;
	asm("#MBGN");
	for (i=3D0; i<SIZE; i++)
		s0 +=3D data[i];
	asm("#MEND");
	gettimeofday(&tv1,0);
	printf("T0: %6.2f ms\n",elap(tv0,tv1));
	printf("S0: %0.2lf\n",s0);

	gettimeofday(&tv0,0);
		s1 =3D one();
	gettimeofday(&tv1,0);
	printf("T1: %6.2f ms\n",elap(tv0,tv1));
	printf("S1: %0.2lf\n",s1);

	free(data);

	return 0;
}


--MP_nK/p.b/qJ=F6l.=Di1suDPB--
