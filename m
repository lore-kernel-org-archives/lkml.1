Return-Path: <linux-kernel-owner+w=401wt.eu-S1760660AbYGUGbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760660AbYGUGbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 02:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbYGUGba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 02:31:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56628 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbYGUGb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 02:31:29 -0400
Message-ID: <48842CDB.1090009@cn.fujitsu.com>
Date: Mon, 21 Jul 2008 14:29:47 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfs: use kstrdup()
References: <4881BEF4.2020201@cn.fujitsu.com> <20080719131317.GA7027@asus> <20080719131909.GB7027@asus> <20080721052713.GY28946@ZenIV.linux.org.uk>
In-Reply-To: <20080721052713.GY28946@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Sat, Jul 19, 2008 at 05:19:09PM +0400, Cyrill Gorcunov wrote:
>> [Cyrill Gorcunov - Sat, Jul 19, 2008 at 05:13:17PM +0400]
>> [...]
>> | | -			}
>> | | -		}
>> | | +		mnt->mnt_devname = kstrdup(name, GFP_KERNEL);
>> | |  	}
>> | |  	return mnt;
>> | |  }
>> | | -- 
>> | | 1.5.4.rc3
>> | | 
>> | | 
>> | 
>> | but kstrdup may return NULL - is it safe there?
>> | Sorry if that "not smart" question.
>> | 
>> | 		- Cyrill -
>>
>> ah, I see it is safe - sorry for noise
> 
> FWIW, it _is_ a good question.
> 
> 	* is all code treating ->mnt_devname as optional?  AFAICS, there's
> at least one place in NFS that doesn't.  We could treat failing allocation
> the same way we treat failing allocation of vfsmount itself - callers can
> cope with that already.

I just did a cleanup, and the original code didn't check for NULL.

I just looked into the git history, and I found out since fs/namespace.c was
created in v2.4.10.4, the code has never changed to check for failing
allocation of ->mnt_devname.

> 	* AFAICS, it should be const char *.

Agreed.

> 	* ... or perhaps we shouldn't copy it at all.  How about something
> like
> 	struct {
> 		int count;
> 		char name[];
> 	}
> with cloning sharing the reference and bumping the count, protecting it with
> e.g. vfsmount_lock?  For setups where we have a lot of bindings/namespaces
> it might be noticable.
> 

I'm not sure whether this is a good idea, as I have limited knowledge about the
vfs internal.


