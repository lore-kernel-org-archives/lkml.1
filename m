Return-Path: <linux-kernel-owner+w=401wt.eu-S1752378AbZAFVHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378AbZAFVHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:07:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZAFVG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:06:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:33037 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbZAFVG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:06:26 -0500
Date: Tue, 6 Jan 2009 13:06:28 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fs@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH 0/2] Push the asynchronous function call concept a little
 further
Message-ID: <20090106130628.59d63bee@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the 2 patches in this series try to push the asynchronous function call
concept a little further;

the first patch allows for creating multiple queues so that you can do
synchronization on your own queue without creating congestion in the
one global queue (for example, as used in the 2nd patch, a per
superblock queue).

the second patch uses a per superblock queue to make the last part of
file deletion (the actual removal of the file content from disk)
using the async function call concept.
The cut is done after the inode is removed from the VFS (and where the
code can and does sleep), but before calling into the filesystem to do 
the actual removal. The locking etc around this should be safe due to
the sleep-ability and the fact that the inode is already out of the VFS
namespaces (eg it's in I_FREEING).

On my testbox, rm -rf of a kernel tree went from 11.6 to 8.6 seconds
with this; with smaller rm's I expect the gain to be more (to the point
where applications that only occasionally delete files no longer will
stutter around this as much).



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
