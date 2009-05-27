Return-Path: <linux-kernel-owner+w=401wt.eu-S1751581AbZE0EM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbZE0EM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 00:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbZE0EMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 00:12:19 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49521 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbZE0EMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 00:12:18 -0400
Date: Tue, 26 May 2009 21:12:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TOMOYO: Add garbage collector support. (v2)
Message-ID: <20090527041218.GA6882@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200905041524.GGH52160.FFFVMSJOOLtHOQ@I-love.SAKURA.ne.jp> <200905062116.HCI09807.VOFFHFSMOLOtQJ@I-love.SAKURA.ne.jp> <200905142108.JIF10080.OOFHJVFtOSQMFL@I-love.SAKURA.ne.jp> <alpine.LRH.2.00.0905151146320.5937@tundra.namei.org> <200905162107.HCE17153.HLSFMtOOFVFOJQ@I-love.SAKURA.ne.jp> <200905250037.n4P0bFwe057503@www262.sakura.ne.jp> <200905250039.n4P0dSIE058041@www262.sakura.ne.jp> <200905250041.n4P0fVCT058575@www262.sakura.ne.jp> <20090527001613.GE7006@linux.vnet.ibm.com> <200905270125.n4R1PS0U031926@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905270125.n4R1PS0U031926@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 10:25:28AM +0900, Tetsuo Handa wrote:
> Hello.
> 
> Paul E. McKenney wrote:
> > The list_del_rcu() primitive is designed for removing elements from
> > lists that have concurrent readers, and it therefore avoids changing the
> > ->next pointer.  That said, I don't immediately see whether or not there
> > is some other reason you need to keep it on the list.  And do you need
> > the ->prev pointer to stay valid?  If not, you might be able to use it
> > in place of the ->is_deleted flag.
> 
> I don't need ->prev pointer.
> 
> > > Use of RCU does not help here because we need to keep the item valid as long as
> > > the item is referred by ->read_var1 or ->read_var2 or ->write_var1 .
> > 
> > You would indeed need some way of tracking those references.  One
> > approach is to make the RCU callback check to see if any of them
> > reference the to-be-deleted object, reposting itself if so.  This
> > approach assumes that such a reference is short-lived, of course.
> > 
> > If the ->read_var1 and other references are long-lived, could you
> > post an RCU callback when the last such reference was removed?
> 
> The reference stored in ->read_var1 / ->read_var2 / ->write_var1 are long-lived
> (it varies from less than one second to more than many hours).

Then one approach would be to check the ->is_deleted flag (or the
->prev pointer) when removing one of the ->read_varN references.
If the flag is set, and if no other ->read_varN references the same
object, post an RCU callback to clean it up.

Of course, when removing the object to start with, you could check
the references, and if none of them referenced the object, you could
post the callback immediately.

Or something similar.

> Well, it's time for me to read all Documentation/RCU/* .

I would also recommend the three-part LWN series as a starting point:

#       http://lwn.net/Articles/262464/ (What is RCU, Fundamentally?)
#       http://lwn.net/Articles/263130/ (What is RCU's Usage?)
#       http://lwn.net/Articles/264090/ (What is RCU's API?)

						Thanx, Paul
