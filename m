Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbYEGCcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbYEGCcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 22:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbYEGCcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 22:32:07 -0400
Received: from relay2.sgi.com ([192.48.171.30]:53194 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754898AbYEGCcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 22:32:06 -0400
Date: Tue, 6 May 2008 21:32:04 -0500
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: akpm@linux-foundation.org, lizf@cn.fujitsu.com,
       seto.hidetoshi@jp.fujitsu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix cpuset sched_relax_domain_level control file
Message-Id: <20080506213204.c54b328d.pj@sgi.com>
In-Reply-To: <6599ad830805061915s2525e48fw369e7c1aff167a76@mail.gmail.com>
References: <48210101.1070205@google.com>
	<20080506183841.e1771032.akpm@linux-foundation.org>
	<482109E5.5050204@cn.fujitsu.com>
	<20080506204946.7754302d.pj@sgi.com>
	<6599ad830805061851n767ff7a1qc8cb850ec98ad60d@mail.gmail.com>
	<20080506205852.8adaa0a2.pj@sgi.com>
	<20080506190809.df1b9398.akpm@linux-foundation.org>
	<20080506211121.e82bb51a.pj@sgi.com>
	<6599ad830805061915s2525e48fw369e7c1aff167a76@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> I'm building against 2.6.26-rc1, and don't see those warnings (or any
> useful code at those lines). It's probably more fallout from the
The following error that Andrew reports seems to be another
side affect of the "system" patch to cpusets.

Andrew wrote:
> cpuset files changes?

I see this error too:

  kernel/cpuset.c: In function 'cpuset_common_file_write':
  kernel/cpuset.c:1374: warning: passing argument 3 of 'update_flag' makes integer from pointer without a cast
  kernel/cpuset.c: In function 'cpuset_destroy':
  kernel/cpuset.c:1793: warning: passing argument 3 of 'update_flag' makes integer from pointer without a cast

I am building with:

Andrew's latest (last couple hours) mmotm, applied on top of
v2.6.26-rc1, with -just- the first two mmotm patches applied to
v2.6.26-rc1, plus your patch:

  origin.patch -- from mmotm
  linux-next.patch -- from mmotm
  Your recent "Fix cpuset sched_relax_domain_level control file" patch

The warning comes from the type inconsistence between the following
lines of kernel/cpuset.c code.  The definition of update_flag() is
expecting an "int turning_on" third argument.  The borked "system"
patch (on my wish I could kill it list) is providing a "char *"
argument.

static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
                       int turning_on)

...

static ssize_t cpuset_common_file_write(struct cgroup *cont,
                                        struct cftype *cft,
                                        struct file *file,
                                        const char __user *userbuf,
                                        size_t nbytes, loff_t *unused_ppos)
{
        struct cpuset *cs = cgroup_cs(cont);
        cpuset_filetype_t type = cft->private;
        char *buffer;
        int retval = 0;

...

        case FILE_SYSTEM:
                retval = update_flag(CS_SYSTEM, cs, buffer);

...

        if (!is_system(cs))
                update_flag(CS_SYSTEM, cs, "1");


-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
