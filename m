Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbZA3Tcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbZA3Tcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 14:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZA3Tcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 14:32:33 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:56736 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbZA3Tcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 14:32:31 -0500
To: Doug Thompson <norsk5@yahoo.com>
Cc: ncunningham-lkml@crca.org.au, Pavel Machek <pavel@suse.cz>,
       Chris Friesen <cfriesen@nortel.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, bluesmoke-devel@lists.sourceforge.net
References: <715599.77204.qm@web50111.mail.re2.yahoo.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 30 Jan 2009 11:32:38 -0800
In-Reply-To: <715599.77204.qm@web50111.mail.re2.yahoo.com> (Doug Thompson's message of "Fri\, 30 Jan 2009 08\:50\:51 -0800 \(PST\)")
Message-ID: <m1wscc7fop.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: norsk5@yahoo.com, bluesmoke-devel@lists.sourceforge.net, linux-mm@kvack.org, linux-kernel@vger.kernel.org, arjan@infradead.org, cfriesen@nortel.com, pavel@suse.cz, ncunningham-lkml@crca.org.au
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Doug Thompson <norsk5@yahoo.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0011]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: marching through all physical memory in software
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Thompson <norsk5@yahoo.com> writes:

> Nigel Cunningham <ncunningham-lkml@crca.org.au> wrote:
>
>     Hi again.
>
>     On Fri, 2009-01-30 at 10:13 +0100, Pavel Machek wrote:
>     > > Hi.
>     > >
>     > > On Wed, 2009-01-28 at 20:38 +0100, Pavel Machek wrote:
>     > > > You can do the scrubbing today by echo reboot > /sys/power/disk; echo
>     > > > disk > /sys/power/state :-)... or using uswsusp APIs.
>     > >
>     > > That won't work. The RAM retains its contents across a reboot, and even
>     > > for a little while after powering off.
>     >
>     > Yes, and the original goal was to rewrite all the memory with same
>     > contents so that parity errors don't accumulate. SO scrubbing here !=
>     > trying to clear it.
>
>     Sorry - I think I missed something.
>
>     AFAICS, hibernating is going to be a noop as far as doing anything to
>     memory that's not touched by the process of hibernating goes. It won't
>     clear it or scrub it or anything else.

A background software scrubber simply has the job of rewritting memory
to it's current content so that the data and the ecc check bits are
guaranteed to be in sync keeping correctable ecc errors caused by
environmental factors from accumulating.

Pavel's original comment was that the hibernation code has to walk all
of memory to save it to disk so it would be a good place to look to
figure out how to walk all of memory.  And incidentally hibernation
would serve as a crud way of rewritting all of memory.


> Even if hibernating worked, it does not touch the issue of scrubbing memory
> that doesn't have hardware support AND the requirement of thousands of nodes in
> cluster who MUST remain operational for days on end.

But it may still serve as an example of how to walk through all of memory.

> Sicortex's MIPS based system fits that exactly.  When I did their EDAC driver
> they wanted to have a software scrubber at a NICE run level to scan memory and
> do this operation without shutting down the system.
>
> We never got to it, but it would be a nice for some to have a background
> software scrubber.  But I would need help from the memory guys on a proper
> interface.
>
> The goal would be have a "loose" target of attempting to all most memory if not
> all.  Sometime of iteration over the memory set.

Thinking about it.  We only care about memory the kernel is using so the memory
maps the BIOS supplies the kernel should be sufficient.  We have weird corner
cases like ACPI but not handling those in the first pass and getting
something working should be fine.

There are other silly things such as wanting to only scrub memory on it's native
NUMA node (if possible) for both performance and scalability.

Eric
