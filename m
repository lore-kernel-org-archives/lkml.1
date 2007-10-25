Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbXJYAHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbXJYAHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 20:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbXJYAHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 20:07:36 -0400
Received: from smtpoutm.mac.com ([17.148.16.71]:53676 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183AbXJYAHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 20:07:35 -0400
In-Reply-To: <20071024212110.GG27248@parisc-linux.org>
References: <20071024195847.GE27248@parisc-linux.org> <1193255992-14385-1-git-send-email-matthew@wil.cx> <0533759C-81D0-45CB-A663-088A6D4E56A9@mac.com> <20071024212110.GG27248@parisc-linux.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <314B5322-3575-4449-90D2-3068BDC3F64D@mac.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
Date: Wed, 24 Oct 2007 20:07:23 -0400
To: Matthew Wilcox <matthew@wil.cx>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 24, 2007, at 17:21:10, Matthew Wilcox wrote:
> On Wed, Oct 24, 2007 at 04:59:48PM -0400, Kyle Moffett wrote:
>> This seems unlikely to work reliably as the various "v*printf"  
>> functions modify the va_list argument they are passed.  It may  
>> happen to work on your particular architecture depending on how  
>> that argument data is passed and stored, but you probably actually  
>> want to make a copy of the varargs list for the first vsnprintf call.
>
> I based what I did on how printk works:
>
>         va_start(args, fmt);
>         r = vprintk(fmt, args);
>         va_end(args);
>
> It doesn't call va_* anywhere else.  I don't claim to be a varargs  
> expert, but if I'm wrong, I'm at least wrong the same way that  
> printk is, so not in any way that's significant for any other  
> architecture Linux runs on.

No, the problem is what happens when you don't have enough space  
allocated:  you call "vsnprintf(s, len, format, args);" and then  
later call "vsprintf(s, format, args);" with the *SAME* "args".   
That's what's broken.

So this is wrong:
> va_list args;
> va_start(args, fmt);
> r1 = vprintk(fmt, args);
> r2 = vprintk(fmt, args);
> va_end(args);

To fix it, you have 2 options.

Option 1:
> va_list args;
> va_start(args, fmt);
> r1 = vprintk(fmt, args);
> va_end(args);
> va_start(args, fmt);
> r2 = vprintk(fmt, args);
> va_end(args);

Option 2:
> va_list args, argscopy;
> va_start(args, fmt);
> va_copy(argscopy, args);
> r1 = vprintk(fmt, argscopy);
> va_end(argscopy);
> r2 = vprintk(fmt, args);
> va_end(args);

Now in a function which *receives* a va_list from one of its callers,  
"Option 1" isn't an option because you don't have the original stack  
frame, so the result looks like this:

> void func1(const char *fmt, ...)
> {
> 	va_list ap;
> 	va_start(ap, fmt);
> 	func2(fmt, ap);
> 	va_end(ap);
> }
>
> void func2(const char *fmt, va_list ap)
> {
> 	va_list ap2;
> 	va_copy(ap2, ap);
> 	vprintk(fmt, ap2);
> 	va_end(ap2);
> 	vprintk(fmt, ap);
> }

Cheers,
Kyle Moffett

