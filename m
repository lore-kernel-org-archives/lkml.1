Return-Path: <linux-kernel-owner+w=401wt.eu-S932864AbZLESM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864AbZLESM4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 13:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757870AbZLESMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 13:12:54 -0500
Received: from cobra.newdream.net ([66.33.216.30]:43564 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802AbZLESMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 13:12:54 -0500
Date: Sat, 5 Dec 2009 10:13:00 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: Ingo Oeser <ioe-lkml@rameria.de>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 05/24] ceph: ref counted buffer
In-Reply-To: <200912050231.23530.ioe-lkml@rameria.de>
Message-ID: <Pine.LNX.4.64.0912051010450.15568@cobra.newdream.net>
References: <1259883691-1042-1-git-send-email-sage@newdream.net>
 <1259883691-1042-5-git-send-email-sage@newdream.net>
 <1259883691-1042-6-git-send-email-sage@newdream.net> <200912050231.23530.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Dec 2009, Ingo Oeser wrote:

> On Friday 04 December 2009, Sage Weil wrote:
> > struct ceph_buffer is a simple ref-counted buffer.  We transparently
> > choose between kmalloc for small buffers and vmalloc for large ones.
> > 
> > This is currently used only for allocating memory for xattr data.
> 
> Could you wrap parts of this refcounting logic around kref?
> see #include <linux/kref.h> and lib/kref.c
> 
> It avoids a bug with memory areas for free and if anybody
> optimizes or changes refcounting stuff, you get all changes for free :-)

The only real difference it looks like are

	smp_mb();

in get() and

	smp_mb__after_atomic_inc();

in put.  Is that needed for all other atomic_t refcounting too?

Switched to kref, and cleaned up the (partially unused) interface.

 fs/ceph/buffer.c    |   37 ++++++++++++++++++++++++++++++++-----
 fs/ceph/buffer.h    |   30 ++++++------------------------
 fs/ceph/inode.c     |   11 +++++++----
 fs/ceph/messenger.c |    2 +-
 fs/ceph/xattr.c     |    8 +++++---
 5 files changed, 51 insertions(+), 37 deletions(-)

sage
