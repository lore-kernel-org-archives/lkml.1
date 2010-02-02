Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab0BBQnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 11:43:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42419 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527Ab0BBQny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 11:43:54 -0500
Date: Tue, 2 Feb 2010 16:43:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] %pd - for printing dentry name
Message-ID: <20100202164341.GG12882@ZenIV.linux.org.uk>
References: <20100201222511.GA12882@ZenIV.linux.org.uk>
 <alpine.LFD.2.00.1002011431490.3664@localhost.localdomain>
 <20100201231847.GC12882@ZenIV.linux.org.uk>
 <20100202065341.GF6292@linux.vnet.ibm.com>
 <20100202070908.GF12882@ZenIV.linux.org.uk>
 <20100202133230.GF1331@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202133230.GF1331@parisc-linux.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 06:32:31AM -0700, Matthew Wilcox wrote:
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
> 
> I think reusing the d_iname is OK.  As long as we always limit the
> number of characters printed to the 'len' element, we should never get
> an overrun.  At worst, we get a mixture of the previous name and the
> next name ... and that's a significant canary in itself.

You are creating an extra deref in normal case.  Inline names are common.
Putting len and hash with the name probably not a win - most of the time
you don't look at actual characters and rely on mismatches in other
components to skip the candidate during search.
