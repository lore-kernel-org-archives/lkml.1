Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbYHaOlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbYHaOlp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 10:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbYHaOli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 10:41:38 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:38686 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbYHaOlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 10:41:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mIkgKWsJtDYFq9/pRTKqhnp/Yg9mRfMndfhonAx10iGHWQqRDWKcshDpSlKYEK5SEE
         CG0DMHLoY6Wmm4HfKfFrUGald+FelL1XtIhsabh1PdkAdI/YzfrR4zzHJyKQ0/qhV7ap
         JjmcV9bE3H4D8jUrEMXbNw5f1amVFrmkN7VJI=
Date: Sun, 31 Aug 2008 18:41:29 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Vegard Nossum <vegard.nossum@gmail.com>, bfields@fieldses.org,
       neilb@suse.de
Subject: Re: [PATCH] sunrpc - fixup userspace buffer possible overrun v2
Message-ID: <20080831144129.GB2884@lenovo>
References: <20080831100806.GD7391@lenovo> <200808311609.12275.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808311609.12275.ioe-lkml@rameria.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Oeser - Sun, Aug 31, 2008 at 04:09:10PM +0200]
| Hi Cyrill,
| 
| On Sunday 31 August 2008, Cyrill Gorcunov wrote:
| > The conclusion is that proc_do_xprt doesn't check for userside buffer
| > size indeed so fix. Also set lenp to number of bytes were really written.
| 
| Why not use  simple_read_from_buffer() for the read case and
| keep the -EINVAL for the write case.

Ah, thanks Ingo - good idea. Btw does libfs.c depends
on anything?

| 
| > Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
| > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| > CC: David Wagner <daw@cs.berkeley.edu>
| > ---
| > 
| > Please review.
| > 
| > Index: linux-2.6.git/net/sunrpc/sysctl.c
| > ===================================================================
| > --- linux-2.6.git.orig/net/sunrpc/sysctl.c	2008-08-31 13:43:46.000000000 +0400
| > +++ linux-2.6.git/net/sunrpc/sysctl.c	2008-08-31 13:58:14.000000000 +0400
| > @@ -60,23 +60,26 @@ static int proc_do_xprt(ctl_table *table
| >  			void __user *buffer, size_t *lenp, loff_t *ppos)
| >  {
| >  	char tmpbuf[256];
| > -	int len;
| > +	size_t len;
| > +
| + ssize_t ret;
| >  	if ((*ppos && !write) || !*lenp) {
| >  		*lenp = 0;
| >  		return 0;
| >  	}
| > +
| >  	if (write)
| >  		return -EINVAL;
| 
|         len = svc_print_xprts(tmpbuf, sizeof(tmpbuf));
| 	ret = simple_read_from_buffer(buffer, ppos, tmpbuf, len);
| 	if (ret >= 0) {
| 		*lenp = ret;
| 		ret = 0;
| 	}
| 
| 	return ret;
|    }
| 
| 
| Best Regards
| 
| Ingo Oeser
| 
		- Cyrill -
