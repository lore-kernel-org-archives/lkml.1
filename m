Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbXFWWvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbXFWWvQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 18:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbXFWWvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 18:51:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40911 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbXFWWvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 18:51:03 -0400
Message-ID: <467DA3D1.6040702@garzik.org>
Date: Sat, 23 Jun 2007 18:50:57 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: perex@suse.cz
CC: Randy Dunlap <randy.dunlap@oracle.com>, akpm <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ALSA: use __devexit_p
References: <20070623144022.94eb0f27.randy.dunlap@oracle.com>
In-Reply-To: <20070623144022.94eb0f27.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This reminds me...

Someone needs to go through ALSA and audit all delays executed via 
$FOO_interruptible().

Several delays within ALSA wait for hardware conditions, and do not 
check for signals pending, which means that the wait-for-condition loop 
becomes a busy loop:

	while (1) {
		foo = read_hardware()
		if (foo & interesting_bits)
			break;
		schedule_timeout_interruptible(1);
	}

The proper fix is (a) remove "_interruptible" [recommended] or (b) check 
for signals.

grep'ing for "_interruptible" quickly finds several such ALSA bugs.

	Jeff


