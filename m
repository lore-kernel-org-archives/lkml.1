Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab0BBNcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 08:32:33 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:35169 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792Ab0BBNcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 08:32:32 -0500
Date: Tue, 2 Feb 2010 06:32:31 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] %pd - for printing dentry name
Message-ID: <20100202133230.GF1331@parisc-linux.org>
References: <20100201222511.GA12882@ZenIV.linux.org.uk> <alpine.LFD.2.00.1002011431490.3664@localhost.localdomain> <20100201231847.GC12882@ZenIV.linux.org.uk> <20100202065341.GF6292@linux.vnet.ibm.com> <20100202070908.GF12882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202070908.GF12882@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 07:09:08AM +0000, Al Viro wrote:
> On Mon, Feb 01, 2010 at 10:53:41PM -0800, Paul E. McKenney wrote:
> 
> > Here is an approximation that might inspire someone to come up with a
> > real solution.
> > 
> > One approach would be to store the name length with the name, so that
> > struct qstr loses the "len" field, and so that its "name" field points
> > to a struct that has a "len" field followed by an array of const
> > unsigned char.  That way, the name and length are closely associated.
> > When you pick up a struct qstr's "name" pointer, you are guaranteed to
> > get a length that matches the name.
> > 
> > Unfortunately:
> > 
> > o	In theory, this leaves the length of the dentry unchanged, but
> > 	alignment is a problem on 64-bit systems.  Also, the long names
> > 	gain an extra four bytes.
> 
> That one is not a big deal.
> 
> > o	If you get a pointer to the d_iname small-name field, rename
> > 	might still change the name out from under you.  This could in
> > 	theory be fixed by refusing to re-use the d_iname field until
> > 	an RCU grace period had elapsed (using an external structure
> > 	instead).  In practice, not sure if this is really a reasonable
> > 	approach.
> 
> That, OTOH, is - most of dentries use inline name and external one is
> really a rarely used fallback.  Making it a common case isn't nice.
> 
> There's another practical problem - a lot of code uses qstr fields and
> patch will be painful; I couldn't care less about the out-of-tree code,
> but it's a flagday change and in-tree patch size is not something to
> sneeze at - I've been crawling through all that code for the last couple
> of days and there's a lot of it.

How about doing this:

 struct qstr {
-	const unsigned char *name;
+	const unsigned char name[0];
 }

 struct dentry {
-	struct qstr d_name;
+	struct qstr *d_name;
-	unsigned char d_iname[DNAME_INLINE_LEN_MIN];    /* small names */
+	union {
+		struct qstr d_iname;
+		char pad[DNAME_INLINE_LEN_MIN];
+	};
 }

Doesn't increase the size of struct dentry, and puts the hash and len
with the name.  Increases long name allocations by 8 bytes each.

I think reusing the d_iname is OK.  As long as we always limit the
number of characters printed to the 'len' element, we should never get
an overrun.  At worst, we get a mixture of the previous name and the
next name ... and that's a significant canary in itself.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
