Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbZFBA56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbZFBA56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 20:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbZFBA5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 20:57:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54732 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbZFBA5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 20:57:51 -0400
Date: Mon, 1 Jun 2009 20:03:49 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: serue@us.ibm.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TOMOYO: Add garbage collector support. (v2)
Message-ID: <20090602010349.GB20977@hallyn.com>
References: <alpine.LRH.2.00.0905151146320.5937@tundra.namei.org> <200905162107.HCE17153.HLSFMtOOFVFOJQ@I-love.SAKURA.ne.jp> <200905250037.n4P0bFwe057503@www262.sakura.ne.jp> <200905250039.n4P0dSIE058041@www262.sakura.ne.jp> <200905250041.n4P0fVCT058575@www262.sakura.ne.jp> <200906012227.FDE64040.MVQLOStOHFOFFJ@I-love.SAKURA.ne.jp> <20090602001137.GA20880@hallyn.com> <200906020030.n520UU1D087893@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906020030.n520UU1D087893@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@i-love.sakura.ne.jp):
> Serge E. Hallyn wrote:
> > Can't you just move the deleted item from the live list to some dead
> > list, using the same ->list list_head?
> 
> I think I can't. If we do list_add(&p->entry.list, &dead_list) after
> list_del_rcu(&p->entry.list) when p->entry.users != 0, p->entry.list.next will
> point to an element on dead list. And reader will no longer be able to resume
> travarsal on the live list.

Use rcu?  Take your spinlock, take entry off the list, wait an rcu cycle,
then move to the dead_list.

All readers should walk the list under rcu_read_lock, so if the manage
to reach ->entry, then entry.list->next will be a valid entry on the live
list until the next rcu cycle.

BTW I'm not telling you have to do this, so if you just don't want to, then
just say so.  But so long as you come back to me with technical reasons
why you can't, then I take it you're interested in a technical solution :)
and can't help but respond...

-serge
