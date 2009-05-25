Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbZEYD3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbZEYD3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 23:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbZEYD33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 23:29:29 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:45080 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbZEYD32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 23:29:28 -0400
Message-ID: <4A1A1094.3020903@davidnewall.com>
Date: Mon, 25 May 2009 12:59:24 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Thomas Glanzmann <thomas@glanzmann.de>, tytso@thunk.org,
       LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: Re: zero out blocks of freed user data for operation a virtual machine
 environment
References: <20090524170045.GC24753@cip.informatik.uni-erlangen.de>
In-Reply-To: <20090524170045.GC24753@cip.informatik.uni-erlangen.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Glanzmann wrote:
> If you don't intend to have such an optional feature in ext3/ext4 I
> would like to know if you know a tool that makes it possible to zero out
> unused blocks?
>
> The only reference that I found for such a tool for Linux is the
> following:
>   
Astounding use of backquote. I'm not sure about the "percent" bit. I
think it's some confusion over only 95% of total blocks being available
for allocation.

I, too, would not recommend it, but it becomes safer by repeatedly
allocating only half the remaining disk, stopping when there's only a
few blocks free, to leave some for all of the other processes.
Presumably it won't be a problem having (potentially) a few free blocks
that don't de-duplicate.

#!/bin/bash
FileSystem=`grep ext /etc/mtab| awk -F" " '{ print $2 }'`

for i in $FileSystem
do
       while number=`df -B 512 $i | awk -F" " '$4 < 10 {exit(1)} {print $4 / 2}'`
       do
              dd count=$number if=/dev/zero || break
       done > $i/zf
       rm -f $i/zf
done



Are you proposing to de-duplicate a live filesystem?
