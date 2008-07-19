Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbYGSKiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbYGSKiX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 06:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbYGSKiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 06:38:14 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:25148 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbYGSKiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 06:38:13 -0400
To: Russ Anderson <rja@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, Tony Luck <tony.luck@intel.com>,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: Re: [PATCH 0/2] Migrate data off physical pages with corrected memory errors (Version 7)
From: Andi Kleen <andi@firstfloor.org>
References: <20080718203514.GD29621@sgi.com>
Date: Sat, 19 Jul 2008 12:37:11 +0200
In-Reply-To: <20080718203514.GD29621@sgi.com> (Russ Anderson's message of "Fri, 18 Jul 2008 15:35:14 -0500")
Message-ID: <87prpa88iw.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 Jul 2008 10:37:08.0470 (UTC) FILETIME=[65065960:01C8E98B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russ Anderson <rja@sgi.com> writes:

> [PATCH 0/2] Migrate data off physical pages with corrected memory errors (Version 7)

FWIW I discussed this with some hardware people and the general
opinion was that it was way too aggressive to disable a page on the
first corrected error like this patchkit currently does.  

The corrected bit error could be caused by a temporary condition
e.g. in the DIMM link, and does not necessarily mean that part of the
DIMM is really going bad. Permanently disabling would only be
justified if you saw repeated corrected errors over a long time from
the same DIMM.

There are also some potential scenarios where being so aggressive
could hurt, e.g. if you have a low rate of random corrected events
spread randomly all over your memory (e.g. with a flakey DIMM
connection) after a long enough uptime you could lose significant parts
of your memory even though the DIMM is actually still ok.

Also the other issue that if the DIMM is going bad then it's likely
larger areas than just the lines making up this page. So you
would still risk uncorrected errors anyways because disabling
the page would only cover a small subset of the affected area.

If you really wanted to do this you probably should hook it up
to mcelog's (or the IA64 equivalent) DIMM database and then
control it from user space with suitable large thresholds
and DIMM specific knowledge. But it's unlikely it can be really
done nicely in a way that is isolated from very specific 
knowledge about the underlying memory configuration.

-Andi
