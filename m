Return-Path: <linux-kernel-owner+w=401wt.eu-S932780AbXCHSdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbXCHSdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 13:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932781AbXCHSdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 13:33:20 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:52531 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932780AbXCHSdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 13:33:19 -0500
Subject: Re: [RFC][Patch 2/6] integrity: fs hook placement
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitriy Monakhov <dmonakhov@sw.ru>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
In-Reply-To: <87ps7jy51e.fsf@sw.ru>
References: <1173369812.5981.2.camel@localhost.localdomain>
	 <87ps7jy51e.fsf@sw.ru>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 13:45:42 -0500
Message-Id: <1173379542.5981.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-08 at 21:16 +0300, Dmitriy Monakhov wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> writes:
> 
> > This patch places calls to the new integrity hooks in the appropriate
> > places in the fs directory. It is not meant in any way to be viewed
> > as a complete set, but used as a basis for an initial discussion.
> >
> > Index: linux-2.6.21-rc3-mm2/fs/ext3/xattr_security.c
> > ===================================================================
> > --- linux-2.6.21-rc3-mm2.orig/fs/ext3/xattr_security.c
> > +++ linux-2.6.21-rc3-mm2/fs/ext3/xattr_security.c
> > @@ -10,6 +10,7 @@
> >  #include <linux/ext3_jbd.h>
> >  #include <linux/ext3_fs.h>
> >  #include <linux/security.h>
> > +#include <linux/integrity.h>
> >  #include "xattr.h"
> >  
> >  static size_t
> > @@ -58,12 +59,19 @@ ext3_init_security(handle_t *handle, str
> >  
> >  	err = security_inode_init_security(inode, dir, &name, &value, &len);
> >  	if (err) {
> > +		/* Even if creation of the security xattr fails, must
> > +		 * indicate this is a new inode. */
> > +		integrity_inode_init_integrity(inode, dir, NULL, NULL, NULL);
> >  		if (err == -EOPNOTSUPP)
> >  			return 0;
> >  		return err;
> >  	}
> <<<< block begin
> >  	err = ext3_xattr_set_handle(handle, inode, EXT3_XATTR_INDEX_SECURITY,
> >  				    name, value, len, 0);
> > +
> > +	integrity_inode_init_integrity(inode, dir, &name, &value, &len);
> > +	err = ext3_xattr_set_handle(handle, inode, EXT3_XATTR_INDEX_SECURITY,
> > +				    name, value, len, 0);
> <<<< block end
> May be i've missed something, but i don't get last block.
> Why you call ext3_xattr_set_handle() twise?, 
> or you just mistyped and  it has to look like this:
> <<<<block_begin

Both security_inode_init_security and integrity_inode_init_integrity
create extended attributes. The first ext3_xattr_set_handle creates the
security extended attribute and the second one creates the integrity
extended attribute.  In the case of EVM, EVM calculates an HMAC on a set
of extended attributes, possibly including the initial security extended
attribute.

Mimi Zohar

