Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbYE3ILT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbYE3ILT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 04:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYE3ILE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 04:11:04 -0400
Received: from as4.cineca.com ([130.186.84.251]:47434 "EHLO as4.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbYE3IK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 04:10:59 -0400
X-Greylist: delayed 524 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 May 2008 04:10:59 EDT
Message-ID: <483FB39A.4070104@gmail.com>
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jan Engelhardt <jengelh@computergmbh.de>,
       Sverre Rabbelier <alturin@gmail.com>, Joe Perches <joe@perches.com>,
       git@vger.kernel.org
Subject: Re: whomto.pl -- finding out whom to send patches to
References: <20080529210018.GA5508@damson.getinternet.no>
In-Reply-To: <20080529210018.GA5508@damson.getinternet.no>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 30 May 2008 09:58:19 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> Hi,
> 
> I've written this perl script that takes a patch as input and prints the
> authors/committers of the affected lines, using git-blame as the back end.
> 
> (The purpose of this is of course to find out whom to send patches to.)
> 
> There are some caveats:
> 
> - If I've understood correctly, git-blame incremental output doesn't split
>   commits when a newer one is found, so we currently possibly take into
>   account more than just the last patch to touch a line. This might not be
>   a disadvantage, however...
> 
> - The patch must apply to the current working tree. I suppose there is
>   some way to use the index information in the patch to determine what to
>   run git-blame against, but this is currently beyond my git knowledge.
> 
> - It's a bit slow, particularly for large files. But doing the same thing
>   by hand would be slower, so I suppose it's an overall improvement.
> 
> Running this on a random -mm patch, for example
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc2/2.6.26-rc2-mm1/broken-out/acpi-fix-fadt-parsing.patch
> gives the following output:
> 
>   $ perl whomto2.pl acpi-fix-fadt-parsing.patch
>   Running git-blame on drivers/acpi/tables/tbfadt.c...
> 
>   To: (Committers)
>       48 Len Brown <len.brown@intel.com>
>   Cc: (Authors)
>       44 Bob Moore <robert.moore@intel.com>
>        2 Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
>        2 Len Brown <len.brown@intel.com>
> 
> Maybe this tool can be useful? :-)
> 
> (Improvements are of course also welcome.)

Minor fix: do not git-blame /dev/null in patches that add new files.

-Andrea

diff -urpN linux/whomto.orig.pl linux/whomto.pl
--- linux/whomto.orig.pl	2008-05-30 09:43:08.000000000 +0200
+++ linux/whomto.pl	2008-05-30 09:49:26.000000000 +0200
@@ -101,6 +101,7 @@ sub parse_patch {
 
 	for (@p) {
 		if (m/^--- .*?\/([^\s~]*)/) {
+			next if ($1 eq 'dev/null');
 			$file = $files{$1} = {
 				chunks => [],
 			};
