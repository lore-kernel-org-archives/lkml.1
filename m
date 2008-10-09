Return-Path: <linux-kernel-owner+w=401wt.eu-S1757421AbYJIV74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbYJIV74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 17:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756162AbYJIV7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 17:59:48 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:51475 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950AbYJIV7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 17:59:47 -0400
Subject: Re: [RFC v6][PATCH 0/9] Kernel based checkpoint/restart
From: Greg Kurz <gkurz@fr.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, jeremy@goop.org, arnd@arndb.de,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20081009131701.GA21112@elte.hu>
References: <1223461197-11513-1-git-send-email-orenl@cs.columbia.edu>
	 <20081009124658.GE2952@elte.hu> <1223557122.11830.14.camel@nimitz>
	 <20081009131701.GA21112@elte.hu>
Content-Type: text/plain
Date: Thu, 09 Oct 2008 23:59:33 +0200
Message-Id: <1223589573.6117.66.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-09 at 15:17 +0200, Ingo Molnar wrote:
> yeah, something like that. A key aspect of it is that is has to be very 
> low-key on the source code level - we dont want to sprinkle the kernel 
> with anything ugly. Perhaps something pretty explicit:
> 
>   current->flags |= PF_NOCR;
> 
> as we do the same thing today for certain facilities:
> 
>   current->flags |= PF_NOFREEZE;
> 
> you probably want to hide it behind:
> 
>   set_current_nocr();
> 

Being uncheckpointable is a transient and hopefully reversible state.
A set_current_cr() function is also needed and should be called at some
time to avoid abusive denials of checkpoint (DoC ?).

With the sys_remap_file_pages() example, set_current_cr() should be
called somewhere in sys_munmap() or even sys_remap_file_pages(). Some
code should be added to detect the mapping that lead the nocr state is
removed (a flag on the affected vma?) or fixed (checking the linearity
of mapping?). Would this code be low-key enough ?

> and have a set_task_nocr() as well, in case there's some proxy state 
> installed by another task.
> 
> Via such wrappers there's no overhead at all in the 
> !CONFIG_CHECKPOINT_RESTART case.
> 
> Plus you could drive the debug mechanism via it as well, by using a 
> trivial extension of the facility:
> 
>   set_current_nocr("CR: sys_remap_file_pages not supported yet.");
>   ...
>   set_task_nocr(t, "CR: PI futexes not supported yet.");
> 
> 	Ingo
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
-- 
Gregory Kurz                                     gkurz@fr.ibm.com
Software Engineer @ IBM/Meiosys                  http://www.ibm.com
Tel +33 (0)534 638 479                           Fax +33 (0)561 400 420

"Anarchy is about taking complete responsibility for yourself."
        Alan Moore.

