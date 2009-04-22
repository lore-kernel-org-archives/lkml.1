Return-Path: <linux-kernel-owner+w=401wt.eu-S1752758AbZDVEmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbZDVEmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 00:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbZDVEmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 00:42:09 -0400
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:47446 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZDVEmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 00:42:08 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH v2] Fix i_mutex handling in nfsd readdir 
To: David Woodhouse <dwmw2@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, bfields@citi.umich.edu,
       hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <1240144069.3589.156.camel@macbook.infradead.org>
References: <8036.1237474444@jrobl> <1237475837.16359.106.camel@macbook.infradead.org> <8913.1237476890@jrobl> <1239960739.3428.33.camel@macbook.infradead.org> <20090417193233.GM26366@ZenIV.linux.org.uk> <1240006620.19059.41.camel@macbook.infradead.org> <20090417224350.GN26366@ZenIV.linux.org.uk> <20090417225306.GO26366@ZenIV.linux.org.uk> <1240013753.21423.86.camel@macbook.infradead.org> <1240144069.3589.156.camel@macbook.infradead.org>
Date: Wed, 22 Apr 2009 13:41:46 +0900
Message-ID: <7321.1240375306@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David Woodhouse:
> This patch fixes it by locking the directory's i_mutex again before
> calling the filldir functions. The original deadlocks which commit
	:::

An entry may be removed between the first mutex_unlock and the second
mutex_lock. In this case, lookup_one_len() in compose_entry_fh() will
return a negative dentry.
Currently the inode test (positive/negative) is done AFTER fh_compose().
Isn't it better to test it BEFORE fh_compose()?

compose_entry_fh()
{
	:::
		dchild = lookup_one_len(name, dparent, namlen);
	if (IS_ERR(dchild))
		return 1;
	if (d_mountpoint(dchild) ||
	    fh_compose(fhp, exp, dchild, &cd->fh) != 0 ||
	    !dchild->d_inode)
		rv = 1;
	:::
}


J. R. Okajima
