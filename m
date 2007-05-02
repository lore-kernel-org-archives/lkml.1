Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbXEBGmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbXEBGmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbXEBGmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:42:18 -0400
Received: from smtp-out.google.com ([216.239.45.13]:1683 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875AbXEBGmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:42:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=n+/c9t2P2SxcK3ivvFkcvh9kzwXOdO7+4w8NwQZegRAVVP0UadH/4OmO8/5jbwel3
	8pNWFDgYxrnvgGmjBnfNA==
Date: Tue, 1 May 2007 23:41:34 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] compiler: define __attribute_unused__
In-Reply-To: <1178087393.28659.238.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0705012336430.22339@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com> 
 <1178084403.28659.222.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0705012254160.21685@chino.kir.corp.google.com>
 <1178087393.28659.238.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Rusty Russell wrote:

> OTOH, your point about "__unneeded" is well taken.  "__needed" and
> "__optional" perhaps?  But their feature is *exactly* that the don't
> look like the gcc attributes, hence avoid their semantic screwage.
> 

Hmm, __optional doesn't sound appropriate either.  Since this is going to 
be defined to be __attribute__ ((unused)), it can apply to both functions 
and variables.  It should be applied to a function if it truly is 
unreferenced within the tree (and there are several examples of this 
current HEAD) and we don't want to use __needed because it still emits the 
function code even though it suppresses the warning.  So saying a function 
that has no callers is "__optional" makes no sense since its code isn't 
going to be emitted in gcc >=3.4.

What's your opinion of my __needed and __maybe_unused idea such as the 
following?



compiler: define __maybe_unused

Define __maybe_unused to apply to both functions or variables as
__attribute__((unused)).  This will not emit a compile-time warning when
a function or variable is declared but unreferenced.

We eventually want to change the name of __attribute_used__ to __used.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/compiler-gcc.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -37,3 +37,4 @@
 #define  noinline			__attribute__((noinline))
 #define __attribute_pure__		__attribute__((pure))
 #define __attribute_const__		__attribute__((__const__))
+#define __maybe_unused			__attribute__((unused))
