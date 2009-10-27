Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442AbZJ0GzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbZJ0GzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 02:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbZJ0GzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 02:55:22 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:55473 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330AbZJ0GzV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 02:55:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IlmCFRXvZUqFwK/4+Sv5q9/EhLkZLXyHvG0hpEZ0w32KFZZHAnx70bG/kihgXqp1UL
         lX/ErqMC9iZk0AtHaRjWT28GLlet9fdM27PKhsQ8I6ltoLYfkUZbEqYqIQC3+Vi6lyf2
         Sa0LuWC+RDJGGJLkxUe3OfUxc1zEPkx2MT26Q=
MIME-Version: 1.0
In-Reply-To: <20091027153626.c5a4b5be.kamezawa.hiroyu@jp.fujitsu.com>
References: <hav57c$rso$1@ger.gmane.org> <hb2cfu$r08$2@ger.gmane.org>
	 <20091014135119.e1baa07f.kamezawa.hiroyu@jp.fujitsu.com>
	 <4ADE3121.6090407@gmail.com>
	 <20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com>
	 <4AE5CB4E.4090504@gmail.com>
	 <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com>
	 <2f11576a0910262310g7aea23c0n9bfc84c900879d45@mail.gmail.com>
	 <20091027153429.b36866c4.minchan.kim@barrios-desktop>
	 <20091027153626.c5a4b5be.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 27 Oct 2009 15:55:26 +0900
Message-ID: <28c262360910262355p3cac5c1bla4de9d42ea67fb4e@mail.gmail.com>
Subject: Re: Memory overcommit
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, vedran.furac@gmail.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 3:36 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 27 Oct 2009 15:34:29 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> On Tue, 27 Oct 2009 15:10:52 +0900
>> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>>
>> > 2009/10/27 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
>> > > On Mon, 26 Oct 2009 17:16:14 +0100
>> > > Vedran Furač <vedran.furac@gmail.com> wrote:
>> > >> >  - Could you show me /var/log/dmesg and /var/log/messages at OOM ?
>> > >>
>> > >> It was catastrophe. :) X crashed (or killed) with all the programs, but
>> > >> my little program was alive for 20 minutes (see timestamps). And for
>> > >> that time computer was completely unusable. Couldn't even get the
>> > >> console via ssh. Rally embarrassing for a modern OS to get destroyed by
>> > >> a 5 lines of C run as an ordinary user. Luckily screen was still alive,
>> > >> oomk usually kills it also. See for yourself:
>> > >>
>> > >> dmesg: http://pastebin.com/f3f83738a
>> > >> messages: http://pastebin.com/f2091110a
>> > >>
>> > >> (CCing to lklm again... I just want people to see the logs.)
>> > >>
>> > > Thank you for reporting and your patience. It seems something strange
>> > > that your KDE programs are killed. I agree.
>> > >
>> > > I attached a scirpt for checking oom_score of all exisiting process.
>> > > (oom_score is a value used for selecting "bad" processs.")
>> > > please run if you have time.
>> > >
>> > > This is a result of my own desktop(on virtual machine.)
>> > > In this environ (Total memory is 1.6GBytes), mmap(1G) program is running.
>> > >
>> > > %check_badness.pl | sort -n | tail
>> > > --
>> > > 89924   3938    mixer_applet2
>> > > 90210   3942    tomboy
>> > > 94753   3936    clock-applet
>> > > 101994  3919    pulseaudio
>> > > 113525  4028    gnome-terminal
>> > > 127340  1       init
>> > > 128177  3871    nautilus
>> > > 151003  11515   bash
>> > > 256944  11653   mmap
>> > > 425561  3829    gnome-session
>> > > --
>> > > Sigh, gnome-session has twice value of mmap(1G).
>> > > Of course, gnome-session only uses 6M bytes of anon.
>> > > I wonder this is because gnome-session has many children..but need to
>> > > dig more. Does anyone has idea ?
>> > > (CCed kosaki)
>> >
>> > Following output address the issue.
>> > The fact is, modern desktop application linked pretty many library. it
>> > makes bloat VSS size and increase
>> > OOM score.
>> >
>> > Ideally, We shouldn't account evictable file-backed mappings for oom_score.
>> >
>> Hmm.
>> I wonder why we consider VM size for OOM kiling.
>> How about RSS size?
>>
>
> Maybe the current code assumes "Tons of swap have been generated, already" if
> oom-kill is invoked. Then, just using mm->anon_rss will not be correct.
>
> Hm, should we count # of swap entries reference from mm ?....

In Vedran case, he didn't use swap. So, Only considering vm is the problem.
I think it would be better to consider both RSS + # of swap entries as
Kosaki mentioned.


>
> Regards,
> -Kame
>
>
>



-- 
Kind regards,
Minchan Kim
