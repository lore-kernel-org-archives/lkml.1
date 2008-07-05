Return-Path: <linux-kernel-owner+w=401wt.eu-S1752992AbYGEKUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbYGEKUo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 06:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYGEKUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 06:20:35 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:17389 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbYGEKUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 06:20:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=IP9CS33tRopT1hDGQzPuuv1sfAExdBHRq1JgP8DoF5Ws2ryCbtxFHXryOuVu6Pe2fD
         5ZGAuzQF2/NFY74+z/1M30wliNm8sLyL0/E2y17XZFkv7Po/J75QUmbnqv2BHqftT3XW
         7mfG9eKlEzU7oKf++p42W3h8PQ5DXOIAKWR+c=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: the printk problem
Date: Sat, 5 Jul 2008 12:20:25 +0200
User-Agent: KMail/1.8.2
Cc: Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Anvin <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>,
       linux-ia64@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
References: <20080625131101.GA6205@digi.com> <20080704204252.GM14894@parisc-linux.org> <20080704150100.1f7b8a65.akpm@linux-foundation.org>
In-Reply-To: <20080704150100.1f7b8a65.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807051220.25418.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 July 2008 00:01, Andrew Morton wrote:
> > > We also jump through hoops to print things like sector_t and
> > > resource_size_t.  They always need to be cast to `unsiged long long',
> > > which generates additional stack space and text in some setups.
> > 
> > The thing is that GCC checks types.  So it's fine to add "print this
> > pointer specially", but you can't in general add new printf arguments
> > without also hacking GCC.  Unless you use -Wno-format, and require
> > sparse to check special kernel types.
> 
> It would be excellent if gcc had an extension system so that you could
> add new printf control chars and maybe even tell gcc how to check them.
> But of course, if that were to happen, we couldn't use it for 4-5 years.
> 
> What I had initially proposed was to abuse %S, which takes a wchar_t*. 
> gcc accepts `unsigned long *' for %S.
> 
> Then, we put the kernel-specific control char after the S, so we can
> print an inode (rofl) with
> 
> 	struct inode *inode;
> 
> 	printk("here is an inode: %Si\n", (unsigned long *)inode);
> 
> Downsides are:
> 
> - there's a cast, so you could accidentally do
> 
> 	printk("here is an inode: %Si\n", (unsigned long *)dentry);
> 
> - there's a cast, and they're ugly
> 
> - gcc cannot of course check that the arg matches the control string
> 
> Unfortunately (and this seems weird), gcc printf checking will not
> accept a void* for %S: it _has_ to be wchar_t*, and the checker won't
> permit void* substitution for that.

Repeating myself here...
We can add an alternative alias to printk:

 asmlinkage int printk(const char * fmt, ...)
         __attribute__ ((format (printf, 1, 2))) __cold;
+asmlinkage int custom_printk(const char * fmt, ...) __cold asm ("printk");

custom_printk() is actually just printk(), that is,
we won't need additional function, we need to teach
*printk* about MAC addresses, NIPQUADs etc;

and then use printk() if you use only standard %fmt (and have it
checked by gcc), or use custom_printk() if you have non-standard
%fmt in the format string.

The only downside that in second case, you lose gcc checking.
No big deal.
--
vda
