Return-Path: <linux-kernel-owner+w=401wt.eu-S1760913AbXHJVVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760913AbXHJVVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763738AbXHJVUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:20:14 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47085 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762575AbXHJVUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:20:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
       coreteam@netfilter.org
Subject: Re: 2.6.23-rc2-mm2
References: <20070809224254.11f42716.akpm@linux-foundation.org>
	<46BC8F71.3070006@googlemail.com> <46BC944F.9020801@googlemail.com>
	<m1fy2rxpje.fsf@ebiederm.dsl.xmission.com>
	<20070810124156.2de9710e.akpm@linux-foundation.org>
Date: Fri, 10 Aug 2007 15:19:55 -0600
In-Reply-To: <20070810124156.2de9710e.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 10 Aug 2007 12:41:56 -0700")
Message-ID: <m1vebnulxg.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> There seems to be rather a lot of damage here.
>
> I assume that the sysctl changes are what caused the netfilter oopses.
>
> - nf_conntrack_init() calls nf_conntrack_expect_init() which fails due to
>   sysctl problems.  

In particular sysctl_check_table finds issues with the sysctl table
so register_sysctl_table refuses to register it.

> - nf_conntrack_init() bales out without calling nf_conntrack_helper_init()
>
>   So nf_ct_helper_hsize never gets initialised.
>
> - Later, netfilter client code calls helper_hash(), which gets a
>   divide-by-zero due to nf_ct_helper_hsize==0.
>
>
> yeah, that's a netfilter bug, but we're trying to get kernels tested here. 
> If I'm feeling energetic I'll drop the sysctl changes and do rc2-mm3. 
> Probably I won't feel energetic, but we'll need a lot of fixes here before
> I can release the sysctl changes in another -mm, please.

As a cheap workaround it should be possible to disable SYSCTL support
in 2.6.23-rc2-mm2 to get around these issues.


Andrew for the moment I have just sent you fixes for all of the issues
that I am aware of.  Mostly they are cheap kill the sys_sysctl()
support patches.

Hopefully that is enough to bring the pain level down to manageable.

I hadn't anticipated subsystems failing because they could not register
their sysctl tables.  I was simply expecting things not to show up in
/proc/sys.  And more of the pain of making working sysctl tables to 
be pushed back to developers.

Eric
