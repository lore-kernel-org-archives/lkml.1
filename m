Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbYHNCbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbYHNCbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 22:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYHNCbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 22:31:00 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:25344 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040AbYHNCbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 22:31:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiADAIc1o0h5LAMbiGdsb2JhbACRcwEBAQ8gpAOBVQ
X-IronPort-AV: E=Sophos;i="4.32,205,1217773800"; 
   d="scan'208";a="181718684"
Date: Thu, 14 Aug 2008 12:30:54 +1000
From: Dave Chinner <david@fromorbit.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, matthew@wil.cx
Subject: Re: [PATCH 4/6] Replace inode flush semaphore with a completion
Message-ID: <20080814023054.GH6119@disturbed>
Mail-Followup-To: Daniel Walker <dwalker@mvista.com>, xfs@oss.sgi.com,
	linux-kernel@vger.kernel.org, matthew@wil.cx
References: <1214556284-4160-1-git-send-email-david@fromorbit.com> <1214556284-4160-5-git-send-email-david@fromorbit.com> <1218597077.6166.15.camel@dhcp32.mvista.com> <20080813075057.GZ6119@disturbed> <1218641641.6166.32.camel@dhcp32.mvista.com> <20080814001938.GC6119@disturbed> <1218677690.6166.51.camel@dhcp32.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218677690.6166.51.camel@dhcp32.mvista.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 06:34:49PM -0700, Daniel Walker wrote:
> On Thu, 2008-08-14 at 10:19 +1000, Dave Chinner wrote:
> > *However*, given that we already have this exact state in the
> > completion itself, I see little reason for adding the additional
> > locking overhead and the complexity of race conditions of keeping
> > this state coherent with the completion. Modifying the completion
> > API slightly to export this state is the simplest, easiest solution
> > to the problem....
> > 
> 
> I'm not suggesting anything concrete at this point, I'm just thinking
> about it.
> 
> If you assume that most of the time your doing async flushing, you
> wouldn't often need to do blocking on the completion .. Another way of
> doing it would be drop the completion most of the time, and just use the
> flag.

I don't think that will work, either - the internal completion
counter must stay in sync so there must be a wait_for_completion()
call for every complete() call. If we make the wait_for_completion()
conditional, then we have to do the same thing for the complete()
call, and that introduces complexity and potential races because the
external flag and the completion cannot be updated atomically....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
