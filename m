Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbZERR6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbZERR6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 13:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbZERR63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 13:58:29 -0400
Received: from sous-sol.org ([216.99.217.87]:41274 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751218AbZERR63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 13:58:29 -0400
Date: Mon, 18 May 2009 10:51:18 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] xen /proc/mtrr implementation
Message-ID: <20090518175118.GL20823@sequoia.sous-sol.org>
References: <20090513133021.GA7277@elte.hu> <4A0ADBA2.2020300@goop.org> <20090515182757.GA19256@elte.hu> <4A0DCC11.10307@goop.org> <m1my9ex818.fsf@fess.ebiederm.org> <4A0DFF78.6000501@goop.org> <20090515202250.0f1218ef@jbarnes-g45> <m1iqk1k708.fsf@fess.ebiederm.org> <4A10EAC4.9070701@goop.org> <20090518085902.GE10687@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090518085902.GE10687@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> Here Xen invades an already fragile piece of upstream code 
> (/proc/mtrr) that is obsolete and on the way out. If you want a 
> solution you should add PAT support to Xen and you should use recent 
> upstream kernels. Or you should emulate /proc/mtrr in _Xen the 
> hypervisor_, if you really care that much - without increasing the 
> amount of crap in Linux.

Could you be specific re: technical issues?  I see in the general mtrr
impact has one oddity:

+int __init common_num_var_ranges
+static int __init xen_num_var_ranges(void);
+.num_var_ranges    =

A bit unusual to have an __init function in an ops table.  Albeit safe in
this case.  Could slightly minimize impact by keeping setup_num_var_ranges
and have it do:

	if (mtrr_if->num_var_ranges)
		num_var_ranges = mtrr_if->num_var_ranges();
	else
		num_var_ranges = common_num_var_ranges;

Similarly, could do a simple inline stub to remove the extra ifdef.

+#ifdef CONFIG_XEN_DOM0
+		xen_init_mtrr();
+#endif

But those are pretty minor.  I think the changes proposed are pretty
small and reasonable to make existing /proc/mtrr usable in Xen dom0
(different discussion of when to formally deprecate /proc/mtrr).

thanks,
-chris
