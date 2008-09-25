Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbYIYPdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbYIYPdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 11:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbYIYPdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 11:33:07 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:47622 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbYIYPdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 11:33:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DkaPFModptfHYfUATk/zfOan5zJwZ7008iYaGh6ViZrePXquXwTGf/NTSfuBA/YSgI
         3ChqwCyJIcdTMUdkNHqt8LVcdxxEYpY2Iy8xrveJpcUWIZn8U2OS6eJBFMwUxTPE195X
         kGmai2oycTAH6a3LxlCJ3Se+MNpZt7W4HPwhY=
Message-ID: <c62985530809250833x2468f07an547a82eaa1329d9@mail.gmail.com>
Date: Thu, 25 Sep 2008 17:33:02 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Pekka Paalanen" <pq@iki.fi>
Subject: Re: [Patch -tip 1/3] Tracing/ftrace: Relay unhandled entry output
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <20080925180916.75d3c9ec@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48DB81BA.2050204@gmail.com> <20080925123802.GA6900@elte.hu>
	 <48DBA683.8000708@gmail.com>
	 <20080925180916.75d3c9ec@daedalus.pq.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/25 Pekka Paalanen <pq@iki.fi>:
> Frederic, in the future, could you just copy the patch
> into the email body (watch out for line wraps and other damage),
> attachments are not usually included in "reply with quote",
> so commenting on them is a tiny bit harder. Thanks.

Ok. I think I have to change my email client. I'm starting to get rid of all
these blank lines or other issues with the patches...
I will think about it...

> IMHO this breaks the trace_seq handling. trace_seq may contain
> the output of several entries, as far as they fit in it as a whole.
> E.g. trace_seq_printf() does not print partial lines but returns 0,
> so that the entry is not consumed right now. The user space reader
> must consume trace_seq content, before trace_seq_printf()
> is attempted again, hopefully with enough space in trace_seq to
> succeed. See tracing_read_pipe().
> print_line() callback works the same way. Returning 0 means "could
> not print it this time, call me back later". You can't use that to
> say "use the default output function instead". Note, that possibly
> the default output function will fail, too, so it could actually
> try many of the default output functions and still fail, eventually
> leading by luck to the correct behaviour in most cases.
> Note, that mmiotrace follows this convention: it deliberatly
> returns 1 without processing when it wants the entry discarded, and
> it returns 0 when there was not enough space to process the entry.
> This is explained in my other email.

Hmm you're right. I didn't thought about the partial line which must
not be printed.
The problem is that with this convention, 0 means two things: "I will
handle this entry
later" or "I can't handle it".
But if you return 0 because you can't handle it, and if the current
len of the seq is 0, the
pipe will be broken.

> What is the supposed return value of print_trace_line(), I do not
> know. Looks like it is used as boolean, so maybe the type should be
> changed to bool. Unless we want three options:
> - 0: could not print now, try again
> - 1: success, entry processed, it can be thrown away
> - 2: fall back to the default output formatting
> Cases 0 and 1 must exist like that, I do not know how useful 2 is,
> but it must be distinct from the first two.

I think it's a good solution.

Thanks to you! I didn't see these issues.
