Return-Path: <linux-kernel-owner+w=401wt.eu-S1759371AbXK1Jn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371AbXK1Jn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 04:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbXK1JnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 04:43:15 -0500
Received: from verein.lst.de ([213.95.11.210]:49276 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319AbXK1JnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 04:43:13 -0500
Date: Wed, 28 Nov 2007 10:43:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: Edward Shishkin <edward@namesys.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Reiserfs-list <reiserfs-devel@vger.kernel.org>, bfields@citi.umich.edu,
       Neil Brown <neilb@suse.de>, Christoph Hellwig <hch@lst.de>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/2] reiser4: new export ops
Message-ID: <20071128094301.GA7760@lst.de>
References: <200710212348.l9LNm3Cq000694@imap1.linux-foundation.org> <474CBEEF.3060303@namesys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474CBEEF.3060303@namesys.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This code looks a little confusing to me..

>   */
>  static char *decode_inode(struct super_block *s, char *addr,
>  			  reiser4_object_on_wire * obj)
> @@ -41,7 +42,8 @@
>  	fplug = file_plugin_by_disk_id(reiser4_get_tree(s), (d16 *) addr);
>  	if (fplug != NULL) {
>  		addr += sizeof(d16);
> -		obj->plugin = fplug;
> +		if (obj)
> +			obj->plugin = fplug;

You are adding quite a few of those if (obj) clauses.  I can't see a
reason for that - care to explain?  The new aops should not disallow for
any functionality that has been there before.

> static struct dentry *reiser4_decode_fh(struct super_block *super, __u32 *fh,
> +					int len, int fhtype, int parent)
>  {
>  	reiser4_context *ctx;
>  	reiser4_object_on_wire object;
>  	char *addr;
>  
>  	ctx = reiser4_init_context(super);
>  	if (IS_ERR(ctx))
> @@ -80,25 +77,19 @@
>  	assert("vs-1482",
>  	       fhtype == FH_WITH_PARENT || fhtype == FH_WITHOUT_PARENT);
>  
> 	addr = (char *)fh;
> 
> 	object_on_wire_init(&object);
> +
> +	if (parent)
> +		/* skip first onwire object */
> +		addr = decode_inode(super, addr, NULL);
> 	if (!IS_ERR(addr)) {
> +		addr = decode_inode(super, addr, &object);
> 		if (!IS_ERR(addr)) {
> 			struct dentry *d;
> 
> +			d = reiser4_get_dentry(super, &object);

I'd suggest to directly poke into the place where the parent handle
is stored.  XFS used a similar construct to the decode_inode helper,
but with the new aops it's faster and easier to read if you just have
a helper on how many bytes to skip.  Did you take a look at how the
various other filesystem handle the export ops?

> --- linux-2.6.23-mm1/fs/reiser4/dscale.c.orig
> +++ linux-2.6.23-mm1/fs/reiser4/dscale.c
> @@ -126,6 +126,24 @@

How are the changes to all these other files related to the export
operations changes?

