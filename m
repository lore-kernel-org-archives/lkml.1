Return-Path: <linux-kernel-owner+w=401wt.eu-S1763209AbXGJJsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763209AbXGJJsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761216AbXGJJrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:47:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758242AbXGJJrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:47:45 -0400
Date: Tue, 10 Jul 2007 05:47:30 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>
Cc: Rik van Riel <riel@redhat.com>, Chuck Ebbert <cebbert@redhat.com>,
       Jan Kratochvil <honza@jikos.cz>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Ernie Petrides <petrides@redhat.com>
Subject: Re: [PATCH][RESEND] PIE randomization
Message-ID: <20070710094730.GH7012@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20070522161642.b71ddacb.akpm@linux-foundation.org> <Pine.LNX.4.64.0705231044540.22906@jikos.suse.cz> <20070704082554.GQ7012@devserv.devel.redhat.com> <Pine.LNX.4.64.0707041927090.11634@jikos.suse.cz> <468D5A3A.1010306@redhat.com> <468D5B28.8080308@redhat.com> <Pine.LNX.4.64.0707070205460.11634@jikos.suse.cz> <20070707123004.GZ7012@devserv.devel.redhat.com> <Pine.LNX.4.64.0707091333230.11634@jikos.suse.cz> <Pine.LNX.4.64.0707092356450.11634@jikos.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707092356450.11634@jikos.suse.cz>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 11:58:07PM +0200, Jiri Kosina wrote:
> On Mon, 9 Jul 2007, Jiri Kosina wrote:
> > [ ... ]
> > > -			if (!BAD_ADDR(elf_entry)) {
> > > +			if (!IS_ERR((void *)elf_entry)) {
> > I agree that this is better solution. Andrew, this Jakub's patch should 
> > replace the pie-randomization-fix-bad_addr-macro.patch if possible. You 
> > can add 
> 
> as this raced :) with Andrew who already folded the 
> pie-randomization-fix-bad_addr-macro.patch into pie-randomization.patch, 
> do you think you could rebase this change against the current state of -mm 
> and resend it? Thanks,

Here it is:

Restore BAD_ADDR check strictness, use IS_ERR in the only place where
the stricter BAD_ADDR can't work, as the value is a load bias rather
than userland address.

Signed-off-by: Jakub Jelinek <jakub@redhat.com>

--- linux/fs/binfmt_elf.c	2007-07-10 11:39:29.000000000 +0200
+++ linux/fs/binfmt_elf.c	2007-07-10 11:41:03.000000000 +0200
@@ -80,7 +80,7 @@ static struct linux_binfmt elf_format = 
 		.hasvdso	= 1
 };
 
-#define BAD_ADDR(x) IS_ERR_VALUE(x)
+#define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
 
 static int set_brk(unsigned long start, unsigned long end)
 {
@@ -1005,7 +1005,7 @@ static int load_elf_binary(struct linux_
 						    interpreter,
 						    &interp_map_addr,
 						    load_bias);
-			if (!BAD_ADDR(elf_entry)) {
+			if (!IS_ERR((void *)elf_entry)) {
 				/*
 				 * load_elf_interp() returns relocation
 				 * adjustment


	Jakub
