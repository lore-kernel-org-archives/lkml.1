Return-Path: <linux-kernel-owner+w=401wt.eu-S1751317AbZH1OSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbZH1OSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 10:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbZH1OSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 10:18:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbZH1OSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 10:18:51 -0400
Subject: Re: [PATCH] inotify:  Ensure we alwasy write the terminating NULL.
From: Eric Paris <eparis@redhat.com>
To: Brian Rogers <brian@xyzw.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <4A97DBC1.3000508@xyzw.org>
References: <m1skffj64t.fsf@fess.ebiederm.org>
	 <1251299483.2308.32.camel@dhcp231-106.rdu.redhat.com>
	 <m1iqg9k17v.fsf_-_@fess.ebiederm.org>  <4A97DBC1.3000508@xyzw.org>
Content-Type: text/plain
Date: Fri, 28 Aug 2009 10:18:31 -0400
Message-Id: <1251469111.2947.12.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-28 at 06:29 -0700, Brian Rogers wrote:
> Eric W. Biederman wrote:
> > Before the rewrite copy_event_to_user always wrote a terqminating '\0'
> > byte to user space after the filename.  Since the rewrite that
> > terminating byte was skipped if your filename is exactly a multiple of
> > event_size.  Ouch!
> >
> > So add one byte to name_size before we round up and use clear_user to
> > set userspace to zero like /dev/zero does instead of copying the
> > strange nul_inotify_event.  I can't quite convince myself len_to_zero
> > will never exceed 16 and even if it doesn't clear_user should be more
> > efficient and a more accurate reflection of what the code is trying to
> > do.
> >
> > Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> >   
> 
> I found that this change prevents my Ubuntu Karmic system from booting. 
> It just idles forever very early in the process. Probably a boot script 
> is waiting for an event that it doesn't receive properly.
> 
> > -	name_len = roundup(event->name_len, event_size);
> > +	name_len = roundup(event->name_len + 1, event_size);
> >   
> 
> This means the test later on will now always evaluate to true:
> > if (name_len) {
> 
> And in cases where that test previously would have failed, the code now 
> outputs a block full of zeros. Assuming that's bad and the test was 
> important, I coded the attached naive fix, which is working for me.

Thanks, I ask Linus to pull a (slightly modified) version.  Don't know
if he'll get it before he runs out on vacation.  Here's hoping.

-Eric

