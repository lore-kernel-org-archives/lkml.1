Return-Path: <linux-kernel-owner+w=401wt.eu-S1752240AbZHFBtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbZHFBtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 21:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbZHFBts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 21:49:48 -0400
Received: from mail-yw0-f183.google.com ([209.85.211.183]:33804 "EHLO
	mail-yw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZHFBts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 21:49:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=osfTElOCh1d7DUiJ7Hiq4iAvdXOLQe2anpOY02S6vZ4CZKM7AFcmTlHCF5JmIrn4Co
         K50mwWJzX6+NsOyoxGQHSUK4PZiSJxH1LlkQ8N5qrDwy7S6dEVTB6ZSw0qvKgL2w1349
         mJxPTglijf7pHdXahJN4WqmMQYeP7Fc8yf8PI=
Date: Thu, 6 Aug 2009 03:49:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 4/5] tracing/filters: Provide basic regex support
Message-ID: <20090806014941.GA24609@nowhere>
References: <1249111408-8657-1-git-send-email-fweisbec@gmail.com> <1249111408-8657-5-git-send-email-fweisbec@gmail.com> <4A76782E.4030803@cn.fujitsu.com> <20090805224709.GH5025@nowhere> <4A7A2E73.7030403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7A2E73.7030403@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 09:14:27AM +0800, Li Zefan wrote:
> Frederic Weisbecker wrote:
> > On Mon, Aug 03, 2009 at 01:39:58PM +0800, Li Zefan wrote:
> >> Frederic Weisbecker wrote:
> >>> This patch provides basic support for regular expressions in filters.
> >>> The common filter file doesn't support any regex but a new
> >>> filter_regex file is created for each subsystem/event.
> >>>
> >>> It supports the following types of regexp:
> >>>
> >>> - *match_beginning
> >>> - *match_middle*
> >>> - match_end*
> >>> - !don't match
> >>>
> >> I don't see why adding "filter_regex" is necessary, why not just make
> >> "filter" support regex?
> > 
> > I did that because I feared about people beeing unable to filter using
> > * as a real character inside a filter string.
> > If we are using only one file, we are forced to get the '*' interpreted.
> > That would also break the ABI.
> > 
> 
> I think we don't maintain stable ABI for debugfs and we've been changing
> the "ABI" in debugfs/tracing/, but of course we shouldn't change it
> without good reasons.


Yeah. May be I'm too much careful there but i prefer not to take the risk.

 
> One alternative is to use '"' to prevent '*' to be translated, but seems
> using "filter_regex" is more convenient, so I agree with this patch.


The problem is that most of the time, the '"' is about mandatory to delimit
a string.
Say you want to filter the lock name &REISERFS_SB(sb)->lock, you can't do that
by just typing:

echo name == &REISERFS_SB(sb)->lock > events/lockdep/filter

because the '&' character is considered as an operator and that will trigger
an error.
Instead you must type:

echo 'name == "&REISERFS_SB(sb)->lock"' > events/lockdep/filter

The '' are there to delimit the string for echo, and the "" are interpreted
by the filter api which take it as a whole string and not strings interleaved
with operators. I even fear - and > may be considered as operators if we omit
the "".

I also thought about using an antislash for those who don't want the * to
be interpreted. But although it seems intuitive, it's not as much as two
distinct and visible files.

Also, we can think about the fact the regexp support could be extended one
day if someone needs to. And we could then encounter even more ambiguous
characters such as $, ^, [, {, etc...

