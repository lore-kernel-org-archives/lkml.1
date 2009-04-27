Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbZD0L5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbZD0L5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 07:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbZD0L5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 07:57:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60755 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbZD0L5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 07:57:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH 29/30] microblaze_mmu_v1: stat.h MMU update
Date: Mon, 27 Apr 2009 13:57:00 +0200
User-Agent: KMail/1.9.9
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       john.williams@petalogix.com
References: <1240821139-7247-23-git-send-email-monstr@monstr.eu> <20090427113030.GA3681@infradead.org> <49F59A6E.9080900@monstr.eu>
In-Reply-To: <49F59A6E.9080900@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904271357.01681.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+zDOqVCGhUEYRHWx4Ewyw1sOQlzKMWTfeIlUT
 Hj9L2koqFxgoHbXW/OpK6BTOf3kQqMgQ62htfNDPZ658D8/LRV
 dPDRvaWgUrNr3xqodq5PQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 April 2009, Michal Simek wrote:
> Christoph Hellwig wrote:

> > Given that microblaze only got merged in the 2.6.30 window I would
> > suggest fixing up the nommu variant.
> 
> ok. Let's do it.
> Here are stats structures from xtensa.
> 
> Arnd: Is it ok for asm-generic?

I carry a (not cleaned up) tree with changes in my playground
(git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git)
as branch generic-microblaze, where I try to use generic
headers for everything. See below for my version of stat.h.
In particular, it uses 64 bit st_size and st_blocks, but 32 bit
time fields. It also defines struct stat to be identical to
struct stat64 on 64 bit systems. 32 bit systems should only
provide the stat64 syscalls, so the shorter types in struct
stat do not hurt.

	Arnd <><

---
#ifndef __ASM_GENERIC_STAT_H
#define __ASM_GENERIC_STAT_H

/*
 * Everybody gets this wrong and has to stick with it for all
 * eternity. Hopefully, this version gets used by new architectures
 * so they don't fall into the same traps.
 *
 * stat64 is copied from powerpc64, with explicit padding added.
 * stat is the same structure layout on 64-bit, without the 'long long'
 * types.
 *
 * By convention, 64 bit architectures use the stat interface, while
 * 32 bit architectures use the stat64 interface. Note that we don't
 * provide an __old_kernel_stat here, which new architecture should
 * not have to start with.
 */

#include <asm/bitsperlong.h>

#define STAT_HAVE_NSEC 1

struct stat {
	unsigned long	st_dev;		/* Device.  */
	unsigned long	st_ino;		/* File serial number.  */
	unsigned int	st_mode;	/* File mode.  */
	unsigned int	st_nlink;	/* Link count.  */
	unsigned int	st_uid;		/* User ID of the file's owner.  */
	unsigned int	st_gid;		/* Group ID of the file's group. */
	unsigned long	st_rdev;	/* Device number, if device.  */
	unsigned long	__pad1;
	long		st_size;	/* Size of file, in bytes.  */
	int		st_blksize;	/* Optimal block size for I/O.  */
	int		__pad2;
	long		st_blocks;	/* Number 512-byte blocks allocated. */
	int		st_atime;	/* Time of last access.  */
	unsigned int	st_atime_nsec;
	int		st_mtime;	/* Time of last modification.  */
	unsigned int	st_mtime_nsec;
	int		st_ctime;	/* Time of last status change.  */
	unsigned int	st_ctime_nsec;
	unsigned int	__unused4;
	unsigned int	__unused5;
};

#if __BITS_PER_LONG != 64
/* This matches struct stat64 in glibc2.1. Only used for 32 bit. */
struct stat64 {
	unsigned long long st_dev;	/* Device.  */
	unsigned long long st_ino;	/* File serial number.  */
	unsigned int	st_mode;	/* File mode.  */
	unsigned int	st_nlink;	/* Link count.  */
	unsigned int	st_uid;		/* User ID of the file's owner.  */
	unsigned int	st_gid;		/* Group ID of the file's group. */
	unsigned long long st_rdev;	/* Device number, if device.  */
	unsigned long long __pad1;
	long long	st_size;	/* Size of file, in bytes.  */
	int		st_blksize;	/* Optimal block size for I/O.  */
	int		__pad2;
	long long	st_blocks;	/* Number 512-byte blocks allocated. */
	int		st_atime;	/* Time of last access.  */
	unsigned int	st_atime_nsec;
	int		st_mtime;	/* Time of last modification.  */
	unsigned int	st_mtime_nsec;
	int		st_ctime;	/* Time of last status change.  */
	unsigned int	st_ctime_nsec;
	unsigned int	__unused4;
	unsigned int	__unused5;
};
#endif

#endif /* __ASM_GENERIC_STAT_H */
