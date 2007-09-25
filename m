Return-Path: <linux-kernel-owner+w=401wt.eu-S1760121AbXIYRY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121AbXIYRY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 13:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbXIYRYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 13:24:48 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:49296 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbXIYRYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 13:24:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YAUDS7zdnA7+dJbbbhA3InAeErgC7RrD6mLs6FFpB/wbLNstcBvRHnJh48NrOQDBlOkMH8y4BK8/qqG6ASfIrXUmAdnG6tWwMMYotUF8C/scd3Xwn/Sj4tJx+iiAOANxZw+jmUtblPtBo7beMhDZT8atQffzGXgt58vL+9gd2SI=
Message-ID: <653402b90709251024k5ae2d120n93e3e00ee6ba0e21@mail.gmail.com>
Date: Tue, 25 Sep 2007 19:24:46 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [RFC] New kernel-message logging API
Cc: LKML <linux-kernel@vger.kernel.org>, holzheu <holzheu@linux.vnet.ibm.com>,
       "Joe Perches" <joe@perches.com>, "Rob Landley" <rob@landley.net>,
       "Dick Streefland" <dick.streefland@altium.nl>
In-Reply-To: <19f34abd0709242227n5ac1f7dp5b1589ceeb3e4c0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com>
	 <653402b90709221805pd1b7efel165a1c55100e3610@mail.gmail.com>
	 <19f34abd0709242227n5ac1f7dp5b1589ceeb3e4c0e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/25/07, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On 9/23/07, Miguel Ojeda <maxextreme@gmail.com> wrote:
> > Nice. I would suggest having some kind of standard way to show the
> > information on the screen/dmesg. I mean, instead of having plain lines
> > being written to the log, having something very short like:
>
> Thanks for the idea. Is this something you want to (manually) insert
> in each printk, or would it be passed like a parameter?

No parameters if possible: As you said, one or two #define's in the
beggining of the file can tell printk what to print as subsystem and
driver/...; and the reason (printk_xxx) could tell the loglevel. For
example: "detected", "registered" or "copyright" messages will have
always some low level priority; and "errors" or "alerts" high
priorities. This can help whenever selecting what loglevel priorities
to log, as all drivers will log most common messages in the same
loglevel.

So, with your change to printk_xxx, we can add real meaning to the
messages, and forget about selecting a priority for most common
messages. And that does not break your idea of writing printk_yyy,
being yyy all the priorities, as we will be able to use that functions
for uncommon kind of messages.

To clarify what I'm saying, here is an example:

  #define PRINTK_SUBSYSTEM "video"
  #define PRINTK_DRIVER "some123ag"
  ...
  printk_copyright("Pretty Systems Inc. (C) <some@body.com>");
  ...
  printk_detected("Some Pro 123ag VGA");
  ...
  printk_registered("Framebuffer /dev/fb1");
  ...
  if (really_weird_stuff_happened)
      printk_emerg("Video card appears to be disconnected!");

As you see, each message will write to the correct priority. Even,
things like "printk_copyright" could have a macro like:

#define PRINTK_COPYRIGHT(who, year, email) printk_copyright(who " (C)
" year " <" email ">");

But I think that its going too far.

> For the subsystem part, it might be possible to #define a subsystem name at
> the beginning of each file and have printing functions automatically
> use this. But otherwise, I think the usefulness of this is perhaps a
> little low compared to the effort needed (ie. for this to be useful,
> each and every printk of the kernel would need to be changed). Also

Right... But in the long time, it can help a lot. For now, every
maintainer should add the #define line in each file and write the
reason while changing the function name (that is something we will
have to do anyway if you change printk).

> notice, even in your examples, that most subsystems/drivers already
> prefix their messages to identify the source. Perhaps a better effort
> spent would be to go through the ones that are missing this "source"
> prefix and fix them?

I would say 70% do it. Also, they just write the name of the
subsystem/driver, a ':' and then a non-standard string. I mean, most
of the messages are about a new detected device, an error encountered,
a registered/mounted device/link, the copyright, the authors, ... Some
of them say "registered XXX", others "XXX registered", other just say
"new XXX" or split the message in two lines, etc.

My point is: Most of the messages are inside five or six categories,
so if people is ready to change/improve printk() API, let's finish all
the duplication, as we usually do with code.

Also, I think it could help a lot in the future if we categorize the
messages by subsystem/driver and level/reason: then we could write
more useful tools for debugging, logging... We could "grep" it, or
select what we want to log, etc.

I'm sure this idea is maybe overwhelming at first, but I think that in
the future will help a lot. Linux is growing everyday more and more,
and if printk() is about to change, as soon as we introduce new
features, easier will be.

>
> Vegard
>

Thanks for your interest in the idea.

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
