Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbXFOME1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbXFOME1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbXFOMEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:04:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:58692 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbXFOMED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:04:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
Date: Fri, 15 Jun 2007 14:03:53 +0200
User-Agent: KMail/1.9.6
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
References: <200706150159.l5F1xNgM000459@hera.kernel.org> <200706151131.38429.arnd@arndb.de> <200706151355.57464.ak@suse.de>
In-Reply-To: <200706151355.57464.ak@suse.de>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706151403.53855.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+OO72wech3B9bJUka/Ekm/ZGVZssZKlUCTwJl
 xXpsMh0g7pKQvqw6aPZStCXCig/USkqVadOomBL/bSPdtO6B/p
 CPj+yVhowBAXeAnxIabSg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007, Andi Kleen wrote:
> 
> On Friday 15 June 2007 11:31:37 Arnd Bergmann wrote:
> > One common problem with 32 bit system call and ioctl emulation
> > is the different alignment rules between i386 and 64 bit machines.
> > A number of drivers work around this by marking the compat
> > structures as 'attribute((packed))', which is not the right
> > solution because it breaks all the non-x86 architectures that
> > want to use the same compat code.
> 
> Why does it break them? It should just make them a little slower.
> 
> The network code requires unaligned accesses to work
> anyways so if your architecture doesn't support them it is already
> remotely crashable.
> 

It doesn't break in all cases, but quite often, you have
something like:

struct foo {
	__u32 a;
	__u64 b;
};

If you define a

struct compat_foo {
	__u32 a;
	__u64 b;
} __attribute__((packed));

That is broken on all non-x86 architectures, because it removes the
padding that is inserted on the respective 32 bit platforms, while

struct compat_foo {
	__u32 a;
	compat_u64 b;
};

Is a correct definition on all architectures. It also produces
somewhat better code if the architecture does not support unaligned
data access, but that is just an unintended side-effect.

	Arnd <><
