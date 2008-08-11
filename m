Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbYHKVTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbYHKVTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 17:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbYHKVTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 17:19:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753091AbYHKVTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 17:19:42 -0400
Date: Mon, 11 Aug 2008 14:18:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: dhowells@redhat.com, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] binfmt_elf_fdpic: Wire up AT_EXECFD, AT_EXECFN,
 AT_SECURE.
Message-Id: <20080811141855.a4ddf04d.akpm@linux-foundation.org>
In-Reply-To: <20080806103615.GC5194@linux-sh.org>
References: <20080806103458.GE2610@linux-sh.org>
	<20080806103615.GC5194@linux-sh.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008 19:36:15 +0900
Paul Mundt <lethal@linux-sh.org> wrote:

> These auxvec entries are the only ones left unhandled out of the current
> base implementation. This syncs up binfmt_elf_fdpic with linux/auxvec.h
> and current binfmt_elf.

The patches ran afoul of the credentials changes in linux-next.

#1 and #2 applied OK, but #3 tossed the below reject.  Please check
that my (fairly obvious) fixups are OK.

***************
*** 562,572 ****
  	}
  
  	/* force 16 byte _final_ alignment here for generality */
- #define DLINFO_ITEMS 13
  
  	nitems = 1 + DLINFO_ITEMS + (k_platform ? 1 : 0) + \
  		(k_base_platform ? 1 : 0) + AT_VECTOR_SIZE_ARCH;
  
  	csp = sp;
  	sp -= nitems * 2 * sizeof(unsigned long);
  	sp -= (bprm->envc + 1) * sizeof(char *);	/* envv[] */
--- 563,576 ----
  	}
  
  	/* force 16 byte _final_ alignment here for generality */
+ #define DLINFO_ITEMS 15
  
  	nitems = 1 + DLINFO_ITEMS + (k_platform ? 1 : 0) + \
  		(k_base_platform ? 1 : 0) + AT_VECTOR_SIZE_ARCH;
  
+ 	if (bprm->interp_flags & BINPRM_FLAGS_EXECFD)
+ 		nitems++;
+ 
  	csp = sp;
  	sp -= nitems * 2 * sizeof(unsigned long);
  	sp -= (bprm->envc + 1) * sizeof(char *);	/* envv[] */
***************
*** 618,623 ****
  	NEW_AUX_ENT(AT_EUID,	(elf_addr_t) current->euid);
  	NEW_AUX_ENT(AT_GID,	(elf_addr_t) current->gid);
  	NEW_AUX_ENT(AT_EGID,	(elf_addr_t) current->egid);
  
  #ifdef ARCH_DLINFO
  	nr = 0;
--- 628,635 ----
  	NEW_AUX_ENT(AT_EUID,	(elf_addr_t) current->euid);
  	NEW_AUX_ENT(AT_GID,	(elf_addr_t) current->gid);
  	NEW_AUX_ENT(AT_EGID,	(elf_addr_t) current->egid);
+ 	NEW_AUX_ENT(AT_SECURE,	security_bprm_secureexec(bprm));
+ 	NEW_AUX_ENT(AT_EXECFN,	bprm->exec);
  
  #ifdef ARCH_DLINFO
  	nr = 0;

