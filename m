Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbZHTPdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbZHTPdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 11:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbZHTPdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 11:33:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419AbZHTPdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 11:33:35 -0400
Date: Thu, 20 Aug 2009 08:32:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Use the cut_here() function in AFS, CacheFiles,
 FS-Cache and RxRPC
In-Reply-To: <20090820105001.29972.33221.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LFD.2.01.0908200816090.3158@localhost.localdomain>
References: <20090820104956.29972.92662.stgit@warthog.procyon.org.uk> <20090820105001.29972.33221.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 Aug 2009, David Howells wrote:
>
> Use the cut_here() function in AFS, CacheFiles, FS-Cache and RxRPC to put
> pertinent extra information between the "cut here" line and the BUG report.

No. This is fundamentally the wrong approach.

>  #define ASSERT(X)						\
>  do {								\
> 	if (unlikely(!(X))) {					\
> -		printk(KERN_ERR "\n");				\
> +		cut_here();					\
>  		printk(KERN_ERR "AFS: Assertion failed\n");	\
>  		BUG();						\

Instead of doing that "cut_here()" thing, you should either use the WARN() 
thing that has a format string already, or we should extend BUG() to have 
that kind of thing too. So in this case I think that you should use WARN() 
instead, ie change it to be

	#define ASSERT(x) do {						\
		if (WARN(X, "AFS: Assertion failed"))		\
			do_exit(SIGSEGV);				\
	} while (0)

instead. And yes, in the long run, I really think we should just extend 
the current BUG() reporting to have that kind of semantics, but I think 
your "cut_here()" thing is a horrible hack.

		Linus
