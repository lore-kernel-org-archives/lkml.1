Return-Path: <linux-kernel-owner+w=401wt.eu-S1759005AbYD2SlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759005AbYD2SlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbYD2Sky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:40:54 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:64016 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbYD2Skx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:40:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LAhNBYk5V13pyW3GV4Ml8KrhYgbcQ8x/+Ck/V+U6IyGDf84GKBxw65MrBVmkDviMAWQ/bs3YHLX1pyeCCWbF0tqs2q0xObYF5Mrlluny20peZ8bvTB3GRA3OjO6edFZo6s91+0f/5p31q1iniHiyCZOtyME7wCrqw1RQeTqmJRQ=
Message-ID: <86802c440804291140k7e96b6cftbb350b8fc72103f@mail.gmail.com>
Date: Tue, 29 Apr 2008 11:40:51 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Gabriel C" <nix.or.die@googlemail.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Mika Fischer" <mika.fischer@zoopnet.de>, balajirrao@gmail.com
In-Reply-To: <m1ej8o4liv.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801192045.17291.yinghai.lu@sun.com>
	 <200801202256.48365.yinghai.lu@sun.com>
	 <20080122165125.GA17992@elte.hu>
	 <200801221623.20861.yinghai.lu@sun.com>
	 <20080426035614.a30afb17.akpm@linux-foundation.org>
	 <48132665.8050202@googlemail.com>
	 <86802c440804261805rc739f9as519213fecdc0cdff@mail.gmail.com>
	 <m17ieh4zuo.fsf@frodo.ebiederm.org> <20080429103150.GJ23198@elte.hu>
	 <m1ej8o4liv.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 10:29 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Ingo Molnar <mingo@elte.hu> writes:
>
>  > * Eric W. Biederman <ebiederm@xmission.com> wrote:
>  >
>  >> So lets concentrate on PAT to solve contiguous MTRR region problems.
>  >>
>  >> We can upgrade UC to WC with pat.  As well as demote WB to UC or WC.
>  >> So for those regions we know about we should be in good shape.
>  >
>  > sure, but whatever we do now in the sysfs API space, it will hit distros
>  > only in a year, relistically, because Xorg also has to adopt to it. The
>  > workaround from Yinghai looks reasonably configurable - if we mess up
>  > (say an SMM comes in while we fiddle with the MTRRs) we'll likely get a
>  > lockup right then, during bootup, so it wont be hard to realize what
>  > went wrong. In that sense it's in fact safer to do it during early init
>  > than let the user do it via some script, because the window is smaller,
>  > etc.
>  >
>  > we still default to the safe mode of course and dont touch MTRRs, but
>  > for note the various configuration options that are available to distros
>  > and users.
>
>  The potential problem isn't while we reprogram the MTRRs, the potential
>  problem is mapping the SMM area uncachable.  In which case we will
>  make each SMM interrupt drastically slower.  Which can have all kinds of
>  unpleasant side effects.

and ACPI area too.

that only try to make the continuous to discrete layout. and still try
to cover all that is (WBs - UC) directly with WB.
only thing is that could run out of MTRR..., and mtrr_gran_size is
used to avoid that.
then some RAM that is less than mtrr_gran_size could be dumped.
so mtrr_gran_size could do sth.
anyway this patch only can meet one end.
for example Mika Fischer's system doesn't need to trim any RAM in MTRR.
but for Gabriel's system may need to trim some RAM in MTRR.

current mtrr_gran_size is default to 64M...

may need another patch to loop all mtrr_chunk_size (2g, 1g, ...64M) ,
mtrr_gran_size (2g, 1g, ...1M) meet
1. leave one or two entry for X server driver
2. lose less cover for RAM in MTRR.

anyway that should be done in BIOS. but ...

>
>  If we really can mess up SMM mode that way we have a really nasty
>  interaction that is horrible to debug, or recognize.
>
>  Further the opportunity for this kind of fixup is small.
>  Newer AMD systems don't need it as they have an extra
>  way of specifying memory about 4G as WB.  Systems with just
>  the MTRRs can only use this when they have right around 4GB
>  because with more memory there are not enough MTRRs to leave them
>  non-overlapping and still mark all of memory WB.

yes. the patch handle the AMD rev f later with mtrr_tom2.
I have one system that give me - ( strange one ?)
0 - 128g WB
4g-512m, 4g wc

after the patch i got

0 - 2048m wb
2048m - 1024m wb
3072m - 3584m wb

YH
