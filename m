Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbZIZTBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbZIZTBE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 15:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbZIZTBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 15:01:03 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:63432 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbZIZTBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 15:01:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XbYR2dJYy9fafDJuHEGkNtuX4xk1BdW0jv+1ZGMyLNSFhb70QsxJxC1TOGIz8Z3iCx
         U54Kkzlv9fUryLKlxnZfSRap/6FdPqbGdJoSwXjW9fcvegbHTcO1KWO358Kczt6/rta9
         gIdtWLj9cO8x1UCTmS2JKnVOKCA9pVq5/fcZM=
Date: Sat, 26 Sep 2009 23:01:03 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       netdev@vger.kernel.org
Subject: Re: [PATCH 9/9] Add explicit bound checks in net/socket.c
Message-ID: <20090926190103.GB4356@lenovo>
References: <20090926204951.424e567e@infradead.org> <20090926205432.24aa1023@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090926205432.24aa1023@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Arjan van de Ven - Sat, Sep 26, 2009 at 08:54:32PM +0200]
| From: Arjan van de Ven <arjan@linux.intel.com>
| Subject: [PATCH 9/9] Add explicit bound checks in net/socket.c
| CC: netdev@vger.kernel.org
| 
| The sys_socketcall() function has a very clever system for the copy
| size of its arguments. Unfortunately, gcc cannot deal with this in
| terms of proving that the copy_from_user() is then always in bounds.
| This is the last (well 9th of this series, but last in the kernel) such
| case around.
| 
| With this patch, we can turn on code to make having the boundary provably
| right for the whole kernel, and detect introduction of new security
| accidents of this type early on.
| 
| Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
| 
| 
| diff --git a/net/socket.c b/net/socket.c
| index 49917a1..13a8d67 100644
| --- a/net/socket.c
| +++ b/net/socket.c
| @@ -2098,12 +2098,17 @@ SYSCALL_DEFINE2(socketcall, int, call, unsigned long __user *, args)
|  	unsigned long a[6];
|  	unsigned long a0, a1;
|  	int err;
| +	unsigned int len;
|  
|  	if (call < 1 || call > SYS_ACCEPT4)
|  		return -EINVAL;
|  
| +	len = nargs[call];
| +	if (len > 6)

Hi Arjan, wouldn't ARRAY_SIZE suffice beter there?
Or I miss something?

| +		return -EINVAL;
| +
|  	/* copy_from_user should be SMP safe. */
| -	if (copy_from_user(a, args, nargs[call]))
| +	if (copy_from_user(a, args, len))
|  		return -EFAULT;
|  
|  	audit_socketcall(nargs[call] / sizeof(unsigned long), a);
| 
| 
| -- 
| Arjan van de Ven 	Intel Open Source Technology Centre
| For development, discussion and tips for power savings, 
| visit http://www.lesswatts.org
|

	-- Cyrill
