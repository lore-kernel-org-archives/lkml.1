Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab0BBP5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 10:57:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751959Ab0BBP5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 10:57:06 -0500
Date: Tue, 2 Feb 2010 07:56:36 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Matthew Wilcox <matthew@wil.cx>
cc: Al Viro <viro@ZenIV.linux.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] %pd - for printing dentry name
In-Reply-To: <20100202133230.GF1331@parisc-linux.org>
Message-ID: <alpine.LFD.2.00.1002020752580.3664@localhost.localdomain>
References: <20100201222511.GA12882@ZenIV.linux.org.uk> <alpine.LFD.2.00.1002011431490.3664@localhost.localdomain> <20100201231847.GC12882@ZenIV.linux.org.uk> <20100202065341.GF6292@linux.vnet.ibm.com> <20100202070908.GF12882@ZenIV.linux.org.uk>
 <20100202133230.GF1331@parisc-linux.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Feb 2010, Matthew Wilcox wrote:
> 
> How about doing this:
> 
>  struct qstr {
> -	const unsigned char *name;
> +	const unsigned char name[0];
>  }
> 
>  struct dentry {
> -	struct qstr d_name;
> +	struct qstr *d_name;
> -	unsigned char d_iname[DNAME_INLINE_LEN_MIN];    /* small names */
> +	union {
> +		struct qstr d_iname;
> +		char pad[DNAME_INLINE_LEN_MIN];
> +	};
>  }
> 
> Doesn't increase the size of struct dentry, and puts the hash and len
> with the name.  Increases long name allocations by 8 bytes each.

Conceptually nice, but in practice that's absolutely horrible.

Why? Because now the dentry lookup logic has to follow an additional 
pointer just to verify the hash and the length of the name. That's some of 
the hottest code we have, and the _last_ thing we want is another pointer 
dereference and cache access in the path that looks up the dentry hash 
chains.

Or am I missing something? I didn't look at the code.

		Linus
