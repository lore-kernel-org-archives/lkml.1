Return-Path: <linux-kernel-owner+w=401wt.eu-S1751690AbXDMGCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbXDMGCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 02:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbXDMGCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 02:02:09 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:35844 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbXDMGCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 02:02:08 -0400
Message-ID: <461F1C8E.1010104@cosmosbay.com>
Date: Fri, 13 Apr 2007 08:00:46 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@muc.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Hugh Dickins <hugh@veritas.com>,
       David Rientjes <rientjes@google.com>,
       Michel Lespinasse <walken@vmware.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] i386 - pte update optimizations
References: <200704120530.l3C5UGbv022814@zach-dev.vmware.com> <461EDBF1.4080904@zytor.com> <461EE9E5.6060403@vmware.com>
In-Reply-To: <461EE9E5.6060403@vmware.com>
Content-Type: multipart/mixed;
 boundary="------------070104060507040302030402"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Fri, 13 Apr 2007 08:00:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070104060507040302030402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Zachary Amsden a écrit :
> 
> Yes.  Even then, last time I clocked instructions, xchg was still slower 
> than read / write, although I could be misremembering.  And it's not 
> totally clear that they will always be in cached state, however, and for 
> SMP, we still want to drop the implicit lock in cases where the 
> processor might not know they are cached exclusive, but we know there 
> are no other racing users.  And there are plenty of old processors out 
> there to still make it worthwhile.
> 

Is there one processor that benefit from this patch then ?

I couldnt get a win on my test machines, maybe they are not old enough ;)

umask() doesnt need xchg() atomic semantic. If several threads are using 
umask() concurrently results are not guaranted anyway.

--------------070104060507040302030402
Content-Type: text/plain;
 name="umask.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="umask.patch"

--- linux-2.6.21-rc6/kernel/sys.c
+++ linux-2.6.21-rc6-ed/kernel/sys.c
@@ -2138,8 +2138,10 @@ asmlinkage long sys_getrusage(int who, s
 
 asmlinkage long sys_umask(int mask)
 {
-	mask = xchg(&current->fs->umask, mask & S_IRWXUGO);
-	return mask;
+	struct fs_struct *fs = current->fs;
+	int old = fs->umask;
+	fs->umask = mask & S_IRWXUGO;
+	return old;
 }
     
 asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,

--------------070104060507040302030402--
