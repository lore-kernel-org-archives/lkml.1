Return-Path: <linux-kernel-owner+w=401wt.eu-S938855AbXHIFnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938855AbXHIFnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 01:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628AbXHIFnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 01:43:00 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36927 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbXHIFm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 01:42:58 -0400
Date: Thu, 9 Aug 2007 11:12:52 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 19/26] union-mount: Make lookup work for union-mounted file systems
Message-ID: <20070809054252.GB27251@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070730161323.100048969@weierstrass.suse.de> <20070730161324.902275409@weierstrass.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070730161324.902275409@weierstrass.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 06:13:42PM +0200, Jan Blunck wrote:
> On union-mounted file systems the lookup function must also visit lower layers
> of the union-stack when doing a lookup. This patches add support for
> union-mounts to cached lookups and real lookups.
> 
> We have 3 different styles of lookup functions now:
> - multiple pathname components, follow mounts, follow union, follow symlinks
> - single pathname component, doesn't follow mounts, follow union, doesn't
>   follow symlinks
> - single pathname component doesn't follow mounts, doesn't follow unions,
>   doesn't follow symlinks
> 
<snip>
> +static int hash_lookup_union(struct nameidata *nd, struct qstr *name,
> +			     struct path *path)
> +{

Jan,

Looks like there is a lot of code duplication b/n lookup_hash versions and
real_lookup versions for union mounts. Is there a reason for doing it
this way? I believe that with a little effort we should be able to get
rid of the above hash_lookup_union() completely and can instead use
real_lookup_union() variants from lookup_hash() also.

The reason I say this is, I can't see any _real_ difference b/n
real_lookup() and __lookup_hash_kern().  While the former does a seqlock
protected(for concurrent renames) dcache lookup followed by a ->lookup(),
the latter does an extra lock free dcache lookup, followed by seqlock
protected dcache lookup and a ->lookup() on failure.

Do you want me to cook up a patch for this Jan ?

Aside from that, it would help if someone could throw some light on the history
of __lookup_hash_kern. I wonder why real_lookup wasn't be used instead.

Regards,
Bharata.
