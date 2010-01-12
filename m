Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959Ab0AMAfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab0AMAfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 19:35:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604Ab0AMAfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 19:35:01 -0500
Received: from UNIX37.ANDREW.CMU.EDU ([128.2.13.167]:54582 "EHLO
	unix37.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0AMAfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 19:35:00 -0500
X-Greylist: delayed 3553 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jan 2010 19:35:00 EST
Date: Tue, 12 Jan 2010 18:34:53 -0500
From: Ben Blum <bblum@andrew.cmu.edu>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, axboe@kernel.dk, ryov@valinux.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       bblum@andrew.cmu.edu
Subject: Re: [RFC] [PATCH 2/2] cgroups: blkio subsystem as module
Message-ID: <20100112233453.GB5098@unix37.andrew.cmu.edu>
References: <20091231051050.GA714@andrew.cmu.edu>
 <20100106160414.bd555474.akpm@linux-foundation.org>
 <20100107012606.GA25577@andrew.cmu.edu>
 <20100107120732.97d502bd.kamezawa.hiroyu@jp.fujitsu.com>
 <4B45824B.9030108@cn.fujitsu.com>
 <20100108163352.GB22219@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100108163352.GB22219@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 11:33:52AM -0500, Vivek Goyal wrote:
> On Fri, Jan 08, 2010 at 12:30:21AM -0500, Ben Blum wrote:
> > Convert blk-cgroup to be buildable as a module
> > 
> > From: Ben Blum <bblum@andrew.cmu.edu>
> > 
> > This patch modifies the Block I/O cgroup subsystem to be able to be built as a
> > module. As the CFQ disk scheduler optionally depends on blk-cgroup, config
> > options in block/Kconfig, block/Kconfig.iosched, and block/blk-cgroup.h are
> > enhanced to support the new module dependency.
> > 
> > Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
> 
> Two quick observations with testing.
> 
> You need to EXPORT cgroup_path.
> 
> Second, after loading the module, I mounted the blkio controller. But creating
> a cgroup directory crashed.
> 
> Vivek

argh, good catches on both of them. didn't test with DEBUG_CFQ_IOSCHED
(for cgroup_path) or with making a sub-cgroup (for the crash); shame on
me. turns out it crashed because I had init_idr before init_css_set, and
init_css_set sets css->id = NULL explicitly. fixed patches forthcoming.

-- bblum

---
 block/Kconfig             |    2 -
 block/Kconfig.iosched     |    2 -
 block/blk-cgroup.c        |   53 +++++++++++++++++++++++++++++++++++-----------
 block/blk-cgroup.h        |   10 ++++++--
 include/linux/iocontext.h |    2 -
 kernel/cgroup.c           |   34 ++++++++++++++++++++++++-----
 6 files changed, 80 insertions(+), 23 deletions(-)
