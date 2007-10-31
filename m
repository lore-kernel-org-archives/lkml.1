Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbXJaLHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbXJaLHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 07:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756391AbXJaLG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 07:06:56 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:57132 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181AbXJaLGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 07:06:55 -0400
Message-ID: <472861A8.8020709@emc.com>
Date: Wed, 31 Oct 2007 07:06:16 -0400
From: Ric Wheeler <ric@emc.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Zach Brown <zab@zabbo.net>
CC: Mike Waychison <mikew@google.com>, Chris Mason <chris.mason@oracle.com>,
       Anton Altaparmakov <aia21@cam.ac.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/6][RFC] Cleanup FIBMAP
References: <20071026233732.568575496@crlf.corp.google.com>	<E579083F-FED3-4990-8E24-275ED38E9E3B@cam.ac.uk> <20071029101001.4378a7cf@think.oraclecorp.com> <47260AB1.9000003@zabbo.net> <472631FE.9070003@google.com> <47263BEC.30501@zabbo.net>
In-Reply-To: <47263BEC.30501@zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.8.30.53115
X-PerlMx-Spam: Gauge=, SPAM=1%, Reason='EMC_FROM_0+ -3, __CP_URI_IN_BODY 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __STOCK_SPAM_11 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zach Brown wrote:
>> Can you clarify what you mean above with an example?  I don't really
>> follow.
> 
> Sure, take 'tar' as an example.  It'll read files in the order that
> their names are returned from directory listing.  This can produce bad
> IO patterns because the order in which the file names are returned
> doesn't match the order of the file's blocks on disk.  (htree, I'm
> looking at you!)
> 
> People have noticed that tar-like loads can be sped up greatly just by
> sorting the files by their inode number as returned by stat(), never
> mind the file blocks themselves.  One example of this is Chris Mason's
> 'acp'.
> 
>   http://oss.oracle.com/~mason/acp/
> 
> The logical extension of that is to use FIBMAP to find the order of file
> blocks on disk and then doing IO on blocks in sorted order.  It'd take
> work to write an app that does this reliably, sure.
> 
> In this use the application doesn't actually care what the absolute
> numbers are.  It cares about their ordering.  File systems would be able
> to chose whatever scheme they wanted for the actual values of the
> results from a FIBMAP-alike as long as the sorting resulted in the right
> IO patterns.
> 
> Arguing that this use is significant enough to justify an addition to
> the file system API is a stretch.  I'm just sharing the observation.
> 
> - z

I use FIBMAP support for a few different things.

The first is to exactly the case that you describe above where we can 
use the first block of a file extracted by FIBMAP to produce an optimal 
sorting for the read order.  My testing showed that the cost of the 
extra fibmap was not too high compared to the speedup, but it was not a 
huge gain over the speedup gained when the read was done in inode sorted 
order.

The second use case is to look at the physical layout of blocks on disk 
for a specific file, use Mark Lord's write_long patches to inject a disk 
error and then read that file to make sure that we are handling disk IO 
errors correctly.  A bit obscure, but really quite useful.

We have also used FIBMAP a few times to try and map an observed IO error 
back to a file. Really slow and painful to do, but should work on any 
file system when a better method is not supported.


ric
