Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbYBGXJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbYBGXJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:09:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761125AbYBGXIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:08:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760431AbYBGXIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:08:50 -0500
Message-ID: <47AB8F63.4020002@redhat.com>
Date: Thu, 07 Feb 2008 17:08:19 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reduce large do_mount stack usage with noinlines
References: <47AA3126.8090102@redhat.com>	<20080206143457.03e8741d.akpm@linux-foundation.org>	<47AA3EAA.9080204@redhat.com> <20080206152239.a2352d6d.akpm@linux-foundation.org>
In-Reply-To: <20080206152239.a2352d6d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 06 Feb 2008 17:11:38 -0600
> Eric Sandeen <sandeen@redhat.com> wrote:
> 
>>  /*
>>   * recursively change the type of the mountpoint.
>> + * noinline this do_mount helper to save do_mount stack space.
>>   */
>> -static int do_change_type(struct nameidata *nd, int flag)
>> +static noinline int do_change_type(struct nameidata *nd, int flag)
> 
> What we could do here is defined a new noinline_because_of_stack_suckiness
> and use that.

Something like:

Index: linux-2.6.24-mm1/include/linux/compiler-gcc.h
===================================================================
--- linux-2.6.24-mm1.orig/include/linux/compiler-gcc.h
+++ linux-2.6.24-mm1/include/linux/compiler-gcc.h
@@ -53,3 +53,9 @@
 #define  noinline			__attribute__((noinline))
 #define __attribute_const__		__attribute__((__const__))
 #define __maybe_unused			__attribute__((unused))
+
+/*
+ * When gcc inlines multiple functions into a parent function,
+ * the stack space used sometimes increases excessively...
+ */
+#define noinline_stackspace	noinline


?

I couldn't think of a great name for it.  There are several noinline
users throughout the kernel with stackspace related comments, so if
desired, I could sprinkle this around.  I'm not very pleased with it
aesthetically though. :)

-Eric
