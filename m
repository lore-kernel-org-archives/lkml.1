Return-Path: <linux-kernel-owner+w=401wt.eu-S1753332AbYFXEpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbYFXEpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 00:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYFXEpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 00:45:41 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:32919 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbYFXEpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 00:45:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=oLzSnzTDyMscKYpTvRmpN9OIjFeiBO0hxKOhDEx7TmZUzK//NyHKkpD8uUMmVETeSv
         3eLoBHArY3bd3Zfc4w2fiNK3MqyWd+vqjs/7yHNkNVJReGdMqlHh8PPvkx4g7PlLw9eI
         RWWfKMUNEtc7VI6kIg5iX6KAuiHe0Cdq0jjSs=
Message-ID: <48607BE7.2060203@gmail.com>
Date: Tue, 24 Jun 2008 13:45:27 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Daniel Lezcano <dlezcano@fr.ibm.com>
CC: Benjamin Thery <benjamin.thery@bull.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Biederman <ebiederm@xmission.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 05/11] sysfs: sysfs_chmod_file handle multiple superblocks
References: <20080618170729.808539948@theryb.frec.bull.fr> <20080618170730.853353875@theryb.frec.bull.fr> <485DD93A.6020600@gmail.com> <486018CB.80005@fr.ibm.com>
In-Reply-To: <486018CB.80005@fr.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Daniel Lezcano wrote:
>> I think it would be great if sysfs_chmod_file can do all-or-nothing
>> instead of failing half way through but given the interface of
>> notify_change(), it could be difficult to implement.  Any ideas?
> 
> Is it acceptable to queue the notifications in a list until we are in
> the loop and loop again to notify when exiting the first loop without
> error ?

Can you please take a look at the following patch?

http://article.gmane.org/gmane.linux.file-systems/24484

Which replaces notify_change() call to two calls to sysfs_setattr() and
fsnotify_change().  The latter never fails and the former should always
succeed if inode_change_ok() succeeds (inode_setattr() never fails
unless the size is changing), so I think the correct thing to do is...

* Separate out sysfs_do_setattr() which doesn't do inode_change_ok() and
just sets the attributes.  Making it a void function which triggers
WARN_ON() when inode_setattr() fails would be a good idea.

* Implement sysfs_chmod_file() in similar way rename/move are
implemented - allocate all resources and check conditions and then iff
everything looks okay commit the operation by calling sysfs_do_setattr().

How does that sound?

Thanks.

-- 
tejun
