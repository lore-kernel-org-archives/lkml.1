Return-Path: <linux-kernel-owner+w=401wt.eu-S1759497AbZFXPYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497AbZFXPYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 11:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbZFXPYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 11:24:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61207 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbZFXPYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 11:24:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] add checksum selftest
Date: Wed, 24 Jun 2009 17:24:30 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1245850289-6673-1-git-send-email-vapier@gentoo.org> <200906241614.02615.arnd@arndb.de> <8bd0f97a0906240745t3a11329fg3ffc6dfb0aa3dec5@mail.gmail.com>
In-Reply-To: <8bd0f97a0906240745t3a11329fg3ffc6dfb0aa3dec5@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200906241724.30947.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19M6z1Sc7Pf1MjgK4poBy9Q2xwsT9Gvnlbv8WG
 yRIKxqVkHz4hYFeLstCVdcfeavQF7gDx2baYMEFTKS8dQWIt52
 xJ4C4eu09WBJBJwbVKk1g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 June 2009, Mike Frysinger wrote:
> >> +static unsigned char __initdata do_csum_data1[] = {
> >> +     0x20,
> >> +};
> >> +static unsigned char __initdata do_csum_data2[] = {
> >> +     0x0d, 0x0a,
> >> +};
> >> +static unsigned char __initdata do_csum_data3[] = {
> >> +     0xff, 0xfb, 0x01,
> >> +};
> >
> > You define separate test vectors for each of the three
> > cases, which looks like it could be optimized by reusing
> > the same test vectors for each case.
> 
> i'm not really familiar with the interfaces to figure out how to do
> this ... i just added some printks to dump arguments/buffers and then
> copied & pasted ones that looked pretty different

I just mean you can consolidate

+struct do_csum_data {
+       unsigned short ret;
+       unsigned char *buff;
+       int len;
+};
+#define DO_CSUM_DATA(_num, _ret) \
+{ \
+       .ret = _ret, \
+       .buff = do_csum_data##_num, \
+       .len = ARRAY_SIZE(do_csum_data##_num), \
+}

and 

+struct csum_partial_data {
+       __wsum ret;
+       const void *buff;
+       int len;
+       __wsum wsum;
+};
+#define CSUM_PARTIAL_DATA(_num, _ret, _wsum) \
+{ \
+       .ret = _ret, \
+       .buff = csum_partial_data##_num, \
+       .len = ARRAY_SIZE(csum_partial_data##_num), \
+       .wsum = _wsum, \
+}

into something like

struct csum_combined_check_data {
	const char *buff;
	int len;
	unsigned short do_csum_ret;
	__wsum wsum;
	unsigned short csum_partial_ret;
};

#define CSUM_COMBINED_TEST_DATA(_num, _do_csum_ret,	\
			 _csum_partial_ret, _wsum)	\
{							\
	.buff = csum_partial_data##_num,		\
	.len = ARRAY_SIZE(csum_partial_data##_num),	\
	.do_csum_ret = _do_csum_ret,			\
	.wsum = _wsum,					\
	.csum_partial_ret = csum_partial_ret,		\
};

This could cut down the length of the module significantly,
without changing any of the semantics.

> >> +static struct csum_partial_data __initdata csum_partial_data[] = {
> >> +     CSUM_PARTIAL_DATA(1,  0x00000074, 0x0),
> >> +     CSUM_PARTIAL_DATA(2,  0x00000a0d, 0x0),
> >> +     CSUM_PARTIAL_DATA(3,  0x0000fe00, 0x0),
> >> +     CSUM_PARTIAL_DATA(5,  0x00005084, 0x0),
> >> +     CSUM_PARTIAL_DATA(8,  0x1101eefe, 0x11016a80),
> >> +     CSUM_PARTIAL_DATA(8b, 0x00008781, 0x847e),
> >> +     CSUM_PARTIAL_DATA(9,  0x1101eefe, 0x11016b80),
> >> +};
> >
> > For partial checksums, the result has to be folded into a 16-bit
> > number using csum_fold(), because csum_partial and other functions
> > return a 32-bit __wsum that can take many equivalent values taht
> > are all correct.
> 
> i hear your words, but i understand them not ;)

The problem is that IP checksumming is only defined for 16-bit
words. We use __wsum (32 bits) as an intermediate in the networking
stack so we can consolidate the folding in one place. If you have
a test vector that results in checksum 0xffff (as a well-formed
packet should), the __wsum could be one of 0x0000ffff, 0xffff0000,
0xffffffff, 0x1234edcb, for any other value x where
(((x >> 16) + (x & 0xffff)) >> 16 + ((x >> 16) + (x & 0xffff)))
& 0xffff = 0xffff. The specific __wsum returned by csum_partial()
is implementation specific, so you cannot compare it to a
precomputed value unless sending it through csum_fold().

	Arnd <><
