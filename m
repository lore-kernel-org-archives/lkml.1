Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbYAYLn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbYAYLn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 06:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYAYLnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 06:43:49 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:57767 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbYAYLnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 06:43:47 -0500
Message-ID: <4799CAE0.7010400@ak.jp.nec.com>
Date: Fri, 25 Jan 2008 20:41:20 +0900
From: Kohei KaiGai <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Andrew G. Morgan" <morgan@kernel.org>
CC: akpm@osdl.org, serue@us.ibm.com, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/3] exporting capability code/name pairs (try 2nd)
References: <47997122.3070504@ak.jp.nec.com> <479990A1.3050103@kernel.org>
In-Reply-To: <479990A1.3050103@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Thanks for your comments.

Andrew G. Morgan wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> KaiGai,
> 
> While this is cute :-), I guess I'm still not all that convinced that
> this is needed.
> 
> libcap already had some (admittedly not quite working) support for
> numeric values of capabilities not currently defined (which I believe is
> now fixed in top of trunk):
> 
> # ./setcap 35=i ./setcap
> # ./getcap ./setcap
> ./setcap = 35+i
> 
> Although, I obviously can't argue that this is as readable as your
> approach, it does seem unlikely that the rate of addition of new
> capabilities will be all that great, and you can recompile everything
> capability related in user-space on a live system without a reboot.

cap_set_flag() and cap_from_text() checks whether required capability
code is in between 0 and __CAP_BITS, or not.
I don't think it works correctly. Is it necessary to obtain this bound
dynamically?

 > Further, if anyone ever wants to translate the capabilities into another
 > language, it seems like user-space is a much better place for that than
 > in the kernel.

Are you intend to translate "cap_net_admin" into native language
representation, for example?
I want to see how Chinese represents it :), but I think it is different
issue with kernel dose not expose its suporing capabilities.

> This patch also requires that /sys be mounted. How does that work for
> code operating early in the boot process or in a chroot environment
> (where an incapable uid=0 account being able to read/write /sys & /proc
> files can do more than a little damage)?

When this patch cannot access /sys, it does not provide dynamically
collected code/name pairs, and it works with statically constructed
table as current libcap doing.

The patched libcap never switch to the dynamic table without successes
in all steps of initialization. Thus, there is no major regression on
this facilitiy.

> None of this touches on the fact that most utility applications that
> will support capabilities "the right way"(TM), will need the #define's
> at compile time for each of the capabilities they require (so they can
> pepper critical regions with cap_set_flag()/cap_set_proc() code.
> 
> When I mentioned this last time, you said you felt this feature was more
> aimed at admin applications like {get,set,pam_}cap. This is fine, but
> none of these admin applications 'use' capabilities, they just make them
> available/visible for other utility applications to use - which gets us
> back to my point; the utility apps can't use them (properly) without
> having compiled-in support to use them appropriately, which requires the
> #define's at compile time or an appropriate vintage of sys/capability.h
> which comes with an appropriately modern version of libcap.  So,
> practically speaking all the capabilities the applications on a system
> should need should be present in the libcap on the system.

Hmm, you are correct. Indeed, applications using capabilities have to
be built with the new libcap which provides fresh sys/capabilitity.h.
It is like a chicken and egg argument.

However, all applications are always built on its running environment,
like RPM packages. These can be delivered as pre-built packages.

> All that being said, the friendliness factor of this is somewhat
> undeniable, and so I can see why folk might want it in the kernel
> anyway. If so, would it possible to move this code into
> security/capability.c and not in the main kernel per-se - protected with
> a configuration option? If it does appear in the kernel, we'll obviously
> add your libcap changes too. If it doesn't, then perhaps we can meet
> your needs with a slight modification to your libcap patch to read the
> capabilities from an optional /etc/XXX file - and make text visibility
> of 'late breaking' capabilities something that the admin can tweak as
> needed?

I think optional configuration file is not a good idea.
It can make unneeded confusion.

If necessary, I'll move this features into security/capability.c and
add a Kconfig option to select it.

Thanks,
-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>
