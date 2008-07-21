Return-Path: <linux-kernel-owner+w=401wt.eu-S1760215AbYGUF10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215AbYGUF10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 01:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbYGUF1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 01:27:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52292 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbYGUF1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 01:27:18 -0400
Date: Mon, 21 Jul 2008 06:27:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfs: use kstrdup()
Message-ID: <20080721052713.GY28946@ZenIV.linux.org.uk>
References: <4881BEF4.2020201@cn.fujitsu.com> <20080719131317.GA7027@asus> <20080719131909.GB7027@asus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080719131909.GB7027@asus>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 05:19:09PM +0400, Cyrill Gorcunov wrote:
> [Cyrill Gorcunov - Sat, Jul 19, 2008 at 05:13:17PM +0400]
> [...]
> | | -			}
> | | -		}
> | | +		mnt->mnt_devname = kstrdup(name, GFP_KERNEL);
> | |  	}
> | |  	return mnt;
> | |  }
> | | -- 
> | | 1.5.4.rc3
> | | 
> | | 
> | 
> | but kstrdup may return NULL - is it safe there?
> | Sorry if that "not smart" question.
> | 
> | 		- Cyrill -
> 
> ah, I see it is safe - sorry for noise

FWIW, it _is_ a good question.

	* is all code treating ->mnt_devname as optional?  AFAICS, there's
at least one place in NFS that doesn't.  We could treat failing allocation
the same way we treat failing allocation of vfsmount itself - callers can
cope with that already.
	* AFAICS, it should be const char *.
	* ... or perhaps we shouldn't copy it at all.  How about something
like
	struct {
		int count;
		char name[];
	}
with cloning sharing the reference and bumping the count, protecting it with
e.g. vfsmount_lock?  For setups where we have a lot of bindings/namespaces
it might be noticable.

Any takers?
