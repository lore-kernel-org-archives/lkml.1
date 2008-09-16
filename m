Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbYIPNbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbYIPNbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 09:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbYIPNba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 09:31:30 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:40058 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbYIPNb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 09:31:29 -0400
Date: Tue, 16 Sep 2008 16:31:12 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] linux/inotify.h: do not include <linux/fcntl.h> in
	userspace
Message-ID: <20080916133112.GB15951@cs181140183.pp.htv.fi>
References: <1221567763-17060-1-git-send-email-kirill@shutemov.name> <20080916125802.GA15951@cs181140183.pp.htv.fi> <20080916130234.GA17082@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080916130234.GA17082@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 04:02:36PM +0300, Kirill A. Shutemov wrote:
> On Tue, Sep 16, 2008 at 03:58:02PM +0300, Adrian Bunk wrote:
> > On Tue, Sep 16, 2008 at 03:22:43PM +0300, Kirill A. Shutemov wrote:
> > > <linux/fcntl.h> conflicts with glibc's <fcntl.h>.
> > > 
> > > It breaks building kdelibs, kdepim and pinot.
> > 
> > We should rather fix the actual bug.
> > 
> > What is the error message?
> 
> /usr/include/asm-generic/fcntl.h:117: error: redefinition of 'struct
> flock'
> /usr/include/bits/fcntl.h:142: error: previous definition of 'struct
> flock'
> /usr/include/asm-generic/fcntl.h:140: error: redefinition of 'struct
> flock64'
> /usr/include/bits/fcntl.h:157: error: previous definition of 'struct
> flock64'
>...

Kernel headers and glibc headers are an own story, Ulrich might know 
best about that.


But I'm wondering, why is kdelibs doing

<--  snip  -->

...
#include <fcntl.h>
#include <sys/syscall.h>
#include <linux/types.h>
// Linux kernel headers are documented to not compile
#define _S390_BITOPS_H
#include <linux/inotify.h>

static inline int inotify_init (void)
{
  return syscall (__NR_inotify_init);
}
...

<--  snip  -->


pinot even contains a file with the inotify syscall numbers for all 
architectures.


inotify_init(2) already documents the following usage:

<--   snip  -->

...
#include <sys/inotify.h>

int inotify_init(void);
...

<--  snip  -->


Unless someone knows a good reason against that (and no matter how the 
kernel situation will change) I'll send patches to get KDE fixed in this 
respect.


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

