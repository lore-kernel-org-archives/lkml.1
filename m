Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbZIANYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbZIANYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 09:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbZIANYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 09:24:18 -0400
Received: from mta-out.inet.fi ([195.156.147.13]:48040 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620AbZIANYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 09:24:18 -0400
Message-ID: <4A9D2079.3000805@trn.iki.fi>
Date: Tue, 01 Sep 2009 16:24:09 +0300
From: =?ISO-8859-1?Q?Lasse_K=E4rkk=E4inen?= <tronic+bpsk@trn.iki.fi>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Avoiding crash in out-of-memory situations
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently a number of simple while (1) malloc(n); processes can crash a 
system even if resource limits are in place as one can only limit the 
memory usage of a process (not that of an user nor the total used by the 
userspace) and any otherwise reasonable nproc and memory limits can be 
circumvented by using more processes.

The OOM killer is supposed to work as a fallback in these situations, 
but unfortunately the system still goes absolutely unresponsive for 
about 10 minutes whenever the OOM killer runs. It would seem that this 
happens because the kernel first gets rid of all buffers and caches, 
slowing things down to a halt, and the OOM killer activates only after 
nothing else can be done.

In a more complex situation (e.g. the one that we just had on our server 
by accidentally running too many valgrind processes) this hang state can 
take very long, essentially requiring the server to be reseted the hard way.

As there AFAIK is no existing remedy to this problem, I would suggest 
implementing either (a) per-user limits, (b) a memory reserve for the 
kernel (e.g. one could reserve 100 MB for the kernel/buffers/caches, 
giving less for the userspace to allocate even if that means having to 
kill processes) or (c) both of them.

Or perhaps there is something that I missed?

P.S. using or not using swap doesn't really affect the fundamental 
problem nor its symptoms, so please don't suggest that either way.
