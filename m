Return-Path: <linux-kernel-owner+w=401wt.eu-S932479AbZDCOdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479AbZDCOdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765509AbZDCOd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:33:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:45700 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbZDCOd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:33:27 -0400
Subject: Re: [PATCH] make inotify event handles use GFP_NOFS
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, balbir@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
       aviro@redhat.com
In-Reply-To: <1238448816.4073.265.camel@laptop>
References: <1237400852.26799.16.camel@localhost.localdomain>
	 <20090330142610.4b94935d.akpm@linux-foundation.org>
	 <1238448816.4073.265.camel@laptop>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 03 Apr 2009 16:34:00 +0200
Message-Id: <1238769240.798.110.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-30 at 23:33 +0200, Peter Zijlstra wrote:
> On Mon, 2009-03-30 at 14:26 -0700, Andrew Morton wrote:
> > On Wed, 18 Mar 2009 14:27:32 -0400
> > Eric Paris <eparis@redhat.com> wrote:
> > 
> > > I think this is a bandaide to shut up lockdep.  I could either figure
> > > out lockdep classes and figure out how to reclassify inotify locks since
> > > I believe Nick is correct when he says inotify watches pin the inode in
> > > core so memory pressure can't evict it.
> > 
> > It's pretty sad to degrading the strength of the memory allocation just
> > to squish a lockdep report.
> 
> Yeah, I agree, its the wrong thing to do. lockdep annotations really
> aren't that hard -- also, you could also talk me through it.

static struct lock_class_key inotify_mutex_free;


     /*
      * here the inotify mutex gets moved to a different
      * data structure with different locking semantics while
      * holding inotify_mutex.
      */
     lock_set_class(&foo->inotify_mutex.dep_map, "inotify_mutex_free",
                     &inotify_mutex_free, 0, _THIS_IP_);


Or when done without holding the inotify_mutex


     /*
      * here the inotify mutex gets moved to a different
      * data structure with different locking semantics.
      */
     lockdep_set_class(&foo->inotify_mutex, &inotify_mutex_free);


Is all there should be to it.
