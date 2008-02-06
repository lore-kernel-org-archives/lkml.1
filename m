Return-Path: <linux-kernel-owner+w=401wt.eu-S1762630AbYBFXfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762630AbYBFXfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760349AbYBFXfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:35:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760239AbYBFXfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:35:12 -0500
Message-ID: <47AA440F.8030403@redhat.com>
Date: Wed, 06 Feb 2008 17:34:39 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reduce large do_mount stack usage with noinlines
References: <47AA3126.8090102@redhat.com>	<20080206143457.03e8741d.akpm@linux-foundation.org>	<47AA3EAA.9080204@redhat.com> <20080206152239.a2352d6d.akpm@linux-foundation.org>
In-Reply-To: <20080206152239.a2352d6d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 06 Feb 2008 17:11:38 -0600
> Eric Sandeen <sandeen@redhat.com> wrote:
> 
>>  /*
>>   * recursively change the type of the mountpoint.
>> + * noinline this do_mount helper to save do_mount stack space.
>>   */
>> -static int do_change_type(struct nameidata *nd, int flag)
>> +static noinline int do_change_type(struct nameidata *nd, int flag)
> 
> What we could do here is defined a new noinline_because_of_stack_suckiness
> and use that.  Reasons:
> 
> - self-documenting, so we don't need to comment each site
> 
> - can be made a no-op for suitable __GNUC__ values if gcc ever fixes this
> 
> - our children we can go through and delete them all when nobody is using
>   the offending gcc versions any more.
> 
> what thinkest thou?

Yes, sounds very good to me.  I'm sure there are more places which could
use this.

Or perhaps there are some magic flags to gcc so that it doesn't inline
so aggressively in situations like this?  IOW is it gcc breakage, or
design - but maybe with defaults that don't fit well in the limited
stack... (well, I suppose the "for N mutually exclusive helper functions
each with stack usage S, use about N*S stack when inlining them all" bit
probably isn't a feature.)

FWIW the XFS team finally just wrested control from GCC.
http://oss.sgi.com/archives/xfs/2006-11/msg00195.html

-Eric
