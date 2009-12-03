Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbZLCR7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbZLCR7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 12:59:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbZLCR7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 12:59:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311AbZLCR7E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 12:59:04 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <8bd0f97a0912021329y7be05434wc9c39d383bfb7ce4@mail.gmail.com>
References: <8bd0f97a0912021329y7be05434wc9c39d383bfb7ce4@mail.gmail.com> <1259421863-12777-1-git-send-email-vapier@gentoo.org> <7946.1259761452@redhat.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>,
       uClinux development list <uclinux-dev@uclinux.org>
Subject: Re: [uClinux-dev] Re: [PATCH] FDPIC: respect PT_GNU_STACK exec markings when creating NOMMU stack
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Date: Thu, 03 Dec 2009 17:58:04 +0000
Message-ID: <16680.1259863084@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier.adi@gmail.com> wrote:

> i have seen a few apps use brk()/sbrk() to query the size of things (like
> e2fsprogs)

We do actually record the size of the brk segment, so maybe we could icache
flush brk as it is increased (if it is increased):

	diff --git a/mm/nommu.c b/mm/nommu.c
	index 3754b16..2ea823d 100644
	--- a/mm/nommu.c
	+++ b/mm/nommu.c
	@@ -432,6 +432,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
		/*
		 * Ok, looks good - let it rip.
		 */
	+	flush_icache_range(mm->brk, brk);
		return mm->brk = brk;
	 }

It might also be worth making the availability of brk() a config option under
NOMMU.

> > Probably VM_DATA_DEFAULT_FLAGS should not include VM_EXEC for either
> > Blackfin or FRV, but it may be required for SH.  The if-statement that
> > calls elf_read_implies_exec() will be optimised away unless the arch
> > specifically sets it (which none of FRV, Blackfin or SH do).
> 
> while true, wont the later personality test (in VM_DATA_DEFAULT_FLAGS)
> be left there ?  guess it's not that big of a deal.

I think we could justify altering FRV and Blackfin to get rid of that test,
since we don't make use of read-implies-exec in those arches, but I think that
should be a separate patch.

David
