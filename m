Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab0BCEHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 23:07:23 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:40231 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab0BCEHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 23:07:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tUOVhyL1qsxNCJ2NsFcAW5WcbFEXatvvQEgYFBBxZjgALS9DraZLYxNTjIUk3GV6MI
         daBYoi6rwD1sMUk4nJNT2Ry+Cw8Kcnz7heWlmSlbFRH3R+DgH7LvWENL/3m3Ww8QOQUd
         kccLu0tPuejZmZG/m1Hq1bSqgx8iprMDajJks=
MIME-Version: 1.0
In-Reply-To: <873a1jdyrg.fsf@basil.nowhere.org>
References: <817ecb6f1001311522q52bf4eebmb748c486dcd5ad35@mail.gmail.com>
	 <873a1jdyrg.fsf@basil.nowhere.org>
Date: Tue, 2 Feb 2010 23:07:02 -0500
Message-ID: <817ecb6f1002022007t236823b2pbf2a443f07532c72@mail.gmail.com>
Subject: Re: [PATCH v8] RO/NX protection for loadable kernel modules
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-next@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 2, 2010 at 6:05 PM, Andi Kleen <andi@firstfloor.org> wrote:

> My current kernel has 52 modules loaded, most of them very small.
> Assuming the additional alignment of the data section cost two more
> pages on average (I think that's a good assumption), that's roughly
> 424KB of additional memory, plus associated runtime costs in increased
> TLB usage.

You are right about the additional memory consumption with this option
enabled. In worst case scenario, a one-page module will get split into
3 pages. This might be a significant and unwelcome increase in some
cases (embedded systems come to mind) and that is why this is
implemented as compile-time option.
However, on a general run-of-the-mill system the impact is not that
significant. Case in point: I run Ubuntu 9.04 amd x86_64 with stock
kernel on a generic AMD box. There are 111 modules loaded for all the
hardware in the box and all the functions that it provides (regular
consumer-grade hardware, but definitely not a typical home desktop
setup). In total, 111 modules consume 15590884 bytes, with no module
less then 10KB. After eliminating top 3 memory hogs (nvidia@8MB,
vboxdrv@1.7MB and snd_hda_intel@0.5MB) we left with 5007532 bytes, 108
modules and nfs leading the list at 300KB. Assuming the worst-case
scenario of 2 additional pages per module, we get
(5007532+108*8192)/5007532 = 1.18 - only 18%. In addition, most
modules already have some unused space left at the end of the last
page and some padding in the middle for page/cache-aligned data. With
that in mind, it looks to me that typical overhead will be about 1
page per module (9% for the case above, although I have no solid
statistics to back this up).

> What would I get for that if I applied the patch and enabled the option?

With this patch you get strict separation of code, RO-data and RW-data
in LKMs. This will prevent all attempts (intentional or erroneous) to
modify code and RO-data, while keeping all data non-executable. While
not targeted to prevent any specific exploit, this patch does improve
general kernel security. When combined with the other two patches I
have submitted (RW+NX for first megabyte and NX for static kernel
data), this patch set completely eliminates kernel pages with
executable data and modifiable code.

> Did you find any bugs with this option?

Well, so far I did not find any bugs in the last version of the patch,
but it definitely breaks any module that uses self-modifying code or
data execution.
An issue with ftrace have been reported earlier and fixed in V7.
