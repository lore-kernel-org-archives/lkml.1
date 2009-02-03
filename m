Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbZBCTPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbZBCTPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 14:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbZBCTPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 14:15:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387AbZBCTPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 14:15:00 -0500
Date: Tue, 3 Feb 2009 11:14:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: pavel@suse.cz, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: /proc/sys/vm/drop_caches: add error handling
Message-Id: <20090203111447.41e2022c.akpm@linux-foundation.org>
In-Reply-To: <20090203204456.ECA3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20090203113319.GA2022@elf.ucw.cz>
	<20090203204456.ECA3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  3 Feb 2009 20:47:56 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > 
> > Document that drop_caches is unsafe, and add error checking so that it
> > bails out on invalid inputs. [Note that this was triggered by Android
> > trying to use it in production, and incidentally writing invalid
> > value...]
> 
> Yup. good patch.
> 
> > -	return 0;
> > +	int res;
> > +	res = proc_dointvec_minmax(table, write, file, buffer, length, ppos);
> > +	if (res)
> > +		return res;
> > +	if (!write)
> > +		return res;
> > +	if (sysctl_drop_caches & ~3)
> > +		return -EINVAL;
> > +	if (sysctl_drop_caches & 1)
> > +		drop_pagecache();
> > +	if (sysctl_drop_caches & 2)
> > +		drop_slab();
> > +	return res;
> >  }
> 
> I think following is clarify more.
> 
> 	res = proc_dointvec_minmax(table, write, file, buffer, length, ppos);
> 	if (res)
> 		return res;
> 	if (!write)
> 		return 0;
> 	if (sysctl_drop_caches & ~3)
> 		return -EINVAL;
> 	if (sysctl_drop_caches & 1)
> 		drop_pagecache();
> 	if (sysctl_drop_caches & 2)
> 		drop_slab();
> 	return 0;
> 
> 
> otherthings, _very_ looks good to me. :)
> 

For better or for worse, my intent here was to be
future-back-compatible.  So if we later add new flags, and people write
code which uses those new flags, that code won't break on old kernels.

Probably that wasn't a very good idea, and such userspace code isn't
very good.
