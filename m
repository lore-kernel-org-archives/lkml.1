Return-Path: <linux-kernel-owner+w=401wt.eu-S1757003AbYDJQil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003AbYDJQil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 12:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755882AbYDJQib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 12:38:31 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:60596 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbYDJQia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 12:38:30 -0400
Message-ID: <47FE425C.7060405@s5r6.in-berlin.de>
Date: Thu, 10 Apr 2008 18:37:48 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-kernel@vger.kernel.org, Josh Triplett <josh@freedesktop.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-wireless@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [RFC 1/3] add macros for new sparse features
References: <20080410134810.629048000@sipsolutions.net> <20080410134827.771251000@sipsolutions.net>
In-Reply-To: <20080410134827.771251000@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg wrote:
> This patch adds kernel macros for a few new sparse features, namely
>  * checking try_lock functions and
>  * making a function or macro require a certain lock.
> 
> Still waiting to see what the sparse folks say to my patches.
> 
> Not-yet-signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  include/linux/compiler.h |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> --- everything.orig/include/linux/compiler.h	2008-04-10 15:36:18.000000000 +0200
> +++ everything/include/linux/compiler.h	2008-04-10 15:36:40.000000000 +0200
> @@ -11,9 +11,12 @@
>  # define __nocast	__attribute__((nocast))
>  # define __iomem	__attribute__((noderef, address_space(2)))
>  # define __acquires(x)	__attribute__((context(x,0,1)))
> +# define __try_acquires(x,t,f)	__attribute__((conditional_context(x,0,t,f)))
>  # define __releases(x)	__attribute__((context(x,1,0)))
>  # define __acquire(x)	__context__(x,1)
>  # define __release(x)	__context__(x,-1)
> +# define __requires(x)	__attribute__((context(x,1,1)))
> +# define __macro_requires(x)	__context__(x,0,1)


So, instead of

  /* always call with host_lock held */
  int foo(struct bar *b)
  {

we could write

  int foo(struct bar *b) __requires(host_lock)
  {

and let sparse check the call chains... or how is it used?

And what about dynamically allocated locks?
E.g. b->lock
Or struct host h* = container_of(b, struct host, m); with the necessity
to hold h->lock...
-- 
Stefan Richter
-=====-==--- -=-- -=-=-
http://arcgraph.de/sr/
