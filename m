Return-Path: <linux-kernel-owner+w=401wt.eu-S1765260AbXJQGTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765260AbXJQGTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 02:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756610AbXJQGTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 02:19:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:62528 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbXJQGTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 02:19:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=ThrFC3mkD6mlsOBvPwXcIgPfsCPsL6UYVLFyhV5qdWfAMpt2FkXlbbIo7hkf/KJN8RgeD6/M4KcFCTA42JinEKSxHPQAkhJXJGJItOIDlrZAhNJr4uzaQqeqCpjgGAKSfEDkAf3mxEVSJMXfGh3lqice6NIUs1Rltg43Y1TpX28=
Message-ID: <4715A8A2.7020108@gmail.com>
Date: Wed, 17 Oct 2007 08:16:02 +0200
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Michael Kerrisk <mtk-manpages@gmx.net>,
       lkml <linux-kernel@vger.kernel.org>,
       Subrata Modak <subrata@linux.vnet.ibm.com>, geoff@gclare.org.uk,
       Christoph Hellwig <hch@lst.de>
Subject: Re: Revised signalfd man-page
References: <46FB9FB9.8080201@gmx.net> <Pine.LNX.4.64.0709271000420.763@alien.or.mcafeemobile.com> <47130EA1.6000300@gmail.com> <Pine.LNX.4.64.0710151103591.5204@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0710151103591.5204@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

Davide Libenzi wrote:
> On Mon, 15 Oct 2007, Michael Kerrisk wrote:
> 
>> Hi Davide,
>>
>> There were two questions that you overlooked in my earlier draft of the
>> signalfd man page.  I've revised one of the questions slightly.  Could you
>> look at these please:
> 
> I think I already answered those, no? Anyway ...

Oops -- if you did, I lost a little context.  (However, what you say below
does give me a sense of deja vu ;-).)

Can you please check my notes below:

>> .SS execve(2) semantics
>> [TO BE COMPLETED]
>> .\" FIXME
>> .\" Davide, what are the intended semantics after an execve()?
>> .\" I would hope that the descriptor remains available, and can
>> .\" be used to read any queued signals.  This is analogous with
>> .\" traditional behavior, where blocked signals that are pending
>> .\" prior to an execve() remain pending after the execve().
>> .\"
>> .\" Below, was my original question, based on how things
>> .\" worked at one point, but perhaps they have changed by now:
>> .\"===
>> .\" As far as I can work out, after an execve() the file descriptor
>> .\" is still available, but reads from it always return 0, even if:
>> .\"
>> .\" a) there were signals pending before the execve().
>> .\"    However, sigpending() shows the signal as pending,
>> .\"    and the signal can be accepted using sigwaitinfo().
>> .\"
>> .\" b) we generate the signal after the exec.
>> .\"
>> .\" Is this intended behavior (the "orphaned sighand" condition
>> .\" described above?)?  Is it a bug?
> 
> With the new code Linus already merged, signalfd does not attach to the 
> sighand anymore, so the "orphaned sighand" behaviour is no more there.
> An exec() will carry the fd over, and you will be able to use the fd in 
> the same way you did before the exec(). If sigpending()/sigwaitinfo() will 
> show signals available, so it should signalfd.

So I wrote:

   execve(2) semantics
       Just  like  any  other  file  descriptor, a signalfd file
       descriptor remains open across an  execve(2),  unless  it
       has  been  marked  for close-on-exec (see fcntl(2)).  Any
       signals  that  were  available  for  reading  before  the
       execve(2)  remain  available to the newly loaded program.
       (This is analogous to traditional signal semantics, where
       a  blocked  signal that is pending remains pending across
       an execve(2).)  (This is analogous to traditional  signal
       semantics, where a blocked signal that is pending remains
       pending across an execve(2).)

Okay?

>> .SS Thread semantics
>> [TO BE COMPLETED]
>> .\" FIXME Davide, a signal can be directed to the process as
>> .\" a whole, or to a particular thread.  What are the intended
>> .\" semantics for signalfd()?  If a thread calls signalfd(),
>> .\" does the resulting file descriptor return just those
>> .\" signals directed to [the thread and the process as a whole],
>> .\" or will it also receive signals that are targeted at
>> .\" other threads in the process?
> 
> It'll return the signals that would be normally returned to the thread 
> with the standard signal delivery methods. That is, calling thread private 
> signals, and calling thread-group shared signals.

So I wrote:

   Thread semantics
       The semantics of signalfd file descriptors  in  a  multi-
       threaded  program  mirror the standard semantics for sig-
       nals.  In other words, when a thread reads  from  a  sig-
       nalfd  file descriptor, it will read the signals that are
       directed to the thread itself and the  signals  that  are
       directed  to the process (i.e., the entire thread group).
       (A thread will not be  able  to  read  signals  that  are
       directed to other threads in the process.)

Okay?

Cheers,

Michael

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.

