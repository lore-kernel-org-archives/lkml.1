Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbXJLTEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbXJLTEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 15:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbXJLTEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 15:04:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37601 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbXJLTEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 15:04:38 -0400
Date: Fri, 12 Oct 2007 20:04:26 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       netdev@vger.kernel.org
Subject: Re: 2.6.23-mm1
Message-ID: <20071012190426.GB8181@ftp.linux.org.uk>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <20071012140328.f82af8e8.kamezawa.hiroyu@jp.fujitsu.com> <20071011234202.2f15bb76.akpm@linux-foundation.org> <20071012064658.GA8181@ftp.linux.org.uk> <20071012001325.ba02a6f0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012001325.ba02a6f0.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 12:13:25AM -0700, Andrew Morton wrote:
> I always forget to test uml.  But a quick test build seems to work until
> it hits this:
> 
> arch/um/drivers/slip_kern.c: In function 'slip_init':
> arch/um/drivers/slip_kern.c:34: error: 'struct net_device' has no member named 'header_cache_update'
> arch/um/drivers/slip_kern.c:35: error: 'struct net_device' has no member named 'hard_header_cache'
> arch/um/drivers/slip_kern.c:36: error: 'struct net_device' has no member named 'hard_header'

Umm...  Dies much faster here:
include/asm-um/arch:
        @echo '  SYMLINK $@'
ifneq ($(KBUILD_SRC),)
        $(Q)mkdir -p $(objtree)/include/asm-um
        $(Q)ln -fsn $(srctree)/include/asm-$(SUBARCH) include/asm-um/arch
else
        $(Q)cd $(TOPDIR)/include/asm-um && ln -sf ../asm-$(SUBARCH) arch
endif
gives a symlink from include/asm-um/arch to include/asm-i386 or
include/asm-x86_64, so e.g.
#ifndef __UM_POSIX_TYPES_H
#define __UM_POSIX_TYPES_H

#include "asm/arch/posix_types.h"

#endif
in asm-um/posix_types.h blows instantly.  Try to build on a tree without
stale symlinks...
