Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbZB0AST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbZB0AST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 19:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbZB0ASF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 19:18:05 -0500
Received: from byss.tchmachines.com ([208.76.80.75]:35450 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbZB0ASE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 19:18:04 -0500
Date: Thu, 26 Feb 2009 16:17:57 -0800
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       shai@scalex86.org
Subject: Re: [PATCH] x86: don't compile vsmp_64 for 32bit
Message-ID: <20090227001757.GE27240@localdomain>
References: <49A626B2.8090205@kernel.org> <20090226064806.GC27240@localdomain> <20090226114457.GB6651@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226114457.GB6651@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 12:44:57PM +0100, Ingo Molnar wrote:
>
>* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>
>> On Wed, Feb 25, 2009 at 09:20:50PM -0800, Yinghai Lu wrote:
>> >
>> >Impact: cleanup
>> >
>> >that is only needed when CONFIG_X86_VSMP is defined with 64bit
>> >also remove dead code about PCI, because CONFIG_X86_VSMP depends on PCI
>> >
>> >Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> >
>> 
>> NAK!
>> vsmp64.c is compiled unconditionally for a reason.  There are ifdefs in the
>> file to avoid code compilation based on config options. is_vsmp_box() is
>> needed even when CONFIG_X86_VSMP is not enabled, since distro kernels don't ship
>> with CONFIG_X86_VSMP, and since is_vsmp_box() is used to determine  whether
>> tsc's can be considered synced or not, this is needed.
>
>is_vsmp_box() is always available:

Yes.  But it does not really detect if the machine is vsmp.  It is just a
'return 0'.

>
>> >+#ifdef CONFIG_X86_VSMP
>> > extern int is_vsmp_box(void);
>> >+#else
>> >+static inline int is_vsmp_box(void)
>> >+{
>> >+	return 0;
>> >+}
>> >+#endif
>
>What this patch does is it reduces the kernel's size when 
>CONFIG_X86_VSMP is turned off and also makes the code arguably 
>cleaner.

True, but by how much? 212 bytes, out of 7285943 bytes which is very
very small percentage wise.

-bash-3.1$ size results/2.6.29-rc6-defconfig/vmlinux
   text    data     bss     dec     hex filename
7285943 1482684  812968 9581595  92341b results/2.6.29-rc6-defconfig/vmlinux
-bash-3.1$ size results/2.6.29-rc6-defconfig+patch/vmlinux
   text    data     bss     dec     hex filename
7285731 1482684  812968 9581383  923347 results/2.6.29-rc6-defconfig+patch/vmlinux

Note that most of the code within vsmp64.c is dependent on PARAVIRT and
won't get compiled if PARAVIRT is not enabled.

We made this code dependent on PARAVIRT rather than CONFIG_X86_VSMP because,
vsmp support has two aspects to it.  One is a minimal paravirtualization part
and the other is internode cacheline support.  While CONFIG_X86_VSMP enables
both, all that is needed for the paravirtualization part is PARAVIRT.  And
it is not heavy or penalizing like the internode cacheline setting.   This will
mean installation of distros with the distro provided installer kernels can be done
relatively easily if paravirt is enabled.   That's all!

>
>> In the future, I would appreciate if you copy me on 
>> cleanups/changes involving vsmp64.c
>
>That is what i did when i queued up the change. That is how you 
>became aware of this commit.
>

Thanks for that.  But I started replying to the message before
the patch was queued/received your email.  But the patch was
queued by the time i finished replying.
