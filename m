Return-Path: <linux-kernel-owner+w=401wt.eu-S1761061AbZANKTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761061AbZANKTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755736AbZANKTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:19:36 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:40170 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956AbZANKTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:19:34 -0500
Date: Wed, 14 Jan 2009 11:19:08 +0100
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, tj@kernel.org, gregkh@suse.de,
       stern@rowland.harvard.edu, jens.axboe@oracle.com,
       hinko.kocevar@cetrtapot.si
Subject: Re: lib/klist.c: bit 0 in pointer can't be used as flag
Message-ID: <20090114101908.GF19262@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <195c7a900901131511l7077eebar8396267e3f2b670b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 12:11:32AM +0100, Bastien ROUCARIES wrote:
> On Tue, Jan 13, 2009 at 11:45 PM, David Miller <davem@davemloft.net> wrote:
> > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Date: Wed, 14 Jan 2009 07:40:19 +0900
> >
> >> > It may be that we've worked around the other spots, although I haven't
> >> > seen anything like that, we might just have been lucky until now.
> >> >
> >> > Can you recall another place where this trick is used?
> >>
> >> rmap.
> >> Don't CRIS use mmu?
> >
> > I'm beginning to suspect the issue is only with objects
> > in the kernel image itself.  Dynamically allocated memory
> > is properly aligned and therefore the "low bit status bits
> > in pointer" trick works.
> Perhaps using a pointerhackalign trick on this structure where
> #define pointerhackalign(x) __attribute__ ((aligned (x)))
> and declare
> struct klist_node {
> ...
> }  pointerhackalign(2);
> 
> Because  __attribute__ ((aligned (x))) could only increase alignment
> it will safe to do that and serve as documentation purpose :)

That works, but we need to do it not for the struct klist_node,
but for the struct we insert into the void * in klist_node,
which is struct klist.

The following patch works for CRIS, and is less intrusive than
my earlier patch. If this the way to go I can resubmit a proper patch.

diff --git a/include/linux/klist.h b/include/linux/klist.h
index 8ea98db..a21cd7a 100644
--- a/include/linux/klist.h
+++ b/include/linux/klist.h
@@ -23,7 +23,7 @@ struct klist {
 	struct list_head	k_list;
 	void			(*get)(struct klist_node *);
 	void			(*put)(struct klist_node *);
-};
+} __attribute__ ((aligned (4)));
 
 #define KLIST_INIT(_name, _get, _put)					\
 	{ .k_lock	= __SPIN_LOCK_UNLOCKED(_name.k_lock),		\

> Regards
> 
> Bastien

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
