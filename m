Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbZKRAxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbZKRAxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 19:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbZKRAxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 19:53:45 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:15232 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbZKRAxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 19:53:44 -0500
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAPnUAkurRN+K/2dsb2JhbAC+FphJhDsE
X-IronPort-AV: E=Sophos;i="4.44,761,1249257600"; 
   d="scan'208";a="105692258"
Date: Tue, 17 Nov 2009 19:53:37 -0500
From: David VomLehn <dvomlehn@cisco.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: dedekind1@gmail.com, Marco Stornelli <marco.stornelli@gmail.com>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-embedded@vger.kernel.org, akpm@linux-foundation.org,
       dwm2@infradead.org, linux-kernel@vger.kernel.org, mpm@selenic.com,
       paul.gortmaker@windriver.com
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
Message-ID: <20091118005337.GA19374@dvomlehn-lnx2.corp.sa.net>
References: <1258463404.27437.103.camel@localhost> <m1pr7hf93s.fsf@fess.ebiederm.org> <20091117235627.GA13469@dvomlehn-lnx2.corp.sa.net> <m1iqd8ptg9.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1iqd8ptg9.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 04:28:22PM -0800, Eric W. Biederman wrote:
> David VomLehn <dvomlehn@cisco.com> writes:
> 
> > On Tue, Nov 17, 2009 at 10:45:43AM -0500, Eric W. Biederman wrote:
> > ...
> >> Why not use the kdump hook?  If you handle a kernel panic that way
> >> you get enhanced reliability and full user space support.  All in a hook
> >> that is already present and already works.
...
> > 1. In what ways would this be better than, say, a panic_notifier?
> 
> A couple of ways. 
> 
> - You are doing the work in a known good kernel instead of the kernel
>   that just paniced for some unknown reason.
> - All of the control logic is in user space (not the kernel) so you can
>   potentially do something as simple as "date >> logfile" to get the
>   date.

I think I see better what you're suggesting--passing the info to a kdump
kernel and having it do whatever it wants. I don't think I want to do this,
but I haven't used any of the kexec() stuff, so I may be missing the point.
Some more context:

My application is an embedded one, and one of the big things I need to do
after a failure is to bring up a fully functional kernel ASAP. Once I have
that kernel, I process all of the crash data in user space concurrently with
running my main application. Because I'm embedded, I'm very limited in how
much crash data I can save over a reboot, how much I can store, and how
much I can send to a central collection point. This is good, since it doesn't
take up a lot of resources, but core dumps are out of the question.

As I understand kdump, I would also need to have a second kernel in memory
to do the kdump work. It wouldn't need to be as big is the kernel that
failed, but it would still require a significant amount of memory. On an
embedded system, the idle memory may be a luxury we can't afford.

I think this makes a kdump-based solution difficult, but if it can meet
my requirements, I'd much rather use it (I've been following kdump since
it's inception quite a few years ago, but it hasn't seemed a good match
for embedded Linux). Does this still sound like a good match?

> > 2. Where would you suggest tying in? (Particularly since not all architectures
> >    currently support kdump)
> 
> No changes are needed kernel side.  You just need an appropriate kernel and
> initrd for your purpose.

I think I must still be missing something. I have dynamic data that I want
to preserve as I reboot from a failed kernel to a fresh new kernel. By
the time the fresh kernel starts init, the dynamic data (IP addresses, MAC
addresses) has been re-written with new values. This is why I'm trying to
preserve, but I may be running without disk or flash. This patch doesn't
preserve the data, but it gets it into the kernel so that it can be
preserved. At present, I'm preserving the data in a panic_notifier function,
but I am not wedded to that. At present, the data will be copied to a
section of memory retained across boots, but I know others will want to
write to flash.

> All of the interesting architectures support kexec, and if an
> architecture doesn't it isn't hard to add.  The architecture specific
> part is very simple.  A pain to debug initially but very simple.

I use MIPS processors, and it looks like it is supported. So long as it's
stable, I'm happy to use it.

> Eric

David VL
