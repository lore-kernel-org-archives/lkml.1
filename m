Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbZGAT1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbZGAT1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 15:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbZGAT1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 15:27:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32892 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbZGAT1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 15:27:22 -0400
Message-ID: <4A4BB898.10909@redhat.com>
Date: Wed, 01 Jul 2009 14:27:20 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Amerigo Wang <amwang@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Eugene Teo <eteo@redhat.com>, viro@zeniv.linux.org.uk,
       Eric Paris <eparis@redhat.com>
Subject: Re: [Patch] allow file truncations when both suid and write permissions
 set
References: <20090625090146.6616.9720.sendpatchset@localhost.localdomain> <4A4BA6F8.7090905@redhat.com>
In-Reply-To: <4A4BA6F8.7090905@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Amerigo Wang wrote:
>> When suid is set and the non-owner user has write permission,
>> any writing into this file should be allowed and suid should be
>> removed after that.
>>
>> However, current kernel only allows writing without truncations,
>> when we do truncations on that file, we get EPERM. This is a bug.

...

> So I think the main problem here is simply that we didn't set
> ATTR_FORCE, right...
> 
> Seems a little odd to |= with ret, -then- check if it's non-0.  Maybe:
> 
>  	/* Remove suid/sgid on truncate too */
> -	newattrs.ia_valid |= should_remove_suid(dentry);
> +	ret = should_remove_suid(dentry);
> +	if (ret)
> +		newattrs.ia_valid |= (ret | ATTR_FORCE);
> 

On second thought, and after talking w/ eparis, I think this probably
needs a security_inode_killpriv() too... it seems like it might be best
to change file_remove_suid(*file) to dentry_remove_suid(*dentry) and
just call that from do_truncate()?

-Eric
