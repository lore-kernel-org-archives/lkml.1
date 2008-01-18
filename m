Return-Path: <linux-kernel-owner+w=401wt.eu-S1760927AbYARMiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927AbYARMiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757492AbYARMip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:38:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:16993 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460AbYARMio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:38:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W9uw87zH3BbB5osFfVooOnVfmUkab60GJJZLKKh/4OvfR3o4eAJpKEAH/ATCuA0innyIWpmGgGjTVqGYaIq77TCUkjBP5HAkeiBncPz2Bb72LNbi8Cav9dx/cT1jwPvHD2GQB5mXRR0u0G+xRZrJbAmoe1WweR7u6jEYnokd8VM=
Message-ID: <519a8b110801180438l389ec1d6t7b888b8c78d59dd8@mail.gmail.com>
Date: Fri, 18 Jan 2008 13:38:42 +0100
From: xming <xmingske@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: Cannot boot xen DomU > 2.6.23.1
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>
In-Reply-To: <4790561E.9040508@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <519a8b110801170813h96b8f2by795e6d8b72a00ba4@mail.gmail.com>
	 <478F8D22.60004@goop.org>
	 <519a8b110801171113y20a3bedfg446e29a30712a26d@mail.gmail.com>
	 <4790561E.9040508@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, I misunderstood your original report to mean that something was
> complaining about "too much" output.  You're saying that lots of console
> output seems to lock the domain.

Sorry about that, and yes that is the case.

> I've had a report about heavy disk IO seems to lock up as well.  Perhaps
> they're both related to high event rates.  Do you think you could try an
> IO-intensive workload to see if you can get a similar lockup?

IO-intensive locks up too (see below)

> When the domain is locked up, what does /usr/lib/xen/bin/xenctx say?

see below

> Hm.  Rather than backing out the structure-change patch, could you try
> this workaround:
>
> diff -r be3ca4e0e19e arch/x86/xen/enlighten.c
> --- a/arch/x86/xen/enlighten.c  Thu Jan 17 14:25:07 2008 -0800
> +++ b/arch/x86/xen/enlighten.c  Thu Jan 17 16:37:42 2008 -0800
> @@ -95,7 +95,7 @@ struct shared_info *HYPERVISOR_shared_in
>   *
>   * 0: not available, 1: available
>   */
> -static int have_vcpu_info_placement = 1;
> +static int have_vcpu_info_placement = 0;
>
>  static void __init xen_vcpu_setup(int cpu)
>  {

First of all this patch solves the lock-ups, it works as advertised :) The DomU
works as before. Just for the record for people trying to apply this to 2.6.23.x
you need to change the /x86/ to /i386/, unified x86 is since 2.6.24.

I tried to create 2 tests, one is IO intensive and the other is console
output intensive:

test1. bonnie++ -s 1024 -u nobody
test2. for i in `seq 1 50000`; do echo 00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ; done

In all acese where it crashed(hanged) there was no oops/panic.

scenario 1 (booted 2.6.23.14 as is)
--------------------------------------------------
(but with init=/bin/bash, otherwise I couldn't get a prompt)

test1: crashed

# /usr/lib/xen/bin/xenctx 108
eip: c037c0c7
esp: c0343f90
eax: 00000000   ebx: 00000001   ecx: 00000000   edx: c0342000
esi: c0373004   edi: c1210df4   ebp: 00001b7d
 cs: 00000061    ds: 0000007b    fs: 000000d8    gs: 00000000

Stack:
 c0100add c0378980 c0101962 c0104821 c120a000 c0378df4 c0348cff 00000025
 c0348430 00000004 00009000 00006df4 00ea1000 c0363be0 c0343fe8 c03dd007
 00000000 c0343fec c0349868 c0343fe0 178bc1f1 00002001 01020800 00060fb1
 00000000 c03dd000 00000000 00000000

Code:
cc cc cc cc cc cc cc cc cc cc cc cc cc cc b8 06 00 00 00 cd 82 <c3> cc
cc cc cc cc cc cc cc cc cc

Call Trace:
  [<c037c0c7>]  <--
  [<c0100add>]
  [<c0378980>]
  [<c0101962>]
  [<c0104821>]
  [<c120a000>]
  [<c0378df4>]
  [<c0348cff>]
  [<c0348430>]
  [<c0363be0>]
  [<c0343fe8>]
  [<c03dd007>]
  [<c0343fec>]
  [<c0349868>]
  [<c0343fe0>]
  [<178bc1f1>]
  [<c03dd000>]

test2: crashed after many many retries and sometimes with strange output

00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAA
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
0000AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ

# /usr/lib/xen/bin/xenctx 113
eip: c037c0c7
esp: c0343f90
eax: 00000000   ebx: 00000001   ecx: 00000000   edx: c0342000
esi: c0373004   edi: c1210df4   ebp: 00001b7d
 cs: 00000061    ds: 0000007b    fs: 000000d8    gs: 00000000

Stack:
 c0100add c0378980 c0101962 c0104821 c120a000 c0378df4 c0348cff 00000025
 c0348430 00000004 00009000 00006df4 00ea1000 c0363be0 c0343fe8 c03dd007
 00000000 c0343fec c0349868 c0343fe0 178bc1f1 00002001 00020800 00060fb1
 00000000 c03dd000 00000000 00000000

Code:
cc cc cc cc cc cc cc cc cc cc cc cc cc cc b8 06 00 00 00 cd 82 <c3> cc
cc cc cc cc cc cc cc cc cc

Call Trace:
  [<c037c0c7>]  <--
  [<c0100add>]
  [<c0378980>]
  [<c0101962>]
  [<c0104821>]
  [<c120a000>]
  [<c0378df4>]
  [<c0348cff>]
  [<c0348430>]
  [<c0363be0>]
  [<c0343fe8>]
  [<c03dd007>]
  [<c0343fec>]
  [<c0349868>]
  [<c0343fe0>]
  [<178bc1f1>]
  [<c03dd000>]

Scenario 2 (have_vcpu_info_placement = 0)
--------------------------------------------------------------

test1: no crash
test2: no crash, but occationally I still get funny output like this

00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
0000AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
000AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
000AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
