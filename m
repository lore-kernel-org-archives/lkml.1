Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbYKXO0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbYKXO0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 09:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYKXO0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 09:26:35 -0500
Received: from ns.suse.de ([195.135.220.2]:34028 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbYKXO0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 09:26:34 -0500
Message-ID: <492AB98C.7030105@suse.de>
Date: Mon, 24 Nov 2008 23:26:20 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>,
       Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/2] md: make devices disappear when they are no longer
 needed.
References: <20081124035516.3465.66413.stgit@notabene.brown> <20081124035530.3465.26724.stgit@notabene.brown> <492A2B2B.7030606@kernel.org> <18730.14324.830648.449469@notabene.brown> <492A3CE6.4010206@kernel.org> <20081124062417.GZ28946@ZenIV.linux.org.uk> <492A500C.9090200@kernel.org> <20081124133124.GB28946@ZenIV.linux.org.uk> <492AB480.5060207@kernel.org>
In-Reply-To: <492AB480.5060207@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Can we then make gendisk hold owner module till it gets released?  It
> would be much nicer to write code to if we can keep the regular object
> reference counting across module boundaries and being able to taking
> down a module while devices are active isn't a too important
> requirement.  For vast majoerity (ide, scsi, md) one way or the other
> doesn't even matter at all.

If always holding reference is too much of a change, we can do

	if (gendisk->fops->disk_release) {
		__module_get(gendisk->fops->owner);
		gendisk->fops->disk_release(gendisk);
		module_put(gendisk->fops->owner);
	}

So that both parties - drivers which can happily unregister devices
during exit and drivers which want to do reference counting across
module boundaries - can be happy.

Thanks.

-- 
tejun
