Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbYJPTuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbYJPTuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbYJPTtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:49:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41973
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753799AbYJPTtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:49:47 -0400
Date: Thu, 16 Oct 2008 12:49:23 -0700 (PDT)
Message-Id: <20081016.124923.222595655.davem@davemloft.net>
To: johannes@sipsolutions.net
Cc: akpm@linux-foundation.org, dan.j.williams@intel.com, tiwai@suse.de,
       linux-ext4@vger.kernel.org, netdev@vger.kernel.org,
       linux-ide@vger.kernel.org, bzolnier@gmail.com, marek.vasut@gmail.com,
       dwmw2@infradead.org, mark.fasheh@oracle.com, ralf@linux-mips.org,
       mchehab@infradead.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       arjan@infradead.org
Subject: Re: powerpc allmodconfig
From: David Miller <davem@davemloft.net>
In-Reply-To: <1224169039.735.57.camel@johannes.berg>
References: <20081015213337.a99a9595.akpm@linux-foundation.org>
	<20081015.220247.262683261.davem@davemloft.net>
	<1224169039.735.57.camel@johannes.berg>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 16 Oct 2008 16:57:19 +0200

> On Wed, 2008-10-15 at 22:02 -0700, David Miller wrote:
> > 
> > 
> > > net/sched/sch_generic.c: In function 'dev_watchdog':
> > > net/sched/sch_generic.c:224: warning: unused variable 'drivername'
> > 
> > Sucky, if WARN_ONCE() evaluates to nothing the sprintf() string buffer
> > on the stack looks unused.
> 
> I've complained about this to Arjan before, we actually lose all
> messages passed to WARN() or WARN_ONCE() on platforms that use bug traps
> for warnings too.

Ok I see how that works, yes, it should be fixed.

If the platform defines a __WARN (which powerpc does) the
whole format string and printf args go unevaluated, it's
because of the following sequence in asm-generic/bug.h:

#ifndef __WARN
#ifndef __ASSEMBLY__
extern void warn_on_slowpath(const char *file, const int line);
extern void warn_slowpath(const char *file, const int line,
		const char *fmt, ...) __attribute__((format(printf, 3, 4)));
#define WANT_WARN_ON_SLOWPATH
#endif
#define __WARN() warn_on_slowpath(__FILE__, __LINE__)
#define __WARN_printf(arg...) warn_slowpath(__FILE__, __LINE__, arg)
#else
#define __WARN_printf(arg...) __WARN()
#endif
