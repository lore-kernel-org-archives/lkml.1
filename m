Return-Path: <linux-kernel-owner+w=401wt.eu-S1752326AbYJYAqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbYJYAqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 20:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbYJYAqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 20:46:09 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:28316 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbYJYAqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 20:46:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=v46a979r+tJ0+fgICdZV/o5GOLTyiR1ycfYpjkVDi3tWgLTXe4UCDnsm1t5t+stpfr
         lYAw6MTPntJ4ET8HkG6g4AC/tZV1lrZh9iCinZpkWQXrYkCI3sIpfje/NqC4JfRFW9SX
         30RBrSOjEsOQGYsAmsWFwJK0d9OCoLQny9Lkk=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: Bloatwatch 2.6.28-rc1: i8042 DMI lookup tables
Date: Fri, 24 Oct 2008 20:46:02 -0400
User-Agent: KMail/1.9.9
Cc: Jiri Kosina <jkosina@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@redhat.com>
References: <1224879959.3248.32.camel@calx> <alpine.LNX.1.10.0810250001530.27479@jikos.suse.cz> <1224890002.3248.71.camel@calx>
In-Reply-To: <1224890002.3248.71.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810242046.02743.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 October 2008, Matt Mackall wrote:
> On Sat, 2008-10-25 at 00:15 +0200, Jiri Kosina wrote:
> > On Fri, 24 Oct 2008, Matt Mackall wrote:
> > 
> > > We've added 12k of new initdata to allnoconfig builds for i8042 DMI
> > > lookup tables:
> > > 
> > > http://www.selenic.com/bloatwatch/?cmd=compare;v1=2.6.27;v2=2.6.28-rc1;part=/built-in/drivers
> > > 
> > > It looks like each table entry is > 320 bytes as we reserve four 80-byte
> > > slots in each for DMI match strings. 
> > 
> > Umm, and what is the actual problem with that, really?
> 
> The actual problem is that if the kernel grows by 12k every time a
> developer says "what's the big deal?" the kernel will become very large
> indeed.
> 
> > OK, we can remove it from .init, but then it will be rotting in memory 
> > forever, which is quite sub-optimal, when this kind of DMI information is 
> > needed only during initialization.
> 
> I wasn't complaining that they were in init, but rather that they were
> 12k. For something like 37 entries. The entry size is ridiculous and
> looks to have grown by a factor of 10 since 2.6.27. What, as they say,
> is up with that?
> 
> It looks like David Woodhouse is to blame:
> 
> commit d945b697d0eea5a811ec299c5f1a25889bb0242b
> Automatic MODULE_ALIAS() for DMI match tables.
> 
> This is probably also responsible for most of the growth in x86 I
> mentioned elsewhere, so it's about 25-30k damage in total. David?
> 

I think that the net effect of this change is positive. While it is
true that the size of the kernel image grew we do discard more memory
(most of DMI tables are marked __initdata) than we were able to do
before DMI strings were embedded into dmi_strmatch so the footprint of
the running kernel now should be smaller. Having said this I wonder if
we could reduce the length of these strings form 79 to let's say 39. 

I would like to get rid of .ident strings in cases when drivers don't
use them for anything, this should free some more memory.

-- 
Dmitry
