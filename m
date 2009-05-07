Return-Path: <linux-kernel-owner+w=401wt.eu-S1763622AbZEGWfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763622AbZEGWfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbZEGWfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:35:05 -0400
Received: from smtp-out.google.com ([216.239.45.13]:57116 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbZEGWfB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:35:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=PHmks3uP5DEErjjqWruWfBUkycVT97Fu8XOmoRbiMs/wSpGy8wtWG5cR10A+aWNDB
	KwRuGcbfqh35BJZ2yCoNw==
MIME-Version: 1.0
In-Reply-To: <20090507221447.GE28770@elte.hu>
References: <396556a20805301217k293e5718h6bbf02b234897235@europa>
	 <20090507221447.GE28770@elte.hu>
Date: Thu, 7 May 2009 15:34:58 -0700
Message-ID: <a84d7bc60905071534l1e65f216mfd9330e93e4da4e2@mail.gmail.com>
Subject: Re: [RFC 1/1] seccomp: Add bitmask of allowed system calls.
From: Adam Langley <agl@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       markus@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That assessment is incorrect, there's no difference between safety
> here really.
>
> LSM cannot magically inspect user-space memory either when multiple
> threads may access it. The point would be to define filters for
> system call _arguments_, which are inherently thread-local and safe.

If I hook security_operations.socket_connect, I can validate the struct
sockaddr after the final copy_from_user. However, since the sockaddr lives in
userspace memory, if I try and validate it from ftrace SYSCALL_ENTER, I can't
know that it won't change before sys_connect reads it again.

Because of that, there are system calls which an LSM hook can safely accept
that an ftrace hook cannot. However, as you point out, any arguments passed in
registers are inheriently safe and these may be sufficiently powerful.

> There are two problems with the bitmap scheme, which i also
> suggested in a previous thread but then found it to be lacking:
>
> 1) enumeration: you define a bitmap. That will be problematic
>   between compat and native 64-bit (both have different syscall
>   vectors).

I /think/ it works out, but I've been bitten before with subtle 32/64 bit
compat issues and accept that it's a bit ugly.

> 2) flexibility. It's an on/off selection per syscall. With the
>   filter we have on, off, or filtered. That's a _whole_ lot more
>   flexible.

Absolutely.

Is there a git tree that I can pull this parsing code from?
(git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
maybe?). I can patch in the seccomp-on-ftrace work and try building the
filtering on top of that. I'll see how it turns out anyway.


Thanks

AGL
