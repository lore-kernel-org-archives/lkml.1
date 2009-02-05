Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbZBEQCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbZBEQCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 11:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbZBEQCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 11:02:35 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:3283 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbZBEQCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 11:02:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jvzZ0mvbpRSAhZLpqD6uHC7NYKymttvQ7tnDHB7JN62obdwFB9DgYG3ZK97M/bE+pc
         Vn5wpd41s1eDSk4mUjiP9gBSL3ENJAPN0ar0/q1HEfYX71mrhv3JRrtXJQ9+YYt91uBq
         LFewvNrx13OEtHXcpK5K7hAOROIC1sF2KG6Vk=
Date: Thu, 5 Feb 2009 10:01:28 -0600
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] module: make modversion_info contain a pointer,
	not an array.
Message-ID: <20090205160128.GA9486@mediacenter>
References: <200901290005.52819.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901290005.52819.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 12:05:52AM +1030, Rusty Russell wrote:
> With allmodconfig (minus non-building modules) on 32-bit x86:
> Total size of modules before: 60009790 bytes
> Total size of modules after: 55927866 bytes
> 
> Saving 7% of module size for CONFIG_MODVERSIONS=y; and these sections
> are kept resident as well.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  include/linux/module.h |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -37,10 +37,12 @@ struct kernel_symbol
>  	const char *name;
>  };
>  
> +/* This is put in the __versions section of a module to indicate the version
> + * it expects for unknown symbols. */
>  struct modversion_info
>  {
>  	unsigned long crc;
> -	char name[MODULE_NAME_LEN];
> +	char *name;
>  };

Hey Rusty thanks for the change, but I just got around to testing this
and I have a few observations/questions.  First this breaks:

modprobe --dump-modversions foo.ko

I actually don't care, but just happened to stumble upon it when I also
noticed that your changes seemed to be working a little too well.  I
currently happen to be building my modules out of order for example
module B depends on symbols from module A, but I build module B first.
This means that the exported symbols are not in the Module.symvers file
when module B is compiled.  I would expect module B to fail to load yet
with your patches it magically works and I don't see any errors in the
logs.  If I run:

objdump -s --section __versions B.ko

I only get something like:

Contents of section __versions:
 0000 d782ec86 00000000

Of course if I build the modules in the correct order and dump the
__versions section I see the correct number of crc/char* pairs.

--
Shawn
