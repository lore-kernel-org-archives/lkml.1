Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbYDIOHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbYDIOHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 10:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYDIOG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 10:06:57 -0400
Received: from rtr.ca ([76.10.145.34]:1872 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbYDIOG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 10:06:56 -0400
Message-ID: <47FCCD7F.8010309@rtr.ca>
Date: Wed, 09 Apr 2008 10:06:55 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Network <linux-net@vger.kernel.org>
Subject: Regression: 2.6.25-rc8: FTP transfer errors
References: <SvnMeM-aZi.A.S3E.b-_-HB@albercik> <47FC4C87.1020705@rtr.ca> <47FCC6B5.70804@rtr.ca>
In-Reply-To: <47FCC6B5.70804@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Mark Lord wrote:
>> Today I've been using 2.6.25-rc8 with an old embedded build system here
>> for my empegs.  One shell script calls out to /usr/bin/ftp to transfer
>> an image to a remote system, and then read it back again and compare.
>>
>> The compare is failing, most (but not all) of the time,
>> but only on 2.6.25-rc8, not on 2.6.24.  Verified by switching
>> back and forth between kernel versions for a short spell.
>>
>> The ftp client is netkit-ftp 0.17-16 on Kubuntu feisty.
>>
>> Switching to ncftpput/ncftpget avoids it on 2.6.25,
>> but I wonder where the problem is.
> 
> Now verified that the data loss occurs in the outbound direction.
> The readback data is the same, regardless of which client s/w is used.
> 
> So something in 2.6.25 is incompatible with the ftp client binary, or libs,
> that are installed here.  Or some other problem.
..

Recap, with more info:

The host system is running 2.6.25-rc8-git.  It uses netkit-ftp to
send a file to the remote system.  Using strace shows that the
entire file was read, and passed to write() for the outbound socket.

The remote system is running linux-2.2.xx, and is reporting -EPIPE
from net/socket.c::sock_recvmsg() before all of the data has been received,
and thus ends up with a short file, missing data at the end.

This exact sequence, with the exact same software,
works fine when the host system is NOT running 2.6.25-*,
(eg. 2.6.11 through 2.6.24 are fine).

Something may be broken here.
