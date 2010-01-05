Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445Ab0AECpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab0AECpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 21:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165Ab0AECpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 21:45:39 -0500
Received: from mga14.intel.com ([143.182.124.37]:9650 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054Ab0AECpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 21:45:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="229202080"
Date: Tue, 5 Jan 2010 10:45:33 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Quentin Barnes <qbarnes+nfs@yahoo-inc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Jonathan Corbet <corbet@lwn.net>, Eric Paris <eparis@redhat.com>
Subject: Re: [RFC][PATCH v4] readahead: introduce O_RANDOM for
	POSIX_FADV_RANDOM
Message-ID: <20100105024533.GA30714@localhost>
References: <20091230051540.GA16308@localhost> <20091230052402.GB26364@localhost> <873a2s8hmp.fsf@basil.nowhere.org> <20100104045020.GA21021@localhost> <20100104161719.a0bb35ad.sfr@canb.auug.org.au> <20100104073328.GA3422@infradead.org> <20100104125620.GB12266@localhost> <20100105130322.006c03ee.sfr@canb.auug.org.au> <20100105022650.GB29428@localhost> <20100105132824.e6c0fb7f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105132824.e6c0fb7f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 10:28:24AM +0800, Stephen Rothwell wrote:
> Hi Fengguang,
> 
> On Tue, 5 Jan 2010 10:26:50 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> >
> > Where is it? I cannot grep find one in arch/.
> > There is one defined in include/asm-generic/fcntl.h:
> > 
> > #ifndef O_SYNC
> > #define __O_SYNC        04000000
> > #define O_SYNC          (__O_SYNC|O_DSYNC)
> > #endif
> > 
> > However it has one less '0' :)
> 
> Search for 0x800000 ...

Thanks, I got it..

Does that mean __O_SYNC would be _accidentally_ masked out in
__dentry_open() by the newly introduced fanotify bit?

        f->f_flags = (flags & ~(FMODE_EXEC | FMODE_NONOTIFY));

The above line is added in commit f67cee7b50b004357be383,
and can be fixed by the below patch.

Eric, what do you think?

Thanks,
Fengguang
---

 include/asm-generic/fcntl.h |    2 +-
 include/linux/fs.h          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux.orig/include/asm-generic/fcntl.h	2010-01-05 10:42:36.000000000 +0800
+++ linux/include/asm-generic/fcntl.h	2010-01-05 10:42:57.000000000 +0800
@@ -5,7 +5,7 @@
 
 /*
  * FMODE_EXEC is 0x20
- * FMODE_NONOTIFY is 0x800000
+ * FMODE_NONOTIFY is 0x1000000
  * These cannot be used by userspace O_* until internal and external open
  * flags are split.
  * -Eric Paris
--- linux.orig/include/linux/fs.h	2010-01-05 10:40:33.000000000 +0800
+++ linux/include/linux/fs.h	2010-01-05 10:42:07.000000000 +0800
@@ -88,7 +88,7 @@ struct inodes_stat_t {
 #define FMODE_NOCMTIME		((__force fmode_t)2048)
 
 /* File was opened by fanotify and shouldn't generate fanotify events */
-#define FMODE_NONOTIFY		((__force fmode_t)8388608)
+#define FMODE_NONOTIFY		((__force fmode_t)0x1000000)
 
 /*
  * The below are the various read and write types that we support. Some of
