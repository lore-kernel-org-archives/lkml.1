Return-Path: <linux-kernel-owner+w=401wt.eu-S1751410AbXEXQIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbXEXQIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 12:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750723AbXEXQID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 12:08:03 -0400
Received: from palrel13.hp.com ([156.153.255.238]:35629 "EHLO palrel13.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbXEXQIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 12:08:01 -0400
Date: Thu, 24 May 2007 11:07:56 -0500
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
To: linux-kernel@vger.kernel.org, tom.l.nguyen@intel.com
Cc: iss_storagedev@hp.com, akpm@linux-foundation.org, jens.axboe@oracle.com
Subject: msi_free_irqs #2
Message-ID: <20070524160756.GA14083@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

So I guess I found the answer to my own question. msi_free_irqs was apparently added
in 2.6.22-something. I don't find it in 2.6.21.2 or anywhere else. So somebody broke a
couple of things.
The most noticable is cciss hangs after turning on interrupts. The reason for that is
the kernel now looks at my array of MSI-X vectors in reverse order. We have 4 ways of
generating an interrupt on Smart Array hw. They are:

#       define DOORBELL_INT     0
#       define PERF_MODE_INT    1
#       define SIMPLE_MODE_INT  2
#       define MEMQ_MODE_INT    3

For INTx these four lines are OR'ed together and run to one interrupt pin. MSI-X
breaks this hardware OR'ing so we must register either all 4 or at the least the
correct interrupt. When I first submitted the MSI/X support I was registering all 4.
Someone changed that to only register a single MSI-X vector. That worked fine until
2.6.22-something. 
Now it appears that the kernel is looking at the array in reverse order. IOW, I must
register PERF_MODE_INT in order for cciss to work. That's messed up. Anybody want to
`fess up to making these changes? :)
I'll keep working this, but I'm going to undo someones change when I figure out where
it's broke.

mikem
