Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbXFYUWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbXFYUWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 16:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbXFYUWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 16:22:15 -0400
Received: from smtp-out.google.com ([216.239.45.13]:14154 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbXFYUWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 16:22:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=LjEGmdiPwW9V0Vynl0QZg+hQJA9SsbgBGdQCR34beye7V4pdu5WaS1Xn8koHdAOdr
	BBr0wy6KXy1xMX5WOQ6pQ==
Message-ID: <468023CA.2090401@google.com>
Date: Mon, 25 Jun 2007 13:21:30 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@google.com>, a.p.zijlstra@chello.nl
Subject: Re: [RFC 1/7] cpuset write dirty map
References: <465FB6CF.4090801@google.com> <Pine.LNX.4.64.0706041138410.24412@schroedinger.engr.sgi.com> <46646A33.6090107@google.com> <Pine.LNX.4.64.0706041250440.25535@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0706041250440.25535@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> 
> What testing was done? Would you include the results of tests in your next 
> post?

	Sorry for the delay in responding -- I was chasing phantom failures.

	I created a stress test which involved using cpusets and mems_allowed
to split memory so that all daemons had memory set aside for them, and
my memory stress test had a separate set of memory. The stress test was
mmaping 7GB of a very large file on disk. It then scans the entire 7GB
of memory reading and modifying each byte. 7GB is more than the amount
of physical memory made available to the stress test.

	Using iostat I can see the initial period of reading from disk,
followed by a period of simultaneous reads and writes as dirty bytes are
pushed to make room for new reads.

	In a separate log-in, in the other cpuset, I am running:

while `true`; do date | tee -a date.txt; sleep 5; done

	date.txt resides on the same disk as the large file mentioned above.
The above while-loop serves the dual purpose of providing me visual
clues of progress along with the opportunity for the "tee" command to
become throttled writing to the disk.

	The effect of this patchset is straightforward. Without it there are
long hangs between appearances of the date. With it the dates are all 5
(or sometimes 6) seconds apart.

	I also added printks to the kernel to verify that, without these
patches, the tee was being throttled (along with lots of other things),
and with the patch only pdflush is being throttled.
	-- Ethan
