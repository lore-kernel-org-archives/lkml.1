Return-Path: <linux-kernel-owner+w=401wt.eu-S1759811AbZFOKIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759811AbZFOKIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 06:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbZFOKIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 06:08:46 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37188 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbZFOKIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 06:08:45 -0400
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Tao Ma <tao.ma@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
References: <4A2A7F33.4030807@oracle.com> <4A2AEBE3.4000100@kernel.org>
	<20090608015242.GB2596@cr0.nay.redhat.com>
	<4A2CA96D.3090502@oracle.com>
	<2375c9f90906072341o2cded749m45bdddfdb499469@mail.gmail.com>
	<4A2CC52B.9010602@oracle.com>
	<2375c9f90906081743p77934f47n8ba1a018d333b95b@mail.gmail.com>
	<m1ab4i11zx.fsf@fess.ebiederm.org>
	<20090611050929.GA2706@cr0.nay.redhat.com>
	<m11vpqvozl.fsf@fess.ebiederm.org> <20090613040958.GA2959@cr0>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 15 Jun 2009 03:08:43 -0700
In-Reply-To: <20090613040958.GA2959@cr0> (Amerigo Wang's message of "Sat\, 13 Jun 2009 12\:09\:58 +0800")
Message-ID: <m17hzdhkr8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: xiyou.wangcong@gmail.com, adobriyan@gmail.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tao.ma@oracle.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Amerigo Wang <xiyou.wangcong@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [Patch BUGFIX] kcore: fix its wrong size on x86_64
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <xiyou.wangcong@gmail.com> writes:

> Fix wrong /proc/kcore size on x86_64.
>
> x86_64 uses __va() macro to caculate the virtual address passed to kclist_add()
> but decodes it with its own macro kc_vadd_to_offset(). This is wrong.

Ok.  I finally understand what is going on here, and no kc_vaddr_to_offset
is not wrong when applied to a virtual address.  In fact I expect the current
definition makes things a bit more predictable.

And yes kclist_add is must be given a virtual address

> Also, according to Documentation/x86/x86_64/mm.txt, kc_vaddr_to_offset()
> is wrong too.

How so?  The file offset is a number space that is different from both
physical and virtual addresses.

> So just remove them, use the generic macro.

I think a case can be made either way.  In practice neither answer
gives us a dense offset space on x86_64 so I think I prefer the
current definition which sets or clears the high bits as opposed
to something that mangles the address more.

> BTW, the man page for /proc/kcore is wrong, its size can be more than
> the physical memory size, because it also contains memory area of
> vmalloc(), vsyscall etc...

Yes, the man page is wrong.  The kcore code is also misleading as it
uses two entirely different definitions of size (aka the maximum
offset accepted).

It uses get_kcore_size and (size_t)high_memory - PAGE_OFFSET + PAGE_SIZE;
The second definition being bogus as it has nothing to do with which
offsets are accepted.

Eric
