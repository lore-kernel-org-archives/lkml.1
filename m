Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbZKDLKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbZKDLKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 06:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbZKDLKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 06:10:17 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:16174 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbZKDLKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:10:14 -0500
X-IronPort-AV: E=Sophos;i="4.44,679,1249272000"; 
   d="scan'208";a="71412604"
Subject: Re: [PATCH] Correct nr_processes() when CPUs have been unplugged
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>, "Paul E. McKenney" <paulmck@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20091103160734.GA21362@elte.hu>
References: <1257243074.23110.779.camel@zakaz.uk.xensource.com>
	 <20091103160734.GA21362@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 4 Nov 2009 11:10:16 +0000
Message-ID: <1257333016.23110.3370.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-03 at 16:07 +0000, Ingo Molnar wrote:
> 
> > This bug appears to pre-date the transition to git and it looks 
> > like  it may even have been present in linux-2.6.0-test7-bk3 since 
> > it looks  like the code Rusty patched in 
> > http://lwn.net/Articles/64773/ was already wrong.
> 
> Nice one. I'm wondering why it was not discovered for such a long
> time. That count can go out of sync easily, and we frequently offline
> cpus during suspend/resume, and /proc lookup failures will be noticed
> in general.

I think most people probably don't run for all that long with CPUs
unplugged, in the suspend/resume case the unplugs are fairly transient
and apart from the suspend/resume itself the system is fairly idle while
the CPUs are not plugged. Note that once you plug all the CPUs back in
the problem goes away again.

I can't imagine very many things pay any attention to st_nlinks
for /proc anyway, so as long as the stat itself succeeds things will
trundle on.

>  How come nobody ran into this? And i'm wondering how you have run
> into this - running cpu hotplug stress-tests with Xen guests - or via
> pure code review? 

We run our Xen domain 0 with a single VCPU by unplugging the others on
boot. We only actually noticed the issue when we switched our installer
to do the same for consistency. The installer uses uclibc and IIRC (the
original discovery was a little while ago) it was using an older variant
of stat(2) which doesn't have a st_nlinks field wide enough to represent
the bogus value and so returned -EOVERFLOW.

My guess is that most systems these days have a libc which uses a newer
variant of stat(2) which is able to represent the large (but invalid)
value so stat() succeeds and since nothing ever actually looks at the
st_nlink field (at least for /proc) things keep working.

Ian.

