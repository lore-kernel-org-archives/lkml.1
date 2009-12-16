Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473AbZLPIyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbZLPIyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZLPIyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:54:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbZLPIyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:54:51 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1260921350-6539-1-git-send-email-vapier@gentoo.org>
References: <1260921350-6539-1-git-send-email-vapier@gentoo.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: dhowells@redhat.com, uclinux-dev@uclinux.org,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NOMMU: add [stack] label to per-process maps output
Date: Wed, 16 Dec 2009 08:54:22 +0000
Message-ID: <22709.1260953662@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier@gentoo.org> wrote:

> it'd be cool if the global /proc/maps could display something like
> [stack/<pid>], but i can't quite divine how to get a mm_struct out
> of a vm_region without having to walk the entire process list.

Tricky.  vm_regions can be shared between multiple mm_structs, although in the
case of the stack, they're probably not.  Furthermore, there's no interface to
mmap() to say the region you're allocating belongs to a particular PID (and
with userspace created threads, you have to create the stack _before_ calling
clone()).

That said, you could add a 'creator pid' to the vm_region.  This could be set
firstly by mmap() to current->pid, and then overridden by clone() for the
stack VMA.  It would be approximate, but probably a good approximation.  You
probably don't actually need a back pointer, just an integer PID.

David
