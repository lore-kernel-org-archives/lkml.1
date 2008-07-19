Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbYGSUl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbYGSUl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 16:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbYGSUlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 16:41:20 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:44524 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbYGSUlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 16:41:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=llYYiuToZanhFKl08elHSM8BQ54Um72uB9v7PjpyBxk7my3RcTGAOsmhpWjcoO80nq
         UOzqKdYDADwzEoi9Tdm/GBkYcMe9xvMhPzpxC0oh3L7ebt4r1cnURnPOiJjezgQVSvco
         A14IlwcHaok4TheWZYiGSWxZwiQiiBRyUQf5U=
Message-ID: <4882517F.6080407@tuffmail.co.uk>
Date: Sat, 19 Jul 2008 21:41:35 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Alexey Starikovskiy <astarikovskiy@suse.de>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] acpi: Rip out EC_FLAGS_QUERY_PENDING (prevent race
 condition)
References: <487D23C3.5070301@student.cs.york.ac.uk> <487F31D7.30803@suse.de> <20080717121309.GF31732@khazad-dum.debian.net> <487F3B6D.3090507@suse.de> <20080717162628.GB18457@khazad-dum.debian.net> <487F7724.5080905@tuffmail.co.uk> <20080717185032.GD18457@khazad-dum.debian.net> <487F986A.3070504@tuffmail.co.uk> <4881CE72.1090401@tuffmail.co.uk> <4881D239.4010402@tuffmail.co.uk> <48821D7B.1080209@suse.de>
In-Reply-To: <48821D7B.1080209@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Starikovskiy wrote:
> Alan,

Thanks for your robust response.  Sorry for not discussing this more in
the first place.  I wanted to write the code that fixes my system first,
and post it as soon as possible.  I think I missed a flag to say "this
post is not an immediate request for submission".

> I don't think this is very good idea -- now every interrupt will add a
> new entry to workqueue,
> and given the rate of this interrupt, it could be become quite long.
>

I confess I gave up too quickly on the synchronisation issues and
resorted to brute force.  Patch #1 is preventing a narrow race:

- acpi_ec_write_cmd() (QUERY)
- EC writes 0 (no event) to input buffer
- new event arrives, triggering a GPE interrupt which is ignored because
QUERY_PENDING is set.
- QUERY_PENDING is cleared (but too late).

Now we ignored an event, which will be delayed until the next GPE interrupt.

The original reason for patch #1 was to stop patch #2 driving me
insane.  If you apply the second patch on it's own, you break
EC_FLAGS_QUERY_PENDING.  It gets cleared as soon as the _first_ query
command is submitted.  It works, but it means the flag no longer has a
clearly defined meaning.  I tried to fix that by only clearing it once
the loop has finished - and then realised I was widening a pre-existing
race condition.

As you say, I took the easy way out and pushed it all into the
workqueue.  So the workqueue ends up as a buffer of GPE occurrences.  I
did look at reducing the memory usage while avoiding race conditions,
but I couldn't find a reasonable solution.  But I looked at it again now
and I have a better solution:

...
    /* moved here from acpi_ec_transaction_unlocked() */
    clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);

    while (acpi_ec_query(ec, &value) == 0)
        acpi_ec_gpe_run_handler(ec, value);
}

The PENDING flag then reflects whether or not there's an item on the
workqueue.  Does that make sense?

> Your second patch is redundant if you add queue entry for each
> interrupt, and as it does not
> require any investments into memory, I like it more.
>
It's not quite redundant with the first patch.  We still have GPE
polling mode - patch #1 doesn't affect that.  In polling mode, it's
essential to query all the pending events - otherwise, if they arrive
more frequently than the polling interval then you will inevitably drop
events.

Patch #2 is also required to fix my buggy hardware.  My laptop's EC
buffers multiple events, but clears SCI_EVT after every query.  This
caused problems in polling mode; with multiple events between polling
intervals only one gets queried - and after a while the buffer overflows
and it breaks completely.
> Also, it is very cool to rip of things you don't care for, but that
> essentially reverts a fix done for 9998,
> so at least, you should ask these people if you broke their setups.
>
I assume you're referring to the "would benefit from wider testing"
patch #3. Thanks for identifying the bugzilla entry - I had difficulty
separating the different entries on GPEs.  I'm optimistic that we can
fix all these crazy buffering EC's without having to disable GPE interrupts.

The reason I like my proposed fix is that it makes the code simple
enough that I can understand it, without making any assumptions about
how many interrupts arrive per GPE.  The EC can be broken in lots of
ways, so long as:

1. We receive interrupts when one or more GPE's are pending.
2. We don't get a constant interrupt storm.

I don't think I missed anything.  Is there anything else I should check
before I try to get testing?

Thanks
Alan
