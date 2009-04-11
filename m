Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbZDKByT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbZDKByT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 21:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZDKByE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 21:54:04 -0400
Received: from mga10.intel.com ([192.55.52.92]:30521 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751327AbZDKByC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 21:54:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,171,1239001200"; 
   d="scan'208";a="680653911"
Message-ID: <49DFF837.9080009@linux.intel.com>
Date: Fri, 10 Apr 2009 18:53:59 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [2.6.30-rc1-git2 regressions] Hibernation broken and
 (minor but annoying) audio problem
References: <200904100057.43827.rjw@sisk.pl> <alpine.LFD.2.00.0904091605080.4583@localhost.localdomain> <200904101439.43480.rjw@sisk.pl> <200904102058.36018.rjw@sisk.pl> <alpine.LFD.2.00.0904101204350.4583@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904101204350.4583@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 10 Apr 2009, Rafael J. Wysocki wrote:
>> I've just verified that the resume-after-hibernation issue goes away after
>> reverting commit 9710794383ee5008d67f1a6613a4717bf6de47bc
>> (async: remove the temporary (2.6.29) "async is off by default" code) , so it
>> is async-related.
> 
> Arjan? Clearly all the necessary fixes weren't found..
> 
> There _is_ a module loading problem wrt initmem - I think you found that 
> and we added a hack for it for the ACPI battery driver. I wonder if we're 
> hitting a similar issue now with module discovery: modules that use 
> "async_schedule()" to do their discovery asynchronously are now not 
> necessarily fully "done" when the module is loaded. 

this is both a "yes and no" kind of thing. It already happened for many cases
(USB, SCSI (and thus libata) etc) but now it can happen for more new cases.


> And so, anything that expected the devices to be available after module 
> load (like they used to) would be screwed.
> 
> IOW, maybe something like the totally untested patch appended here (that 
> should also allow us to make the ACPI battery code to go back to using 
> __init).
> 

this will work. It's a tad unfortunate that we basically end up synchronizing
at load time; maybe some time in the future we can make this opt-in/out ;-(
