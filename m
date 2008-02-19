Return-Path: <linux-kernel-owner+w=401wt.eu-S1758786AbYBSEsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbYBSEsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 23:48:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYBSErx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 23:47:53 -0500
Received: from n10.bullet.mail.mud.yahoo.com ([209.191.125.208]:43811 "HELO
	n10.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752184AbYBSErw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 23:47:52 -0500
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Feb 2008 23:47:52 EST
X-Yahoo-Newman-Id: 714442.51424.bm@omp422.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5EfXdc52/cnHBmsQx6AUeZ+CmyK8DTn/3aUPKdk6333UodeQY595ONUeV1f1FqGQOuA4RIGWac13r4ufjzcpw0zOYDNOzddDOmMqCkUFKaH/aj7LV8KC8RE4xUM7TT2El4TgiYpcVPpNlKyl/YkBKw/3rzg2ZoH8jsUaElkIpsY=  ;
X-YMail-OSG: Cy3jpnIVM1m3Zp0oBS0RF9w1BMNLayTBb7H4NAiSXM52naVkgfyX5FWLuxYNMN5zI60KiCfLnw--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/3] Fix Unlikely(x) == y
Date: Tue, 19 Feb 2008 15:41:01 +1100
User-Agent: KMail/1.9.5
Cc: Andi Kleen <andi@firstfloor.org>, Willy Tarreau <w@1wt.eu>,
       Roel Kluin <12o3l@tiscali.nl>, geoffrey.levand@am.sony.com,
       linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       lkml <linux-kernel@vger.kernel.org>
References: <47B70A61.9030306@tiscali.nl> <200802191333.53607.nickpiggin@yahoo.com.au> <20080218184027.429cf47b@laptopd505.fenrus.org>
In-Reply-To: <20080218184027.429cf47b@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802191541.01398.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008 13:40, Arjan van de Ven wrote:
> On Tue, 19 Feb 2008 13:33:53 +1100
>
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > Actually one thing I don't like about gcc is that I think it still
> > emits cmovs for likely/unlikely branches, which is silly (the gcc
> > developers seem to be in love with that instruction). If that goes
> > away, then branch hints may be even better.
>
> only for -Os and only if the result is smaller afaik.

What is your evidence for saying this? Because here, with the latest
kernel and recent gcc-4.3 snapshot, it spits out cmov like crazy even
when compiled with -O2.

npiggin@am:~/usr/src/linux-2.6$ grep cmov kernel/sched.s | wc -l
45

And yes it even does for hinted branches and even at -O2/3

npiggin@am:~/tests$ cat cmov.c
int test(int a, int b)
{
        if (__builtin_expect(a < b, 0))
                return a;
        else
                return b;
}
npiggin@am:~/tests$ gcc-4.3 -S -O2 cmov.c
npiggin@am:~/tests$ head -13 cmov.s
        .file   "cmov.c"
        .text
        .p2align 4,,15
..globl test
        .type   test, @function
test:
..LFB2:
        cmpl    %edi, %esi
        cmovle  %esi, %edi
        movl    %edi, %eax
        ret
..LFE2:
        .size   test, .-test

This definitely should be a branch, IMO.

> (cmov tends to be a performance loss most of the time so for -O2 and such
> it isn't used as far as I know.. it does make for nice small code however
> ;-)

It shouldn't be hard to work out the cutover point based on how
expensive cmov is, how expensive branch and branch mispredicts are,
and how often the branch is likely to be mispredicted. For an
unpredictable branch, cmov is normally quite a good win even on
modern CPUs. But gcc overuses it I think.

