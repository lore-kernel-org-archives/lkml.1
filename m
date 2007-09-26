Return-Path: <linux-kernel-owner+w=401wt.eu-S1760760AbXIZPEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760AbXIZPEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbXIZPDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:03:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51023 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbXIZPDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:03:51 -0400
Date: Wed, 26 Sep 2007 16:03:45 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: haveblue@us.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] fix sys_mknodat breakage from r/o bind mounts
Message-ID: <20070926150345.GA24744@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Miklos Szeredi <miklos@szeredi.hu>, haveblue@us.ibm.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <E1IaJMd-000535-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IaJMd-000535-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 12:58:47AM +0200, Miklos Szeredi wrote:
>  	if (!S_ISREG(mode)  && !S_ISCHR(mode)  && !S_ISBLK(mode) &&
> -	    !S_ISFIFO(mode) && !S_ISSOCK(mode) && mode != 0) {
> +	    !S_ISFIFO(mode) && !S_ISSOCK(mode) && (mode & S_IFMT) != 0) {

FYI this whole section might be cleaner as


static int may_mknod(mode_t mode)
{
	switch (mode & S_IFMT) {
	case S_IFREG:
	case S_IFCHR:
	case S_IFBLK:
	case S_IFFIFO:
	case S_IFSOCK:
	case 0:	/* zero mode translates to S_IFREG *
		return 0;
	case S_IFDIR:
		return -EPERM;
	default:
		return -EINVAL;
	}
}

and then in sys_mknodat just a

	error = may_mknod(mode);
	if (error)
		goto out_dput;

