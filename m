Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbXFONws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbXFONws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 09:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbXFONwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 09:52:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:50280 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbXFONwg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 09:52:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
Date: Fri, 15 Jun 2007 15:52:20 +0200
User-Agent: KMail/1.9.6
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200706150159.l5F1xNgM000459@hera.kernel.org> <200706151442.23939.arnd@arndb.de> <20070615134512.GG8154@parisc-linux.org>
In-Reply-To: <20070615134512.GG8154@parisc-linux.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706151552.20915.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/FqhU/0UtlkiK1Ppv7+fNGtREsCgh1MhMCzTf
 cfmjPh1saqhAS7OIUuUmsXlJI47mFoM+gHzwDmyPzdhj5Bxx21
 33kHIZNs/S8G9vaZL1/7Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007, Matthew Wilcox wrote:
> Here's a program which illustrates the source of confusion:
> 
> #include <stdio.h>
> #include <stddef.h>
> 
> typedef unsigned long long __attribute__((aligned(4))) compat_u64;
> 
> struct foo {
>         int y;
>         unsigned long long __attribute__((aligned(4))) x;
> };
> 
> struct bar {
>         int y;
>         compat_u64 x;
> };
> 
> int main(void)
> {
>         printf("offset of foo->x is %lu\n", offsetof(struct foo, x));
>         printf("offset of bar->x is %lu\n", offsetof(struct bar, x));
>         return 0;
> }
> 
> output (on ia64, and I'm told other 64-bit platforms) is:
> 
> $ ./test 
> offset of foo->x is 8
> offset of bar->x is 4
> 
> I'll try and come up with some wording that works for the GCC manual.



I just talked to Ulrich Weigand, who explained to me that
__attribute__((packed)) should not be specified on a typedef that is
not also a struct/union/enum definition, because it can not change the
type anyway.

Also, the attribute((aligned(x))) works differently in a typedef than
in a field or variable declaration:

In your struct foo, __attribute__((aligned(4))) does not have any
effect because the attribute on a field declaration will only increase
the alignment if you specify a larger value than the default alignment
for the member type.

In struct bar, you have two members that both have type with a default
alignment of 4, because the typedef overwrote the default alignment
for the compat_u64 type.

	Arnd <><
