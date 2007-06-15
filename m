Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbXFOMn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbXFOMn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbXFOMnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:43:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:53305 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbXFOMnR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:43:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
Date: Fri, 15 Jun 2007 14:42:23 +0200
User-Agent: KMail/1.9.6
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200706150159.l5F1xNgM000459@hera.kernel.org> <200706151131.38429.arnd@arndb.de> <20070615121133.GF8154@parisc-linux.org>
In-Reply-To: <20070615121133.GF8154@parisc-linux.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706151442.23939.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/XE5DEXjG0S+fCdrI/4mXGtRbOFmD1+n+pGDe
 v8faWp6HsYR4poofCvotrrxTjIDKgWqsxYBGZVYgYJAstyP4oh
 xhe3uZwlkf31EYsCIzOHQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007, Matthew Wilcox wrote:
> You're relying on compat_[us]64 being only used in structures which are
> already packed.  If someone uses them in a non-packed struct, they won't
> decrease the alignment.  I think it would be more effective to specify
> it as:
> 
> __attribute__((aligned(4), packed))

That's what I thought as well at first, since this is how the gcc 
documentation seems to describe it. However, recent version of gcc
complain about this:

gcc-4.1 -Wall -O2 test.c  -c
test.c:1: warning: 'packed' attribute ignored

I have tested versions 2.95, 3.3 and 4.1, an they all ignore do the
right thing when you do not specify the packed attribute.

> The other problem is that if someone defines a struct like this:
> 
> struct foo {
>         short bar;
>         compat_s64 baz;
> } __attribute__((packed))
> 
> it'll have different definitions on x86 and ia64.
> 
> So I think we should be aiming for the ((aligned, packed)) definition and
> remove the __attribute__((packed)) from the struct definitions.  What do
> you think?

There should never be an __attribute__((packed)) to solve this alignment
problem, neither in the definition of compat_s64 nor in the definition of
a data structure using it.

We might ask the gcc developers to clarify the documentation, which as of 4.1
states:

     The `aligned' attribute can only increase the alignment; but you
     can decrease it by specifying `packed' as well.  See below.

My understanding is that this only applies to statically allocated variables,
but not to automatic stack variables and to usage of the type inside of
a data structure.

	Arnd <><
