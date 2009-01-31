Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbZAaMsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbZAaMsw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 07:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZAaMso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 07:48:44 -0500
Received: from relay1.allsecurenet.com ([66.111.57.92]:44114 "EHLO
	relay1.allsecurenet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbZAaMsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 07:48:43 -0500
Message-ID: <4984489C.8020309@buttersideup.com>
Date: Sat, 31 Jan 2009 12:48:28 +0000
From: Tim Small <tim@buttersideup.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Doug Thompson <norsk5@yahoo.com>, ncunningham-lkml@crca.org.au,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Chris Friesen <cfriesen@nortel.com>, Pavel Machek <pavel@suse.cz>,
       bluesmoke-devel@lists.sourceforge.net,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: marching through all physical memory in software
References: <715599.77204.qm@web50111.mail.re2.yahoo.com>	<m1wscc7fop.fsf@fess.ebiederm.org> <49836114.1090209@buttersideup.com> <m1iqnw1676.fsf@fess.ebiederm.org>
In-Reply-To: <m1iqnw1676.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> At the point we are talking about software scrubbing it makes sense to assume
> a least common denominator memory controller, one that does not do automatic
> write-back of the corrected value, as all of the recent memory controllers
> do scrubbing in hardware.
>   

I was just trying to clarify the distinction between the two processes 
which have similar names, but aren't (IMO) actually that similar:

"Software Scrubbing"

Triggering a read, and subsequent rewrite of a particular RAM location 
which has suffered a correctable ECC error(s) i.e. hardware detects an 
error, then the OS takes care of the rewrite to "scrub" the error in the 
case that the hardware doesn't handle this automatically.

This should be a very-occasional error-path process, and performance is 
probably not critical..


"Background Scrubbing"

. This is a poor name, IMO (scrub infers some kind of write to me), 
which applies to a process whereby you ensure that the ECC check-bits 
are verified periodically for the whole of physical RAM, so that single 
bit errors in a given ECC block don't accumulate and turn into 
uncorrectable errors.  It may also lead to improved data collection for 
some failure modes.  Again, many memory controllers implement this 
feature in hardware, so we shouldn't do it twice where this is supported.

There is (AFAIK) no need to do any writes here, and in fact doing so is 
only likely to hurt performance, I think....  The design which springs 
to mind is of a background thread which (possibly at idle priority) 
reads RAM at a user-configurable rate (e.g. consume a max of n% of 
memory bandwidth, or read  all of RAM at least once every x minutes).  
Possible design issues:

. There will be some trade off between reducing impact on the system as 
a whole, and making firm guarantees about how often memory is checked.  
Difficult to know what the default would be, but probably 
no-firm-guarantee of minimum time (idle processing only) is likely to 
cause least problems for most users.
. An eye will need to be kept on the impact that this reading has on the 
performance of the rest of the system (e.g. cache pollution, and NUMA, 
as you previously mentioned), but my gut feeling is that for the 
majority of systems it shouldn't be significant.  If practical 
mechanisms are available on some CPUs to read RAM without populating the 
CPU cache, we should use those (but I've no idea if they exist or not).

Perhaps a good default would be to benchmark memory read bandwidth when 
the feature is turned on, and then operate at (e.g.) 0.5% of that bandwidth.


Cheers,

Tim.
