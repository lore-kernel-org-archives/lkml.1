Return-Path: <linux-kernel-owner+w=401wt.eu-S1759323AbYFLKVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbYFLKVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 06:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895AbYFLKVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 06:21:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756685AbYFLKVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 06:21:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <27332.1213264136@redhat.com>
References: <27332.1213264136@redhat.com> <20080612072955.GA8097@linux-sh.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Bryan Wu <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nommu: Correct kobjsize() page validity checks.
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 12 Jun 2008 11:20:53 +0100
Message-ID: <2336.1213266053@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Works for me.

Having said that, it doesn't produce the right answers under SLOB, with or
without this patch:

	void task_mem(struct seq_file *m, struct mm_struct *mm)
	{
		struct vm_list_struct *vml;
		unsigned long bytes = 0, sbytes = 0, slack = 0;

		down_read(&mm->mmap_sem);
		for (vml = mm->context.vmlist; vml; vml = vml->next) {
			if (!vml->vma)
				continue;

			bytes += kobjsize(vml);

Here kobjsize() returns 16384 (PAGE_SIZE) when it should return something a
lot smaller.  This appears related to SLOB not setting PG_slab, so
/proc/pic/status gets messed up:

	Mem:      983040 bytes
	Slack:     44112 bytes
	Shared:  1687552 bytes

SLAB returns 64 at this point, and in /proc/pid/status shows:

	Mem:      594016 bytes
	Slack:     44112 bytes
	Shared:  1638688 bytes

with or without the patch, which might even be correct.


Maybe on SLOB we want kobjsize() to become sizeof() where we're dealing with
fixed size units such as structs.  On the other hand, getting rid of
kobjsize() entirely would be good.

David
