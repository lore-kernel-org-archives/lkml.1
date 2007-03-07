Return-Path: <linux-kernel-owner+w=401wt.eu-S965051AbXCGLK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965051AbXCGLK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 06:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965057AbXCGLK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 06:10:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965051AbXCGLKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 06:10:55 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070307034216.472921801C4@magilla.sf.frob.com> 
References: <20070307034216.472921801C4@magilla.sf.frob.com> 
To: Roland McGrath <roland@redhat.com>
Cc: bryan.wu@analog.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] utrace: nommu fixup support utrace 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 07 Mar 2007 11:10:37 +0000
Message-ID: <7689.1173265837@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath <roland@redhat.com> wrote:

> That old ptrace check seems pretty questionable to me.  I think what you
> want is for the nommu world's get_user_pages/access_process_vm when called
> with force=1,write=1 on a read-only MAP_PRIVATE page to do something more
> morally similar to the mmu world's COW than it does now.

Such as what?  You *can't* do COW without relocating all the pointers userspace
may have into that VMA.  However, unless you force non-sharing of R/O
MAP_PRIVATE VMAs, you will have text segments of executables and libraries
shared with other processes.  Imagine: you set a breakpoint in uclibc read()
and your whole system dies instantly.

What I did is to say that if a process has PT_TRACED set then the MAP_PRIVATE
VMAs start with their own copies.  The debugger can set this in a new process
by cloning it with appropriate CLONE_xxx flags.

It's not perfect, I know, but it's the best I could come up with as a solution
to debugging things in a NOMMU environment that supports shared libraries and
executables.

David
