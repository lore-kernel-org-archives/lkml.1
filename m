Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbZDVTNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbZDVTNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 15:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbZDVTMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:12:55 -0400
Received: from mail.fieldses.org ([141.211.133.115]:39219 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbZDVTMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:12:54 -0400
Date: Wed, 22 Apr 2009 15:12:44 -0400
To: hooanon05@yahoo.co.jp
Cc: David Woodhouse <dwmw2@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] Fix i_mutex handling in nfsd readdir
Message-ID: <20090422191244.GD9541@fieldses.org>
References: <1237475837.16359.106.camel@macbook.infradead.org> <8913.1237476890@jrobl> <1239960739.3428.33.camel@macbook.infradead.org> <20090417193233.GM26366@ZenIV.linux.org.uk> <1240006620.19059.41.camel@macbook.infradead.org> <20090417224350.GN26366@ZenIV.linux.org.uk> <20090417225306.GO26366@ZenIV.linux.org.uk> <1240013753.21423.86.camel@macbook.infradead.org> <1240144069.3589.156.camel@macbook.infradead.org> <7321.1240375306@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7321.1240375306@jrobl>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 01:41:46PM +0900, hooanon05@yahoo.co.jp wrote:
> 
> David Woodhouse:
> > This patch fixes it by locking the directory's i_mutex again before
> > calling the filldir functions. The original deadlocks which commit
> 	:::
> 
> An entry may be removed between the first mutex_unlock and the second
> mutex_lock. In this case, lookup_one_len() in compose_entry_fh() will
> return a negative dentry.
> Currently the inode test (positive/negative) is done AFTER fh_compose().
> Isn't it better to test it BEFORE fh_compose()?
> 
> compose_entry_fh()
> {
> 	:::
> 		dchild = lookup_one_len(name, dparent, namlen);
> 	if (IS_ERR(dchild))
> 		return 1;
> 	if (d_mountpoint(dchild) ||
> 	    fh_compose(fhp, exp, dchild, &cd->fh) != 0 ||
> 	    !dchild->d_inode)
> 		rv = 1;
> 	:::
> }

Yes, I think you're right.

Arrrgh.

--b.
