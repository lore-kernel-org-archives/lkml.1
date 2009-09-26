Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085AbZIZTFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbZIZTFN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 15:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbZIZTFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 15:05:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:58925 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbZIZTFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 15:05:10 -0400
Date: Sat, 26 Sep 2009 21:05:32 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       netdev@vger.kernel.org
Subject: Re: [PATCH 9/9] Add explicit bound checks in net/socket.c
Message-ID: <20090926210532.4c664705@infradead.org>
In-Reply-To: <20090926190103.GB4356@lenovo>
References: <20090926204951.424e567e@infradead.org>
	<20090926205432.24aa1023@infradead.org>
	<20090926190103.GB4356@lenovo>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Sep 2009 23:01:03 +0400
Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> [Arjan van de Ven - Sat, Sep 26, 2009 at 08:54:32PM +0200]
> | From: Arjan van de Ven <arjan@linux.intel.com>
> | Subject: [PATCH 9/9] Add explicit bound checks in net/socket.c
> | CC: netdev@vger.kernel.org
> | 
> | The sys_socketcall() function has a very clever system for the copy
> | size of its arguments. Unfortunately, gcc cannot deal with this in
> | terms of proving that the copy_from_user() is then always in bounds.
> | This is the last (well 9th of this series, but last in the kernel)
> such | case around.
> | 
> | With this patch, we can turn on code to make having the boundary
> provably | right for the whole kernel, and detect introduction of new
> security | accidents of this type early on.
> | 
> | Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> | 
> | 
> | diff --git a/net/socket.c b/net/socket.c
> | index 49917a1..13a8d67 100644
> | --- a/net/socket.c
> | +++ b/net/socket.c
> | @@ -2098,12 +2098,17 @@ SYSCALL_DEFINE2(socketcall, int, call,
> unsigned long __user *, args) |  	unsigned long a[6];
> |  	unsigned long a0, a1;
> |  	int err;
> | +	unsigned int len;
> |  
> |  	if (call < 1 || call > SYS_ACCEPT4)
> |  		return -EINVAL;
> |  
> | +	len = nargs[call];
> | +	if (len > 6)
> 
> Hi Arjan, wouldn't ARRAY_SIZE suffice beter there?
> Or I miss something?

yeah you missed that I screwed up ;(

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 9/9] Add explicit bound checks in net/socket.c
CC: netdev@vger.kernel.org

The sys_socketcall() function has a very clever system for the copy
size of its arguments. Unfortunately, gcc cannot deal with this in
terms of proving that the copy_from_user() is then always in bounds.
This is the last (well 9th of this series, but last in the kernel) such
case around.

With this patch, we can turn on code to make having the boundary provably
right for the whole kernel, and detect introduction of new security
accidents of this type early on.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>


diff --git a/net/socket.c b/net/socket.c
index 49917a1..13a8d67 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2098,12 +2098,17 @@ SYSCALL_DEFINE2(socketcall, int, call, unsigned long __user *, args)
 	unsigned long a[6];
 	unsigned long a0, a1;
 	int err;
+	unsigned int len;
 
 	if (call < 1 || call > SYS_ACCEPT4)
 		return -EINVAL;
 
+	len = nargs[call];
+	if (len > 6 * sizeof(unsiged long))
+		return -EINVAL;
+
 	/* copy_from_user should be SMP safe. */
-	if (copy_from_user(a, args, nargs[call]))
+	if (copy_from_user(a, args, len))
 		return -EFAULT;
 
 	audit_socketcall(nargs[call] / sizeof(unsigned long), a);



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
