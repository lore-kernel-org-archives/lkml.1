Return-Path: <linux-kernel-owner+w=401wt.eu-S1757358AbYKUQnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbYKUQnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:43:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbYKUQmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:42:50 -0500
Received: from mailoutltc.fnis.com ([199.200.24.190]:9997 "EHLO
	mailoutltc.fnis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbYKUQmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:42:49 -0500
Message-ID: <4926E501.9010802@fnis.com>
Date: Fri, 21 Nov 2008 11:42:41 -0500
From: "K.S. Bhaskar" <ks.bhaskar@fnis.com>
Reply-To: "K.S. Bhaskar" <ks.bhaskar@fnis.com>
Organization: Fidelity National Information Services, Inc.
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
CC: Jeff Moyer <jmoyer@redhat.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: Enterprise workload testing for storage and filesystems
References: <1226962063.3403.13.camel@localhost.localdomain> <x49y6zegjum.fsf@segfault.boston.devel.redhat.com> <4926DAFC.5070006@fnis.com> <4926DF63.1030107@hp.com>
In-Reply-To: <4926DF63.1030107@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Nov 2008 16:42:42.0236 (UTC) FILETIME=[2C342FC0:01C94BF8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2008 11:18 AM, Alan D. Brunelle wrote:
> K.S. Bhaskar wrote:

[KSB2] <...snip...>

> Thanks for additional feedback Bhaskar - I've been playing with this
> on-and-off the last couple of days trying to stress one testbed (16 way
> AMD, 128GB RAM, two P800 Smart Arrays (48 disks total put into a single
> LVM2/DM volume)). I've been able to get the I/O subsystem 100% utilized,
> but in so doing really didn't stress the system (something like 80-90%
> idle).
> 
> In order to stress the whole system, it sounds like it _may_ be better
> to use 48 separate file systems on 48 separate platters (each with its
> own DB)? Or are there other knobs to play with to get more of the system
> involved besides the I/O? Is it a good idea to separate the journals
> from the DB (separate FS/platter)?

[KSB2] The intent of io_thrash is to stress the IO subsystem.  So, I am 
not at all surprised that CPU and memory were not stressed.

With the 48 platters on your system, perhaps consider creating 4 logical 
volumes each striped across 12 physical volumes.  Try 8 databases, with 
each logical volume having two databases and journal files for two 
databases that reside on different file systems.

In the real world, yes one would separate each journal file from its 
database file, at least putting them on separate platters, because if 
the journal platters, disk controller, or file system croak, you still 
have the database, and if the database underpinnings die, the database 
is recoverable from a backup and the journal file.  One aims to get 
maximum separation from the database and its journal file.

If you want to simulate an application that produces a more balanced 
load, perhaps you can set %ioUnderLock to 0 and modify io_thrash to do 
some compute intensive task (like fill a large block of memory with 
pseudo random numbers) before each IO operation.  You would probably 
want to increase the number of processes so that the IO subsystem 
continues to be driven hard.

Regards
-- Bhaskar

_____________

The information contained in this message is proprietary and/or confidential. If you are not the 
intended recipient, please: (i) delete the message and all copies; (ii) do not disclose, 
distribute or use the message in any manner; and (iii) notify the sender immediately. In addition, 
please be aware that any message addressed to our domain is subject to archiving and review by 
persons other than the intended recipient. Thank you.
_____________
