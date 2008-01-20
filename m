Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbYATM5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbYATM5F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 07:57:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbYATM4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 07:56:55 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:54693 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbYATM4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 07:56:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=myfryKJI74pxYtgiozH3xjsKg2c0HBy8+u/xsInD81mN8NcDFd8Pw911fQsDJx7hO0+QROdgf7WZvBUYmCU0YnJs84Ulur3D4bZsWx/t6R8vk1xHHdVdnCPhi/Cm9iI4B9rz9U8STdmO/E1Jmtc6U8JCqQNjhEqL9BIfSKM6RIs=
Message-ID: <4793450F.40902@gmail.com>
Date: Sun, 20 Jan 2008 21:56:47 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 0/6] RFC: Typesafe callbacks
References: <200801202046.14746.rusty@rustcorp.com.au>
In-Reply-To: <200801202046.14746.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Hi all,
> 
>    Converting to and from void * for callback functions loses type safety: 
> everywhere else we expect the compiler to catch incorrect pointer types 
> handed to functions.
> 
>    It's pretty simple to create typesafe callback functions using typeof, and 
> with a little gcc trickery we can allow both old-style and typesafe callbacks 
> to avoid churn on commonly-used routines.

I wasn't too convinced with only irq handler conversion but with other
things converted, I'm liking it very much.  I really like the timer
conversion as casting between void * and unsigned long is annoying.
Possible improvements.

* Passing NULL as data to callback which takes non-void pointer
  triggers warning.  I think this should be allowed.  Something like
  the following?

* Allowing non-pointer integral types which fit into pointer would be
  nice.  It's often convenient to pass integers to simple callbacks.

The following macro kinda-sorta achieves the above two but it doesn't
consider promotion of integer types and thus is too strict.  There
gotta be some way.

#define kthread_create(threadfn, data, namefmt...) ({		\
	int (*_threadfn)(typeof(data));				\
	void *_data;						\
	_threadfn = __builtin_choose_expr(!__builtin_types_compatible_p(typeof(data), typeof(NULL)), \
			(threadfn), (void *)(threadfn));	\
	_data = __builtin_choose_expr(sizeof(data) <= sizeof(void *), \
			(void *)(unsigned long)data, (void *)data); \
	__kthread_create((void *)_threadfn, _data, namefmt);	\
})

Thanks.

-- 
tejun
