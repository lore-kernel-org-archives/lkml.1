Return-Path: <linux-kernel-owner+w=401wt.eu-S1756299AbYEVQJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299AbYEVQJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbYEVQJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:09:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:59426 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbYEVQJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:09:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=hmIBlrpQewqmQ6le4gvGmDNf4UaFy/ima6B0yAmIfMO234riwf5y7LFuoawLDpKYtzYicaKlv9hNC2+mMcmzdKhp7Ddaz2oStA1FTiANIAzh4m3gCew13R0nr6KDS5R8LV5aT0w5UfPxGSNigqVW6KgTviLjH7X0jGw5vTzeVaU=
Date: Thu, 22 May 2008 18:08:53 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/6] ERR_PTR: warn when ERR_PTR parameter is not errno
	value
Message-ID: <20080522160851.GC8447@joi>
References: <20080513201813.GA5869@joi> <1211148273-16226-1-git-send-email-marcin.slusarz@gmail.com> <87hccvurxr.fsf@saeurebad.de> <20080519064345.GB4707@martell.zuzino.mipt.ru> <8763tav6hi.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8763tav6hi.fsf@saeurebad.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 02:11:21PM +0200, Johannes Weiner wrote:
> Hi,
> 
> Alexey Dobriyan <adobriyan@gmail.com> writes:
> 
> > On Mon, May 19, 2008 at 01:13:20AM +0200, Johannes Weiner wrote:
> >> Marcin Slusarz <marcin.slusarz@gmail.com> writes:
> >> 
> >> > Check at runtime whether error argument of ERR_PTR and ERR_OR_0_PTR
> >> > is valid. It can catch bugs which possibly lead to oops or panic earlier.
> >> >
> >> > Currently there are > 600 calls of ERR_PTR with non-constant argument
> >> > in Linux kernel sources.
> >
> >> > --- a/include/linux/err.h
> >> > +++ b/include/linux/err.h
> >> > @@ -3,6 +3,7 @@
> >> >  
> >> >  #include <linux/compiler.h>
> >> >  
> >> > +#include <asm/bug.h>
> >> >  #include <asm/errno.h>
> >> >  
> >> >  /*
> >> > @@ -21,6 +22,7 @@
> >> >  
> >> >  static inline void *__ERR_PTR(long error)
> >> >  {
> >> > +	WARN_ON(!IS_ERR_VALUE(error));
> >> >  	return (void *) error;
> >> >  }
> >> >  
> >> > @@ -28,6 +30,7 @@ static inline void *__ERR_PTR(long error)
> >> >  
> >> >  static inline void *__ERR_OR_0_PTR(long error)
> >> >  {
> >> > +	WARN_ON(!IS_ERR_VALUE(error) && error);
> >> >  	return (void *) error;
> >> >  }
> >> 
> >> How about WARN_ON_ONCE() instead?  That would warn once for each erroneous user
> >> which should be enough.
> >
> > And blow up .bss ?
> 
> Well, okay.  Perhaps ratelimiting?  I really prefer a bigger image size
> over a spammed dmesg.

Well, when I add 0 as a valid argument for ERR_PTR, this check won't add too many
false positives, so I think simple WARN_ON is safe.

Marcin
