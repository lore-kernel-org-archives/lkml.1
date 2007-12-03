Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbXLCI6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbXLCI6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 03:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbXLCI6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 03:58:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbXLCI63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 03:58:29 -0500
Date: Mon, 3 Dec 2007 03:58:17 -0500
From: Jakub Jelinek <jakub@redhat.com>
To: Thomas Gleixner <tglx@www.tglx.de>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Fedora's latest gcc produces unbootable kernels
Message-ID: <20071203085817.GQ16835@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20071201154223.1b052d39@poseidon.drzeus.cx> <20071201184752.33536d09@poseidon.drzeus.cx> <20071201212054.2377c8be@poseidon.drzeus.cx> <23803.203.197.163.97.1196669842.squirrel@www.tglx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23803.203.197.163.97.1196669842.squirrel@www.tglx.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 09:17:22AM +0100, Thomas Gleixner wrote:
> I looked at the disassembly but I can not spot the problem.
> 
> I think the real problem is somewhere else. Likely candidates are
> hrtimer_forward() or hrtimer_start() - in that order.

Should be hopefully fixed in latest Fedora gcc.  The problem was in code like
typedef union { long long int s; } U;
typedef struct { U u; } S;

void foo (S *s, long long int x, unsigned long int y)
{
  s->u = ({ (U) { .s = s->u.s + x * y }; });
}

where a backport of a recent optimization of mine, without which gcc handles
terribly initializers from compound literals (which is something hrtimer
uses just everywhere - why can't ktime.h for #if BITS_PER_LONG == 64 || defined(CONFIG_KTIME_SCALAR)
just use a scalar rather than union with a scalar in it??), sets the LHS
object to the compound literal's initializer rather than forcing creation of
a temporary object (the compound literal).  Unfortunately the gimplifier
had some bugs in case the initializer references (or at least might
reference) parts of LHS object.  Fixed by backporting 2 Ada bugfixes for the
gimplifier from GCC trunk (Ada was hitting those bugs even without this
compound literal optimization).

	Jakub
