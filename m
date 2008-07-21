Return-Path: <linux-kernel-owner+w=401wt.eu-S1757574AbYGUI3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbYGUI3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 04:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbYGUI3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 04:29:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44643 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877AbYGUI3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 04:29:03 -0400
Date: Mon, 21 Jul 2008 09:28:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfs: use kstrdup()
Message-ID: <20080721082857.GB28946@ZenIV.linux.org.uk>
References: <4881BEF4.2020201@cn.fujitsu.com> <20080719131317.GA7027@asus> <20080719131909.GB7027@asus> <20080721052713.GY28946@ZenIV.linux.org.uk> <48842CDB.1090009@cn.fujitsu.com> <20080721070346.GA28946@ZenIV.linux.org.uk> <20080721080427.GC6662@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721080427.GC6662@lenovo>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 12:04:27PM +0400, Cyrill Gorcunov wrote:
>  		err = mnt_alloc_id(mnt);
> -		if (err) {
> -			kmem_cache_free(mnt_cache, mnt);
> -			return NULL;
> +		if (err)
> +			goto err;

Ugh...  Labels are in a separate namespace, but really...

> +		if (name) {
> +			mnt->mnt_devname = kstrdup(name, GFP_KERNEL);
> +			if (!mnt->mnt_devname)
> +				goto err;

> +err:
> +	kmem_cache_free(mnt_cache, mnt);
> +	return NULL;

Leak; note the mnt_alloc_id() above.  Either do that kstrdup() first and
kfree the result on mnt_alloc_id() failure or do mnt_free_id() on kstrdup()
one...
