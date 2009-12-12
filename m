Return-Path: <linux-kernel-owner+w=401wt.eu-S932629AbZLMBQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629AbZLMBQg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:16:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932246AbZLMBQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:16:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49875 "HELO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755699AbZLMBPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:15:15 -0500
Date: Sat, 12 Dec 2009 10:54:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <200912121848.33062.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0912121049390.3526@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912120048.46180.rjw@sisk.pl> <alpine.LFD.2.00.0912111552330.3526@localhost.localdomain> <200912121848.33062.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 Dec 2009, Rafael J. Wysocki wrote:
> 
> I'd like to put it into my tree in this form, if you don't mind.

This version still has a major problem, which is not related to 
completions vs rwsems, but simply to the fact that you wanted to do this 
at the generic device layer level rather than do it at the actual 
low-level suspend/resume level.

Namely that there's no apparent sane way to say "don't wait for children".

PCI bridges that don't suspend at all - or any other device that only 
suspends in the 'suspend_late()' thing, for that matter - don't have any 
reason what-so-ever to wait for children, since they aren't actually 
suspending in the first place. But you make them wait regardless, which 
then serializes things unnecessarily (for example, two unrelated USB 
controllers).

And no, making _everything_ be async is _not_ the answer.

			Linus
