Return-Path: <linux-kernel-owner+w=401wt.eu-S1755727AbZBXJvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbZBXJvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 04:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbZBXJvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 04:51:11 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40624 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbZBXJvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 04:51:10 -0500
Date: Tue, 24 Feb 2009 11:09:13 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Salman Qazi <sqazi@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: Performance regression in write() syscall
Message-ID: <20090224100913.GU26292@one.firstfloor.org>
References: <20090224020304.GA4496@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224020304.GA4496@google.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 06:03:04PM -0800, Salman Qazi wrote:
> While the introduction of __copy_from_user_nocache (see commit:
> 0812a579c92fefa57506821fa08e90f47cb6dbdd) may have been an improvement
> for sufficiently large writes, there is evidence to show that it is
> deterimental for small writes.  Unixbench's fstime test gives the
> following results for 256 byte writes with MAX_BLOCK of 2000:

Do you have some data on where the cycles are spent? 

In theory it should be neutral on small writes.

> @@ -192,14 +192,20 @@ static inline int __copy_from_user_nocache(void *dst, const void __user *src,
>  					   unsigned size)
>  {
>  	might_sleep();
> -	return __copy_user_nocache(dst, src, size, 1);
> +	if (likely(size >= PAGE_SIZE))
> +		return __copy_user_nocache(dst, src, size, 1);
> +	else
> +		return __copy_from_user(dst, src, size);

I think you disabled it completely, the kernel never really does
any copies larger than page size because all its internal objects
are page sized only.

That check would need to be higher up the VFS stack (above filemap.c code) 
before the copies are split up.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
