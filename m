Return-Path: <linux-kernel-owner+w=401wt.eu-S1759282AbYBZAoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282AbYBZAoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 19:44:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbYBZAny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 19:43:54 -0500
Received: from phunq.net ([64.81.85.152]:59055 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750779AbYBZAnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 19:43:53 -0500
From: Daniel Phillips <phillips@phunq.net>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 00/37] Permit filesystem local caching
Date: Mon, 25 Feb 2008 16:43:14 -0800
User-Agent: KMail/1.9.5
Cc: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
References: <200802251401.16413.phillips@phunq.net> <17916.1203636833@redhat.com> <22888.1203981562@redhat.com>
In-Reply-To: <22888.1203981562@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802251643.16631.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 February 2008 15:19, David Howells wrote:
> So I guess there's a problem in cachefiles's efficiency - possibly due
> to the fact that it tries to be fully asynchronous.

OK, not just my imagination, and it makes me feel better about the patch 
set because efficiency bugs are fixable while fundamental limitations 
are not.

How much of a hurry are you in to merge this feature?  You have bits 
like this:

"Add a function to install a monitor on the page lock waitqueue for a 
particular page, thus allowing the page being unlocked to be detected.
This is used by CacheFiles to detect read completion on a page in the 
backing filesystem so that it can then copy the data to the waiting 
netfs page."

We already have that hook, it is called bio_endio.  My strong intuition 
is that your whole mechanism should sit directly on the block device, 
no matter how attractive it seems to be able to piggyback on the 
namespace and layout management code of existing filesystems.  I see 
your current effort as the moral equivalent of FUSE: you are able to 
demonstrate certain desirable behavioral properties, but you are unable 
to reach full theoretical efficiency because there are layers and 
layers of interface gunk interposed between the netfs user and the 
cache device.

That said, I also see you have put a huge amount of work into this over 
the years, it is nicely broken out, you are responsive and easy to work 
with, all arguments for an early merge.  Against that, you invade core 
kernel for reasons that are not necessarily justified:

  * two new page flags
  * a new fileops method
  * many changes to LSM including new object class and new hooks
  * separate fs*id from task struct
  * new page-private destructor hook
  * probably other bits I missed

Would it be correct to say that some of these changes are to support 
disconnected operation?  If so, you really have two patch sets:

  1) Persistent netfs cache
  2) Disconnected netfs operation

You have some short snappers that look generally useful:

  * add_wait_queue_tail (cool)
  * write to a file without a struct file (includes ->mapping cleanup,
    probably good)
  * export fsync_super

Why not hunt around for existing in-kernel users that would benefit so 
these can be submitted as standalone patches, shortening the remaining 
patch set and partially overcoming objections due to core kernel 
changes?

One thing I don't see is users coming on to lkml and saying "please 
merge this, it works great for me".  Since you probably have such 
users, why not give them a poke? 

Your cachefilesd is going to need anti-deadlock medicine like ddsnap 
has.  Since you don't seem at all worried about that right now, I 
suspect you have not hammered this code really heavily, correct?  
Without preventative measures, any memory-using daemon sitting in the 
block IO path will deadlock if you hit it hard enough.

A couple of years ago you explained the purpose of the new page flags to 
me and there is no way I can find that email again.  Could you explain 
it again please?  Meanwhile I am doing my duty and reading your OLS 
slides etc.

Regards,

Daniel
