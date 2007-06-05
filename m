Return-Path: <linux-kernel-owner+w=401wt.eu-S1759396AbXFELsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396AbXFELsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 07:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbXFELsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 07:48:30 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:44321 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbXFELs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 07:48:29 -0400
Date: Tue, 5 Jun 2007 13:48:13 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: volatile and atomic_t/spinlock_t
Message-ID: <20070605114813.GA17048@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm just wondering why we have an inconsistency between several archs when
it comes to the definitions of atomic_t, atomic64_t, spinlock_t and their
accessors. Currently we have on most architectures something like

typedef struct { volatile int counter; } atomic_t;

except for i386/x86_64 which has

typedef struct { int counter; } atomic_t;

but then again we have (including x86_64)

typedef struct { volatile long counter; } atomic64_t;

In addition we have

#define atomic_read(v)		((v)->counter)
#define atomic64_read(v)	((v)->counter)

So something like

(1)	while (atomic_read(&v));

May or may not work. Yes, I know it should be

(2)	while (atomic_read(&v))
		cpu_relax();

I'm just wondering about the inconsistency between 32 and 64 bit here and if
(1) is supposed to work or not.

When it comes to spinlock_t we have (on i386):

typedef struct {
	unsigned int slock;
} raw_spinlock_t;

and

static inline int __raw_spin_is_locked(raw_spinlock_t *x)
{
	return *(volatile signed char *)(&(x)->slock) <= 0;
}

Most other architectures have something like this

typedef struct {
	volatile unsigned int slock;
} raw_spinlock_t;

and

#define __raw_spin_is_locked(x)	((x)->slock != 0)

So is

	while (__raw_spin_is_locked(&v));

supposed to work? Or should that be 

	while (__raw_spin_is_locked(&v))
		cpu_relax();

as well and all the volatiles can/should go away?
