Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab0BBQNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 11:13:36 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:36317 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab0BBQNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 11:13:35 -0500
Date: Tue, 2 Feb 2010 09:13:33 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] %pd - for printing dentry name
Message-ID: <20100202161333.GH1331@parisc-linux.org>
References: <20100201222511.GA12882@ZenIV.linux.org.uk> <alpine.LFD.2.00.1002011431490.3664@localhost.localdomain> <20100201231847.GC12882@ZenIV.linux.org.uk> <20100202065341.GF6292@linux.vnet.ibm.com> <20100202070908.GF12882@ZenIV.linux.org.uk> <20100202133230.GF1331@parisc-linux.org> <alpine.LFD.2.00.1002020752580.3664@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002020752580.3664@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 07:56:36AM -0800, Linus Torvalds wrote:
> On Tue, 2 Feb 2010, Matthew Wilcox wrote:
> > 
> > How about doing this:
> > 
> >  struct qstr {
> > -	const unsigned char *name;
> > +	const unsigned char name[0];
> >  }
> > 
> >  struct dentry {
> > -	struct qstr d_name;
> > +	struct qstr *d_name;
> > -	unsigned char d_iname[DNAME_INLINE_LEN_MIN];    /* small names */
> > +	union {
> > +		struct qstr d_iname;
> > +		char pad[DNAME_INLINE_LEN_MIN];
> > +	};
> >  }
> > 
> > Doesn't increase the size of struct dentry, and puts the hash and len
> > with the name.  Increases long name allocations by 8 bytes each.
> 
> Conceptually nice, but in practice that's absolutely horrible.
> 
> Why? Because now the dentry lookup logic has to follow an additional 
> pointer just to verify the hash and the length of the name. That's some of 
> the hottest code we have, and the _last_ thing we want is another pointer 
> dereference and cache access in the path that looks up the dentry hash 
> chains.

I'd thought it was in the same cacheline ... but that's not generally
true since dentries are so large.  And the d_name is at the other end
of the dentry, so they're guaranteed to be in different cachelines.  Bum.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
