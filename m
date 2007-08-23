Return-Path: <linux-kernel-owner+w=401wt.eu-S1762294AbXHWMfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762294AbXHWMfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 08:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758182AbXHWMfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 08:35:03 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1327 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758172AbXHWMfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 08:35:02 -0400
Message-ID: <46CD7ECA.6010507@shadowen.org>
Date: Thu, 23 Aug 2007 13:34:18 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: 2.6.23-rc3-mm1
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46CC6FB2.1010801@csn.ul.ie> <20070822111029.46db0ab7.akpm@linux-foundation.org> <20070823120318.GA7506@shadowen.org> <20070823122215.GS8058@bingen.suse.de>
In-Reply-To: <20070823122215.GS8058@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Thu, Aug 23, 2007 at 01:03:18PM +0100, Andy Whitcroft wrote:
>> It seems that this is a problem caused by the way we check for
>> compiler options in x86_64.  Each compiler flag is checked for
>> individually and if available added to cflags-y, later that is
>> added to CFLAGS.  However, this means that each flag is checked
>> in total isolation.  On x86_64 (on this compiler at least) the
>> -mpreferred-stack-boundary and -m{32,64} flags are actually mutually
>> dependant, the alignment constraints vary based on the word size.
>> This leads to the compile failure:
>>
>>     # gcc -mpreferred-stack-boundary=3 -S -xc /dev/null  -o FOO
>>     # echo $?
>>     0
>>     # gcc -m64 -mpreferred-stack-boundary=3 -S -xc /dev/null  -o FOO
>>     /dev/null:1: error: -mpreferred-stack-boundary=3 is not between 4 and 12
>>     # echo $?
>>     1
>>
>> In the main Makefile we always add each flag directly to CFLAGS
>> which means we check them all in combination, perhaps this is
>> prudent here also?  Either way I suspect that changing the -m64
>> check to add itself directly to CFLAGS will fix this us.
> 
> Ok that makes sense. Most people don't see it because they don't
> need -m64. 
> 
> I fixed it up with 
> ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/cflags-probe
> and then
> ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/less-stack-alignment
> (replacement for the mm patch)
> 
> Can you test?

Sure, will do that now and let you know.

-apw
