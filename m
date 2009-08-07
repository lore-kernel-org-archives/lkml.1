Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbZHGEO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbZHGEO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 00:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbZHGEO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 00:14:58 -0400
Received: from mail-yw0-f177.google.com ([209.85.211.177]:65102 "EHLO
	mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbZHGEO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 00:14:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KwFiFe2VqyX7vQj3LpHosWDl+d7BJz2A2PhK7DeIXsLtqEwD0IUvjSsBWfu6nhCkGJ
         WgjlZGRIy06q+HFRNEkydXXC/wKxeFDUgzyPbwhQTU5RNBbfNrngwZxOFSr06Z5froS5
         JppYrkPkjEiDu/0o8P2C3rOd64/5BelHLG17Q=
Subject: Re: [RFC][PATCH 4/5] tracing/filters: Provide basic regex support
From: Tom Zanussi <tzanussi@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20090806014941.GA24609@nowhere>
References: <1249111408-8657-1-git-send-email-fweisbec@gmail.com>
	 <1249111408-8657-5-git-send-email-fweisbec@gmail.com>
	 <4A76782E.4030803@cn.fujitsu.com> <20090805224709.GH5025@nowhere>
	 <4A7A2E73.7030403@cn.fujitsu.com>  <20090806014941.GA24609@nowhere>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 23:14:57 -0500
Message-Id: <1249618497.30024.36.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On Thu, 2009-08-06 at 03:49 +0200, Frederic Weisbecker wrote:
> On Thu, Aug 06, 2009 at 09:14:27AM +0800, Li Zefan wrote:
> > Frederic Weisbecker wrote:
> > > On Mon, Aug 03, 2009 at 01:39:58PM +0800, Li Zefan wrote:
> > >> Frederic Weisbecker wrote:
> > >>> This patch provides basic support for regular expressions in filters.
> > >>> The common filter file doesn't support any regex but a new
> > >>> filter_regex file is created for each subsystem/event.
> > >>>
> > >>> It supports the following types of regexp:
> > >>>
> > >>> - *match_beginning
> > >>> - *match_middle*
> > >>> - match_end*
> > >>> - !don't match
> > >>>
> > >> I don't see why adding "filter_regex" is necessary, why not just make
> > >> "filter" support regex?
> > > 
> > > I did that because I feared about people beeing unable to filter using
> > > * as a real character inside a filter string.
> > > If we are using only one file, we are forced to get the '*' interpreted.
> > > That would also break the ABI.
> > > 
> > 
> > I think we don't maintain stable ABI for debugfs and we've been changing
> > the "ABI" in debugfs/tracing/, but of course we shouldn't change it
> > without good reasons.
> 
> 
> Yeah. May be I'm too much careful there but i prefer not to take the risk.
> 
>  
> > One alternative is to use '"' to prevent '*' to be translated, but seems
> > using "filter_regex" is more convenient, so I agree with this patch.
> 
> 
> The problem is that most of the time, the '"' is about mandatory to delimit
> a string.
> Say you want to filter the lock name &REISERFS_SB(sb)->lock, you can't do that
> by just typing:
> 
> echo name == &REISERFS_SB(sb)->lock > events/lockdep/filter
> 
> because the '&' character is considered as an operator and that will trigger
> an error.
> Instead you must type:
> 
> echo 'name == "&REISERFS_SB(sb)->lock"' > events/lockdep/filter
> 
> The '' are there to delimit the string for echo, and the "" are interpreted
> by the filter api which take it as a whole string and not strings interleaved
> with operators. I even fear - and > may be considered as operators if we omit
> the "".
> 
> I also thought about using an antislash for those who don't want the * to
> be interpreted. But although it seems intuitive, it's not as much as two
> distinct and visible files.
> 
> Also, we can think about the fact the regexp support could be extended one
> day if someone needs to. And we could then encounter even more ambiguous
> characters such as $, ^, [, {, etc...
> 

This a nice new feature - I considered doing it (not complete regexp
support, just * in strings) for the original patch, but ran out of time
- glad you added it.

I still think it makes sense to have some basic support for * in the
regular filter file, so I'd vote for getting rid of the filter_regex
file for now and just adding * support with the antislash escape to the
regular filter file.  If you later wanted to add more full-fledged
regexp support and it didn't make sense to do it in the regular filter
file, then you could go crazy and add the filter_regex later...

Thanks,

Tom 

