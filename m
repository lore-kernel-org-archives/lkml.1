Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbYIYPgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbYIYPgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 11:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbYIYPgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 11:36:17 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:25771 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbYIYPgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 11:36:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=JDqg5KvrSC4MxgoEbvCcVVfz+gmJfJQ4NFtZT7amkqQIn+KZZswwdcwoZoTp4LpRtk
         nWtQZrFfCQhxpxoCtG3u4gzDL5YTR7OHVdgk8YME1c//N6MuUdP+lJN9nEgY8NiOEBd+
         rAZJTdTSw7OodAGFWO//RDOSyOSKJmDLtCo28=
Date: Thu, 25 Sep 2008 18:36:08 +0300
From: Pekka Paalanen <pq@iki.fi>
To: "=?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker" <fweisbec@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [Patch -tip 3/3] Tracing/ftrace: Don't consume entries
 unhandled by mmiotrace
Message-ID: <20080925183608.283babfb@daedalus.pq.iki.fi>
In-Reply-To: <c62985530809250744t3ce0011ajebd8343eb748cf24@mail.gmail.com>
References: <48DB8408.7080408@gmail.com>
	<20080925173435.5f525557@daedalus.pq.iki.fi>
	<c62985530809250744t3ce0011ajebd8343eb748cf24@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008 16:44:08 +0200
"Frédéric Weisbecker" <fweisbec@gmail.com> wrote:

> 2008/9/25 Pekka Paalanen <pq@iki.fi>:
> > NACK.
> >
> > mmiotrace's log output is stricly specified, the standard/default
> > printing functions may NOT be used. The output is supposed to be
> > machine readable in addition to human readable.
> >
> > The ftrace infrastructure assumes there is only one active tracer
> > at a time, therefore destroying unhandled entries is not a problem.
> 
> Hi Pekka.
> 
> It's up to you.
> I just guessed that one would trace IO and stack for example.
> Or why not IO and functions: This sounds to me very useful (who
> performed this io..?)

We can (must) return to this if/when multiple tracers are allowed
to be active simultaneously. But in the current situation, I do not
see a way to trace more than one thing, but I haven't really looked
into the other tracers.

OTOH, mmiotrace log format has a pid field, which is pretty much unused
currently. It could be used to record the current process, if one exists.
That can be added, should the need arise, but so far the field has been
reserved for tracing accesses done in user space - but those are not
caught yet.

I'm not sure what stack trace collects, but tracing functions is useless
or harmful in the usual use case of mmiotrace, i.e. tracing a binary-only
proprietary driver. The functions will be anonymous anyway, and we can't
disassemble the driver due to possible legal reasons. That's why mmiotrace
does not even collect instruction pointers by default, although it
supports them (or did, can't recall if it works now, since it hasn't been
needed). I assume the goal is to create a free open driver without any
legal issues by watching what the proprietary driver does.

Even if the log would be cluttered with MMIO from other, uninteresting
drivers, you can use the physical address to filter the entries by
device (and therefore driver) afterwards. This is one reason why
an mmiotrace log starts with the contents of /proc/bus/pci/devices.

Was there some other scenario you were thinking about?

-- 
Pekka Paalanen
http://www.iki.fi/pq/
