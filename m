Return-Path: <linux-kernel-owner+w=401wt.eu-S1761208AbZBMHSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761208AbZBMHSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 02:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbZBMHS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 02:18:27 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43138 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbZBMHS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 02:18:26 -0500
Date: Fri, 13 Feb 2009 07:18:16 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: containers@lists.osdl.org, Paul Menage <menage@google.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [cgroup or VFS ?] WARNING: at fs/namespace.c:636
	mntput_no_expire+0xac/0xf2()
Message-ID: <20090213071816.GK28946@ZenIV.linux.org.uk>
References: <499013CC.2060808@cn.fujitsu.com> <4993BD5D.2020707@cn.fujitsu.com> <20090212062442.GE28946@ZenIV.linux.org.uk> <4993C2A0.3050507@cn.fujitsu.com> <4993C7C2.4060100@cn.fujitsu.com> <20090212070729.GF28946@ZenIV.linux.org.uk> <4995007D.7040101@cn.fujitsu.com> <20090213054751.GI28946@ZenIV.linux.org.uk> <49950F3D.3030704@cn.fujitsu.com> <20090213064135.GJ28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213064135.GJ28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 06:41:35AM +0000, Al Viro wrote:

Aaaargh...

        /*
         * We don't have to hold all of the locks at the
         * same time here because we know that we're the
         * last reference to mnt and that no new writers
         * can come in.
         */
        for_each_possible_cpu(cpu) {
                struct mnt_writer *cpu_writer = &per_cpu(mnt_writers, cpu);
                if (cpu_writer->mnt != mnt)
                        continue;
                spin_lock(&cpu_writer->lock);

is *almost* OK.  Modulo SMP cache coherency.  We know that nothing should
be setting ->mnt to ours anymore, that's fine.  But we do not know if
we'd seen *earlier* change done on CPU in question (not the one we
are running __mntput() on).

I probably would still like to use milder solution in the long run, but for
now let's check if turning that into

                struct mnt_writer *cpu_writer = &per_cpu(mnt_writers, cpu);
                spin_lock(&cpu_writer->lock);
                if (cpu_writer->mnt != mnt) {
			spin_unlock(&cpu_writer->lock);
                        continue;
		}
prevents the problem, OK?
