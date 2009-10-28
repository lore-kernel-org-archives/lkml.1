Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243AbZJ1OrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbZJ1OrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 10:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbZJ1Oq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 10:46:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197AbZJ1Oqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 10:46:55 -0400
Message-ID: <4AE8595F.1080404@redhat.com>
Date: Wed, 28 Oct 2009 10:46:55 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matt Carlson <mcarlson@broadcom.com>, Michael Chan <mchan@broadcom.com>,
       KVM list <kvm@vger.kernel.org>
Subject: TG3, kvm, ipv6 & tso data corruption bug?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been tracking down what I thought was a KVM related network
issue for a while, however it appears it could be a hardware issue.

The symptom is that data in network packets gets corrupted, before
the checksum is calculated.  This means the remote host can get
corrupted data, with no way to calculate it (except application
level checksums).  Luckily ssh has such checksums, so my rsync over
ssh backup script discovered this issue.

On a very regular basis, I got this message from ssh:

	Corrupted MAC on input.

I have played around a bit and narrowed it down to the following:

ipv4          => no problem
ipv6 w/o tso  => no problem
ipv6 with tso => occasional data corruption

Disabling tso with ethtool -K eth0 tso off makes the problem stop.

I am running Fedora 12's 2.6.31.1-56.fc12.x86_64 kernel, with the
following hardware:

05:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5761 
Gigabit Ethernet PCIe (rev 10)

I do not know enough about the network layer to know whether this is
fixable in software or whether TSO offloading for ipv6 should just
be disabled on this model.

-- 
All rights reversed.
