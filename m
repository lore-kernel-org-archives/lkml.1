Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbZBCLsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbZBCLsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 06:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZBCLsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 06:48:01 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41455 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbZBCLsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 06:48:00 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: /proc/sys/vm/drop_caches: add error handling
Cc: kosaki.motohiro@jp.fujitsu.com, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20090203113319.GA2022@elf.ucw.cz>
References: <20090203113319.GA2022@elf.ucw.cz>
Message-Id: <20090203204456.ECA3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue,  3 Feb 2009 20:47:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Document that drop_caches is unsafe, and add error checking so that it
> bails out on invalid inputs. [Note that this was triggered by Android
> trying to use it in production, and incidentally writing invalid
> value...]

Yup. good patch.

> -	return 0;
> +	int res;
> +	res = proc_dointvec_minmax(table, write, file, buffer, length, ppos);
> +	if (res)
> +		return res;
> +	if (!write)
> +		return res;
> +	if (sysctl_drop_caches & ~3)
> +		return -EINVAL;
> +	if (sysctl_drop_caches & 1)
> +		drop_pagecache();
> +	if (sysctl_drop_caches & 2)
> +		drop_slab();
> +	return res;
>  }

I think following is clarify more.

	res = proc_dointvec_minmax(table, write, file, buffer, length, ppos);
	if (res)
		return res;
	if (!write)
		return 0;
	if (sysctl_drop_caches & ~3)
		return -EINVAL;
	if (sysctl_drop_caches & 1)
		drop_pagecache();
	if (sysctl_drop_caches & 2)
		drop_slab();
	return 0;


otherthings, _very_ looks good to me. :)



