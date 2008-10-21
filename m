Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbYJUPqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbYJUPqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 11:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYJUPqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 11:46:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58161 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751704AbYJUPqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 11:46:12 -0400
Date: Tue, 21 Oct 2008 16:46:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: hooanon05@yahoo.co.jp
Cc: linux-kernel@vger.kernel.org
Subject: Re: __vm_enough_memory(), OVERCOMMIT_NEVER, current->mm, kernel
 thread
Message-ID: <20081021164619.341f01d9@lxorguk.ukuu.org.uk>
In-Reply-To: <7123.1224602071@jrobl>
References: <7123.1224602071@jrobl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In this case, NFSD (kernel thread) calls shmem_file_write() or
> shmem_write_begin() and __vm_enough_memory() is called. But current->mm
> is NULL and the kernel crashes.
> If a user have to set OVERCOMMIT_NEVER, where should we fix?

Calling into the file system code assuming that current->mm is
NULL isn't safe and hasn't been for a very long time since someone added
the 3% hack.

The shmem case is actually a bit special so my thoughts are:

Make security_vm_enough_memory() WARN() if current->mm = NULL
Make security_vm_enough_memory_mm() WARN() if the passed mm = NULL
Add security_vm_enough_memory_fs() which does not do the warning test

All would still call security->ops->vm_enough_memory and then
__vm_enough_memory() would skip the 3% adjustment when the passed mm was
NULL

Does that sound sensible ?

Alan
